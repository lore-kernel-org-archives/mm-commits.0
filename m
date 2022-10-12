Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A48F5C4321E
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 22:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiJLW5h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Oct 2022 18:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJLW52 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2022 18:57:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3BD1204F4
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 15:57:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E51EFB819BB
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 22:57:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10D5C433D6;
        Wed, 12 Oct 2022 22:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665615444;
        bh=pQbIHvXco9jOm5gTLMsaVrkmaKa2wTC6vBhRzVJuE2s=;
        h=Date:To:From:Subject:From;
        b=L8/d6ImjJeHDQDylM97zwCfHH7bATVkbGcdAsJaQAzgxmw3q8StQb0JlWeEBjGcDg
         g4YKt3OYsTkUzsPIMiUnjnPJ55QSR0EWTx+chbsp2ZO/8b6qX6hS4uKELqfMIV6BXw
         tp9biQzaCk8mhiNz4hug+isw4vbFiZw7KjiX6XQY=
Date:   Wed, 12 Oct 2022 15:57:23 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@gmail.com, xkernel.wang@foxmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_meminit-add-checks-for-the-allocation-functions.patch removed from -mm tree
Message-Id: <20221012225724.A10D5C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/test_meminit: add checks for the allocation functions
has been removed from the -mm tree.  Its filename was
     lib-test_meminit-add-checks-for-the-allocation-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xiaoke Wang <xkernel.wang@foxmail.com>
Subject: lib/test_meminit: add checks for the allocation functions
Date: Fri, 4 Mar 2022 17:12:15 +0800

alloc_pages(), kmalloc() and vmalloc() are all memory allocation functions
which can return NULL when some internal memory failures happen.  So it is
better to check the return of them to catch the failure in time for better
test them.

Link: https://lkml.kernel.org/r/tencent_D44A49FFB420EDCCBFB9221C8D14DFE12908@qq.com
Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_meminit.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/lib/test_meminit.c~lib-test_meminit-add-checks-for-the-allocation-functions
+++ a/lib/test_meminit.c
@@ -67,17 +67,24 @@ static int __init do_alloc_pages_order(i
 	size_t size = PAGE_SIZE << order;
 
 	page = alloc_pages(GFP_KERNEL, order);
+	if (!page)
+		goto err;
 	buf = page_address(page);
 	fill_with_garbage(buf, size);
 	__free_pages(page, order);
 
 	page = alloc_pages(GFP_KERNEL, order);
+	if (!page)
+		goto err;
 	buf = page_address(page);
 	if (count_nonzero_bytes(buf, size))
 		(*total_failures)++;
 	fill_with_garbage(buf, size);
 	__free_pages(page, order);
 	return 1;
+err:
+	(*total_failures)++;
+	return 1;
 }
 
 /* Test the page allocator by calling alloc_pages with different orders. */
@@ -100,15 +107,22 @@ static int __init do_kmalloc_size(size_t
 	void *buf;
 
 	buf = kmalloc(size, GFP_KERNEL);
+	if (!buf)
+		goto err;
 	fill_with_garbage(buf, size);
 	kfree(buf);
 
 	buf = kmalloc(size, GFP_KERNEL);
+	if (!buf)
+		goto err;
 	if (count_nonzero_bytes(buf, size))
 		(*total_failures)++;
 	fill_with_garbage(buf, size);
 	kfree(buf);
 	return 1;
+err:
+	(*total_failures)++;
+	return 1;
 }
 
 /* Test vmalloc() with given parameters. */
@@ -117,15 +131,22 @@ static int __init do_vmalloc_size(size_t
 	void *buf;
 
 	buf = vmalloc(size);
+	if (!buf)
+		goto err;
 	fill_with_garbage(buf, size);
 	vfree(buf);
 
 	buf = vmalloc(size);
+	if (!buf)
+		goto err;
 	if (count_nonzero_bytes(buf, size))
 		(*total_failures)++;
 	fill_with_garbage(buf, size);
 	vfree(buf);
 	return 1;
+err:
+	(*total_failures)++;
+	return 1;
 }
 
 /* Test kmalloc()/vmalloc() by allocating objects of different sizes. */
_

Patches currently in -mm which might be from xkernel.wang@foxmail.com are



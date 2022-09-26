Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA4F5C07E9D
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 17:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiIZRSl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 13:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiIZRSH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 13:18:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67DCB5E5E
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 09:31:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 958EDB80B2B
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 16:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24BE9C433C1;
        Mon, 26 Sep 2022 16:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664209878;
        bh=GiOEyKS2dWuKQ8QjDaGTjq/R9sAqEyBuYf0JhW/PBUg=;
        h=Date:To:From:Subject:From;
        b=UtUBVyz3JAi2Fk+sYgRSXn57kdUp8yF23Lx3jlIKRNKysVp+gQZmern9Tjqthm0Vm
         s1Vc22M1n6YFmAqToiJseZcZu9eN2VtNmvCMBNX05qOWQXsSO/FkLPt2SYzFl+JWO0
         KnDaZJbuhR1ZU+ag9/VOQzBo0hGawp7uAjBA4aKI=
Date:   Mon, 26 Sep 2022 09:31:15 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@gmail.com, xkernel.wang@foxmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_meminit-add-checks-for-the-allocation-functions.patch added to mm-unstable branch
Message-Id: <20220926163118.24BE9C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_meminit: add checks for the allocation functions
has been added to the -mm mm-unstable branch.  Its filename is
     lib-test_meminit-add-checks-for-the-allocation-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_meminit-add-checks-for-the-allocation-functions.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

lib-test_meminit-add-checks-for-the-allocation-functions.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2017C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236168AbiEJEXR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236413AbiEJEWn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:22:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D771C0F11
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26AB36176A
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFBEC385A6;
        Tue, 10 May 2022 04:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156260;
        bh=rSNs8sQq58xDTwSnS7QVtJgT3VmbjsneS9l0V2kFsqk=;
        h=Date:To:From:Subject:From;
        b=qDSZrCzAFxgPxsmzvR/NLPSPAQMVIAxU6AaZxZ+PF6Y/OUCPzP57YkLqCz/iwnQ4q
         jLfLqoS4HFoqNDjFbjcAnQZrugg3MzeOktcOlP7PV6zFyACGXIc6XrJpefosIDR3I6
         fd3s44IJR9Ad4dlwfbERITCtYXGS5l5JJx0KtbYs=
Date:   Mon, 09 May 2022 21:17:39 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@gmail.com, akpm@linux-foundation.org,
        xkernel.wang@foxmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-test_meminit-optimize-do_kmem_cache_rcu_persistent-test.patch removed from -mm tree
Message-Id: <20220510041740.7CFBEC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/test_meminit: optimize do_kmem_cache_rcu_persistent() test
has been removed from the -mm tree.  Its filename was
     lib-test_meminit-optimize-do_kmem_cache_rcu_persistent-test.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xiaoke Wang <xkernel.wang@foxmail.com>
Subject: lib/test_meminit: optimize do_kmem_cache_rcu_persistent() test

To make the test more robust, there are the following changes:
1. add a check for the return value of kmem_cache_alloc().
2. properly release the object `buf` on several error paths.
3. release the objects of `used_objects` if we never hit `saved_ptr`.
4. destroy the created cache by default.

Link: https://lkml.kernel.org/r/tencent_7CB95F1C3914BCE1CA4A61FF7C20E7CCB108@qq.com
Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Xiaoke Wang <xkernel.wang@foxmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_meminit.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/lib/test_meminit.c~lib-test_meminit-optimize-do_kmem_cache_rcu_persistent-test
+++ a/lib/test_meminit.c
@@ -279,13 +279,18 @@ static int __init do_kmem_cache_rcu_pers
 	c = kmem_cache_create("test_cache", size, size, SLAB_TYPESAFE_BY_RCU,
 			      NULL);
 	buf = kmem_cache_alloc(c, GFP_KERNEL);
+	if (!buf)
+		goto out;
 	saved_ptr = buf;
 	fill_with_garbage(buf, size);
 	buf_contents = kmalloc(size, GFP_KERNEL);
-	if (!buf_contents)
+	if (!buf_contents) {
+		kmem_cache_free(c, buf);
 		goto out;
+	}
 	used_objects = kmalloc_array(maxiter, sizeof(void *), GFP_KERNEL);
 	if (!used_objects) {
+		kmem_cache_free(c, buf);
 		kfree(buf_contents);
 		goto out;
 	}
@@ -306,11 +311,14 @@ static int __init do_kmem_cache_rcu_pers
 		}
 	}
 
+	for (iter = 0; iter < maxiter; iter++)
+		kmem_cache_free(c, used_objects[iter]);
+
 free_out:
-	kmem_cache_destroy(c);
 	kfree(buf_contents);
 	kfree(used_objects);
 out:
+	kmem_cache_destroy(c);
 	*total_failures += fail;
 	return 1;
 }
_

Patches currently in -mm which might be from xkernel.wang@foxmail.com are



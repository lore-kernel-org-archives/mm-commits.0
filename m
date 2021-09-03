Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCC09C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7D9E61131
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239176AbhICVA0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:59150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349960AbhICVAZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:00:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A5D6610FD;
        Fri,  3 Sep 2021 20:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702764;
        bh=QXQxDH8gvGzqU8WOBYpI+b88+Jb/DrnGq7O36z+UT70=;
        h=Date:From:To:Subject:From;
        b=xoOMW7kguESgsyqIXw7/pT5ThFQUHm5FDQaj9uODPz33UPEzOQrX7D1MegIunOnDo
         cmUE3cAahx5QKo8iaHXltF8b3gWoN2nTL5tol6roJ2guXEpXCCVXA9aZI+YDPFGwcZ
         bD9ybUVJ3fqcguTCDsNmdGCoSfHf4wUSJBtEJNr0=
Date:   Fri, 03 Sep 2021 13:59:24 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org
Subject:  [merged]
 kasan-test-avoid-corrupting-memory-in-copy_user_test.patch removed from -mm
 tree
Message-ID: <20210903205924.1udZ9JYkU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: test: avoid corrupting memory in copy_user_test
has been removed from the -mm tree.  Its filename was
     kasan-test-avoid-corrupting-memory-in-copy_user_test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@gmail.com>
Subject: kasan: test: avoid corrupting memory in copy_user_test

copy_user_test() does writes past the allocated object.  As the result, it
corrupts kernel memory, which might lead to crashes with the HW_TAGS mode,
as it neither uses quarantine nor redzones.

(Technically, this test can't yet be enabled with the HW_TAGS mode, but
this will be implemented in the future.)

Adjust the test to only write memory within the aligned kmalloc object.

Link: https://lkml.kernel.org/r/19bf3a5112ee65b7db88dc731643b657b816c5e8.1628779805.git.andreyknvl@gmail.com
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan_module.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/lib/test_kasan_module.c~kasan-test-avoid-corrupting-memory-in-copy_user_test
+++ a/lib/test_kasan_module.c
@@ -15,13 +15,11 @@
 
 #include "../mm/kasan/kasan.h"
 
-#define OOB_TAG_OFF (IS_ENABLED(CONFIG_KASAN_GENERIC) ? 0 : KASAN_GRANULE_SIZE)
-
 static noinline void __init copy_user_test(void)
 {
 	char *kmem;
 	char __user *usermem;
-	size_t size = 10;
+	size_t size = 128 - KASAN_GRANULE_SIZE;
 	int __maybe_unused unused;
 
 	kmem = kmalloc(size, GFP_KERNEL);
@@ -38,25 +36,25 @@ static noinline void __init copy_user_te
 	}
 
 	pr_info("out-of-bounds in copy_from_user()\n");
-	unused = copy_from_user(kmem, usermem, size + 1 + OOB_TAG_OFF);
+	unused = copy_from_user(kmem, usermem, size + 1);
 
 	pr_info("out-of-bounds in copy_to_user()\n");
-	unused = copy_to_user(usermem, kmem, size + 1 + OOB_TAG_OFF);
+	unused = copy_to_user(usermem, kmem, size + 1);
 
 	pr_info("out-of-bounds in __copy_from_user()\n");
-	unused = __copy_from_user(kmem, usermem, size + 1 + OOB_TAG_OFF);
+	unused = __copy_from_user(kmem, usermem, size + 1);
 
 	pr_info("out-of-bounds in __copy_to_user()\n");
-	unused = __copy_to_user(usermem, kmem, size + 1 + OOB_TAG_OFF);
+	unused = __copy_to_user(usermem, kmem, size + 1);
 
 	pr_info("out-of-bounds in __copy_from_user_inatomic()\n");
-	unused = __copy_from_user_inatomic(kmem, usermem, size + 1 + OOB_TAG_OFF);
+	unused = __copy_from_user_inatomic(kmem, usermem, size + 1);
 
 	pr_info("out-of-bounds in __copy_to_user_inatomic()\n");
-	unused = __copy_to_user_inatomic(usermem, kmem, size + 1 + OOB_TAG_OFF);
+	unused = __copy_to_user_inatomic(usermem, kmem, size + 1);
 
 	pr_info("out-of-bounds in strncpy_from_user()\n");
-	unused = strncpy_from_user(kmem, usermem, size + 1 + OOB_TAG_OFF);
+	unused = strncpy_from_user(kmem, usermem, size + 1);
 
 	vm_munmap((unsigned long)usermem, PAGE_SIZE);
 	kfree(kmem);
_

Patches currently in -mm which might be from andreyknvl@gmail.com are



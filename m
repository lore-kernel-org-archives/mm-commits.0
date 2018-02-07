From: akpm@linux-foundation.org
Subject: [merged]
 kasan-remove-redundant-initialization-of-variable-real_size.patch removed
 from -mm tree
Date: Wed, 07 Feb 2018 11:55:44 -0800
Message-ID: <20180207195544.76Zf3hQZu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58096 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754421AbeBGTzp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:55:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, colin.king@canonical.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: remove redundant initialization of variable 'real_size'
has been removed from the -mm tree.  Its filename was
     kasan-remove-redundant-initialization-of-variable-real_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: kasan: remove redundant initialization of variable 'real_size'

Variable real_size is initialized with a value that is never read, it is
re-assigned a new value later on, hence the initialization is redundant
and can be removed.

Cleans up clang warning:
lib/test_kasan.c:422:21: warning: Value stored to 'real_size' during
its initialization is never read

Link: http://lkml.kernel.org/r/20180206144950.32457-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/test_kasan.c~kasan-remove-redundant-initialization-of-variable-real_size lib/test_kasan.c
--- a/lib/test_kasan.c~kasan-remove-redundant-initialization-of-variable-real_size
+++ a/lib/test_kasan.c
@@ -419,7 +419,7 @@ static noinline void __init kasan_stack_
 static noinline void __init ksize_unpoisons_memory(void)
 {
 	char *ptr;
-	size_t size = 123, real_size = size;
+	size_t size = 123, real_size;
 
 	pr_info("ksize() unpoisons the whole allocated chunk\n");
 	ptr = kmalloc(size, GFP_KERNEL);
_

Patches currently in -mm which might be from colin.king@canonical.com are

mm-ksm-make-function-stable_node_dup-static.patch
mm-swap-make-pointer-swap_avail_heads-static.patch


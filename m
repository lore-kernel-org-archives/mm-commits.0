From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn]
 kasan-initialise-array-in-kasan_memcmp-test.patch removed from -mm tree
Date: Sat, 25 Apr 2020 17:41:15 -0700
Message-ID: <20200426004115.HNGMyO3fi%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbgDZAlR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 25 Apr 2020 20:41:17 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, danielmicay@gmail.com, dja@axtens.net, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: initialise array in kasan_memcmp test
has been removed from the -mm tree.  Its filename was
     kasan-initialise-array-in-kasan_memcmp-test.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Daniel Axtens <dja@axtens.net>
Subject: kasan: initialise array in kasan_memcmp test

memcmp may bail out before accessing all the memory if the buffers contain
differing bytes.  kasan_memcmp calls memcmp with a stack array.  Stack
variables are not necessarily initialised (in the absence of a compiler
plugin, at least).  Sometimes this causes the memcpy to bail early thus
fail to trigger kasan.

Make sure the array initialised to zero in the code.

No other test is dependent on the contents of an array on the stack.

Link: http://lkml.kernel.org/r/20200423154503.5103-4-dja@axtens.net
Signed-off-by: Daniel Axtens <dja@axtens.net>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_kasan.c~kasan-initialise-array-in-kasan_memcmp-test
+++ a/lib/test_kasan.c
@@ -638,7 +638,7 @@ static noinline void __init kasan_memcmp
 {
 	char *ptr;
 	size_t size = 24;
-	int arr[9];
+	int arr[9] = {};
 
 	pr_info("out-of-bounds in memcmp\n");
 	ptr = kmalloc(size, GFP_KERNEL | __GFP_ZERO);
_

Patches currently in -mm which might be from dja@axtens.net are

kasan-stop-tests-being-eliminated-as-dead-code-with-fortify_source.patch
kasan-stop-tests-being-eliminated-as-dead-code-with-fortify_source-v4.patch
stringh-fix-incompatibility-between-fortify_source-and-kasan.patch

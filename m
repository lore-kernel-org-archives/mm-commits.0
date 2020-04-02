From: akpm@linux-foundation.org
Subject: [folded-merged]
 kasan-fix-wstringop-overflow-warning.patch removed from -mm tree
Date: Wed, 01 Apr 2020 20:34:40 -0700
Message-ID: <20200402033440.jqWttcNYy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387403AbgDBDel (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 1 Apr 2020 23:34:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, cai@lca.pw, dvyukov@google.com, mm-commits@vger.kernel.org, sfr@canb.auug.org.au, walter-zh.wu@mediatek.com


The patch titled
     Subject: kasan: fix -Wstringop-overflow warning
has been removed from the -mm tree.  Its filename was
     kasan-fix-wstringop-overflow-warning.patch

This patch was dropped because it was folded into kasan-add-test-for-invalid-size-in-memmove.patch

------------------------------------------------------
From: Walter Wu <walter-zh.wu@mediatek.com>
Subject: kasan: fix -Wstringop-overflow warning

Compiling with gcc-9.2.1 points out below warnings.

In function 'memmove',
    inlined from 'kmalloc_memmove_invalid_size' at lib/test_kasan.c:301:2:
include/linux/string.h:441:9: warning: '__builtin_memmove' specified
bound 18446744073709551614 exceeds maximum object size
9223372036854775807 [-Wstringop-overflow=]

Why generate this warning?  Because our test function deliberately pass a
negative number in memmove(), so we need to make it "volatile" so that
compiler doesn't see it.

The volatile trick is documented here:
https://gcc.gnu.org/onlinedocs/gcc-9.2.0/gcc/Warning-Options.html#Warning-Options

"They do not occur for variables or elements declared volatile. Because
these warnings depend on optimization, the exact variables or elements
for which there are warnings depends on the precise optimization options
and version of GCC used."

Link: http://lkml.kernel.org/r/20200311134244.13016-1-walter-zh.wu@mediatek.com
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/test_kasan.c~kasan-fix-wstringop-overflow-warning
+++ a/lib/test_kasan.c
@@ -289,6 +289,7 @@ static noinline void __init kmalloc_memm
 {
 	char *ptr;
 	size_t size = 64;
+	volatile size_t invalid_size = -2;
 
 	pr_info("invalid size in memmove\n");
 	ptr = kmalloc(size, GFP_KERNEL);
@@ -298,7 +299,7 @@ static noinline void __init kmalloc_memm
 	}
 
 	memset((char *)ptr, 0, 64);
-	memmove((char *)ptr, (char *)ptr + 4, -2);
+	memmove((char *)ptr, (char *)ptr + 4, invalid_size);
 	kfree(ptr);
 }
 
_

Patches currently in -mm which might be from walter-zh.wu@mediatek.com are

kasan-detect-negative-size-in-memory-operation-function.patch
kasan-add-test-for-invalid-size-in-memmove.patch

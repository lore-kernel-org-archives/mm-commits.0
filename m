From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-fix-wstringop-overflow-warning.patch added to -mm
 tree
Date: Wed, 11 Mar 2020 16:38:04 -0700
Message-ID: <20200311233804.wIi8_12GX%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgCKXiF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 11 Mar 2020 19:38:05 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, cai@lca.pw, dvyukov@google.com, mm-commits@vger.kernel.org, sfr@canb.auug.org.au, walter-zh.wu@mediatek.com


The patch titled
     Subject: kasan: fix -Wstringop-overflow warning
has been added to the -mm tree.  Its filename is
     kasan-fix-wstringop-overflow-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-wstringop-overflow-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-wstringop-overflow-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
kasan-fix-wstringop-overflow-warning.patch

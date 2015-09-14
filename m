From: akpm@linux-foundation.org
Subject: + kasan-fix-a-type-conversion-error.patch added to -mm tree
Date: Mon, 14 Sep 2015 15:06:50 -0700
Message-ID: <55f744fa.v7FbhEh6UZlumVnZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbbINWGv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 18:06:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: long.wanglong@huawei.com, aryabinin@virtuozzo.com, vladimir.murzin@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: Fix a type conversion error
has been added to the -mm tree.  Its filename is
     kasan-fix-a-type-conversion-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-a-type-conversion-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-a-type-conversion-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang Long <long.wanglong@huawei.com>
Subject: kasan: Fix a type conversion error

The current KASAN code can not find the following out-of-bounds bugs:

	char *ptr;
	ptr = kmalloc(8, GFP_KERNEL);
	memset(ptr+7, 0, 2);

the cause of the problem is the type conversion error in
*memory_is_poisoned_n* function.  So this patch fix that.

Signed-off-by: Wang Long <long.wanglong@huawei.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/kasan/kasan.c~kasan-fix-a-type-conversion-error mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-fix-a-type-conversion-error
+++ a/mm/kasan/kasan.c
@@ -220,7 +220,7 @@ static __always_inline bool memory_is_po
 		s8 *last_shadow = (s8 *)kasan_mem_to_shadow((void *)last_byte);
 
 		if (unlikely(ret != (unsigned long)last_shadow ||
-			((last_byte & KASAN_SHADOW_MASK) >= *last_shadow)))
+			((long)(last_byte & KASAN_SHADOW_MASK) >= *last_shadow)))
 			return true;
 	}
 	return false;
_

Patches currently in -mm which might be from long.wanglong@huawei.com are

lib-test_kasan-add-some-testcases.patch
kasan-fix-a-type-conversion-error.patch


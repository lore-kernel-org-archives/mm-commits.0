From: akpm@linux-foundation.org
Subject: [merged] kasan-fix-a-type-conversion-error.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:17:51 -0800
Message-ID: <563d0aef.FRaNOWYwXXtyJ6VJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161810AbbKFURv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:17:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: long.wanglong@huawei.com, aryabinin@virtuozzo.com, vladimir.murzin@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: Fix a type conversion error
has been removed from the -mm tree.  Its filename was
     kasan-fix-a-type-conversion-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -203,7 +203,7 @@ static __always_inline bool memory_is_po
 		s8 *last_shadow = (s8 *)kasan_mem_to_shadow((void *)last_byte);
 
 		if (unlikely(ret != (unsigned long)last_shadow ||
-			((last_byte & KASAN_SHADOW_MASK) >= *last_shadow)))
+			((long)(last_byte & KASAN_SHADOW_MASK) >= *last_shadow)))
 			return true;
 	}
 	return false;
_

Patches currently in -mm which might be from long.wanglong@huawei.com are



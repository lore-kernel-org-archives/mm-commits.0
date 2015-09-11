From: akpm@linux-foundation.org
Subject: + kasan-fix-last-shadow-judgement-in-memory_is_poisoned_16.patch
 added to -mm tree
Date: Fri, 11 Sep 2015 14:58:46 -0700
Message-ID: <55f34e96.BVVw7fgjMY1fe0nj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbbIKV6r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 17:58:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, adech.fo@gmail.com, aryabinin@virtuozzo.com, mmarek@suse.cz, rusty@rustcorp.com.au, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix last shadow judgement in memory_is_poisoned_16()
has been added to the -mm tree.  Its filename is
     kasan-fix-last-shadow-judgement-in-memory_is_poisoned_16.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-last-shadow-judgement-in-memory_is_poisoned_16.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-last-shadow-judgement-in-memory_is_poisoned_16.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: kasan: fix last shadow judgement in memory_is_poisoned_16()

The shadow which correspond 16 bytes memory may span 2 or 3 bytes.  If the
memory is aligned on 8, then the shadow takes only 2 bytes.  So we check
"shadow_first_bytes" is enough, and need not to call
"memory_is_poisoned_1(addr + 15);".  But the code "if
(likely(!last_byte))" is wrong judgement.

e.g.  addr=0, so last_byte = 15 & KASAN_SHADOW_MASK = 7, then the code
will continue to call "memory_is_poisoned_1(addr + 15);"

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andrey Konovalov <adech.fo@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Marek <mmarek@suse.cz>
Cc: <zhongjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/kasan/kasan.c~kasan-fix-last-shadow-judgement-in-memory_is_poisoned_16 mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-fix-last-shadow-judgement-in-memory_is_poisoned_16
+++ a/mm/kasan/kasan.c
@@ -135,12 +135,11 @@ static __always_inline bool memory_is_po
 
 	if (unlikely(*shadow_addr)) {
 		u16 shadow_first_bytes = *(u16 *)shadow_addr;
-		s8 last_byte = (addr + 15) & KASAN_SHADOW_MASK;
 
 		if (unlikely(shadow_first_bytes))
 			return true;
 
-		if (likely(!last_byte))
+		if (likely(IS_ALIGNED(addr, 8)))
 			return false;
 
 		return memory_is_poisoned_1(addr + 15);
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

kasan-fix-last-shadow-judgement-in-memory_is_poisoned_16.patch


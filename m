From: akpm@linux-foundation.org
Subject: + arm64-kasan-dont-allocate-extra-shadow-memory.patch added to
 -mm tree
Date: Thu, 01 Jun 2017 14:52:03 -0700
Message-ID: <59308c83.j6+kjzIyZiJxWzA4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60280 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbdFAVwE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2017 17:52:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, catalin.marinas@arm.com, dvyukov@google.com, glider@google.com, hpa@zytor.com, mark.rutland@arm.com, mingo@elte.hu, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64/kasan: don't allocate extra shadow memory
has been added to the -mm tree.  Its filename is
     arm64-kasan-dont-allocate-extra-shadow-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-kasan-dont-allocate-extra-shadow-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-kasan-dont-allocate-extra-shadow-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: arm64/kasan: don't allocate extra shadow memory

We used to read several bytes of the shadow memory in advance.  Therefore
additional shadow memory mapped to prevent crash if speculative load would
happen near the end of the mapped shadow memory.

Now we don't have such speculative loads, so we no longer need to map
additional shadow memory.

Link: http://lkml.kernel.org/r/20170601162338.23540-3-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/kasan_init.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN arch/arm64/mm/kasan_init.c~arm64-kasan-dont-allocate-extra-shadow-memory arch/arm64/mm/kasan_init.c
--- a/arch/arm64/mm/kasan_init.c~arm64-kasan-dont-allocate-extra-shadow-memory
+++ a/arch/arm64/mm/kasan_init.c
@@ -191,14 +191,8 @@ void __init kasan_init(void)
 		if (start >= end)
 			break;
 
-		/*
-		 * end + 1 here is intentional. We check several shadow bytes in
-		 * advance to slightly speed up fastpath. In some rare cases
-		 * we could cross boundary of mapped shadow, so we just map
-		 * some more here.
-		 */
 		vmemmap_populate((unsigned long)kasan_mem_to_shadow(start),
-				(unsigned long)kasan_mem_to_shadow(end) + 1,
+				(unsigned long)kasan_mem_to_shadow(end),
 				pfn_to_nid(virt_to_pfn(start)));
 	}
 
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-kasan-get-rid-of-speculative-shadow-checks.patch
x86-kasan-dont-allocate-extra-shadow-memory.patch
arm64-kasan-dont-allocate-extra-shadow-memory.patch
mm-kasan-add-support-for-memory-hotplug.patch


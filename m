From: akpm@linux-foundation.org
Subject: + x86-kasan-dont-allocate-extra-shadow-memory.patch added to -mm
 tree
Date: Thu, 01 Jun 2017 14:52:01 -0700
Message-ID: <59308c81.ESO5O0sHsbFkkDrK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60270 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751078AbdFAVwC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2017 17:52:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, catalin.marinas@arm.com, dvyukov@google.com, glider@google.com, hpa@zytor.com, mark.rutland@arm.com, mingo@elte.hu, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86/kasan: don't allocate extra shadow memory
has been added to the -mm tree.  Its filename is
     x86-kasan-dont-allocate-extra-shadow-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-kasan-dont-allocate-extra-shadow-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-kasan-dont-allocate-extra-shadow-memory.patch

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
Subject: x86/kasan: don't allocate extra shadow memory

We used to read several bytes of the shadow memory in advance.  Therefore
additional shadow memory mapped to prevent crash if speculative load would
happen near the end of the mapped shadow memory.

Now we don't have such speculative loads, so we no longer need to map
additional shadow memory.

Link: http://lkml.kernel.org/r/20170601162338.23540-2-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/kasan_init_64.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN arch/x86/mm/kasan_init_64.c~x86-kasan-dont-allocate-extra-shadow-memory arch/x86/mm/kasan_init_64.c
--- a/arch/x86/mm/kasan_init_64.c~x86-kasan-dont-allocate-extra-shadow-memory
+++ a/arch/x86/mm/kasan_init_64.c
@@ -23,12 +23,7 @@ static int __init map_range(struct range
 	start = (unsigned long)kasan_mem_to_shadow(pfn_to_kaddr(range->start));
 	end = (unsigned long)kasan_mem_to_shadow(pfn_to_kaddr(range->end));
 
-	/*
-	 * end + 1 here is intentional. We check several shadow bytes in advance
-	 * to slightly speed up fastpath. In some rare cases we could cross
-	 * boundary of mapped shadow, so we just map some more here.
-	 */
-	return vmemmap_populate(start, end + 1, NUMA_NO_NODE);
+	return vmemmap_populate(start, end, NUMA_NO_NODE);
 }
 
 static void __init clear_pgds(unsigned long start,
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-kasan-get-rid-of-speculative-shadow-checks.patch
x86-kasan-dont-allocate-extra-shadow-memory.patch
arm64-kasan-dont-allocate-extra-shadow-memory.patch
mm-kasan-add-support-for-memory-hotplug.patch


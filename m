From: akpm@linux-foundation.org
Subject: [merged] x86-kasan-dont-allocate-extra-shadow-memory.patch
 removed from -mm tree
Date: Tue, 11 Jul 2017 12:25:28 -0700
Message-ID: <20170711192528.kuLj6vg19%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48194 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933785AbdGKTZ3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:25:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, catalin.marinas@arm.com, dvyukov@google.com, glider@google.com, hpa@zytor.com, mark.rutland@arm.com, mingo@elte.hu, mm-commits@vger.kernel.org, tglx@linutronix.de, will.deacon@arm.com


The patch titled
     Subject: x86/kasan: don't allocate extra shadow memory
has been removed from the -mm tree.  Its filename was
     x86-kasan-dont-allocate-extra-shadow-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



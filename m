From: akpm@linux-foundation.org
Subject: + memblock-dont-adjust-size-in-memblock_find_base.patch added to -mm tree
Date: Thu, 03 Feb 2011 12:25:22 -0800
Message-ID: <201102032025.p13KPMWa022800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751561Ab1BCU0K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 15:26:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org, airlied@linux.ie, benh@kernel.crashing.org, davem@davemloft.net, hpa@zytor.com, mingo@elte.hu


The patch titled
     memblock: don't adjust size in memblock_find_base()
has been added to the -mm tree.  Its filename is
     memblock-dont-adjust-size-in-memblock_find_base.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memblock: don't adjust size in memblock_find_base()
From: Yinghai Lu <yinghai@kernel.org>

While applying patch to use memblock to find aperture for 64bit x86.
Ingo found system with 1g + force_iommu

> No AGP bridge found
> Node 0: aperture @ 38000000 size 32 MB
> Aperture pointing to e820 RAM. Ignoring.
> Your BIOS doesn't leave a aperture memory hole
> Please enable the IOMMU option in the BIOS setup
> This costs you 64 MB of RAM
> Cannot allocate aperture memory hole (0,65536K)

the corresponding code:
	addr = memblock_find_in_range(0, 1ULL<<32, aper_size, 512ULL<<20);
	if (addr == MEMBLOCK_ERROR || addr + aper_size > 0xffffffff) {
		printk(KERN_ERR
			"Cannot allocate aperture memory hole (%lx,%uK)\n",
				addr, aper_size>>10);
		return 0;
	}
	memblock_x86_reserve_range(addr, addr + aper_size, "aperture64")

it fails because memblock core code align the size with 512M. that could make
size way too big.

So don't align the size in that case.

actually __memblock_alloc_base, the another caller already align that before calling that function.

BTW. x86 does not use __memblock_alloc_base...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/memblock.c~memblock-dont-adjust-size-in-memblock_find_base mm/memblock.c
--- a/mm/memblock.c~memblock-dont-adjust-size-in-memblock_find_base
+++ a/mm/memblock.c
@@ -137,8 +137,6 @@ static phys_addr_t __init_memblock membl
 
 	BUG_ON(0 == size);
 
-	size = memblock_align_up(size, align);

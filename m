Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FB71EF389
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545880; cv=none; b=lLLjKyihKRgnkFnzaJ9GbsY3uAmH24sqzdaHuzp1ERhFopKSLHE5NOzaKkdwAYB/73Mh4TdI/w4QC1c3g8+F4WWj0VYo23H9ufBtAQUwlSYHqSg+VcitOvuZaFZkR7VoTO7StCkSUBxp8tCo17AtsCLbO+ELd1FnWQEEYFANvEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545880; c=relaxed/simple;
	bh=As6+zFUekms0F/cnHmPjv33WPsqeee04OHqL49Q43cA=;
	h=Date:To:From:Subject:Message-Id; b=LzjF6f2Z5wrG4rPo00DCPnsdVGt2060odByMCJvDzGIjaOLMSh4k13Jv4orneIpnBtbwiroUX/n9Gy7PbHtF2Joj1jpJm29rFgSuL9SFtnQyTtafvyPd1oBD3FB0rog6uqOPl0YhbHgkH1WFV/NFtKZHidzPcCgW5HYX9ljvKzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tXo1iSFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tXo1iSFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D68C4CEE4;
	Tue,  1 Apr 2025 22:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545880;
	bh=As6+zFUekms0F/cnHmPjv33WPsqeee04OHqL49Q43cA=;
	h=Date:To:From:Subject:From;
	b=tXo1iSFVNZUJmL+X192i7kIgDl4TkCNWYVlmH+jYqLXxyIR6m2fZWkCwXzn+rwru3
	 Czbr/YK9hilsGYL1rKXHlC5fgnX02HYeAh1XueCgOtrr5B0U2HeZNfPut4mpqIsfRk
	 kUgQSD3anssUOJ8Lslnjl9dlvGel0tHJZoH9IITc=
Date: Tue, 01 Apr 2025 15:17:59 -0700
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,oliver.sang@intel.com,nathan@kernel.org,mingo@redhat.com,luto@kernel.org,jiaxun.yang@flygoat.com,hpa@zytor.com,dave.hansen@linux.intel.com,bp@alien8.de,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_init-init-holes-in-the-end-of-the-memory-map-for-flatmem.patch removed from -mm tree
Message-Id: <20250401221800.29D68C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: init holes in the end of the memory map for FLATMEM
has been removed from the -mm tree.  Its filename was
     mm-mm_init-init-holes-in-the-end-of-the-memory-map-for-flatmem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm/mm_init: init holes in the end of the memory map for FLATMEM
Date: Tue, 25 Mar 2025 13:49:27 +0200

Patch series "mm: fixes for fallouts from mem_init() cleanup".

These are the fixes for fallouts from mem_init() cleanup reported by
Nathan Chancellor and kbuild.  The details are in the commit messages.


This patch (of 2):

Kernel test robot reports the following crash on 32-bit system with
FLATMEM and DEBUG_VM_PGFLAGS enabled:

[    0.478822][    T0] kernel BUG at include/linux/page-flags.h:536!
[    0.479312][    T0] Oops: invalid opcode: 0000 [#1] PREEMPT SMP
[    0.479768][    T0] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.14.0-rc6-00357-g8268af309d07 #1
[    0.480470][    T0] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
[ 0.481260][ T0] EIP: reserve_bootmem_region (include/linux/page-flags.h:536)
[ 0.481683][ T0] Code: 5d c3 01 f1 89 c8 ba e1 38 f4 c3 e8 1e 37 8e fc 0f 0b b8 90 e2 62 c4 e8 e2 05 5e fc 01 f1 89 c8 ba be 85 f7 c3 e8 04 37 8e fc <0f> 0b b8 80 e2 62 c4 e8 c8 05 5e fc 55 89 e5 53 57 56 83 ec 10 89
[    0.483177][    T0] EAX: 00000000 EBX: c425df50 ECX: 00000000 EDX: 00000000
[    0.483712][    T0] ESI: 017ffc00 EDI: ffffffff EBP: c425df34 ESP: c425df2c
[    0.484248][    T0] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00210046
[    0.484846][    T0] CR0: 80050033 CR2: 00000000 CR3: 04b48000 CR4: 00000090
[    0.485376][    T0] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    0.485907][    T0] DR6: fffe0ff0 DR7: 00000400
[    0.486253][    T0] Call Trace:
[ 0.486494][ T0] ? __die_body (arch/x86/kernel/dumpstack.c:478)
[ 0.486822][ T0] ? die (arch/x86/kernel/dumpstack.c:?)
[ 0.487099][ T0] ? do_trap (arch/x86/kernel/traps.c:? arch/x86/kernel/traps.c:197)
[ 0.487409][ T0] ? do_error_trap (arch/x86/kernel/traps.c:217)
[ 0.487752][ T0] ? reserve_bootmem_region (include/linux/page-flags.h:536)
[ 0.488153][ T0] ? exc_overflow (arch/x86/kernel/traps.c:301)
[ 0.488490][ T0] ? handle_invalid_op (arch/x86/kernel/traps.c:254)
[ 0.488869][ T0] ? reserve_bootmem_region (include/linux/page-flags.h:536)
[ 0.489271][ T0] ? exc_invalid_op (arch/x86/kernel/traps.c:316)
[ 0.489619][ T0] ? handle_exception (arch/x86/entry/entry_32.S:1055)
[ 0.489996][ T0] ? exc_overflow (arch/x86/kernel/traps.c:301)
[ 0.490332][ T0] ? reserve_bootmem_region (include/linux/page-flags.h:536)
[ 0.490733][ T0] ? exc_overflow (arch/x86/kernel/traps.c:301)
[ 0.491068][ T0] ? reserve_bootmem_region (include/linux/page-flags.h:536)
[ 0.491470][ T0] memmap_init_reserved_pages (mm/memblock.c:2203)
[ 0.491887][ T0] free_low_memory_core_early (mm/memblock.c:?)
[ 0.492302][ T0] memblock_free_all (mm/memblock.c:2272 include/linux/atomic/atomic-arch-fallback.h:546 include/linux/atomic/atomic-long.h:123 include/linux/atomic/atomic-instrumented.h:3261 include/linux/mm.h:67 mm/memblock.c:2273)
[ 0.492659][ T0] mem_init (arch/x86/mm/init_32.c:735)
[ 0.492952][ T0] mm_core_init (mm/mm_init.c:2730)
[ 0.493271][ T0] start_kernel (init/main.c:958)
[ 0.493604][ T0] i386_start_kernel (arch/x86/kernel/head32.c:79)
[ 0.493969][ T0] startup_32_smp (arch/x86/kernel/head_32.S:292)

The crash happens because after commit 8268af309d07 ("arch, mm: set
max_mapnr when allocating memory map for FLATMEM") max_mapnr is rounded up
to MAX_ORDER_NR_PAGES and the pages in the end of the memory map are
passing pfn_valid() check in reserve_bootmem_region().

Make sure that that pages in the end of the memory map are initialized,
just like the pages in the end of the last section for SPARSEMEM.

Link: https://lkml.kernel.org/r/20250325114928.1791109-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20250325114928.1791109-2-rppt@kernel.org
Fixes: 8268af309d07 ("arch, mm: set max_mapnr when allocating memory map for FLATMEM")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202503241424.d16223ec-lkp@intel.com
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/mm_init.c~mm-mm_init-init-holes-in-the-end-of-the-memory-map-for-flatmem
+++ a/mm/mm_init.c
@@ -984,19 +984,19 @@ static void __init memmap_init(void)
 		}
 	}
 
-#ifdef CONFIG_SPARSEMEM
 	/*
 	 * Initialize the memory map for hole in the range [memory_end,
-	 * section_end].
+	 * section_end] for SPARSEMEM and in the range [memory_end, memmap_end]
+	 * for FLATMEM.
 	 * Append the pages in this hole to the highest zone in the last
 	 * node.
-	 * The call to init_unavailable_range() is outside the ifdef to
-	 * silence the compiler warining about zone_id set but not used;
-	 * for FLATMEM it is a nop anyway
 	 */
+#ifdef CONFIG_SPARSEMEM
 	end_pfn = round_up(end_pfn, PAGES_PER_SECTION);
-	if (hole_pfn < end_pfn)
+#else
+	end_pfn = round_up(end_pfn, MAX_ORDER_NR_PAGES);
 #endif
+	if (hole_pfn < end_pfn)
 		init_unavailable_range(hole_pfn, end_pfn, zone_id, nid);
 }
 
_

Patches currently in -mm which might be from rppt@kernel.org are



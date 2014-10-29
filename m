From: akpm@linux-foundation.org
Subject: [merged]
 x86-cma-reserve-dma-contiguous-area-after-initmem_init.patch removed from
 -mm tree
Date: Wed, 29 Oct 2014 11:23:09 -0700
Message-ID: <5451308d.q8/DqpJK5NFavgoR%akpm__45086.3309008584$1414607009$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48412 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836AbaJ2SXI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Oct 2014 14:23:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weijie.yang@samsung.com, fengguang.wu@intel.com, m.szyprowski@samsung.com, mina86@mina86.com, mingo@elte.hu, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, cma: reserve dma contiguous area after initmem_init()
has been removed from the -mm tree.  Its filename was
     x86-cma-reserve-dma-contiguous-area-after-initmem_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: x86, cma: reserve dma contiguous area after initmem_init()

Fengguang Wu reported a BUG: Int 6: CR2 (null) on x86 platform in
0-day Linux Kernel Performance Test:

[    0.000000] BRK [0x025ee000, 0x025eefff] PGTABLE
[    0.000000] cma: dma_contiguous_reserve(limit 13ffe000)
[    0.000000] cma: dma_contiguous_reserve: reserving 31 MiB for global area
[    0.000000] BUG: Int 6: CR2   (null)
[    0.000000]      EDI c0000000  ESI   (null)  EBP 41c11ea4  EBX 425cc101
[    0.000000]      ESP 41c11e98   ES 0000007b   DS 0000007b
[    0.000000]      EDX 00000001  ECX   (null)  EAX 41cd8150
[    0.000000]      vec 00000006  err   (null)  EIP 41072227   CS 00000060  flg 00210002
[    0.000000] Stack: 425cc150   (null)   (null) 41c11ef4 41d4ee4d   (null) 13ffe000 41c11ec4
[    0.000000]        41c2d900   (null) 13ffe000   (null) 4185793e 0000002e 410c2982 41c11f00
[    0.000000]        410c2df5   (null)   (null)   (null) 425cc150 00013efe   (null) 41c11f28
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.17.0-next-20141008 #815
[    0.000000]  00000000 425cc101 41c11e48 41850786 41c11ea4 41d2b1db 41d95f71 00000006
[    0.000000]  00000000 c0000000 00000000 41c11ea4 425cc101 41c11e98 0000007b 0000007b
[    0.000000]  00000001 00000000 41cd8150 00000006 00000000 41072227 00000060 00210002
[    0.000000] Call Trace:
[    0.000000]  [<41850786>] dump_stack+0x16/0x18
[    0.000000]  [<41d2b1db>] early_idt_handler+0x6b/0x6b
[    0.000000]  [<41072227>] ? __phys_addr+0x2e/0xca
[    0.000000]  [<41d4ee4d>] cma_declare_contiguous+0x3c/0x2d7
[    0.000000]  [<4185793e>] ? _raw_spin_unlock_irqrestore+0x59/0x91
[    0.000000]  [<410c2982>] ? wake_up_klogd+0x8/0x33
[    0.000000]  [<410c2df5>] ? console_unlock+0x448/0x461
[    0.000000]  [<41d6d359>] dma_contiguous_reserve_area+0x27/0x47
[    0.000000]  [<41d6d4d1>] dma_contiguous_reserve+0x158/0x163
[    0.000000]  [<41d33e0f>] setup_arch+0x79b/0xc68
[    0.000000]  [<4184c0b4>] ? printk+0x1c/0x1e
[    0.000000]  [<41d2b7cf>] start_kernel+0x9c/0x456
[    0.000000]  [<41d2b2ca>] i386_start_kernel+0x79/0x7d

see detail: https://lkml.org/lkml/2014/10/8/708

It is because dma_contiguous_reserve() is called before initmem_init() in x86,
the variable high_memory is not initialized but accessed by __pa(high_memory)
in dma_contiguous_reserve().

This patch moves dma_contiguous_reserve() after initmem_init() so that
high_memory is initialized before accessed.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/setup.c~x86-cma-reserve-dma-contiguous-area-after-initmem_init arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~x86-cma-reserve-dma-contiguous-area-after-initmem_init
+++ a/arch/x86/kernel/setup.c
@@ -1128,7 +1128,6 @@ void __init setup_arch(char **cmdline_p)
 	setup_real_mode();
 
 	memblock_set_current_limit(get_max_mapped());
-	dma_contiguous_reserve(max_pfn_mapped << PAGE_SHIFT);
 
 	/*
 	 * NOTE: On x86-32, only from this point on, fixmaps are ready for use.
@@ -1159,6 +1158,7 @@ void __init setup_arch(char **cmdline_p)
 	early_acpi_boot_init();
 
 	initmem_init();
+	dma_contiguous_reserve(max_pfn_mapped << PAGE_SHIFT);
 
 	/*
 	 * Reserve memory for crash kernel after SRAT is parsed so that it
_

Patches currently in -mm which might be from weijie.yang@samsung.com are

zram-avoid-null-pointer-access-in-concurrent-situation.patch
linux-next.patch


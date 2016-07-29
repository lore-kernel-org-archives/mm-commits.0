From: akpm@linux-foundation.org
Subject: [merged]
 arm64-acpi-fix-the-acpi-alignment-exception-when-mem=-specified.patch
 removed from -mm tree
Date: Fri, 29 Jul 2016 11:56:49 -0700
Message-ID: <579ba6f1.BJ0gHAzYlklzSPMV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbcG2S4u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:56:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dennis.chen@arm.com, ard.biesheuvel@linaro.org, catalin.marinas@arm.com, kaly.xin@arm.com, mark.rutland@arm.com, matt@codeblueprint.co.uk, mgorman@techsingularity.net, mingo@kernel.org, penberg@kernel.org, rafael@kernel.org, steve.capper@arm.com, tangchen@cn.fujitsu.com, tony.luck@intel.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64:acpi: fix the acpi alignment exception when 'mem=' specified
has been removed from the -mm tree.  Its filename was
     arm64-acpi-fix-the-acpi-alignment-exception-when-mem=-specified.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dennis Chen <dennis.chen@arm.com>
Subject: arm64:acpi: fix the acpi alignment exception when 'mem=' specified

When booting an ACPI enabled kernel with 'mem=x', there is the possibility
that ACPI data regions from the firmware will lie above the memory limit. 
Ordinarily these will be removed by memblock_enforce_memory_limit(.).

Unfortunately, this means that these regions will then be mapped by
acpi_os_ioremap(.) as device memory (instead of normal) thus unaligned
accessess will then provoke alignment faults.

In this patch we adopt memblock_mem_limit_remove_map instead, and this
preserves these ACPI data regions (marked NOMAP) thus ensuring that these
regions are not mapped as device memory.

For example, below is an alignment exception observed on ARM platform
when booting the kernel with 'acpi=on mem=8G':
...
[    0.542475] Unable to handle kernel paging request at virtual address ffff0000080521e7
[    0.550457] pgd = ffff000008aa0000
[    0.553880] [ffff0000080521e7] *pgd=000000801fffe003, *pud=000000801fffd003, *pmd=000000801fffc003, *pte=00e80083ff1c1707
[    0.564939] Internal error: Oops: 96000021 [#1] PREEMPT SMP
[    0.570553] Modules linked in:
[    0.573626] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.7.0-rc3-next-20160616+ #172
[    0.581344] Hardware name: AMD Overdrive/Supercharger/Default string, BIOS ROD1001A 02/09/2016
[    0.590025] task: ffff800001ef0000 ti: ffff800001ef8000 task.ti: ffff800001ef8000
[    0.597571] PC is at acpi_ns_lookup+0x520/0x734
[    0.602134] LR is at acpi_ns_lookup+0x4a4/0x734
[    0.606693] pc : [<ffff0000083b8b10>] lr : [<ffff0000083b8a94>] pstate: 60000045
[    0.614145] sp : ffff800001efb8b0
[    0.617478] x29: ffff800001efb8c0 x28: 000000000000001b
[    0.622829] x27: 0000000000000001 x26: 0000000000000000
[    0.628181] x25: ffff800001efb9e8 x24: ffff000008a10000
[    0.633531] x23: 0000000000000001 x22: 0000000000000001
[    0.638881] x21: ffff000008724000 x20: 000000000000001b
[    0.644230] x19: ffff0000080521e7 x18: 000000000000000d
[    0.649580] x17: 00000000000038ff x16: 0000000000000002
[    0.654929] x15: 0000000000000007 x14: 0000000000007fff
[    0.660278] x13: ffffff0000000000 x12: 0000000000000018
[    0.665627] x11: 000000001fffd200 x10: 00000000ffffff76
[    0.670978] x9 : 000000000000005f x8 : ffff000008725fa8
[    0.676328] x7 : ffff000008a8df70 x6 : ffff000008a8df70
[    0.681679] x5 : ffff000008a8d000 x4 : 0000000000000010
[    0.687027] x3 : 0000000000000010 x2 : 000000000000000c
[    0.692378] x1 : 0000000000000006 x0 : 0000000000000000
...
[    1.262235] [<ffff0000083b8b10>] acpi_ns_lookup+0x520/0x734
[    1.267845] [<ffff0000083a7160>] acpi_ds_load1_begin_op+0x174/0x4fc
[    1.274156] [<ffff0000083c1f4c>] acpi_ps_build_named_op+0xf8/0x220
[    1.280380] [<ffff0000083c227c>] acpi_ps_create_op+0x208/0x33c
[    1.286254] [<ffff0000083c1820>] acpi_ps_parse_loop+0x204/0x838
[    1.292215] [<ffff0000083c2fd4>] acpi_ps_parse_aml+0x1bc/0x42c
[    1.298090] [<ffff0000083bc6e8>] acpi_ns_one_complete_parse+0x1e8/0x22c
[    1.304753] [<ffff0000083bc7b8>] acpi_ns_parse_table+0x8c/0x128
[    1.310716] [<ffff0000083bb8fc>] acpi_ns_load_table+0xc0/0x1e8
[    1.316591] [<ffff0000083c9068>] acpi_tb_load_namespace+0xf8/0x2e8
[    1.322818] [<ffff000008984128>] acpi_load_tables+0x7c/0x110
[    1.328516] [<ffff000008982ea4>] acpi_init+0x90/0x2c0
[    1.333603] [<ffff0000080819fc>] do_one_initcall+0x38/0x12c
[    1.339215] [<ffff000008960cd4>] kernel_init_freeable+0x148/0x1ec
[    1.345353] [<ffff0000086b7d30>] kernel_init+0x10/0xec
[    1.350529] [<ffff000008084e10>] ret_from_fork+0x10/0x40
[    1.355878] Code: b9009fbc 2a00037b 36380057 3219037b (b9400260)
[    1.362035] ---[ end trace 03381e5eb0a24de4 ]---
[    1.366691] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

With 'efi=debug', we can see those ACPI regions loaded by firmware on
that board as:
[    0.000000] efi:   0x0083ff185000-0x0083ff1b4fff [Reserved           |   |  |  |  |  |  |  |   |WB|WT|WC|UC]*
[    0.000000] efi:   0x0083ff1b5000-0x0083ff1c2fff [ACPI Reclaim Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]*
[    0.000000] efi:   0x0083ff223000-0x0083ff224fff [ACPI Memory NVS    |   |  |  |  |  |  |  |   |WB|WT|WC|UC]*

Link: http://lkml.kernel.org/r/1468475036-5852-3-git-send-email-dennis.chen@arm.com
Acked-by: Steve Capper <steve.capper@arm.com>
Signed-off-by: Dennis Chen <dennis.chen@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Kaly Xin <kaly.xin@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm64/mm/init.c~arm64-acpi-fix-the-acpi-alignment-exception-when-mem=-specified arch/arm64/mm/init.c
--- a/arch/arm64/mm/init.c~arm64-acpi-fix-the-acpi-alignment-exception-when-mem=-specified
+++ a/arch/arm64/mm/init.c
@@ -224,7 +224,7 @@ void __init arm64_memblock_init(void)
 	 * via the linear mapping.
 	 */
 	if (memory_limit != (phys_addr_t)ULLONG_MAX) {
-		memblock_enforce_memory_limit(memory_limit);
+		memblock_mem_limit_remove_map(memory_limit);
 		memblock_add(__pa(_text), (u64)(_end - _text));
 	}
 
_

Patches currently in -mm which might be from dennis.chen@arm.com are



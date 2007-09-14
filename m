From: akpm@linux-foundation.org
Subject: - fix-bios-e820-end-address.patch removed from -mm tree
Date: Fri, 14 Sep 2007 15:19:33 -0700
Message-ID: <200709142219.l8EMJX6q027081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34902 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757733AbXINWTj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 18:19:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anil.s.keshavamurthy@intel.com, ak@suse.de, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     Fix BIOS-e820 end address
has been removed from the -mm tree.  Its filename was
     fix-bios-e820-end-address.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: Fix BIOS-e820 end address
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>

--snip of boot message--
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fe8cc00 (usable)
----end snip---

As you see from above the address 0000000000100000 is both
shown as reserved and usable which is confusing.

This patch fixes the BIOS-e820 end address.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/e820.c   |    2 +-
 arch/x86_64/kernel/e820.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/e820.c~fix-bios-e820-end-address arch/i386/kernel/e820.c
--- a/arch/i386/kernel/e820.c~fix-bios-e820-end-address
+++ a/arch/i386/kernel/e820.c
@@ -753,7 +753,7 @@ void __init print_memory_map(char *who)
 	for (i = 0; i < e820.nr_map; i++) {
 		printk(" %s: %016Lx - %016Lx ", who,
 			e820.map[i].addr,
-			e820.map[i].addr + e820.map[i].size);
+			e820.map[i].addr + e820.map[i].size - 1);
 		switch (e820.map[i].type) {
 		case E820_RAM:	printk("(usable)\n");
 				break;
diff -puN arch/x86_64/kernel/e820.c~fix-bios-e820-end-address arch/x86_64/kernel/e820.c
--- a/arch/x86_64/kernel/e820.c~fix-bios-e820-end-address
+++ a/arch/x86_64/kernel/e820.c
@@ -368,7 +368,7 @@ void __init e820_print_map(char *who)
 	for (i = 0; i < e820.nr_map; i++) {
 		printk(KERN_INFO " %s: %016Lx - %016Lx ", who,
 			(unsigned long long) e820.map[i].addr,
-			(unsigned long long) (e820.map[i].addr + e820.map[i].size));
+			(unsigned long long) (e820.map[i].addr + e820.map[i].size - 1));
 		switch (e820.map[i].type) {
 		case E820_RAM:	printk("(usable)\n");
 				break;
_

Patches currently in -mm which might be from anil.s.keshavamurthy@intel.com are

optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch
fix-bios-e820-end-address.patch
kprobes-support-kretprobe-blacklist.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-gfx-workaround-kconfig-fix.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-iommu-floppy-workaround-kconfig-fix.patch
intel-iommu-optimize-sg-map-unmap-calls.patch

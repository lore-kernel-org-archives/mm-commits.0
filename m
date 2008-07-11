From: akpm@linux-foundation.org
Subject: + use-warn-in-arch-x86-kernel.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:45:28 -0700
Message-ID: <200807111851.m6BIp96p031307@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757401AbYGKSva (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:51:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, mingo@elte.hu


The patch titled
     Use WARN() in arch/x86/kernel
has been added to the -mm tree.  Its filename is
     use-warn-in-arch-x86-kernel.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use WARN() in arch/x86/kernel
From: Arjan van de Ven <arjan@linux.intel.com>

Use WARN() instead of a printk+WARN_ON() pair; this way the message becomes
part of the warning section for better reporting/collection.  This also
allowed the folding of some if()'s into the WARN()

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mtrr/main.c  |    5 +----
 arch/x86/kernel/pci-calgary_64.c |    3 +--
 arch/x86/kernel/tsc_sync.c       |    6 ++----
 3 files changed, 4 insertions(+), 10 deletions(-)

diff -puN arch/x86/kernel/cpu/mtrr/main.c~use-warn-in-arch-x86-kernel arch/x86/kernel/cpu/mtrr/main.c
--- a/arch/x86/kernel/cpu/mtrr/main.c~use-warn-in-arch-x86-kernel
+++ a/arch/x86/kernel/cpu/mtrr/main.c
@@ -1496,11 +1496,8 @@ int __init mtrr_trim_uncached_memory(uns
 
 	/* kvm/qemu doesn't have mtrr set right, don't trim them all */
 	if (!highest_pfn) {
-		if (!kvm_para_available()) {
-			printk(KERN_WARNING
+		WARN(!kvm_para_available(), KERN_WARNING
 				"WARNING: strange, CPU MTRRs all blank?\n");
-			WARN_ON(1);
-		}
 		return 0;
 	}
 
diff -puN arch/x86/kernel/pci-calgary_64.c~use-warn-in-arch-x86-kernel arch/x86/kernel/pci-calgary_64.c
--- a/arch/x86/kernel/pci-calgary_64.c~use-warn-in-arch-x86-kernel
+++ a/arch/x86/kernel/pci-calgary_64.c
@@ -340,9 +340,8 @@ static void iommu_free(struct iommu_tabl
 	/* were we called with bad_dma_address? */
 	badend = bad_dma_address + (EMERGENCY_PAGES * PAGE_SIZE);
 	if (unlikely((dma_addr >= bad_dma_address) && (dma_addr < badend))) {
-		printk(KERN_ERR "Calgary: driver tried unmapping bad DMA "
+		WARN(1, KERN_ERR "Calgary: driver tried unmapping bad DMA "
 		       "address 0x%Lx\n", dma_addr);
-		WARN_ON(1);
 		return;
 	}
 
diff -puN arch/x86/kernel/tsc_sync.c~use-warn-in-arch-x86-kernel arch/x86/kernel/tsc_sync.c
--- a/arch/x86/kernel/tsc_sync.c~use-warn-in-arch-x86-kernel
+++ a/arch/x86/kernel/tsc_sync.c
@@ -88,11 +88,9 @@ static __cpuinit void check_tsc_warp(voi
 			__raw_spin_unlock(&sync_lock);
 		}
 	}
-	if (!(now-start)) {
-		printk("Warning: zero tsc calibration delta: %Ld [max: %Ld]\n",
+	WARN(!(now-start),
+		"Warning: zero tsc calibration delta: %Ld [max: %Ld]\n",
 			now-start, end-start);
-		WARN_ON(1);
-	}
 }
 
 /*
_

Patches currently in -mm which might be from arjan@linux.intel.com are

linux-next.patch
via-velocity-fix-sleep-with-spinlock-bug-during-mtu-change.patch
rename-warn-to-warning-to-clear-the-namespace.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
kernel-irq-managec-replace-a-printk-warn_on-to-a-warn.patch
example-use-of-warn.patch
use-warn-in-kernel-irq-managec.patch
use-warn-in-kernel-panicc.patch
use-warn-in-mm-vmallocc.patch
use-warn-in-kernel-lockdepc.patch
use-warn-in-kernel-irq-chipc.patch
use-warn-in-arch-x86-mm-ioremapc.patch
use-warn-in-arch-x86-mm-pageattrc.patch
use-warn-in-arch-x86-kernel.patch
use-warn-in-block.patch
use-warn-in-drivers-base.patch
use-warn-in-lib.patch
use-warn-in-fs.patch
usr-warn-in-fs-sysfs.patch
use-warn-in-fs-proc.patch


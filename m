From: akpm@linux-foundation.org
Subject: + pci-uninline-pci_ioremap_bar.patch added to -mm tree
Date: Wed, 22 Oct 2008 16:54:34 -0700
Message-ID: <200810230009.m9N09JbY027610@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318AbYJWAJy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Oct 2008 20:09:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, arjan@infradead.org, arjan@linux.intel.com, jbarnes@virtuousgeek.org


The patch titled
     pci: uninline pci_ioremap_bar()
has been added to the -mm tree.  Its filename is
     pci-uninline-pci_ioremap_bar.patch

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
Subject: pci: uninline pci_ioremap_bar()
From: Andrew Morton <akpm@linux-foundation.org>

Fix the alpha build, too:

In file included from /usr/src/devel/arch/alpha/include/asm/core_mcpcia.h:9,
                 from /usr/src/devel/arch/alpha/include/asm/io.h:226,
                 from arch/alpha/kernel/asm-offsets.c:12:
include/linux/pci.h: In function 'pci_ioremap_bar':
include/linux/pci.h:1139: error: implicit declaration of function 'ioremap_nocache'
include/linux/pci.h:1140: warning: return makes pointer from integer without a cast
In file included from arch/alpha/kernel/asm-offsets.c:12:
/usr/src/devel/arch/alpha/include/asm/io.h: At top level:
/usr/src/devel/arch/alpha/include/asm/io.h:300: error: conflicting types for 'ioremap_nocache'
include/linux/pci.h:1139: error: previous implicit declaration of 'ioremap_nocache' was here

Repairs

commit aa42d7c6138afdc54f74e971456a0fbfec16b77b
Author: Arjan van de Ven <arjan@infradead.org>
Date:   Sun Sep 28 16:36:11 2008 -0700

    PCI: introduce an pci_ioremap(pdev, barnr) function

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci.c   |   16 ++++++++++++++++
 include/linux/pci.h |   15 +--------------
 2 files changed, 17 insertions(+), 14 deletions(-)

diff -puN drivers/pci/pci.c~pci-uninline-pci_ioremap_bar drivers/pci/pci.c
--- a/drivers/pci/pci.c~pci-uninline-pci_ioremap_bar
+++ a/drivers/pci/pci.c
@@ -56,6 +56,22 @@ unsigned char pci_bus_max_busnr(struct p
 }
 EXPORT_SYMBOL_GPL(pci_bus_max_busnr);
 
+#ifdef CONFIG_HAS_IOMEM
+void *pci_ioremap_bar(struct pci_dev *pdev, int bar)
+{
+	/*
+	 * Make sure the BAR is actually a memory resource, not an IO resource
+	 */
+	if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM)) {
+		WARN_ON(1);
+		return NULL;
+	}
+	return ioremap_nocache(pci_resource_start(pdev, bar),
+				     pci_resource_len(pdev, bar));
+}
+EXPORT_SYMBOL_GPL(pci_ioremap_bar);
+#endif
+
 #if 0
 /**
  * pci_max_busnr - returns maximum PCI bus number
diff -puN include/linux/pci.h~pci-uninline-pci_ioremap_bar include/linux/pci.h
--- a/include/linux/pci.h~pci-uninline-pci_ioremap_bar
+++ a/include/linux/pci.h
@@ -1126,20 +1126,7 @@ static inline void pci_mmcfg_early_init(
 static inline void pci_mmcfg_late_init(void) { }
 #endif
 
-#ifdef CONFIG_HAS_IOMEM
-static inline void * pci_ioremap_bar(struct pci_dev *pdev, int bar)
-{
-	/*
-	 * Make sure the BAR is actually a memory resource, not an IO resource
-	 */
-	if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM)) {
-		WARN_ON(1);
-		return NULL;
-	}
-	return ioremap_nocache(pci_resource_start(pdev, bar),
-				     pci_resource_len(pdev, bar));
-}
-#endif
+void *pci_ioremap_bar(struct pci_dev *pdev, int bar);
 
 #endif /* __KERNEL__ */
 #endif /* LINUX_PCI_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memcg-fix-page_cgroup-allocation.patch
epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch
fs-remove-prepare_write-commit_write-fix.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
linux-next-fix-vfs-for-about-to-be-merged-ext3-patches.patch
git-tests-git-rejects.patch
revert-i7300_idle-driver-v155.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
leds-driver-for-hp-harddisk-protection-led-fix-fix-2.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs-fix.patch
ext3-add-support-for-non-native-signed-unsigned-htree-hash-algorithms-checkpatch-fixes.patch
devpts-fix-unused-function-warning.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-broke.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch
pci-uninline-pci_ioremap_bar.patch


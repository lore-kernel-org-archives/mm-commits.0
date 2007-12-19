From: akpm@linux-foundation.org
Subject: + drivers-pci-msic-move-arch-hooks-to-the-top.patch added to -mm tree
Date: Tue, 18 Dec 2007 16:29:14 -0800
Message-ID: <200712190029.lBJ0TEa0029714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57723 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753537AbXLSA3q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 19:29:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, greg@kroah.com, michael@ellerman.id.au


The patch titled
     drivers/pci/msi.c: move arch hooks to the top
has been added to the -mm tree.  Its filename is
     drivers-pci-msic-move-arch-hooks-to-the-top.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/pci/msi.c: move arch hooks to the top
From: Adrian Bunk <bunk@kernel.org>

Fix the following problem present with older gcc versions:

  CC      drivers/pci/msi.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pci/msi.c:692: warning: weak declaration of `arch_msi_check_device' after first use results in unspecified behavior
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pci/msi.c:704: warning: weak declaration of `arch_setup_msi_irqs' after first use results in unspecified behavior
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pci/msi.c:724: warning: weak declaration of `arch_teardown_msi_irqs' after first use results in unspecified behavior

Older gcc versions don't like that they cannot see that they are weak
functions at the time when they are used.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Michael Ellerman <michael@ellerman.id.au>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/msi.c |   91 +++++++++++++++++++++-----------------------
 1 file changed, 45 insertions(+), 46 deletions(-)

diff -puN drivers/pci/msi.c~drivers-pci-msic-move-arch-hooks-to-the-top drivers/pci/msi.c
--- a/drivers/pci/msi.c~drivers-pci-msic-move-arch-hooks-to-the-top
+++ a/drivers/pci/msi.c
@@ -25,6 +25,51 @@
 
 static int pci_msi_enable = 1;
 
+/* Arch hooks */
+
+int __attribute__ ((weak))
+arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
+{
+	return 0;
+}
+
+int __attribute__ ((weak))
+arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *entry)
+{
+	return 0;
+}
+
+int __attribute__ ((weak))
+arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+{
+	struct msi_desc *entry;
+	int ret;
+
+	list_for_each_entry(entry, &dev->msi_list, list) {
+		ret = arch_setup_msi_irq(dev, entry);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+void __attribute__ ((weak)) arch_teardown_msi_irq(unsigned int irq)
+{
+	return;
+}
+
+void __attribute__ ((weak))
+arch_teardown_msi_irqs(struct pci_dev *dev)
+{
+	struct msi_desc *entry;
+
+	list_for_each_entry(entry, &dev->msi_list, list) {
+		if (entry->irq != 0)
+			arch_teardown_msi_irq(entry->irq);
+	}
+}
+
 static void msi_set_enable(struct pci_dev *dev, int enable)
 {
 	int pos;
@@ -682,49 +727,3 @@ void pci_msi_init_pci_dev(struct pci_dev
 {
 	INIT_LIST_HEAD(&dev->msi_list);
 }
-
-
-/* Arch hooks */
-
-int __attribute__ ((weak))
-arch_msi_check_device(struct pci_dev* dev, int nvec, int type)
-{
-	return 0;
-}
-
-int __attribute__ ((weak))
-arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *entry)
-{
-	return 0;
-}
-
-int __attribute__ ((weak))
-arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
-{
-	struct msi_desc *entry;
-	int ret;
-
-	list_for_each_entry(entry, &dev->msi_list, list) {
-		ret = arch_setup_msi_irq(dev, entry);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
-void __attribute__ ((weak)) arch_teardown_msi_irq(unsigned int irq)
-{
-	return;
-}
-
-void __attribute__ ((weak))
-arch_teardown_msi_irqs(struct pci_dev *dev)
-{
-	struct msi_desc *entry;
-
-	list_for_each_entry(entry, &dev->msi_list, list) {
-		if (entry->irq != 0)
-			arch_teardown_msi_irq(entry->irq);
-	}
-}
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
drivers-cpufreq-cpufreq_statsc-section-fix.patch
git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
git-net.patch
git-netdev-all.patch
git-battery.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
drivers-pci-msic-move-arch-hooks-to-the-top.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
scsi-qla2xxx-qla_osc-section-fix.patch
git-x86.patch
git-cryptodev.patch
git-xtensa.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
nubus-kill-drivers-nubus-nubus_symsc.patch
m68k-kill-arch-m68k-mac-mac_ksymsc.patch
m68k-kill-arch-m68k-hp300-ksymsc.patch
m68k-kill-arch-m68k-amiga-amiga_ksymsc.patch
m68k-kill-arch-m68k-atari-atari_ksymsc.patch
m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
remove-__attribute_used__.patch
remove-__attribute_used__-checkpatch-fixes.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
linux-inith-simplify-__meminitexit-dependencies.patch
proper-prototype-for-signals_init.patch
kernel-ptracec-should-include-linux-syscallsh.patch
make-srcu_readers_active-static.patch
kernel-notifierc-should-include-linux-rebooth.patch
proper-prototype-for-get_filesystem_list.patch
fs-utimesc-should-include-linux-syscallsh.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
proper-prototype-for-vty_init.patch
drivers-misc-lkdtmc-cleanups.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
ext4-superc-fix-ifdefs.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
remove-documentation-smptxt.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch

From: akpm@linux-foundation.org
Subject: + iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer.patch added to -mm tree
Date: Thu, 05 Jul 2007 12:35:54 -0700
Message-ID: <200707051935.l65JZs8T014800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56475 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757576AbXGETlo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 15:41:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     iomap: sort out the broken address reporting caused by the iomap layer
has been added to the -mm tree.  Its filename is
     iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iomap: sort out the broken address reporting caused by the iomap layer
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Add an iomap_name() function which translates an I/O map into a string to
print.

Use it for the Libata layer

For now we use 0xXXXX for I/O and 0xXXXXXXXX for MMIO.  I'm assuming that
eventually some other platforms will want to use their own iomap_name() and
we can add ARCH_HAVE_IOMAP_NAME later as such a platform needs it.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/iomap.h |    5 +++++
 lib/iomap.c                 |   12 ++++++++++++
 2 files changed, 17 insertions(+)

diff -puN include/asm-generic/iomap.h~iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer include/asm-generic/iomap.h
--- a/include/asm-generic/iomap.h~iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer
+++ a/include/asm-generic/iomap.h
@@ -65,4 +65,9 @@ struct pci_dev;
 extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
 extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
 
+/* Convert an iomap to text for this platform */
+extern char *iomap_name(void __iomem *addr, char *buf, size_t len);
+#define IOMAP_NAMELEN	12
+
+
 #endif
diff -puN lib/iomap.c~iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer lib/iomap.c
--- a/lib/iomap.c~iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer
+++ a/lib/iomap.c
@@ -268,3 +268,15 @@ void pci_iounmap(struct pci_dev *dev, vo
 }
 EXPORT_SYMBOL(pci_iomap);
 EXPORT_SYMBOL(pci_iounmap);
+
+char *iomap_name(void __iomem *port, char *buf, size_t len)
+{
+	if (port == NULL) {
+		snprintf(buf, len, "None");
+		return buf;
+	}
+	IO_COND(port, snprintf(buf, len, "0x%04lx", port),
+		snprintf(buf, len, "%08lx", port));
+	return buf;
+}
+EXPORT_SYMBOL(iomap_name);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

lots-of-architectures-enable-arbitary-speed-tty-support.patch
powerpc-enable-arbitary-speed-tty-ioctls-and-split.patch
nozomi-remove-termios-checks-from-various-old-char-serial-drivers.patch
ia64-arbitary-speed-tty-ioctl-support.patch
git-libata-all.patch
libata-add-ich8m-pciids-to-ata_piix.patch
libata-add-irq_flags-to-struct-pata_platform_info.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
pata_pdc202xx_old-correct-cable-detect-logic.patch
libata-support-chips-with-64k-prd-quirk.patch
libata-support-chips-with-64k-prd-quirk-export.patch
pata_hpt3x3-major-reworking-and-testing.patch
iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer.patch
ata-use-iomap_name.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
rfcomm-hangup-ttys-before-releasing-rfcomm_dev.patch
fix-gregkh-pci-pci-syscallc-switch-to-refcounting-api.patch
add-pci_try_set_mwi.patch
git-scsi-misc.patch
ppa-coding-police-and-printk-levels.patch
mos7840c-turn-this-into-a-serial-driver.patch
pl2303-remove-bogus-checks-and-fix-speed-support-to-use.patch
visor-and-whiteheat-remove-bogus-termios-change-checks.patch
mos7720-remove-bogus-no-termios-change-check.patch
io_-remove-bogus-termios-no-change-checks.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh-fix.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
blackfin-enable-arbitary-speed-serial-setting.patch
h8300-enable-arbitary-speed-tty-port-setup.patch
arm26-enable-arbitary-speed-tty-ioctls-and-split.patch
m32r-enable-arbitary-speed-tty-rate-setting.patch
etrax-enable-arbitary-speed-setting-on-tty-ports.patch
v850-enable-arbitary-speed-tty-ioctls.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
update-zilog-timeout.patch
edd-switch-to-pci_get-based-api.patch
mpu401-warning-fixes.patch
char-tty_ioctl-use-wait_event_interruptible_timeout.patch
char-tty_ioctl-little-whitespace-cleanup.patch
intel-rng-undo-mess-made-by-an-80-column-extremist.patch
improve-behaviour-of-spurious-irq-detect.patch
audit-add-tty-input-auditing.patch
audit-add-tty-input-auditing-fix.patch
audit-add-tty-input-auditing-fix-2.patch
revert-vanishing-ioctl-handler-debugging.patch
amiserial-remove-incorrect-no-termios-change-check.patch
genericserial-remove-bogus-optimisation-check-and-dead-code-paths.patch
synclink-remove-bogus-no-change-termios-optimisation.patch
68360serial-remove-broken-optimisation.patch
serial-remove-termios-checks-from-various-old-char-serial.patch
i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
stallion-remove-unneeded-lock_kernel.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
driver-edac-add-mips-and-ppc-visibility.patch
driver-edac-mod-race-fix-i82875p.patch
driver-edac-fix-ignored-return-i82875p.patch
include-linux-pci_id-h-add-amd-northbridge-defines.patch

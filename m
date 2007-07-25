From: akpm@linux-foundation.org
Subject: - iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer.patch removed from -mm tree
Date: Wed, 25 Jul 2007 02:03:58 -0700
Message-ID: <200707250903.l6P93wr3026524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39862 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756267AbXGYJEr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jul 2007 05:04:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     iomap: sort out the broken address reporting caused by the iomap layer
has been removed from the -mm tree.  Its filename was
     iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer.patch

This patch was dropped because it had testing failures

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
@@ -281,3 +281,15 @@ void pci_iounmap(struct pci_dev *dev, vo
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

origin.patch
revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
git-scsi-rc-fixes.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
geode-setup-correct-chipset-access-functions-fix.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
blackfin-enable-arbitary-speed-serial-setting.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
update-coredump-path-in-kernel-to-not-check-coredump-rlim-if-core_pattern-is-a-pipe.patch
iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer.patch
remove-kconfig-setting-config_debug_shirq.patch
debug-handling-of-early-spurious-interrupts.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix.patch

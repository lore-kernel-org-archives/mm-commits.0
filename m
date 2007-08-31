From: akpm@linux-foundation.org
Subject: - libata-strict-checking-for-identify-reporting.patch removed from -mm tree
Date: Fri, 31 Aug 2007 09:56:45 -0700
Message-ID: <200708311656.l7VGujJI017511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44695 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758967AbXHaRIV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 13:08:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     libata: strict checking for identify reporting
has been removed from the -mm tree.  Its filename was
     libata-strict-checking-for-identify-reporting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: strict checking for identify reporting
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The ATA specifications require checks on certain flags before assuming the
validity of other data.  Go through the methods and correct those needing
extra checks.  Also note limits on ata_id_major_version with respect to ATA-1
and ATA-2.  Correct the 32bit PIO check.

Wants to sit in -mm for a bit in case of a screwup on my part that I didn't
hit on the test drives and also in case someone, somewhere has a drive that
gets it wrong.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ata.h |   96 +++++++++++++++++++++++++++++++++++++-----
 1 files changed, 85 insertions(+), 11 deletions(-)

diff -puN include/linux/ata.h~libata-strict-checking-for-identify-reporting include/linux/ata.h
--- a/include/linux/ata.h~libata-strict-checking-for-identify-reporting
+++ a/include/linux/ata.h
@@ -334,22 +334,12 @@ struct ata_taskfile {
 };
 
 #define ata_id_is_ata(id)	(((id)[0] & (1 << 15)) == 0)
-#define ata_id_rahead_enabled(id) ((id)[85] & (1 << 6))
-#define ata_id_wcache_enabled(id) ((id)[85] & (1 << 5))
-#define ata_id_hpa_enabled(id)	((id)[85] & (1 << 10))
-#define ata_id_has_fua(id)	((id)[84] & (1 << 6))
-#define ata_id_has_flush(id)	((id)[83] & (1 << 12))
-#define ata_id_has_flush_ext(id) ((id)[83] & (1 << 13))
-#define ata_id_has_lba48(id)	((id)[83] & (1 << 10))
-#define ata_id_has_hpa(id)	((id)[82] & (1 << 10))
-#define ata_id_has_wcache(id)	((id)[82] & (1 << 5))
-#define ata_id_has_pm(id)	((id)[82] & (1 << 3))
 #define ata_id_has_lba(id)	((id)[49] & (1 << 9))
 #define ata_id_has_dma(id)	((id)[49] & (1 << 8))
 #define ata_id_has_ncq(id)	((id)[76] & (1 << 8))
 #define ata_id_queue_depth(id)	(((id)[75] & 0x1f) + 1)
 #define ata_id_removeable(id)	((id)[0] & (1 << 7))
-#define ata_id_has_dword_io(id)	((id)[50] & (1 << 0))
+#define ata_id_has_dword_io(id)	((id)[48] & (1 << 0))
 #define ata_id_has_AN(id)	\
 	( (((id)[76] != 0x0000) && ((id)[76] != 0xffff)) && \
 	  ((id)[78] & (1 << 5)) )
@@ -365,6 +355,90 @@ struct ata_taskfile {
 
 #define ata_id_cdb_intr(id)	(((id)[0] & 0x60) == 0x20)
 
+static inline int ata_id_has_fua(const u16 *id)
+{
+	if ((id[84] & 0xC000) != 0x4000)
+		return 0;
+	return id[84] & (1 << 6);
+}
+
+static inline int ata_id_has_flush(const u16 *id)
+{
+	if ((id[83] & 0xC000) != 0x4000)
+		return 0;
+	return id[83] & (1 << 12);
+}
+
+static inline int ata_id_has_flush_ext(const u16 *id)
+{
+	if ((id[83] & 0xC000) != 0x4000)
+		return 0;
+	return id[83] & (1 << 13);
+}
+
+static inline int ata_id_has_lba48(const u16 *id)
+{
+	if ((id[83] & 0xC000) != 0x4000)
+		return 0;
+	return id[83] & (1 << 10);
+}
+
+static inline int ata_id_hpa_enabled(const u16 *id)
+{
+	/* Yes children, word 83 valid bits cover word 82 data */
+	if ((id[83] & 0xC000) != 0x4000)
+		return 0;
+	/* And 87 covers 85-87 */
+	if ((id[87] & 0xC000) != 0x4000)
+		return 0;
+	/* Check command sets enabled as well as supported */
+	if ((id[85] & ( 1 << 10)) == 0)
+		return 0;
+	return id[82] & (1 << 10);
+}
+
+static inline int ata_id_has_wcache(const u16 *id)
+{
+	/* Yes children, word 83 valid bits cover word 82 data */
+	if ((id[83] & 0xC000) != 0x4000)
+		return 0;
+	return id[82] & (1 << 5);
+}
+
+static inline int ata_id_has_pm(const u16 *id)
+{
+	if ((id[83] & 0xC000) != 0x4000)
+		return 0;
+	return id[82] & (1 << 3);
+}
+
+static inline int ata_id_rahead_enabled(const u16 *id)
+{
+	if ((id[87] & 0xC000) != 0x4000)
+		return 0;
+	return id[85] & (1 << 6);
+}
+
+static inline int ata_id_wcache_enabled(const u16 *id)
+{
+	if ((id[87] & 0xC000) != 0x4000)
+		return 0;
+	return id[85] & (1 << 5);
+}
+
+/**
+ *	ata_id_major_version	-	get ATA level of drive
+ *	@id: Identify data
+ *
+ *	Caveats:
+ *		ATA-1 considers identify optional
+ *		ATA-2 introduces mandatory identify
+ *		ATA-3 introduces word 80 and accurate reporting
+ *
+ *	The practical impact of this is that ata_id_major_version cannot
+ *	reliably report on drives below ATA3.
+ */
+
 static inline unsigned int ata_id_major_version(const u16 *id)
 {
 	unsigned int mver;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-add-a-drivers-ide-style-dma-disable.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
git-scsi-misc.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
git-xtensa.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch

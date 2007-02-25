From: akpm@linux-foundation.org
Subject: + libata-test-major-version-in-ata_id_is_sata.patch added to -mm tree
Date: Sun, 25 Feb 2007 05:09:03 -0800
Message-ID: <200702251309.l1PD95kd029970@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35818 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964944AbXBYNJJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Feb 2007 08:09:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com


The patch titled
     libata: test major version in ata_id_is_sata()
has been added to the -mm tree.  Its filename is
     libata-test-major-version-in-ata_id_is_sata.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: test major version in ata_id_is_sata()
From: Tejun Heo <htejun@gmail.com>

Test major version in ata_id_is_sata() not separately.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ata.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN include/linux/ata.h~libata-test-major-version-in-ata_id_is_sata include/linux/ata.h
--- a/include/linux/ata.h~libata-test-major-version-in-ata_id_is_sata
+++ a/include/linux/ata.h
@@ -282,7 +282,6 @@ struct ata_taskfile {
 };
 
 #define ata_id_is_ata(id)	(((id)[0] & (1 << 15)) == 0)
-#define ata_id_is_sata(id)	((id)[93] == 0)
 #define ata_id_rahead_enabled(id) ((id)[85] & (1 << 6))
 #define ata_id_wcache_enabled(id) ((id)[85] & (1 << 5))
 #define ata_id_hpa_enabled(id)	((id)[85] & (1 << 10))
@@ -324,6 +323,11 @@ static inline unsigned int ata_id_major_
 	return mver;
 }
 
+static inline int ata_id_is_sata(const u16 *id)
+{
+	return ata_id_major_version(id) >= 5 && id[93] == 0;
+}
+
 static inline int ata_id_current_chs_valid(const u16 *id)
 {
 	/* For ATA-1 devices, if the INITIALIZE DEVICE PARAMETERS command
@@ -350,7 +354,7 @@ static inline int ata_id_is_cfa(const u1
 
 static inline int ata_drive_40wire(const u16 *dev_id)
 {
-	if (ata_id_major_version(dev_id) >= 5 && ata_id_is_sata(dev_id))
+	if (ata_id_is_sata(dev_id))
 		return 0;	/* SATA */
 	if ((dev_id[93] & 0xE000) == 0x6000)
 		return 0;	/* 80 wire */
_

Patches currently in -mm which might be from htejun@gmail.com are

git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
add-id_to_dma_mode-function-for-printing-dma-modes.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
acpi-driver-support-for-pata.patch
acpi-driver-support-for-pata-fix.patch
libata-use-new-id_to_dma_mode-function-to-tidy-reporting.patch
libata-test-major-version-in-ata_id_is_sata.patch
pci-allow-multiple-calls-to-pcim_pin_device.patch

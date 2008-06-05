From: akpm@linux-foundation.org
Subject: + qla2xxx-use-memory_read_from_buffer.patch added to -mm tree
Date: Wed, 04 Jun 2008 17:30:17 -0700
Message-ID: <200806050030.m550UHPb016990@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755436AbYFEAaW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 20:30:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, James.Bottomley@HansenPartnership.com, andrew.vasquez@qlogic.com, linux-driver@qlogic.com, seokmann.ju@qlogic.com


The patch titled
     qla2xxx: use memory_read_from_buffer()
has been added to the -mm tree.  Its filename is
     qla2xxx-use-memory_read_from_buffer.patch

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
Subject: qla2xxx: use memory_read_from_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andrew Vasquez <linux-driver@qlogic.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Seokmann Ju <seokmann.ju@qlogic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla2xxx/qla_attr.c |   45 ++++++------------------------
 1 file changed, 10 insertions(+), 35 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_attr.c~qla2xxx-use-memory_read_from_buffer drivers/scsi/qla2xxx/qla_attr.c
--- a/drivers/scsi/qla2xxx/qla_attr.c~qla2xxx-use-memory_read_from_buffer
+++ a/drivers/scsi/qla2xxx/qla_attr.c
@@ -8,6 +8,7 @@
 
 #include <linux/kthread.h>
 #include <linux/vmalloc.h>
+#include <linux/fs.h>
 
 static int qla24xx_vport_disable(struct fc_vport *, bool);
 
@@ -20,18 +21,12 @@ qla2x00_sysfs_read_fw_dump(struct kobjec
 {
 	struct scsi_qla_host *ha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
-	char *rbuf = (char *)ha->fw_dump;
 
 	if (ha->fw_dump_reading == 0)
 		return 0;
-	if (off > ha->fw_dump_len)
-                return 0;
-	if (off + count > ha->fw_dump_len)
-		count = ha->fw_dump_len - off;
 
-	memcpy(buf, &rbuf[off], count);
-
-	return (count);
+	return memory_read_from_buffer(buf, count, &off, ha->fw_dump,
+					ha->fw_dump_len);
 }
 
 static ssize_t
@@ -94,20 +89,13 @@ qla2x00_sysfs_read_nvram(struct kobject 
 {
 	struct scsi_qla_host *ha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
-	int		size = ha->nvram_size;
-	char		*nvram_cache = ha->nvram;
 
-	if (!capable(CAP_SYS_ADMIN) || off > size || count == 0)
+	if (!capable(CAP_SYS_ADMIN))
 		return 0;
-	if (off + count > size) {
-		size -= off;
-		count = size;
-	}
 
 	/* Read NVRAM data from cache. */
-	memcpy(buf, &nvram_cache[off], count);
-
-	return count;
+	return memory_read_from_buffer(buf, count, &off, ha->nvram,
+					ha->nvram_size);
 }
 
 static ssize_t
@@ -175,14 +163,9 @@ qla2x00_sysfs_read_optrom(struct kobject
 
 	if (ha->optrom_state != QLA_SREADING)
 		return 0;
-	if (off > ha->optrom_region_size)
-		return 0;
-	if (off + count > ha->optrom_region_size)
-		count = ha->optrom_region_size - off;
 
-	memcpy(buf, &ha->optrom_buffer[off], count);
-
-	return count;
+	return memory_read_from_buffer(buf, count, &off, ha->optrom_buffer,
+					ha->optrom_region_size);
 }
 
 static ssize_t
@@ -374,20 +357,12 @@ qla2x00_sysfs_read_vpd(struct kobject *k
 {
 	struct scsi_qla_host *ha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
-	int           size = ha->vpd_size;
-	char          *vpd_cache = ha->vpd;
 
-	if (!capable(CAP_SYS_ADMIN) || off > size || count == 0)
+	if (!capable(CAP_SYS_ADMIN))
 		return 0;
-	if (off + count > size) {
-		size -= off;
-		count = size;
-	}
 
 	/* Read NVRAM data from cache. */
-	memcpy(buf, &vpd_cache[off], count);
-
-	return count;
+	return memory_read_from_buffer(buf, count, &off, ha->vpd, ha->vpd_size);
 }
 
 static ssize_t
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

lib-export-bitrev16.patch
bluetooth-hci_bcspc-small-cleanups-api-users.patch
bluetooth-hci_bcspc-small-cleanups-api-users-fix.patch
binfmt_misc-use-simple_read_from_buffer.patch
ocfs2-use-simple_read_from_buffer.patch
ipc-use-simple_read_from_buffer.patch
isdn-use-simple_read_from_buffer.patch
s390-vmcp-use-simple_read_from_buffer.patch
s390-use-simple_read_from_buffer.patch
nwflash-use-simple_read_from_buffer.patch
usbmon-use-simple_read_from_buffer.patch
ttusb-use-simple_read_from_buffer.patch
airo-use-simple_read_from_buffer.patch
cris-use-simple_read_from_buffer.patch
introduce-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer.patch
firmware-use-memory_read_from_buffer.patch
acpi-use-memory_read_from_buffer.patch
aty-use-memory_read_from_buffer.patch
zorro-use-memory_read_from_buffer.patch
s390-cio-use-memory_read_from_buffer.patch
s390-use-memory_read_from_buffer.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch


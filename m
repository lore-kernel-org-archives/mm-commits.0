From: akpm@linux-foundation.org
Subject: - pci-procc-sparse-endian-annotations.patch removed from -mm tree
Date: Wed, 23 Jul 2008 14:02:40 -0700
Message-ID: <200807232102.m6NL2efn011779@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026AbYGWVCm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 17:02:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pci: proc.c sparse endian annotations
has been removed from the -mm tree.  Its filename was
     pci-procc-sparse-endian-annotations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: proc.c sparse endian annotations
From: Harvey Harrison <harvey.harrison@gmail.com>

drivers/pci/proc.c:91:3: warning: cast from restricted __le16
drivers/pci/proc.c:100:3: warning: cast from restricted __le32
drivers/pci/proc.c:109:3: warning: cast from restricted __le16
drivers/pci/proc.c:161:40: warning: cast to restricted __le16
drivers/pci/proc.c:170:41: warning: cast to restricted __le32
drivers/pci/proc.c:179:40: warning: cast to restricted __le16

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/proc.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/pci/proc.c~pci-procc-sparse-endian-annotations drivers/pci/proc.c
--- a/drivers/pci/proc.c~pci-procc-sparse-endian-annotations
+++ a/drivers/pci/proc.c
@@ -88,7 +88,7 @@ proc_bus_pci_read(struct file *file, cha
 	if ((pos & 3) && cnt > 2) {
 		unsigned short val;
 		pci_user_read_config_word(dev, pos, &val);
-		__put_user(cpu_to_le16(val), (unsigned short __user *) buf);
+		__put_user(cpu_to_le16(val), (__le16 __user *) buf);
 		buf += 2;
 		pos += 2;
 		cnt -= 2;
@@ -97,7 +97,7 @@ proc_bus_pci_read(struct file *file, cha
 	while (cnt >= 4) {
 		unsigned int val;
 		pci_user_read_config_dword(dev, pos, &val);
-		__put_user(cpu_to_le32(val), (unsigned int __user *) buf);
+		__put_user(cpu_to_le32(val), (__le32 __user *) buf);
 		buf += 4;
 		pos += 4;
 		cnt -= 4;
@@ -106,7 +106,7 @@ proc_bus_pci_read(struct file *file, cha
 	if (cnt >= 2) {
 		unsigned short val;
 		pci_user_read_config_word(dev, pos, &val);
-		__put_user(cpu_to_le16(val), (unsigned short __user *) buf);
+		__put_user(cpu_to_le16(val), (__le16 __user *) buf);
 		buf += 2;
 		pos += 2;
 		cnt -= 2;
@@ -156,8 +156,8 @@ proc_bus_pci_write(struct file *file, co
 	}
 
 	if ((pos & 3) && cnt > 2) {
-		unsigned short val;
-		__get_user(val, (unsigned short __user *) buf);
+		__le16 val;
+		__get_user(val, (__le16 __user *) buf);
 		pci_user_write_config_word(dev, pos, le16_to_cpu(val));
 		buf += 2;
 		pos += 2;
@@ -165,8 +165,8 @@ proc_bus_pci_write(struct file *file, co
 	}
 
 	while (cnt >= 4) {
-		unsigned int val;
-		__get_user(val, (unsigned int __user *) buf);
+		__le32 val;
+		__get_user(val, (__le32 __user *) buf);
 		pci_user_write_config_dword(dev, pos, le32_to_cpu(val));
 		buf += 4;
 		pos += 4;
@@ -174,8 +174,8 @@ proc_bus_pci_write(struct file *file, co
 	}
 
 	if (cnt >= 2) {
-		unsigned short val;
-		__get_user(val, (unsigned short __user *) buf);
+		__le16 val;
+		__get_user(val, (__le16 __user *) buf);
 		pci_user_write_config_word(dev, pos, le16_to_cpu(val));
 		buf += 2;
 		pos += 2;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-remove-sparse-endian-warnings.patch
input-ads7846c-sparse-lock-annotation.patch
mtd-diskonchipc-fix-sparse-endian-warnings.patch
lockd-trivial-sparse-endian-annotations.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
asm-generic-int-ll64h-always-provide-__su64.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
ecryptfs-cryptoc-use-unaligned-byteorder-helpers.patch
ecryptfs-inodec-mmapc-use-unaligned-byteorder-helpers.patch
markers-fix-sparse-integer-as-null-pointer-warning.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch
byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch


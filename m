From: akpm@linux-foundation.org
Subject: - doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:54:56 -0700
Message-ID: <200710180654.l9I6sukK030557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58445 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760935AbXJRHhU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:37:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     doc firmware_sample_firmware_class.c: kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: doc firmware_sample_firmware_class.c: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 Documentation/firmware_class/firmware_sample_firmware_class.c | 5246 -> 5211 (-35 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/firmware_class/firmware_sample_firmware_class.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN Documentation/firmware_class/firmware_sample_firmware_class.c~doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc Documentation/firmware_class/firmware_sample_firmware_class.c
--- a/Documentation/firmware_class/firmware_sample_firmware_class.c~doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc
+++ a/Documentation/firmware_class/firmware_sample_firmware_class.c
@@ -109,15 +109,15 @@ static int fw_setup_class_device(struct 
 				 const char *fw_name,
 				 struct device *device)
 {
-	int retval = 0;
-	struct firmware_priv *fw_priv = kmalloc(sizeof(struct firmware_priv),
-						GFP_KERNEL);
+	int retval;
+	struct firmware_priv *fw_priv;
 
-	if(!fw_priv){
+	fw_priv = kzalloc(sizeof(struct firmware_priv),	GFP_KERNEL);
+	if (!fw_priv) {
 		retval = -ENOMEM;
 		goto out;
 	}
-	memset(fw_priv, 0, sizeof(*fw_priv));
+
 	memset(class_dev, 0, sizeof(*class_dev));
 
 	strncpy(fw_priv->fw_id, fw_name, FIRMWARE_NAME_MAX);
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
git-cifs.patch
kernel-forkc-remove-unneeded-variable-initialization-in-copy_process.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch

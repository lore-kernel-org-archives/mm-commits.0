From: akpm@linux-foundation.org
Subject: + bluetooth-remove-the-redundant-non-seekable-llseek-method.patch added to -mm tree
Date: Tue, 29 May 2007 17:33:24 -0700
Message-ID: <200705300033.l4U0XO85015451@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750740AbXE3Adc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 20:33:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, marcel@holtmann.org


The patch titled
     BLUETOOTH: remove the redundant non-seekable llseek method
has been added to the -mm tree.  Its filename is
     bluetooth-remove-the-redundant-non-seekable-llseek-method.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: BLUETOOTH: remove the redundant non-seekable llseek method
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the llseek method given that the open method already calls
nonseekable_open().

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/hci_vhci.c |    6 ------
 1 files changed, 6 deletions(-)

diff -puN drivers/bluetooth/hci_vhci.c~bluetooth-remove-the-redundant-non-seekable-llseek-method drivers/bluetooth/hci_vhci.c
--- a/drivers/bluetooth/hci_vhci.c~bluetooth-remove-the-redundant-non-seekable-llseek-method
+++ a/drivers/bluetooth/hci_vhci.c
@@ -180,11 +180,6 @@ static inline ssize_t vhci_put_user(stru
 	return total;
 }
 
-static loff_t vhci_llseek(struct file *file, loff_t offset, int origin)
-{
-	return -ESPIPE;
-}
-
 static ssize_t vhci_read(struct file *file,
 				char __user *buf, size_t count, loff_t *pos)
 {
@@ -332,7 +327,6 @@ static int vhci_fasync(int fd, struct fi
 
 static const struct file_operations vhci_fops = {
 	.owner		= THIS_MODULE,
-	.llseek		= vhci_llseek,
 	.read		= vhci_read,
 	.write		= vhci_write,
 	.poll		= vhci_poll,
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-arm-master.patch
git-ieee1394.patch
input-delete-useless-reference-to-dead-module_parm-macro.patch
git-kbuild.patch
bluetooth-remove-the-redundant-non-seekable-llseek-method.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
remove-dead-references-to-module_parm-macro.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch

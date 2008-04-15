From: akpm@linux-foundation.org
Subject: + scsi-use-non-racy-method-for-proc-entries-creation.patch added to -mm tree
Date: Tue, 15 Apr 2008 16:56:19 -0700
Message-ID: <200804152356.m3FNuJB2022524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753286AbYDOX43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 19:56:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, James.Bottomley@HansenPartnership.com, adobriyan@gmail.com, ebiederm@xmission.com, gregkh@suse.de


The patch titled
     scsi: use non-racy method for proc entries creation
has been added to the -mm tree.  Its filename is
     scsi-use-non-racy-method-for-proc-entries-creation.patch

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
Subject: scsi: use non-racy method for proc entries creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create() to make sure that ->proc_fops be setup before gluing PDE to
main tree.

Add correct ->owner to proc_fops to fix reading/module unloading race.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_proc.c |    4 ++--
 drivers/scsi/sg.c        |   12 ++++--------
 2 files changed, 6 insertions(+), 10 deletions(-)

diff -puN drivers/scsi/scsi_proc.c~scsi-use-non-racy-method-for-proc-entries-creation drivers/scsi/scsi_proc.c
--- a/drivers/scsi/scsi_proc.c~scsi-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/scsi/scsi_proc.c
@@ -408,6 +408,7 @@ static int proc_scsi_open(struct inode *
 }
 
 static const struct file_operations proc_scsi_operations = {
+	.owner		= THIS_MODULE,
 	.open		= proc_scsi_open,
 	.read		= seq_read,
 	.write		= proc_scsi_write,
@@ -426,10 +427,9 @@ int __init scsi_init_procfs(void)
 	if (!proc_scsi)
 		goto err1;
 
-	pde = create_proc_entry("scsi/scsi", 0, NULL);
+	pde = proc_create("scsi/scsi", 0, NULL, &proc_scsi_operations);
 	if (!pde)
 		goto err2;
-	pde->proc_fops = &proc_scsi_operations;
 
 	return 0;
 
diff -puN drivers/scsi/sg.c~scsi-use-non-racy-method-for-proc-entries-creation drivers/scsi/sg.c
--- a/drivers/scsi/sg.c~scsi-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/scsi/sg.c
@@ -2667,7 +2667,6 @@ sg_proc_init(void)
 {
 	int k, mask;
 	int num_leaves = ARRAY_SIZE(sg_proc_leaf_arr);
-	struct proc_dir_entry *pdep;
 	struct sg_proc_leaf * leaf;
 
 	sg_proc_sgp = proc_mkdir(sg_proc_sg_dirname, NULL);
@@ -2676,13 +2675,10 @@ sg_proc_init(void)
 	for (k = 0; k < num_leaves; ++k) {
 		leaf = &sg_proc_leaf_arr[k];
 		mask = leaf->fops->write ? S_IRUGO | S_IWUSR : S_IRUGO;
-		pdep = create_proc_entry(leaf->name, mask, sg_proc_sgp);
-		if (pdep) {
-			leaf->fops->owner = THIS_MODULE,
-			leaf->fops->read = seq_read,
-			leaf->fops->llseek = seq_lseek,
-			pdep->proc_fops = leaf->fops;
-		}
+		leaf->fops->owner = THIS_MODULE;
+		leaf->fops->read = seq_read;
+		leaf->fops->llseek = seq_lseek;
+		proc_create(leaf->name, mask, sg_proc_sgp, leaf->fops);
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from den@openvz.org are

git-net.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
nfsd-use-proc_create-to-setup-de-proc_fops.patch
nfs-use-proc_create-to-setup-de-proc_fops.patch
afs-use-non-racy-method-for-proc-entries-creation.patch
ext4-use-non-racy-method-for-proc-entries-creation.patch
reiserfs-use-non-racy-method-for-proc-entries-creation.patch
jbd2-use-non-racy-method-for-proc-entries-creation.patch
sysvipc-use-non-racy-method-for-proc-entries-creation.patch
mm-use-non-racy-method-for-proc-swaps-creation.patch
sound-use-non-racy-method-for-proc-driver-snd-page-alloc-creation.patch
zorro-use-non-racy-method-for-proc-entries-creation.patch
samples-use-non-racy-method-for-proc-marker-example-creation.patch
scsi-use-non-racy-method-for-proc-entries-creation.patch
usb-use-non-racy-method-for-proc-entries-creation.patch
s390-use-non-racy-method-for-proc-entries-creation.patch
arm-use-non-racy-method-for-proc-davinci_clocks-creation.patch
avr32-proc-use-non-racy-method-for-proc-tlb-creation.patch
cris-use-non-racy-method-for-proc-system_profile-creation.patch
ia64-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-pcxl_dma-creation.patch
powerpc-use-non-racy-method-for-proc-entries-creation.patch
acpi-use-non-racy-method-for-proc-entries-creation.patch
netdev-use-non-racy-method-for-proc-entries-creation.patch
isdn-use-non-racy-method-for-proc-entries-creation.patch
kernel-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation-2.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch


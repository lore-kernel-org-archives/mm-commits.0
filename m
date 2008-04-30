From: akpm@linux-foundation.org
Subject: - scsi-use-non-racy-method-for-proc-entries-creation.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:47:05 -0700
Message-ID: <200804300547.m3U5l5bm029673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758745AbYD3GMR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, James.Bottomley@HansenPartnership.com, adobriyan@gmail.com, ebiederm@xmission.com, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     scsi: use non-racy method for proc entries creation
has been removed from the -mm tree.  Its filename was
     scsi-use-non-racy-method-for-proc-entries-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -413,6 +413,7 @@ static int proc_scsi_open(struct inode *
 }
 
 static const struct file_operations proc_scsi_operations = {
+	.owner		= THIS_MODULE,
 	.open		= proc_scsi_open,
 	.read		= seq_read,
 	.write		= proc_scsi_write,
@@ -431,10 +432,9 @@ int __init scsi_init_procfs(void)
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

origin.patch
drivers-use-non-racy-method-for-proc-entries-creation-2-rio.patch
sunrpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch
netfilter-assign-pde-data-before-gluing-pde-into-proc-tree.patch
net-assign-pde-data-before-gluing-pde-into-proc-tree.patch
ipv6-assign-pde-data-before-gluing-pde-into-proc-tree.patch
atm-assign-pde-data-before-gluing-pde-into-proc-tree.patch
vlan-assign-pde-data-before-gluing-pde-into-proc-tree.patch
cciss-assign-pde-data-before-gluing-pde-into-proc-tree.patch
powerpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch
ipv4-assign-pde-data-before-gluing-pde-into-proc-tree.patch
netfilter-assign-pde-fops-before-gluing-pde-into-proc-tree.patch
netfilter-assign-pde-data-before-gluing-pde-into-proc-tree-2.patch
netns-assign-pde-data-before-gluing-entry-into-proc-tree.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch


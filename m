From: akpm@linux-foundation.org
Subject: + afs-use-non-racy-method-for-proc-entries-creation.patch added to -mm tree
Date: Tue, 15 Apr 2008 16:56:01 -0700
Message-ID: <200804152356.m3FNu2aB022497@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753358AbYDOX4a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 19:56:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, adobriyan@gmail.com, dhowells@redhat.com, ebiederm@xmission.com


The patch titled
     afs: use non-racy method for proc entries creation
has been added to the -mm tree.  Its filename is
     afs-use-non-racy-method-for-proc-entries-creation.patch

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
Subject: afs: use non-racy method for proc entries creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create()/proc_create_data() to make sure that ->proc_fops and ->data
be setup before gluing PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/proc.c |   33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff -puN fs/afs/proc.c~afs-use-non-racy-method-for-proc-entries-creation fs/afs/proc.c
--- a/fs/afs/proc.c~afs-use-non-racy-method-for-proc-entries-creation
+++ a/fs/afs/proc.c
@@ -41,6 +41,7 @@ static const struct file_operations afs_
 	.write		= afs_proc_cells_write,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
+	.owner		= THIS_MODULE,
 };
 
 static int afs_proc_rootcell_open(struct inode *inode, struct file *file);
@@ -56,7 +57,8 @@ static const struct file_operations afs_
 	.read		= afs_proc_rootcell_read,
 	.write		= afs_proc_rootcell_write,
 	.llseek		= no_llseek,
-	.release	= afs_proc_rootcell_release
+	.release	= afs_proc_rootcell_release,
+	.owner		= THIS_MODULE,
 };
 
 static int afs_proc_cell_volumes_open(struct inode *inode, struct file *file);
@@ -80,6 +82,7 @@ static const struct file_operations afs_
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= afs_proc_cell_volumes_release,
+	.owner		= THIS_MODULE,
 };
 
 static int afs_proc_cell_vlservers_open(struct inode *inode,
@@ -104,6 +107,7 @@ static const struct file_operations afs_
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= afs_proc_cell_vlservers_release,
+	.owner		= THIS_MODULE,
 };
 
 static int afs_proc_cell_servers_open(struct inode *inode, struct file *file);
@@ -127,6 +131,7 @@ static const struct file_operations afs_
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= afs_proc_cell_servers_release,
+	.owner		= THIS_MODULE,
 };
 
 /*
@@ -143,17 +148,13 @@ int afs_proc_init(void)
 		goto error_dir;
 	proc_afs->owner = THIS_MODULE;
 
-	p = create_proc_entry("cells", 0, proc_afs);
+	p = proc_create("cells", 0, proc_afs, &afs_proc_cells_fops);
 	if (!p)
 		goto error_cells;
-	p->proc_fops = &afs_proc_cells_fops;
-	p->owner = THIS_MODULE;
 
-	p = create_proc_entry("rootcell", 0, proc_afs);
+	p = proc_create("rootcell", 0, proc_afs, &afs_proc_rootcell_fops);
 	if (!p)
 		goto error_rootcell;
-	p->proc_fops = &afs_proc_rootcell_fops;
-	p->owner = THIS_MODULE;
 
 	_leave(" = 0");
 	return 0;
@@ -395,26 +396,20 @@ int afs_proc_cell_setup(struct afs_cell 
 	if (!cell->proc_dir)
 		goto error_dir;
 
-	p = create_proc_entry("servers", 0, cell->proc_dir);
+	p = proc_create_data("servers", 0, cell->proc_dir,
+			     &afs_proc_cell_servers_fops, cell);
 	if (!p)
 		goto error_servers;
-	p->proc_fops = &afs_proc_cell_servers_fops;
-	p->owner = THIS_MODULE;
-	p->data = cell;
 
-	p = create_proc_entry("vlservers", 0, cell->proc_dir);
+	p = proc_create_data("vlservers", 0, cell->proc_dir,
+			     &afs_proc_cell_vlservers_fops, cell);
 	if (!p)
 		goto error_vlservers;
-	p->proc_fops = &afs_proc_cell_vlservers_fops;
-	p->owner = THIS_MODULE;
-	p->data = cell;
 
-	p = create_proc_entry("volumes", 0, cell->proc_dir);
+	p = proc_create_data("volumes", 0, cell->proc_dir,
+			     &afs_proc_cell_volumes_fops, cell);
 	if (!p)
 		goto error_volumes;
-	p->proc_fops = &afs_proc_cell_volumes_fops;
-	p->owner = THIS_MODULE;
-	p->data = cell;
 
 	_leave(" = 0");
 	return 0;
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


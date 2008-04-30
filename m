From: akpm@linux-foundation.org
Subject: - afs-use-non-racy-method-for-proc-entries-creation.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:46:47 -0700
Message-ID: <200804300546.m3U5klga029636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758021AbYD3Frg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:47:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@gmail.com, dhowells@redhat.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     afs: use non-racy method for proc entries creation
has been removed from the -mm tree.  Its filename was
     afs-use-non-racy-method-for-proc-entries-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: afs: use non-racy method for proc entries creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create()/proc_create_data() to make sure that ->proc_fops and ->data
be setup before gluing PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Acked-by: David Howells <dhowells@redhat.com>
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


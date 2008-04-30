From: akpm@linux-foundation.org
Subject: - nfs-use-proc_create-to-setup-de-proc_fops.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:46:44 -0700
Message-ID: <200804300546.m3U5ki87029633@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756152AbYD3Fr3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:47:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@gmail.com, bfields@fieldses.org, ebiederm@xmission.com, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     nfs: use proc_create to setup de->proc_fops
has been removed from the -mm tree.  Its filename was
     nfs-use-proc_create-to-setup-de-proc_fops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nfs: use proc_create to setup de->proc_fops
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create() to make sure that ->proc_fops be setup before gluing PDE to
main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/client.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN fs/nfs/client.c~nfs-use-proc_create-to-setup-de-proc_fops fs/nfs/client.c
--- a/fs/nfs/client.c~nfs-use-proc_create-to-setup-de-proc_fops
+++ a/fs/nfs/client.c
@@ -1321,6 +1321,7 @@ static const struct file_operations nfs_
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
+	.owner		= THIS_MODULE,
 };
 
 static int nfs_volume_list_open(struct inode *inode, struct file *file);
@@ -1341,6 +1342,7 @@ static const struct file_operations nfs_
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
+	.owner		= THIS_MODULE,
 };
 
 /*
@@ -1507,20 +1509,16 @@ int __init nfs_fs_proc_init(void)
 	proc_fs_nfs->owner = THIS_MODULE;
 
 	/* a file of servers with which we're dealing */
-	p = create_proc_entry("servers", S_IFREG|S_IRUGO, proc_fs_nfs);
+	p = proc_create("servers", S_IFREG|S_IRUGO,
+			proc_fs_nfs, &nfs_server_list_fops);
 	if (!p)
 		goto error_1;
 
-	p->proc_fops = &nfs_server_list_fops;
-	p->owner = THIS_MODULE;
-
 	/* a file of volumes that we have mounted */
-	p = create_proc_entry("volumes", S_IFREG|S_IRUGO, proc_fs_nfs);
+	p = proc_create("volumes", S_IFREG|S_IRUGO,
+			proc_fs_nfs, &nfs_volume_list_fops);
 	if (!p)
 		goto error_2;
-
-	p->proc_fops = &nfs_volume_list_fops;
-	p->owner = THIS_MODULE;
 	return 0;
 
 error_2:
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


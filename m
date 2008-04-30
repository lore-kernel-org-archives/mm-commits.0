From: akpm@linux-foundation.org
Subject: - nfsd-use-proc_create-to-setup-de-proc_fops.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:46:42 -0700
Message-ID: <200804300546.m3U5kgfG029630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753645AbYD3FrX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:47:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@gmail.com, bfields@fieldses.org, ebiederm@xmission.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     nfsd: use proc_create to setup de->proc_fops
has been removed from the -mm tree.  Its filename was
     nfsd-use-proc_create-to-setup-de-proc_fops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nfsd: use proc_create to setup de->proc_fops
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create() to make sure that ->proc_fops be setup before gluing PDE to
main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfsctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/nfsd/nfsctl.c~nfsd-use-proc_create-to-setup-de-proc_fops fs/nfsd/nfsctl.c
--- a/fs/nfsd/nfsctl.c~nfsd-use-proc_create-to-setup-de-proc_fops
+++ a/fs/nfsd/nfsctl.c
@@ -169,6 +169,7 @@ static const struct file_operations expo
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
+	.owner		= THIS_MODULE,
 };
 
 /*----------------------------------------------------------------------------*/
@@ -801,10 +802,9 @@ static int create_proc_exports_entry(voi
 	entry = proc_mkdir("fs/nfs", NULL);
 	if (!entry)
 		return -ENOMEM;
-	entry = create_proc_entry("fs/nfs/exports", 0, NULL);
+	entry = proc_create("exports", 0, entry, &exports_operations);
 	if (!entry)
 		return -ENOMEM;
-	entry->proc_fops =  &exports_operations;
 	return 0;
 }
 #else /* CONFIG_PROC_FS */
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


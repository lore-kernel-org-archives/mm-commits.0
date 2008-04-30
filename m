From: akpm@linux-foundation.org
Subject: - reiserfs-use-non-racy-method-for-proc-entries-creation.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:46:51 -0700
Message-ID: <200804300546.m3U5kpDq029646@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757765AbYD3Fre (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:47:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@gmail.com, chris.mason@oracle.com, ebiederm@xmission.com, jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: use non-racy method for proc entries creation
has been removed from the -mm tree.  Its filename was
     reiserfs-use-non-racy-method-for-proc-entries-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: use non-racy method for proc entries creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create()/proc_create_data() to make sure that ->proc_fops and ->data
be setup before gluing PDE to main tree.

/proc entry owner is also added.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/procfs.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN fs/reiserfs/procfs.c~reiserfs-use-non-racy-method-for-proc-entries-creation fs/reiserfs/procfs.c
--- a/fs/reiserfs/procfs.c~reiserfs-use-non-racy-method-for-proc-entries-creation
+++ a/fs/reiserfs/procfs.c
@@ -467,6 +467,7 @@ static const struct file_operations r_fi
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = seq_release,
+	.owner = THIS_MODULE,
 };
 
 static struct proc_dir_entry *proc_info_root = NULL;
@@ -475,12 +476,8 @@ static const char proc_info_root_name[] 
 static void add_file(struct super_block *sb, char *name,
 		     int (*func) (struct seq_file *, struct super_block *))
 {
-	struct proc_dir_entry *de;
-	de = create_proc_entry(name, 0, REISERFS_SB(sb)->procdir);
-	if (de) {
-		de->data = func;
-		de->proc_fops = &r_file_operations;
-	}
+	proc_create_data(name, 0, REISERFS_SB(sb)->procdir,
+			 &r_file_operations, func);
 }
 
 int reiserfs_proc_info_init(struct super_block *sb)
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


From: akpm@linux-foundation.org
Subject: - procfs-directory-entry-cleanup.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:54:28 -0700
Message-ID: <200707162054.l6GKsSKt001803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34894 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759643AbXGPVYh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:24:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaosuo@gmail.com, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     procfs directory entry cleanup
has been removed from the -mm tree.  Its filename was
     procfs-directory-entry-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: procfs directory entry cleanup
From: "Changli Gao" <xiaosuo@gmail.com>

Function proc_register() will assign proc_dir_operations and
proc_dir_inode_operations to ent's members proc_fops and proc_iops
correctly if ent is a directory. So the early assignment isn't
necessary.

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff -puN fs/proc/generic.c~procfs-directory-entry-cleanup fs/proc/generic.c
--- a/fs/proc/generic.c~procfs-directory-entry-cleanup
+++ a/fs/proc/generic.c
@@ -530,12 +530,6 @@ static int proc_register(struct proc_dir
 		return -EAGAIN;
 	dp->low_ino = i;
 
-	spin_lock(&proc_subdir_lock);
-	dp->next = dir->subdir;
-	dp->parent = dir;
-	dir->subdir = dp;
-	spin_unlock(&proc_subdir_lock);
-
 	if (S_ISDIR(dp->mode)) {
 		if (dp->proc_iops == NULL) {
 			dp->proc_fops = &proc_dir_operations;
@@ -551,6 +545,13 @@ static int proc_register(struct proc_dir
 		if (dp->proc_iops == NULL)
 			dp->proc_iops = &proc_file_inode_operations;
 	}
+
+	spin_lock(&proc_subdir_lock);
+	dp->next = dir->subdir;
+	dp->parent = dir;
+	dir->subdir = dp;
+	spin_unlock(&proc_subdir_lock);
+
 	return 0;
 }
 
@@ -653,9 +654,6 @@ struct proc_dir_entry *proc_mkdir_mode(c
 
 	ent = proc_create(&parent, name, S_IFDIR | mode, 2);
 	if (ent) {
-		ent->proc_fops = &proc_dir_operations;
-		ent->proc_iops = &proc_dir_inode_operations;
-
 		if (proc_register(parent, ent) < 0) {
 			kfree(ent);
 			ent = NULL;
@@ -690,10 +688,6 @@ struct proc_dir_entry *create_proc_entry
 
 	ent = proc_create(&parent,name,mode,nlink);
 	if (ent) {
-		if (S_ISDIR(mode)) {
-			ent->proc_fops = &proc_dir_operations;
-			ent->proc_iops = &proc_dir_inode_operations;
-		}
 		if (proc_register(parent, ent) < 0) {
 			kfree(ent);
 			ent = NULL;
_

Patches currently in -mm which might be from xiaosuo@gmail.com are

origin.patch

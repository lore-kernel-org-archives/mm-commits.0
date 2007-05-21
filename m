From: akpm@linux-foundation.org
Subject: + procfs-directory-entry-cleanup.patch added to -mm tree
Date: Sun, 20 May 2007 20:41:02 -0700
Message-ID: <200705210341.l4L3f1BH001692@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40531 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbXEUDmP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 May 2007 23:42:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaosuo@gmail.com


The patch titled
     procfs directory entry cleanup
has been added to the -mm tree.  Its filename is
     procfs-directory-entry-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: procfs directory entry cleanup
From: "Changli Gao" <xiaosuo@gmail.com>

Function proc_register() will assign proc_dir_operations and
proc_dir_inode_operations to ent's members proc_fops and proc_iops
correctly if ent is a directory. So the early assignment isn't
necessary.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN fs/proc/generic.c~procfs-directory-entry-cleanup fs/proc/generic.c
--- a/fs/proc/generic.c~procfs-directory-entry-cleanup
+++ a/fs/proc/generic.c
@@ -649,9 +649,6 @@ struct proc_dir_entry *proc_mkdir_mode(c
 
 	ent = proc_create(&parent, name, S_IFDIR | mode, 2);
 	if (ent) {
-		ent->proc_fops = &proc_dir_operations;
-		ent->proc_iops = &proc_dir_inode_operations;
-
 		if (proc_register(parent, ent) < 0) {
 			kfree(ent);
 			ent = NULL;
@@ -686,10 +683,6 @@ struct proc_dir_entry *create_proc_entry
 
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

procfs-directory-entry-cleanup.patch

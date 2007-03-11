From: akpm@linux-foundation.org
Subject: + fix-race-between-proc_readdir-and-remove_proc_entry.patch added to -mm tree
Date: Sun, 11 Mar 2007 04:44:51 -0800
Message-ID: <200703111244.l2BCipIf011771@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46269 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933285AbXCKMsr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 08:48:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com, adobriyan@sw.ru, ebiederm@xmission.com


The patch titled
     Fix race between proc_readdir and remove_proc_entry
has been added to the -mm tree.  Its filename is
     fix-race-between-proc_readdir-and-remove_proc_entry.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix race between proc_readdir and remove_proc_entry
From: "Darrick J. Wong" <djwong@us.ibm.com>

Fix the following race:

proc_readdir				remove_proc_entry
============				=================

spin_lock(&proc_subdir_lock);
[choose PDE to start filldir from]
spin_unlock(&proc_subdir_lock);
					spin_lock(&proc_subdir_lock);
					[find PDE]
					[free PDE, refcount is 0]
					spin_unlock(&proc_subdir_lock);
		    /* boom */
if (filldir(dirent, de->name, ...

[de_put on error path --adobriyan]
Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN fs/proc/generic.c~fix-race-between-proc_readdir-and-remove_proc_entry fs/proc/generic.c
--- a/fs/proc/generic.c~fix-race-between-proc_readdir-and-remove_proc_entry
+++ a/fs/proc/generic.c
@@ -478,14 +478,21 @@ int proc_readdir(struct file * filp,
 			}
 
 			do {
+				struct proc_dir_entry *next;
+
 				/* filldir passes info to user space */
+				de_get(de);
 				spin_unlock(&proc_subdir_lock);
 				if (filldir(dirent, de->name, de->namelen, filp->f_pos,
-					    de->low_ino, de->mode >> 12) < 0)
+					    de->low_ino, de->mode >> 12) < 0) {
+					de_put(de);
 					goto out;
+				}
 				spin_lock(&proc_subdir_lock);
 				filp->f_pos++;
-				de = de->next;
+				next = de->next;
+				de_put(de);
+				de = next;
 			} while (de);
 			spin_unlock(&proc_subdir_lock);
 	}
_

Patches currently in -mm which might be from djwong@us.ibm.com are

fix-race-between-proc_readdir-and-remove_proc_entry.patch

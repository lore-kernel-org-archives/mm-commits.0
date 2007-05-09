From: akpm@linux-foundation.org
Subject: - fix-race-between-proc_readdir-and-remove_proc_entry.patch removed from -mm tree
Date: Tue, 08 May 2007 19:46:01 -0700
Message-ID: <200705090246.l492k1mn008803@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968823AbXEICqk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:46:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, adobriyan@sw.ru, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Fix race between proc_readdir and remove_proc_entry
has been removed from the -mm tree.  Its filename was
     fix-race-between-proc_readdir-and-remove_proc_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

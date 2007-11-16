From: akpm@linux-foundation.org
Subject: + proc-less-lock-operations-during-lookup.patch added to -mm tree
Date: Fri, 16 Nov 2007 13:50:11 -0800
Message-ID: <200711162150.lAGLoBQe005300@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35879 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756315AbXKPVut (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Nov 2007 16:50:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru


The patch titled
     proc: less LOCK operations during lookup
has been added to the -mm tree.  Its filename is
     proc-less-lock-operations-during-lookup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: proc: less LOCK operations during lookup
From: Alexey Dobriyan <adobriyan@sw.ru>

Pseudo-code for lookup effectively is:

	LOCK kernel
	LOCK proc_subdir_lock
		find PDE
		UNLOCK proc_subdir_lock

		get inode

		LOCK proc_subdir_lock
		goto unlock
	UNLOCK proc_subdir_lock
	UNLOCK kernel

We can get rid of LOCK/UNLOCK pair after getting inode simply by jumping
to unlock_kernel() directly.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/generic.c~proc-less-lock-operations-during-lookup fs/proc/generic.c
--- a/fs/proc/generic.c~proc-less-lock-operations-during-lookup
+++ a/fs/proc/generic.c
@@ -403,12 +403,12 @@ struct dentry *proc_lookup(struct inode 
 				spin_unlock(&proc_subdir_lock);
 				error = -EINVAL;
 				inode = proc_get_inode(dir->i_sb, ino, de);
-				spin_lock(&proc_subdir_lock);
-				break;
+				goto out_unlock;
 			}
 		}
 	}
 	spin_unlock(&proc_subdir_lock);
+out_unlock:
 	unlock_kernel();
 
 	if (inode) {
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
proc-remove-module_license.patch
proc-less-lock-operations-during-lookup.patch
proc-prototypes-redux.patch
proc-remove-useless-check-on-symlink-removal.patch
proc-remove-useless-checks-in-proc_register.patch
single_open-seq_release-leak-diagnostics.patch

From: akpm@linux-foundation.org
Subject: - proc-less-lock-operations-during-lookup.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:11:50 -0800
Message-ID: <200802082011.m18KBVc7010122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47219 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753501AbYBHUp0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:45:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     proc: less LOCK operations during lookup
has been removed from the -mm tree.  Its filename was
     proc-less-lock-operations-during-lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -406,12 +406,12 @@ struct dentry *proc_lookup(struct inode 
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
single_open-seq_release-leak-diagnostics.patch

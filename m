From: akpm@linux-foundation.org
Subject: - vfs-fix-shrink_submounts.patch removed from -mm tree
Date: Thu, 13 Nov 2008 13:26:56 -0800
Message-ID: <200811132126.mADLQudI027580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33817 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752089AbYKMV1D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 16:27:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, adobriyan@gmail.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: fix shrink_submounts
has been removed from the -mm tree.  Its filename was
     vfs-fix-shrink_submounts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: fix shrink_submounts
From: Eric W. Biederman <ebiederm@xmission.com>

In the last refactoring of shrink_submounts a variable was not completely
renamed.  So finish the renaming of mnt to m now.

Without this if you attempt to mount an nfs mount that has both automatic
nfs sub mounts on it, and has normal mounts on it.  The unmount will
succeed when it should not.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/namespace.c~vfs-fix-shrink_submounts fs/namespace.c
--- a/fs/namespace.c~vfs-fix-shrink_submounts
+++ a/fs/namespace.c
@@ -1815,8 +1815,8 @@ static void shrink_submounts(struct vfsm
 		while (!list_empty(&graveyard)) {
 			m = list_first_entry(&graveyard, struct vfsmount,
 						mnt_expire);
-			touch_mnt_namespace(mnt->mnt_ns);
-			umount_tree(mnt, 1, umounts);
+			touch_mnt_namespace(m->mnt_ns);
+			umount_tree(m, 1, umounts);
 		}
 	}
 }
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
linux-next.patch
vmcore-remove-saved_max_pfn-check.patch


From: akpm@linux-foundation.org
Subject: - ecryptfs-fix-imbalanced-mutex-locking.patch removed from -mm tree
Date: Tue, 13 May 2008 14:34:30 -0700
Message-ID: <200805132134.m4DLYUpM000926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759946AbYEMVem (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:34:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptFS: fix imbalanced mutex locking
has been removed from the -mm tree.  Its filename was
     ecryptfs-fix-imbalanced-mutex-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptFS: fix imbalanced mutex locking
From: Cyrill Gorcunov <gorcunov@gmail.com>

Fix imbalanced calls for mutex lock/unlock on ecryptfs_daemon_hash_mux
Revealed by Ingo Molnar: http://lkml.org/lkml/2008/5/7/260

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/miscdev.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/ecryptfs/miscdev.c~ecryptfs-fix-imbalanced-mutex-locking fs/ecryptfs/miscdev.c
--- a/fs/ecryptfs/miscdev.c~ecryptfs-fix-imbalanced-mutex-locking
+++ a/fs/ecryptfs/miscdev.c
@@ -257,12 +257,14 @@ ecryptfs_miscdev_read(struct file *file,
 	mutex_lock(&daemon->mux);
 	if (daemon->flags & ECRYPTFS_DAEMON_ZOMBIE) {
 		rc = 0;
+		mutex_unlock(&ecryptfs_daemon_hash_mux);
 		printk(KERN_WARNING "%s: Attempt to read from zombified "
 		       "daemon\n", __func__);
 		goto out_unlock_daemon;
 	}
 	if (daemon->flags & ECRYPTFS_DAEMON_IN_READ) {
 		rc = 0;
+		mutex_unlock(&ecryptfs_daemon_hash_mux);
 		goto out_unlock_daemon;
 	}
 	/* This daemon will not go away so long as this flag is set */
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
module-loading-elf-handling-use-selfmag-instead-of-numeric-constant.patch


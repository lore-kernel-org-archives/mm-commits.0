From: akpm@linux-foundation.org
Subject: - ecryptfs-remove-unnecessary-mux-from-ecryptfs_init_ecryptfs_miscdev.patch removed from -mm tree
Date: Sun, 06 Jul 2008 20:03:02 -0700
Message-ID: <200807070303.m67332bh004622@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753133AbYGGDDY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:03:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, gorcunov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: remove unnecessary mux from ecryptfs_init_ecryptfs_miscdev()
has been removed from the -mm tree.  Its filename was
     ecryptfs-remove-unnecessary-mux-from-ecryptfs_init_ecryptfs_miscdev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs: remove unnecessary mux from ecryptfs_init_ecryptfs_miscdev()
From: Michael Halcrow <mhalcrow@us.ibm.com>

The misc_mtx should provide all the protection required to keep the daemon
hash table sane during miscdev registration.  Since this mutex is causing
gratuitous lockdep warnings, this patch removes it.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Reported-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/miscdev.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/ecryptfs/miscdev.c~ecryptfs-remove-unnecessary-mux-from-ecryptfs_init_ecryptfs_miscdev fs/ecryptfs/miscdev.c
--- a/fs/ecryptfs/miscdev.c~ecryptfs-remove-unnecessary-mux-from-ecryptfs_init_ecryptfs_miscdev
+++ a/fs/ecryptfs/miscdev.c
@@ -575,13 +575,11 @@ int ecryptfs_init_ecryptfs_miscdev(void)
 	int rc;
 
 	atomic_set(&ecryptfs_num_miscdev_opens, 0);
-	mutex_lock(&ecryptfs_daemon_hash_mux);
 	rc = misc_register(&ecryptfs_miscdev);
 	if (rc)
 		printk(KERN_ERR "%s: Failed to register miscellaneous device "
 		       "for communications with userspace daemons; rc = [%d]\n",
 		       __func__, rc);
-	mutex_unlock(&ecryptfs_daemon_hash_mux);
 	return rc;
 }
 
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

git-unionfs.patch
fsstack-fsstack_copy_inode_size-locking.patch
ecryptfs-privileged-kthread-for-lower-file-opens.patch
ecryptfs-discard-ecryptfsd-registration-messages-in-miscdev.patch
ecryptfs-propagate-key-errors-up-at-mount-time.patch
ecryptfs-string-copy-cleanup.patch
ecryptfs-cryptoc-use-unaligned-byteorder-helpers.patch
ecryptfs-inodec-mmapc-use-unaligned-byteorder-helpers.patch
tpm-use-correct-data-types-for-sizes-in-tpm_write-and-tpm_read.patch
notify_change-callers-must-hold-i_mutex.patch


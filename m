From: akpm@linux-foundation.org
Subject: + ecryptfs-remove-unnecessary-mux-from-ecryptfs_init_ecryptfs_miscdev.patch added to -mm tree
Date: Thu, 26 Jun 2008 09:14:21 -0700
Message-ID: <200806261614.m5QGELa4007191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751738AbYFZQUG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jun 2008 12:20:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com, gorcunov@gmail.com


The patch titled
     ecryptfs: remove unnecessary mux from ecryptfs_init_ecryptfs_miscdev()
has been added to the -mm tree.  Its filename is
     ecryptfs-remove-unnecessary-mux-from-ecryptfs_init_ecryptfs_miscdev.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ecryptfs-remove-unnecessary-mux-from-ecryptfs_init_ecryptfs_miscdev.patch
git-unionfs.patch
ecryptfs-privileged-kthread-for-lower-file-opens.patch
notify_change-callers-must-hold-i_mutex.patch


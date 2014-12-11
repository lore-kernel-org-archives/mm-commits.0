From: akpm@linux-foundation.org
Subject: [merged]
 char_dev-remove-pointless-assignment-from-__register_chrdev_region.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:55:33 -0800
Message-ID: <5489e8a5.dzzANL81qSKqGxLl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbaLKSze (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:55:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/char_dev.c: remove pointless assignment from __register_chrdev_region()
has been removed from the -mm tree.  Its filename was
     char_dev-remove-pointless-assignment-from-__register_chrdev_region.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fs/char_dev.c: remove pointless assignment from __register_chrdev_region()

At one place we assign major number we found to ret.  That assignment is
then never used and actually doesn't make any sense given how the code is
currently structured (the assignment comes from pre-git times).  Just
remove it.

Coverity id: 1226852.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/char_dev.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/char_dev.c~char_dev-remove-pointless-assignment-from-__register_chrdev_region fs/char_dev.c
--- a/fs/char_dev.c~char_dev-remove-pointless-assignment-from-__register_chrdev_region
+++ a/fs/char_dev.c
@@ -117,7 +117,6 @@ __register_chrdev_region(unsigned int ma
 			goto out;
 		}
 		major = i;
-		ret = major;
 	}
 
 	cd->major = major;
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
befs-remove-dead-code.patch
linux-next.patch
fallocate-create-fan_modify-and-in_modify-events.patch
fsnotify-unify-inode-and-mount-marks-handling.patch
fsnotify-remove-destroy_list-from-fsnotify_mark.patch
mm-add-strictlimit-knob-v2.patch


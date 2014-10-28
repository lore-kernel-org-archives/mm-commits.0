From: akpm@linux-foundation.org
Subject: +
 char_dev-remove-pointless-assignment-from-__register_chrdev_region.patch
 added to -mm tree
Date: Tue, 28 Oct 2014 15:50:35 -0700
Message-ID: <54501dbb.B7lh/8Eij9t1htvS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34330 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaJ1Wue (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Oct 2014 18:50:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/char_dev.c: remove pointless assignment from __register_chrdev_region()
has been added to the -mm tree.  Its filename is
     char_dev-remove-pointless-assignment-from-__register_chrdev_region.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/char_dev-remove-pointless-assignment-from-__register_chrdev_region.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/char_dev-remove-pointless-assignment-from-__register_chrdev_region.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

bitmap-fix-undefined-shift-in-__bitmap_shift_leftright.patch
fallocate-create-fan_modify-and-in_modify-events.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-fix-xattr-check-in-ocfs2_get_xattr_nolock.patch
ocfs2-remove-bogus-test-from-ocfs2_read_locked_inode.patch
ocfs2-report-error-from-o2hb_do_disk_heartbeat-to-user.patch
ocfs2-remove-pointless-assignment-in-ocfs2_init.patch
char_dev-remove-pointless-assignment-from-__register_chrdev_region.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
ncpfs-return-proper-error-from-ncp_ioc_setroot-ioctl.patch
befs-remove-dead-code.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch


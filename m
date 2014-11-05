From: akpm@linux-foundation.org
Subject: + mm-fix-comment-before-truncate_setsize.patch added to -mm tree
Date: Wed, 05 Nov 2014 14:11:09 -0800
Message-ID: <545aa07d./fzH9Ll376V+UpW6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbaKEWLI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Nov 2014 17:11:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, JBeulich@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix comment before truncate_setsize()
has been added to the -mm tree.  Its filename is
     mm-fix-comment-before-truncate_setsize.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-comment-before-truncate_setsize.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-comment-before-truncate_setsize.patch

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
Subject: mm: fix comment before truncate_setsize()

XFS doesn't always hold i_mutex when calling truncate_setsize() and it
uses a different lock to serialize truncates and writes.  So fix the
comment before truncate_setsize().

Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Jan Beulich <JBeulich@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/truncate.c~mm-fix-comment-before-truncate_setsize mm/truncate.c
--- a/mm/truncate.c~mm-fix-comment-before-truncate_setsize
+++ a/mm/truncate.c
@@ -715,8 +715,9 @@ EXPORT_SYMBOL(truncate_pagecache);
  * necessary) to @newsize. It will be typically be called from the filesystem's
  * setattr function when ATTR_SIZE is passed in.
  *
- * Must be called with inode_mutex held and before all filesystem specific
- * block truncation has been performed.
+ * Must be called with a lock serializing truncates and writes (generally
+ * i_mutex but e.g. xfs uses a different lock) and before all filesystem
+ * specific block truncation has been performed.
  */
 void truncate_setsize(struct inode *inode, loff_t newsize)
 {
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
fallocate-create-fan_modify-and-in_modify-events.patch
fanotify-ignore-marks-not-respected.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-fix-xattr-check-in-ocfs2_get_xattr_nolock.patch
ocfs2-remove-bogus-test-from-ocfs2_read_locked_inode.patch
ocfs2-report-error-from-o2hb_do_disk_heartbeat-to-user.patch
ocfs2-remove-pointless-assignment-in-ocfs2_init.patch
char_dev-remove-pointless-assignment-from-__register_chrdev_region.patch
mm-fix-comment-before-truncate_setsize.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
ncpfs-return-proper-error-from-ncp_ioc_setroot-ioctl.patch
befs-remove-dead-code.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch


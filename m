From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-xattr-check-in-ocfs2_get_xattr_nolock.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:55:10 -0800
Message-ID: <5489e88e.8I//a4vkklbUpxts%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44959 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbaLKSzL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:55:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: Fix xattr check in ocfs2_get_xattr_nolock()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-xattr-check-in-ocfs2_get_xattr_nolock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ocfs2: Fix xattr check in ocfs2_get_xattr_nolock()

ocfs2_get_xattr_nolock() checks whether inode has any extended attributes
(OCFS2_HAS_XATTR_FL).  If not, it just sets 'ret' to -ENODATA but
continues with checking inline and external attributes anyway (which is
pointless although it does not harm).  Just return immediately when we
know there are no extended attributes in the inode.

Coverity id: 1226906.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/xattr.c~ocfs2-fix-xattr-check-in-ocfs2_get_xattr_nolock fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~ocfs2-fix-xattr-check-in-ocfs2_get_xattr_nolock
+++ a/fs/ocfs2/xattr.c
@@ -1284,7 +1284,7 @@ int ocfs2_xattr_get_nolock(struct inode
 		return -EOPNOTSUPP;
 
 	if (!(oi->ip_dyn_features & OCFS2_HAS_XATTR_FL))
-		ret = -ENODATA;
+		return -ENODATA;
 
 	xis.inode_bh = xbs.inode_bh = di_bh;
 	di = (struct ocfs2_dinode *)di_bh->b_data;
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


From: akpm@osdl.org
Subject: - ocfs2-relative-atime-support.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:08:25 -0800
Message-ID: <200612140608.kBE68PjX001951@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52088 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbWLNGI7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:08:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mark.fasheh@oracle.com, hch@lst.de, val_henson@linux.intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     ocfs2: relative atime support
has been removed from the -mm tree.  Its filename was
     ocfs2-relative-atime-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ocfs2: relative atime support
From: Mark Fasheh <mark.fasheh@oracle.com>

Update ocfs2_should_update_atime() to understand the MNT_RELATIME flag and
to test against mtime / ctime accordingly.

[akpm@osdl.org: cleanups]
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Valerie Henson <val_henson@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ocfs2/file.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN fs/ocfs2/file.c~ocfs2-relative-atime-support fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-relative-atime-support
+++ a/fs/ocfs2/file.c
@@ -153,6 +153,14 @@ int ocfs2_should_update_atime(struct ino
 	    ((vfsmnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(inode->i_mode)))
 		return 0;
 
+	if (vfsmnt->mnt_flags & MNT_RELATIME) {
+		if ((timespec_compare(&inode->i_atime, &inode->i_mtime) <= 0) ||
+		    (timespec_compare(&inode->i_atime, &inode->i_ctime) <= 0))
+			return 1;
+
+		return 0;
+	}
+
 	now = CURRENT_TIME;
 	if ((now.tv_sec - inode->i_atime.tv_sec <= osb->s_atime_quantum))
 		return 0;
_

Patches currently in -mm which might be from mark.fasheh@oracle.com are

conditionally-check-expected_preempt_count-in-__resched_legal.patch
git-ocfs2.patch


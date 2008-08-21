From: akpm@linux-foundation.org
Subject: + filesystem-freezing-remove-xfs-specific-ioctl-interfaces-for-freeze-feature.patch added to -mm tree
Date: Thu, 21 Aug 2008 13:20:23 -0700
Message-ID: <200808212020.m7LKKODX024059@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754595AbYHUUUf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 16:20:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: t-sato@yk.jp.nec.com, dgc@sgi.com, hch@lst.de, lachlan@sgi.com, m-hamaguchi@ys.jp.nec.com, tes@sgi.com, viro@zeniv.linux.org.uk


The patch titled
     filesystem freezing: remove XFS specific ioctl interfaces for freeze feature
has been added to the -mm tree.  Its filename is
     filesystem-freezing-remove-xfs-specific-ioctl-interfaces-for-freeze-feature.patch

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
Subject: filesystem freezing: remove XFS specific ioctl interfaces for freeze feature
From: Takashi Sato <t-sato@yk.jp.nec.com>

Remvoe the XFS specific ioctl interfaces and request codes for freeze
feature.

This patch has been supplied by David Chinner.

Signed-off-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Timothy Shimmin <tes@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_ioctl.c   |   15 ---------------
 fs/xfs/linux-2.6/xfs_ioctl32.c |    2 --
 fs/xfs/xfs_fs.h                |    4 ++--
 3 files changed, 2 insertions(+), 19 deletions(-)

diff -puN fs/xfs/linux-2.6/xfs_ioctl.c~filesystem-freezing-remove-xfs-specific-ioctl-interfaces-for-freeze-feature fs/xfs/linux-2.6/xfs_ioctl.c
--- a/fs/xfs/linux-2.6/xfs_ioctl.c~filesystem-freezing-remove-xfs-specific-ioctl-interfaces-for-freeze-feature
+++ a/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -1529,21 +1529,6 @@ xfs_ioctl(
 		return -error;
 	}
 
-	case XFS_IOC_FREEZE:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (inode->i_sb->s_frozen == SB_UNFROZEN)
-			freeze_bdev(inode->i_sb->s_bdev);
-		return 0;
-
-	case XFS_IOC_THAW:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-		if (inode->i_sb->s_frozen != SB_UNFROZEN)
-			thaw_bdev(inode->i_sb->s_bdev, inode->i_sb);
-		return 0;
-
 	case XFS_IOC_GOINGDOWN: {
 		__uint32_t in;
 
diff -puN fs/xfs/linux-2.6/xfs_ioctl32.c~filesystem-freezing-remove-xfs-specific-ioctl-interfaces-for-freeze-feature fs/xfs/linux-2.6/xfs_ioctl32.c
--- a/fs/xfs/linux-2.6/xfs_ioctl32.c~filesystem-freezing-remove-xfs-specific-ioctl-interfaces-for-freeze-feature
+++ a/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -398,8 +398,6 @@ xfs_compat_ioctl(
 	case XFS_IOC_FSGROWFSDATA:
 	case XFS_IOC_FSGROWFSLOG:
 	case XFS_IOC_FSGROWFSRT:
-	case XFS_IOC_FREEZE:
-	case XFS_IOC_THAW:
 	case XFS_IOC_GOINGDOWN:
 	case XFS_IOC_ERROR_INJECTION:
 	case XFS_IOC_ERROR_CLEARALL:
diff -puN fs/xfs/xfs_fs.h~filesystem-freezing-remove-xfs-specific-ioctl-interfaces-for-freeze-feature fs/xfs/xfs_fs.h
--- a/fs/xfs/xfs_fs.h~filesystem-freezing-remove-xfs-specific-ioctl-interfaces-for-freeze-feature
+++ a/fs/xfs/xfs_fs.h
@@ -477,8 +477,8 @@ typedef struct xfs_handle {
 #define XFS_IOC_ERROR_INJECTION	     _IOW ('X', 116, struct xfs_error_injection)
 #define XFS_IOC_ERROR_CLEARALL	     _IOW ('X', 117, struct xfs_error_injection)
 /*	XFS_IOC_ATTRCTL_BY_HANDLE -- deprecated 118	 */
-#define XFS_IOC_FREEZE		     _IOWR('X', 119, int)
-#define XFS_IOC_THAW		     _IOWR('X', 120, int)
+/*	XFS_IOC_FREEZE		  -- FIFREEZE   119	 */
+/*	XFS_IOC_THAW		  -- FITHAW     120	 */
 #define XFS_IOC_FSSETDM_BY_HANDLE    _IOW ('X', 121, struct xfs_fsop_setdm_handlereq)
 #define XFS_IOC_ATTRLIST_BY_HANDLE   _IOW ('X', 122, struct xfs_fsop_attrlist_handlereq)
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
_

Patches currently in -mm which might be from t-sato@yk.jp.nec.com are

filesystem-freezing-implement-generic-freeze-feature.patch
filesystem-freezing-remove-xfs-specific-ioctl-interfaces-for-freeze-feature.patch
filesystem-freezing-add-timeout-feature.patch


From: akpm@linux-foundation.org
Subject: [merged] xfs-underflow-bug-in-xfs_attrlist_by_handle.patch
 removed from -mm tree
Date: Mon, 09 Dec 2013 13:53:53 -0800
Message-ID: <52a63bf1.eBV1unrRHrardRAL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933049Ab3LIVxy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Dec 2013 16:53:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nico@ngolde.de, fabs@goesec.de, elder@kernel.org, dchinner@redhat.com, bpm@sgi.com, dan.carpenter@oracle.com

Subject: [merged] xfs-underflow-bug-in-xfs_attrlist_by_handle.patch removed from -mm tree
To: dan.carpenter@oracle.com,bpm@sgi.com,dchinner@redhat.com,elder@kernel.org,fabs@goesec.de,nico@ngolde.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Dec 2013 13:53:53 -0800


The patch titled
     Subject: xfs: underflow bug in xfs_attrlist_by_handle()
has been removed from the -mm tree.  Its filename was
     xfs-underflow-bug-in-xfs_attrlist_by_handle.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: xfs: underflow bug in xfs_attrlist_by_handle()

If we allocate less than sizeof(struct attrlist) then we end up corrupting
memory or doing a ZERO_PTR_SIZE dereference.

This can only be triggered with CAP_SYS_ADMIN.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Acked-by: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_ioctl.c   |    3 ++-
 fs/xfs/xfs_ioctl32.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/xfs/xfs_ioctl.c~xfs-underflow-bug-in-xfs_attrlist_by_handle fs/xfs/xfs_ioctl.c
--- a/fs/xfs/xfs_ioctl.c~xfs-underflow-bug-in-xfs_attrlist_by_handle
+++ a/fs/xfs/xfs_ioctl.c
@@ -442,7 +442,8 @@ xfs_attrlist_by_handle(
 		return -XFS_ERROR(EPERM);
 	if (copy_from_user(&al_hreq, arg, sizeof(xfs_fsop_attrlist_handlereq_t)))
 		return -XFS_ERROR(EFAULT);
-	if (al_hreq.buflen > XATTR_LIST_MAX)
+	if (al_hreq.buflen < sizeof(struct attrlist) ||
+	    al_hreq.buflen > XATTR_LIST_MAX)
 		return -XFS_ERROR(EINVAL);
 
 	/*
diff -puN fs/xfs/xfs_ioctl32.c~xfs-underflow-bug-in-xfs_attrlist_by_handle fs/xfs/xfs_ioctl32.c
--- a/fs/xfs/xfs_ioctl32.c~xfs-underflow-bug-in-xfs_attrlist_by_handle
+++ a/fs/xfs/xfs_ioctl32.c
@@ -356,7 +356,8 @@ xfs_compat_attrlist_by_handle(
 	if (copy_from_user(&al_hreq, arg,
 			   sizeof(compat_xfs_fsop_attrlist_handlereq_t)))
 		return -XFS_ERROR(EFAULT);
-	if (al_hreq.buflen > XATTR_LIST_MAX)
+	if (al_hreq.buflen < sizeof(struct attrlist) ||
+	    al_hreq.buflen > XATTR_LIST_MAX)
 		return -XFS_ERROR(EINVAL);
 
 	/*
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch
drivers-scsi-megaraid-megaraid_mmc-missing-bounds-check-in-mimd_to_kioc.patch
drivers-block-paride-pgc-underflow-bug-in-pg_write.patch
drivers-mailbox-omap-make-mbox-irq-signed-for-error-handling.patch
checkpatch-warn-only-on-space-before-semicolon-at-end-of-line.patch
linux-next.patch


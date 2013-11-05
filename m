From: akpm@linux-foundation.org
Subject: + xfs-underflow-bug-in-xfs_attrlist_by_handle.patch added to -mm
 tree
Date: Tue, 05 Nov 2013 13:51:23 -0800
Message-ID: <5279685b.Tlp5tKE9gGNyDvDu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58611 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab3KEVvY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Nov 2013 16:51:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nico@ngolde.de, fabs@goesec.de, elder@kernel.org, dchinner@redhat.com, bpm@sgi.com, dan.carpenter@oracle.com

Subject: + xfs-underflow-bug-in-xfs_attrlist_by_handle.patch added to -mm tree
To: dan.carpenter@oracle.com,bpm@sgi.com,dchinner@redhat.com,elder@kernel.org,fabs@goesec.de,nico@ngolde.de
From: akpm@linux-foundation.org
Date: Tue, 05 Nov 2013 13:51:23 -0800


The patch titled
     Subject: xfs: underflow bug in xfs_attrlist_by_handle()
has been added to the -mm tree.  Its filename is
     xfs-underflow-bug-in-xfs_attrlist_by_handle.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/xfs-underflow-bug-in-xfs_attrlist_by_handle.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/xfs-underflow-bug-in-xfs_attrlist_by_handle.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: xfs: underflow bug in xfs_attrlist_by_handle()

If we allocate less than sizeof(struct attrlist) then we end up corrupting
memory or doing a ZERO_PTR_SIZE dereference.

This can only be triggered with CAP_SYS_ADMIN.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Cc: Ben Myers <bpm@sgi.com>
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

ocfs2-add-missing-errno-in-ocfs2_ioctl_move_extents.patch
drivers-block-paride-pgc-underflow-bug-in-pg_write.patch
backlight-lm3630-signedness-bug-in-lm3630a_chip_init.patch
backlight-lm3630-potential-null-deref-in-probe.patch
linux-next.patch
xfs-underflow-bug-in-xfs_attrlist_by_handle.patch


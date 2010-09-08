From: akpm@linux-foundation.org
Subject: + xfs-prevent-reading-uninitialized-stack-memory.patch added to -mm tree
Date: Wed, 08 Sep 2010 14:55:29 -0700
Message-ID: <201009082155.o88LtT2H012054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751168Ab0IHV4C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2010 17:56:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.j.rosenberg@gmail.com, aelder@sgi.com, stable@kernel.org


The patch titled
     xfs: prevent reading uninitialized stack memory
has been added to the -mm tree.  Its filename is
     xfs-prevent-reading-uninitialized-stack-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xfs: prevent reading uninitialized stack memory
From: Dan Rosenberg <dan.j.rosenberg@gmail.com>

The XFS_IOC_FSGETXATTR ioctl allows unprivileged users to read 12 bytes of
uninitialized stack memory, because the fsxattr struct declared on the
stack in xfs_ioc_fsgetxattr() does not alter (or zero) the 12-byte fsx_pad
member before copying it back to the user.  This patch takes care of it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Cc: Alex Elder <aelder@sgi.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/xfs/linux-2.6/xfs_ioctl.c~xfs-prevent-reading-uninitialized-stack-memory fs/xfs/linux-2.6/xfs_ioctl.c
--- a/fs/xfs/linux-2.6/xfs_ioctl.c~xfs-prevent-reading-uninitialized-stack-memory
+++ a/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -785,6 +785,8 @@ xfs_ioc_fsgetxattr(
 {
 	struct fsxattr		fa;
 
+	memset(&fa, 0, sizeof(struct fsxattr));
+
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	fa.fsx_xflags = xfs_ip2xflags(ip);
 	fa.fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
_

Patches currently in -mm which might be from dan.j.rosenberg@gmail.com are

xfs-prevent-reading-uninitialized-stack-memory.patch


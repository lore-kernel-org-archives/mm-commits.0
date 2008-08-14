From: akpm@linux-foundation.org
Subject: - xfs-use-get_unaligned_-helpers.patch removed from -mm tree
Date: Thu, 14 Aug 2008 16:54:04 -0700
Message-ID: <200808142354.m7ENs4pE003884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751863AbYHNXyI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 19:54:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, dgc@sgi.com, lachlan@sgi.com, tes@sgi.com, mm-commits@vger.kernel.org


The patch titled
     xfs: use get_unaligned_* helpers
has been removed from the -mm tree.  Its filename was
     xfs-use-get_unaligned_-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xfs: use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/xfs/xfs_inode.c~xfs-use-get_unaligned_-helpers fs/xfs/xfs_inode.c
--- a/fs/xfs/xfs_inode.c~xfs-use-get_unaligned_-helpers
+++ a/fs/xfs/xfs_inode.c
@@ -580,8 +580,8 @@ xfs_iformat_extents(
 		xfs_validate_extents(ifp, nex, XFS_EXTFMT_INODE(ip));
 		for (i = 0; i < nex; i++, dp++) {
 			xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
-			ep->l0 = be64_to_cpu(get_unaligned(&dp->l0));
-			ep->l1 = be64_to_cpu(get_unaligned(&dp->l1));
+			ep->l0 = get_unaligned_be64(&dp->l0);
+			ep->l1 = get_unaligned_be64(&dp->l1);
 		}
 		XFS_BMAP_TRACE_EXLIST(ip, nex, whichfork);
 		if (whichfork != XFS_DATA_FORK ||
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
x86-fix-shadowed-variable-warning.patch
cifs-remove-global_extern-macro.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
v4l-drx397xdc-sparse-annotations.patch
input-ads7846c-sparse-lock-annotation.patch
kvm-make-functions-static.patch
misdn-endian-annotations-for-struct-zt.patch
misdn-annotate-iomem-pointer-and-add-statics.patch
drivers-net-replace-__function__-with-__func__.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
wireless-replace-__function__-with-__func__.patch
xtensa-replace-remaining-__function__-occurences.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch


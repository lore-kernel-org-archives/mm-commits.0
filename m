From: akpm@linux-foundation.org
Subject: - fs-xfs-xfs_bmap_btreec2312-error-b-undeclared-first.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:58:36 -0700
Message-ID: <200708242058.l7OKwaQn014320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54716 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758700AbXHXVID (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michal.k.k.piotrowski@gmail.com, dgc@sgi.com, tes@sgi.com, mm-commits@vger.kernel.org


The patch titled
     fs/xfs/xfs_bmap_btree.c:2312: error: 'b' undeclared (first  use in this function) (Was Re: 2.6.23-rc3-mm1)
has been removed from the -mm tree.  Its filename was
     fs-xfs-xfs_bmap_btreec2312-error-b-undeclared-first.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs/xfs/xfs_bmap_btree.c:2312: error: 'b' undeclared (first  use in this function) (Was Re: 2.6.23-rc3-mm1)
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

/home/devel/linux-mm/fs/xfs/xfs_bmap_btree.c: In function 'xfs_bmbt_set_allf':
/home/devel/linux-mm/fs/xfs/xfs_bmap_btree.c:2312: error: 'b' undeclared (first use in this function)
/home/devel/linux-mm/fs/xfs/xfs_bmap_btree.c:2312: error: (Each undeclared identifier is reported only once
/home/devel/linux-mm/fs/xfs/xfs_bmap_btree.c:2312: error: for each function it appears in.)
/home/devel/linux-mm/fs/xfs/xfs_bmap_btree.c: In function 'xfs_bmbt_disk_set_allf':
/home/devel/linux-mm/fs/xfs/xfs_bmap_btree.c:2372: error: 'b' undeclared (first use in this function)

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: David Chinner <dgc@sgi.com>
Cc: Timothy Shimmin <tes@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_bmap_btree.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/xfs/xfs_bmap_btree.c~fs-xfs-xfs_bmap_btreec2312-error-b-undeclared-first fs/xfs/xfs_bmap_btree.c
--- a/fs/xfs/xfs_bmap_btree.c~fs-xfs-xfs_bmap_btreec2312-error-b-undeclared-first
+++ a/fs/xfs/xfs_bmap_btree.c
@@ -2309,7 +2309,7 @@ xfs_bmbt_set_allf(
 		((xfs_bmbt_rec_base_t)blockcount &
 		(xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
 #else	/* !XFS_BIG_BLKNOS */
-	if (ISNULLSTARTBLOCK(b)) {
+	if (ISNULLSTARTBLOCK(startblock)) {
 		r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
 			((xfs_bmbt_rec_base_t)startoff << 9) |
 			 (xfs_bmbt_rec_base_t)XFS_MASK64LO(9);
@@ -2369,7 +2369,7 @@ xfs_bmbt_disk_set_allf(
 		 ((xfs_bmbt_rec_base_t)blockcount &
 		  (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
 #else	/* !XFS_BIG_BLKNOS */
-	if (ISNULLSTARTBLOCK(b)) {
+	if (ISNULLSTARTBLOCK(startblock)) {
 		r->l0 = cpu_to_be64(
 			((xfs_bmbt_rec_base_t)extent_flag << 63) |
 			 ((xfs_bmbt_rec_base_t)startoff << 9) |
_

Patches currently in -mm which might be from michal.k.k.piotrowski@gmail.com are

origin.patch
git-alsa.patch
git-dvb.patch
git-kvm.patch
git-netdev-all.patch
revert-8139too-clean-up-i-o-remapping.patch
git-xfs.patch
fs-remove-some-aop_truncated_page.patch
jsm-remove-further-unneeded-crud-fix.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
reiser4.patch

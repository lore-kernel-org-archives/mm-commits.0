From: akpm@osdl.org
Subject: - ufs-truncate-negative-to-unsigned-fix.patch removed from -mm tree
Date: Tue, 30 Jan 2007 13:46:48 -0800
Message-ID: <200701302146.l0ULkmd6030129@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51870 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbXA3Vqx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 16:46:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     ufs: truncate negative to unsigned fix
has been removed from the -mm tree.  Its filename was
     ufs-truncate-negative-to-unsigned-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ufs: truncate negative to unsigned fix
From: Evgeniy Dushistov <dushistov@mail.ru>

During ufs_trunc_direct which is subroutine of ufs::truncate, we try the first
of all free parts of block and then whole blocks.  But we calculate size of
block's part to free in the wrong way.

This may cause bad update of used blocks and fragments statistic, and you can
got report that you have free 32T on 1Gb partition.

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ufs/truncate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ufs/truncate.c~ufs-truncate-negative-to-unsigned-fix fs/ufs/truncate.c
--- a/fs/ufs/truncate.c~ufs-truncate-negative-to-unsigned-fix
+++ a/fs/ufs/truncate.c
@@ -109,10 +109,10 @@ static int ufs_trunc_direct (struct inod
 	tmp = fs32_to_cpu(sb, *p);
 	if (!tmp )
 		ufs_panic (sb, "ufs_trunc_direct", "internal error");
+	frag2 -= frag1;
 	frag1 = ufs_fragnum (frag1);
-	frag2 = ufs_fragnum (frag2);
 
-	ufs_free_fragments (inode, tmp + frag1, frag2 - frag1);
+	ufs_free_fragments(inode, tmp + frag1, frag2);
 	mark_inode_dirty(inode);
 	frag_to_free = tmp + frag1;
 
_

Patches currently in -mm which might be from dushistov@mail.ru are

origin.patch
ufs2-write-mount-as-rw.patch
ufs2-write-inodes-write.patch
ufs2-write-block-allocation-update.patch

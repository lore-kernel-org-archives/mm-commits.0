From: akpm@linux-foundation.org
Subject: - ufs2-tindirect-truncate-fix.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:08:56 -0800
Message-ID: <200703180908.l2I98uan019984@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60386 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbXCRJJI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:09:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dushistov@mail.ru, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     ufs2: tindirect truncate fix
has been removed from the -mm tree.  Its filename was
     ufs2-tindirect-truncate-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ufs2: tindirect truncate fix
From: Evgeniy Dushistov <dushistov@mail.ru>

During modification of code to support UFS2 writing,
the case with "three indirect" blocks in truncate path was missed,
this patch fixes this situation.

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/truncate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ufs/truncate.c~ufs2-tindirect-truncate-fix fs/ufs/truncate.c
--- a/fs/ufs/truncate.c~ufs2-tindirect-truncate-fix
+++ a/fs/ufs/truncate.c
@@ -348,7 +348,7 @@ static int ufs_trunc_tindirect(struct in
 	}
 
 	for (i = tindirect_block ; i < uspi->s_apb ; i++) {
-		tind = ubh_get_addr32 (tind_bh, i);
+		tind = ubh_get_data_ptr(uspi, tind_bh, i);
 		retry |= ufs_trunc_dindirect(inode, UFS_NDADDR + 
 			uspi->s_apb + ((i + 1) << uspi->s_2apbshift), tind);
 		ubh_mark_buffer_dirty(tind_bh);
_

Patches currently in -mm which might be from dushistov@mail.ru are

origin.patch

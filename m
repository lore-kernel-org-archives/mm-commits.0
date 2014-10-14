From: akpm@linux-foundation.org
Subject: [merged] fs-ufs-ballocc-remove-unused-variable.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:21:08 -0700
Message-ID: <543d6994.aZzCUx1YnPqL7WsF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbaJNSVH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:21:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ufs/balloc.c: remove unused variable
has been removed from the -mm tree.  Its filename was
     fs-ufs-ballocc-remove-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/ufs/balloc.c: remove unused variable

ucg is defined and set in ufs_bitmap_search but never used.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/balloc.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/ufs/balloc.c~fs-ufs-ballocc-remove-unused-variable fs/ufs/balloc.c
--- a/fs/ufs/balloc.c~fs-ufs-ballocc-remove-unused-variable
+++ a/fs/ufs/balloc.c
@@ -784,7 +784,6 @@ static u64 ufs_bitmap_search(struct supe
 		0x0, 0x2, 0x6, 0xe, 0x1e, 0x3e, 0x7e, 0xfe, 0x1fe
 	};
 	struct ufs_sb_private_info *uspi = UFS_SB(sb)->s_uspi;
-	struct ufs_cylinder_group *ucg;
 	unsigned start, length, loc;
 	unsigned pos, want, blockmap, mask, end;
 	u64 result;
@@ -792,8 +791,6 @@ static u64 ufs_bitmap_search(struct supe
 	UFSD("ENTER, cg %u, goal %llu, count %u\n", ucpi->c_cgx,
 	     (unsigned long long)goal, count);
 
-	ucg = ubh_get_ucg(UCPI_UBH(ucpi));

From: akpm@linux-foundation.org
Subject: - ufs-remove-unused-fs64_add-and-fs64_sub.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:01:08 -0700
Message-ID: <200804282201.m3SM18fx018819@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965663AbYD1WBO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:01:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     ufs: remove unused fs64_add and fs64_sub
has been removed from the -mm tree.  Its filename was
     ufs-remove-unused-fs64_add-and-fs64_sub.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ufs: remove unused fs64_add and fs64_sub
From: Marcin Slusarz <marcin.slusarz@gmail.com>

remove fs64_add and fs64_sub - they probably weren't ever used because
their prototypes used u32 instead of __fs64

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/swab.h |   18 ------------------
 1 file changed, 18 deletions(-)

diff -puN fs/ufs/swab.h~ufs-remove-unused-fs64_add-and-fs64_sub fs/ufs/swab.h
--- a/fs/ufs/swab.h~ufs-remove-unused-fs64_add-and-fs64_sub
+++ a/fs/ufs/swab.h
@@ -41,24 +41,6 @@ cpu_to_fs64(struct super_block *sbp, u64
 }
 
 static __inline u32
-fs64_add(struct super_block *sbp, u32 *n, int d)
-{
-	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
-		return *n = cpu_to_le64(le64_to_cpu(*n)+d);
-	else
-		return *n = cpu_to_be64(be64_to_cpu(*n)+d);
-}
-
-static __inline u32
-fs64_sub(struct super_block *sbp, u32 *n, int d)
-{
-	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
-		return *n = cpu_to_le64(le64_to_cpu(*n)-d);
-	else
-		return *n = cpu_to_be64(be64_to_cpu(*n)-d);
-}

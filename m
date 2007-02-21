From: akpm@linux-foundation.org
Subject: - minix-v3-fix-superblock-definition.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:45:07 -0800
Message-ID: <200702211045.l1LAj71O006330@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46807 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932421AbXBUKpW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:45:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Andries.Brouwer@cwi.nl, cedric.augonnet@gmail.com, danarag@gmail.com, mm-commits@vger.kernel.org


The patch titled
     minix v3: fix superblock definition
has been removed from the -mm tree.  Its filename was
     minix-v3-fix-superblock-definition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: minix v3: fix superblock definition
From: Andries Brouwer <Andries.Brouwer@cwi.nl>

Somehow we got the layout of the v3 superblock wrong, which causes crashes due
to overindexing of the buffer_head array in statfs on large fielsystems.

Cc: "Cedric Augonnet" <cedric.augonnet@gmail.com>
Cc: "Daniel Aragones" <danarag@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/minix_fs.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/minix_fs.h~minix-v3-fix-superblock-definition include/linux/minix_fs.h
--- a/include/linux/minix_fs.h~minix-v3-fix-superblock-definition
+++ a/include/linux/minix_fs.h
@@ -78,8 +78,7 @@ struct minix_super_block {
  * V3 minix super-block data on disk
  */
 struct minix3_super_block {
-	__u16 s_ninodes;
-	__u16 s_nzones;
+	__u32 s_ninodes;
 	__u16 s_pad0;
 	__u16 s_imap_blocks;
 	__u16 s_zmap_blocks;
_

Patches currently in -mm which might be from Andries.Brouwer@cwi.nl are

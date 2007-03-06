From: akpm@linux-foundation.org
Subject: - reiser4-use-reiser4_gfp_mask_get-in-reiser4-inode-allocation.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:00:15 -0800
Message-ID: <200703060200.l2620Fh7008715@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46619 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965687AbXCFCAX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:00:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zam@namesys.com, reiser@namesys.com, mm-commits@vger.kernel.org


The patch titled
     Reiser4: use reiser4_gfp_mask_get in reiser4 inode allocation.
has been removed from the -mm tree.  Its filename was
     reiser4-use-reiser4_gfp_mask_get-in-reiser4-inode-allocation.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: Reiser4: use reiser4_gfp_mask_get in reiser4 inode allocation.
From: Alexaner Zarochentsev <zam@namesys.com>

Use reiser4_gfp_mask_get for new reiser4 inode allocationr.  For deadlock
avaidance, it changes the memory allocation flags to GFP_NOFS if there is a
transaction open or any znode locks are held.

Signed-off-by: Alexander Zarochentsev <zam@namesys.com>
Cc: Hans Reiser <reiser@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/super_ops.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiser4/super_ops.c~reiser4-use-reiser4_gfp_mask_get-in-reiser4-inode-allocation fs/reiser4/super_ops.c
--- a/fs/reiser4/super_ops.c~reiser4-use-reiser4_gfp_mask_get-in-reiser4-inode-allocation
+++ a/fs/reiser4/super_ops.c
@@ -92,7 +92,7 @@ static struct inode *reiser4_alloc_inode
 	reiser4_inode_object *obj;
 
 	assert("nikita-1696", super != NULL);
-	obj = kmem_cache_alloc(inode_cache, SLAB_KERNEL);
+	obj = kmem_cache_alloc(inode_cache, reiser4_ctx_gfp_mask_get());
 	if (obj != NULL) {
 		reiser4_inode *info;
 
_

Patches currently in -mm which might be from zam@namesys.com are

reiser4.patch
reiser4-use-reiser4_gfp_mask_get-in-reiser4-inode-allocation.patch
reiser4-re-add-page_count-check-to-reiser4_releasepage.patch
reiser4-restore-fibmap-ioctl-support-for-packed-files.patch
reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress.patch

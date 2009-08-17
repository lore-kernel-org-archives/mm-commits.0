From: akpm@linux-foundation.org
Subject: [merged] ibmvscsi-avoid-unnecessary-use-of-kzalloc_pool.patch removed from -mm tree
Date: Mon, 17 Aug 2009 13:05:05 -0700
Message-ID: <200908172005.n7HK55xM017736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477AbZHQUKe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 16:10:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sage@newdream.net, James.Bottomley@HansenPartnership.com, brking@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ibmvscsi: avoid unnecessary use of kzalloc_pool
has been removed from the -mm tree.  Its filename was
     ibmvscsi-avoid-unnecessary-use-of-kzalloc_pool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ibmvscsi: avoid unnecessary use of kzalloc_pool
From: Sage Weil <sage@newdream.net>

The allocated struct is manually zeroed after allocation, so avoid using
the (broken) kzalloc mempool (which does not re-zero previously used items
when they are returned to the pool).

Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Sage Weil <sage@newdream.net>
Acked-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvscsi-avoid-unnecessary-use-of-kzalloc_pool drivers/scsi/ibmvscsi/ibmvfc.c
--- a/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvscsi-avoid-unnecessary-use-of-kzalloc_pool
+++ a/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4217,7 +4217,7 @@ static int ibmvfc_alloc_mem(struct ibmvf
 	if (!vhost->trace)
 		goto free_disc_buffer;
 
-	vhost->tgt_pool = mempool_create_kzalloc_pool(IBMVFC_TGT_MEMPOOL_SZ,
+	vhost->tgt_pool = mempool_create_kmalloc_pool(IBMVFC_TGT_MEMPOOL_SZ,
 						      sizeof(struct ibmvfc_target));
 
 	if (!vhost->tgt_pool) {
_

Patches currently in -mm which might be from sage@newdream.net are

linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
md-avoid-use-of-broken-kzalloc-mempool.patch
mm-remove-broken-kzalloc-mempool.patch


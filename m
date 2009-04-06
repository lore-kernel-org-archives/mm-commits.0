From: akpm@linux-foundation.org
Subject: [merged] scsi-used-kmem_cache_zalloc-instead-of-kmem_cache_alloc-memset.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:39:17 -0700
Message-ID: <200904061939.n36JdHmV013841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930AbZDFUD6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:03:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yjwei@cn.fujitsu.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     scsi: use kmem_cache_zalloc instead of kmem_cache_alloc/memset
has been removed from the -mm tree.  Its filename was
     scsi-used-kmem_cache_zalloc-instead-of-kmem_cache_alloc-memset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: use kmem_cache_zalloc instead of kmem_cache_alloc/memset
From: Wei Yongjun <yjwei@cn.fujitsu.com>

Used kmem_cache_zalloc instead of kmem_cache_alloc/memset.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/scsi/scsi.c~scsi-used-kmem_cache_zalloc-instead-of-kmem_cache_alloc-memset drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c~scsi-used-kmem_cache_zalloc-instead-of-kmem_cache_alloc-memset
+++ a/drivers/scsi/scsi.c
@@ -169,12 +169,10 @@ scsi_pool_alloc_command(struct scsi_host
 {
 	struct scsi_cmnd *cmd;
 
-	cmd = kmem_cache_alloc(pool->cmd_slab, gfp_mask | pool->gfp_mask);
+	cmd = kmem_cache_zalloc(pool->cmd_slab, gfp_mask | pool->gfp_mask);
 	if (!cmd)
 		return NULL;
 
-	memset(cmd, 0, sizeof(*cmd));

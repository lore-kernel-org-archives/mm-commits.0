From: akpm@linux-foundation.org
Subject: + scsi-used-kmem_cache_zalloc-instead-of-kmem_cache_alloc-memset.patch added to -mm tree
Date: Mon, 09 Feb 2009 14:07:38 -0800
Message-ID: <200902092207.n19M7cQb030904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752966AbZBIWHq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 17:07:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yjwei@cn.fujitsu.com, James.Bottomley@HansenPartnership.com


The patch titled
     scsi: use kmem_cache_zalloc instead of kmem_cache_alloc/memset
has been added to the -mm tree.  Its filename is
     scsi-used-kmem_cache_zalloc-instead-of-kmem_cache_alloc-memset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

From: akpm@linux-foundation.org
Subject: [merged]
 kernel-better-document-the-use_mm-unuse_mm-api-contract-fix-2.patch removed
 from -mm tree
Date: Tue, 16 Jun 2020 10:28:32 -0700
Message-ID: <20200616172832.v1u6S_0Gl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730790AbgFPR2d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Jun 2020 13:28:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexdeucher@gmail.com, hch@lst.de, mm-commits@vger.kernel.org, sfr@canb.auug.org.au


The patch titled
     Subject: drm/amdkfd: fix up for {un}use_mm() rename
has been removed from the -mm tree.  Its filename was
     kernel-better-document-the-use_mm-unuse_mm-api-contract-fix-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: drm/amdkfd: fix up for {un}use_mm() rename

Link: http://lkml.kernel.org/r/20200528201940.759c58ff@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alex Deucher <alexdeucher@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdkfd/kfd_process.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c~kernel-better-document-the-use_mm-unuse_mm-api-contract-fix-2
+++ a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -115,7 +115,7 @@ static void kfd_sdma_activity_worker(str
 		return;
 	}
 
-	use_mm(mm);
+	kthread_use_mm(mm);
 
 	dqm_lock(dqm);
 
@@ -142,7 +142,7 @@ static void kfd_sdma_activity_worker(str
 	}
 
 	dqm_unlock(dqm);
-	unuse_mm(mm);
+	kthread_unuse_mm(mm);
 	mmput(mm);
 }
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

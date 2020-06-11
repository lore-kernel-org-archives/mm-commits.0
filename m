From: akpm@linux-foundation.org
Subject: [folded-merged]
 kernel-better-document-the-use_mm-unuse_mm-api-contract-v2-fix.patch
 removed from -mm tree
Date: Wed, 10 Jun 2020 18:21:21 -0700
Message-ID: <20200611012121.KH0pbvkCd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbgFKBVW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:21:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haren@linux.ibm.com, hch@lst.de, mm-commits@vger.kernel.org, sfr@canb.auug.org.au


The patch titled
     Subject: powerpc/vas: fix up for {un}use_mm() rename
has been removed from the -mm tree.  Its filename was
     kernel-better-document-the-use_mm-unuse_mm-api-contract-v2-fix.patch

This patch was dropped because it was folded into kernel-better-document-the-use_mm-unuse_mm-api-contract.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: powerpc/vas: fix up for {un}use_mm() rename

Link: http://lkml.kernel.org/r/20200422163935.5aa93ba5@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Haren Myneni <haren@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/powernv/vas-fault.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/powernv/vas-fault.c~kernel-better-document-the-use_mm-unuse_mm-api-contract-v2-fix
+++ a/arch/powerpc/platforms/powernv/vas-fault.c
@@ -127,7 +127,7 @@ static void update_csb(struct vas_window
 		return;
 	}
 
-	use_mm(window->mm);
+	kthread_use_mm(window->mm);
 	rc = copy_to_user(csb_addr, &csb, sizeof(csb));
 	/*
 	 * User space polls on csb.flags (first byte). So add barrier
@@ -139,7 +139,7 @@ static void update_csb(struct vas_window
 		smp_mb();
 		rc = copy_to_user(csb_addr, &csb, sizeof(u8));
 	}
-	unuse_mm(window->mm);
+	kthread_unuse_mm(window->mm);
 	put_task_struct(tsk);
 
 	/* Success */
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

kernel-better-document-the-use_mm-unuse_mm-api-contract.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-fix-2.patch

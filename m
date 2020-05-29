From: akpm@linux-foundation.org
Subject: +
 kernel-better-document-the-use_mm-unuse_mm-api-contract-fix-2.patch added
 to -mm tree
Date: Fri, 29 May 2020 14:05:20 -0700
Message-ID: <20200529210520.Eu7gFaWrW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727781AbgE2VFW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 29 May 2020 17:05:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexdeucher@gmail.com, hch@lst.de, mm-commits@vger.kernel.org, sfr@canb.auug.org.au


The patch titled
     Subject: drm/amdkfd: fix up for {un}use_mm() rename
has been added to the -mm tree.  Its filename is
     kernel-better-document-the-use_mm-unuse_mm-api-contract-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-better-document-the-use_mm-unuse_mm-api-contract-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-better-document-the-use_mm-unuse_mm-api-contract-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -114,7 +114,7 @@ static void kfd_sdma_activity_worker(str
 		return;
 	}
 
-	use_mm(mm);
+	kthread_use_mm(mm);
 
 	dqm_lock(dqm);
 
@@ -141,7 +141,7 @@ static void kfd_sdma_activity_worker(str
 	}
 
 	dqm_unlock(dqm);
-	unuse_mm(mm);
+	kthread_unuse_mm(mm);
 	mmput(mm);
 }
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

kernel-better-document-the-use_mm-unuse_mm-api-contract-v2-fix.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-fix-2.patch

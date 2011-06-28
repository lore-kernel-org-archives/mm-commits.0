From: akpm@linux-foundation.org
Subject: + mm-__tlb_remove_page-checks-correct-batch.patch added to -mm tree
Date: Tue, 28 Jun 2011 16:09:25 -0700
Message-ID: <201106282309.p5SN9Pqb013244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751205Ab1F1XKB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 19:10:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, a.p.zijlstra@chello.nl


The patch titled
     mm: __tlb_remove_page() check the correct batch
has been added to the -mm tree.  Its filename is
     mm-__tlb_remove_page-checks-correct-batch.patch

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
Subject: mm: __tlb_remove_page() check the correct batch
From: Shaohua Li <shaohua.li@intel.com>

__tlb_remove_page() switches to a new batch page, but still checks space
in the old batch.  This check always fails, and causes a forced tlb flush.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memory.c~mm-__tlb_remove_page-checks-correct-batch mm/memory.c
--- a/mm/memory.c~mm-__tlb_remove_page-checks-correct-batch
+++ a/mm/memory.c
@@ -305,6 +305,7 @@ int __tlb_remove_page(struct mmu_gather 
 	if (batch->nr == batch->max) {
 		if (!tlb_next_batch(tlb))
 			return 0;
+		batch = tlb->active;
 	}
 	VM_BUG_ON(batch->nr > batch->max);
 
_

Patches currently in -mm which might be from shaohua.li@intel.com are

mm-__tlb_remove_page-checks-correct-batch.patch
linux-next.patch
tmpfs-simplify-prealloc_page.patch
intel_idle-fix-api-misuse.patch
intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch


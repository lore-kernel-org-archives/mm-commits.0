From: akpm@linux-foundation.org
Subject: [merged]
 mm-dont-call-mmu_notifier_invalidate_page-during-munlock.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:53:25 -0700
Message-ID: <5390cab5.0Up8SS4+nzHT5qcM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56595 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbaFETxZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:53:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, koct9i@gmail.com

Subject: [merged] mm-dont-call-mmu_notifier_invalidate_page-during-munlock.patch removed from -mm tree
To: koct9i@gmail.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:53:25 -0700


The patch titled
     Subject: mm/rmap.c: don't call mmu_notifier_invalidate_page() during munlock
has been removed from the -mm tree.  Its filename was
     mm-dont-call-mmu_notifier_invalidate_page-during-munlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: mm/rmap.c: don't call mmu_notifier_invalidate_page() during munlock

In its munmap mode, try_to_unmap_one() searches other mlocked vmas, it
never unmaps pages.  There is no reason for invalidation because ptes are
left unchanged.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/rmap.c~mm-dont-call-mmu_notifier_invalidate_page-during-munlock mm/rmap.c
--- a/mm/rmap.c~mm-dont-call-mmu_notifier_invalidate_page-during-munlock
+++ a/mm/rmap.c
@@ -1252,7 +1252,7 @@ static int try_to_unmap_one(struct page
 
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
-	if (ret != SWAP_FAIL)
+	if (ret != SWAP_FAIL && TTU_ACTION(flags) != TTU_MUNLOCK)
 		mmu_notifier_invalidate_page(mm, address);
 out:
 	return ret;
_

Patches currently in -mm which might be from koct9i@gmail.com are

origin.patch
linux-next.patch


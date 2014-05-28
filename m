From: akpm@linux-foundation.org
Subject: + mm-dont-call-mmu_notifier_invalidate_page-during-munlock.patch
 added to -mm tree
Date: Wed, 28 May 2014 16:10:03 -0700
Message-ID: <53866ccb.RMnfFVP9YOXyCspu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43228 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbaE1XKE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 May 2014 19:10:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, koct9i@gmail.com

Subject: + mm-dont-call-mmu_notifier_invalidate_page-during-munlock.patch added to -mm tree
To: koct9i@gmail.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 28 May 2014 16:10:03 -0700


The patch titled
     Subject: mm/rmap.c: don't call mmu_notifier_invalidate_page() during munlock
has been added to the -mm tree.  Its filename is
     mm-dont-call-mmu_notifier_invalidate_page-during-munlock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dont-call-mmu_notifier_invalidate_page-during-munlock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-call-mmu_notifier_invalidate_page-during-munlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1246,7 +1246,7 @@ static int try_to_unmap_one(struct page
 
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
-	if (ret != SWAP_FAIL)
+	if (ret != SWAP_FAIL && TTU_ACTION(flags) != TTU_MUNLOCK)
 		mmu_notifier_invalidate_page(mm, address);
 out:
 	return ret;
_

Patches currently in -mm which might be from koct9i@gmail.com are

tools-vm-page-typesc-catch-sigbus-if-raced-with-truncate.patch
mm-process_vm_access-move-config-option-into-init-kconfig.patch
mm-dont-call-mmu_notifier_invalidate_page-during-munlock.patch
linux-next.patch


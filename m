From: akpm@linux-foundation.org
Subject: [merged]
 mm-hmm-fix-uninitialized-use-of-entry-in-hmm_vma_walk_pmd.patch removed
 from -mm tree
Date: Thu, 01 Feb 2018 11:34:25 -0800
Message-ID: <20180201193425.bFfTLWzfD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60806 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754648AbeBATe3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:34:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com


The patch titled
     Subject: mm/hmm: fix uninitialized use of 'entry' in hmm_vma_walk_pmd()
has been removed from the -mm tree.  Its filename was
     mm-hmm-fix-uninitialized-use-of-entry-in-hmm_vma_walk_pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/hmm: fix uninitialized use of 'entry' in hmm_vma_walk_pmd()

The variable 'entry' is used before being initialized in
hmm_vma_walk_pmd().

No bad effect (beside performance hit) so !non_swap_entry(0) evaluate
to true which trigger a fault as if CPU was trying to access migrated
memory and migrate memory back from device memory to regular memory.

This function (hmm_vma_walk_pmd()) is called when a device driver tries
to populate its own page table.  For migrated memory it should not
happen as the device driver should already have populated its page
table correctly during the migration.

Only case I can think of is multi-GPU where a second GPU triggers
migration back to regular memory.  Again this would just result in a
performance hit, nothing bad would happen.

Link: http://lkml.kernel.org/r/20180122185759.26286-1-jglisse@redhat.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hmm.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/hmm.c~mm-hmm-fix-uninitialized-use-of-entry-in-hmm_vma_walk_pmd mm/hmm.c
--- a/mm/hmm.c~mm-hmm-fix-uninitialized-use-of-entry-in-hmm_vma_walk_pmd
+++ a/mm/hmm.c
@@ -418,7 +418,7 @@ again:
 		}
 
 		if (!pte_present(pte)) {
-			swp_entry_t entry;
+			swp_entry_t entry = pte_to_swp_entry(pte);
 
 			if (!non_swap_entry(entry)) {
 				if (hmm_vma_walk->fault)
@@ -426,8 +426,6 @@ again:
 				continue;
 			}
 
-			entry = pte_to_swp_entry(pte);

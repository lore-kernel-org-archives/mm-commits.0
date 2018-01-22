From: akpm@linux-foundation.org
Subject: + mm-hmm-fix-uninitialized-use-of-entry-in-hmm_vma_walk_pmd.patch added to -mm tree
Date: Mon, 22 Jan 2018 12:58:42 -0800
Message-ID: <5a665082.idtJB3UCTz9BIKSY%akpm__38595.5437472605$1516654634$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52910 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750953AbeAVU6o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Jan 2018 15:58:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rcampbell@nvidia.com, jglisse@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm: fix uninitialized use of 'entry' in hmm_vma_walk_pmd()
has been added to the -mm tree.  Its filename is
     mm-hmm-fix-uninitialized-use-of-entry-in-hmm_vma_walk_pmd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hmm-fix-uninitialized-use-of-entry-in-hmm_vma_walk_pmd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hmm-fix-uninitialized-use-of-entry-in-hmm_vma_walk_pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/hmm: fix uninitialized use of 'entry' in hmm_vma_walk_pmd()

The variable 'entry' is used before being initialized in
hmm_vma_walk_pmd().

Link: http://lkml.kernel.org/r/20180122185759.26286-1-jglisse@redhat.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: <stable@vger.kernel.org>
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

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966C220B0F
	for <mm-commits@vger.kernel.org>; Wed, 14 Aug 2024 20:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723665741; cv=none; b=guCyM6KYCZj38KFHeeEBkqYC7zFHH2BbcOalC6BjPRdNsPSwIhLM9r29GRzTYFQBtQ1BdAhaFNhq72rhORlJDsRaAbQkf+gIK0abGSaNfeEANbRwOEs7atlWr1zVhrhmIsNl1KwmFAmRDtHBxGJMhiesuGBy3ux1QgaNbG7KnVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723665741; c=relaxed/simple;
	bh=Ce2e/q9BGzh0TpO8bMV1qxpwIAJ7uEcItNTBAm3rzlk=;
	h=Date:To:From:Subject:Message-Id; b=cHHWL6qtNOStnex0RIuXAXBQSE61mpmdbrKzMTfXJa+Cn9KkLMXOBn+zxS9hntB1rCqOb6xxLIxXqceuqwkAuu+ZVBjSN3EGk3qdEKnkWLph07UvrWUB1ziwUzAp70+CaE54cyzven4KT49n9J1jYjUsVRH+KMsASYzpn7I6cXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sxBmVBtO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sxBmVBtO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1964C116B1;
	Wed, 14 Aug 2024 20:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723665741;
	bh=Ce2e/q9BGzh0TpO8bMV1qxpwIAJ7uEcItNTBAm3rzlk=;
	h=Date:To:From:Subject:From;
	b=sxBmVBtOxmux+cOS7cusM2VAgUERb+l5cf19llKdtdp/eMtQsZ0l1JIcIlhoSw1Jf
	 dQUrr3XhMNpOrQZ5vjFTi1Ty3nk5J2w9N4eJCBz8XTFsyLvdlT6n4/T6WpEwcyHE1R
	 A/kg7oZNZFZbxT3MEJIrjauDab4gcHqkp/PQo34A=
Date: Wed, 14 Aug 2024 13:02:20 -0700
To: mm-commits@vger.kernel.org,baohua@kernel.org,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-a-pageflag-for-partially-mapped-folios-fix.patch added to mm-unstable branch
Message-Id: <20240814200220.F1964C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-introduce-a-pageflag-for-partially-mapped-folios-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-a-pageflag-for-partially-mapped-folios-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-a-pageflag-for-partially-mapped-folios-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm-introduce-a-pageflag-for-partially-mapped-folios-fix
Date: Wed, 14 Aug 2024 13:36:58 +0100

fix MTHP_STAT_SPLIT_DEFERRED for PMD_ORDER

Link: https://lkml.kernel.org/r/88d411c5-6d66-4d41-ae86-e0f943e5fb91@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Cc: Barry Song <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   17 +++++++++--------
 mm/rmap.c        |    2 +-
 2 files changed, 10 insertions(+), 9 deletions(-)

--- a/mm/huge_memory.c~mm-introduce-a-pageflag-for-partially-mapped-folios-fix
+++ a/mm/huge_memory.c
@@ -3452,6 +3452,7 @@ void __folio_undo_large_rmappable(struct
 	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
 }
 
+/* partially_mapped=false won't clear PG_partially_mapped folio flag */
 void deferred_split_folio(struct folio *folio, bool partially_mapped)
 {
 	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
@@ -3481,16 +3482,16 @@ void deferred_split_folio(struct folio *
 		return;
 
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
-	if (partially_mapped)
+	if (partially_mapped) {
 		folio_set_partially_mapped(folio);
-	else
-		folio_clear_partially_mapped(folio);
+		if (folio_test_pmd_mappable(folio))
+			count_vm_event(THP_DEFERRED_SPLIT_PAGE);
+		count_mthp_stat(folio_order(folio), MTHP_STAT_SPLIT_DEFERRED);
+	} else {
+		/* partially mapped folios cannont become partially unmapped */
+		VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
+	}
 	if (list_empty(&folio->_deferred_list)) {
-		if (partially_mapped) {
-			if (folio_test_pmd_mappable(folio))
-				count_vm_event(THP_DEFERRED_SPLIT_PAGE);
-			count_mthp_stat(folio_order(folio), MTHP_STAT_SPLIT_DEFERRED);
-		}
 		list_add_tail(&folio->_deferred_list, &ds_queue->split_queue);
 		ds_queue->split_queue_len++;
 #ifdef CONFIG_MEMCG
--- a/mm/rmap.c~mm-introduce-a-pageflag-for-partially-mapped-folios-fix
+++ a/mm/rmap.c
@@ -1578,7 +1578,7 @@ static __always_inline void __folio_remo
 	 * Check partially_mapped first to ensure it is a large folio.
 	 */
 	if (partially_mapped && folio_test_anon(folio) &&
-	    list_empty(&folio->_deferred_list))
+	    !folio_test_partially_mapped(folio))
 		deferred_split_folio(folio, true);
 
 	__folio_mod_stat(folio, -nr, -nr_pmdmapped);
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

mm-introduce-a-pageflag-for-partially-mapped-folios.patch
mm-introduce-a-pageflag-for-partially-mapped-folios-fix.patch
mm-split-underutilized-thps.patch
mm-add-sysfs-entry-to-disable-splitting-underutilized-thps.patch


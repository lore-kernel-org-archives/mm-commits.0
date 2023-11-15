Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FDF2C072A2
	for <mm-commits@archiver.kernel.org>; Wed, 15 Nov 2023 23:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235695AbjKOXbL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Nov 2023 18:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235627AbjKOXa6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2023 18:30:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF377198
        for <mm-commits@vger.kernel.org>; Wed, 15 Nov 2023 15:30:54 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D60C433C9;
        Wed, 15 Nov 2023 23:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700091054;
        bh=GJJVPUMhA8TzyEcG3qHZnxwzSWqiSYhHeX3xg5BAQAo=;
        h=Date:To:From:Subject:From;
        b=jfo7Qf+FAyvdt/mardbPWMyGntA442z/xouCIfvWTz3ijtRff4TU9JSnKJlfGQJ0w
         R9w19gD4DLD2SaCdhV5VbSH+/5D2sCt6mFHTzYsWpy1m+5DvQkRJ78I0x0F34aWg5T
         G4A4R4wdOL5f8I3UL3jiWOXVutUvGacMrK/+SA0g=
Date:   Wed, 15 Nov 2023 15:30:53 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ryan.roberts@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-more-ptep_get-conversion.patch removed from -mm tree
Message-Id: <20231115233054.78D60C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: more ptep_get() conversion
has been removed from the -mm tree.  Its filename was
     mm-more-ptep_get-conversion.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: more ptep_get() conversion
Date: Tue, 14 Nov 2023 15:49:45 +0000

Commit c33c794828f2 ("mm: ptep_get() conversion") converted all (non-arch)
call sites to use ptep_get() instead of doing a direct dereference of the
pte.  Full rationale can be found in that commit's log.

Since then, three new call sites have snuck in, which directly dereference
the pte, so let's fix those up.

Unfortunately there is no reliable automated mechanism to catch these; I'm
relying on a combination of Coccinelle (which throws up a lot of false
positives) and some compiler magic to force a compiler error on
dereference (While this approach finds dereferences, it also yields a
non-booting kernel so can't be committed).

Link: https://lkml.kernel.org/r/20231114154945.490401-1-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c     |    2 +-
 mm/ksm.c         |    2 +-
 mm/userfaultfd.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/filemap.c~mm-more-ptep_get-conversion
+++ a/mm/filemap.c
@@ -3443,7 +3443,7 @@ static vm_fault_t filemap_map_folio_rang
 		 * handled in the specific fault path, and it'll prohibit the
 		 * fault-around logic.
 		 */
-		if (!pte_none(vmf->pte[count]))
+		if (!pte_none(ptep_get(&vmf->pte[count])))
 			goto skip;
 
 		count++;
--- a/mm/ksm.c~mm-more-ptep_get-conversion
+++ a/mm/ksm.c
@@ -468,7 +468,7 @@ static int break_ksm_pmd_entry(pmd_t *pm
 			page = pfn_swap_entry_to_page(entry);
 	}
 	/* return 1 if the page is an normal ksm page or KSM-placed zero page */
-	ret = (page && PageKsm(page)) || is_ksm_zero_pte(*pte);
+	ret = (page && PageKsm(page)) || is_ksm_zero_pte(ptent);
 	pte_unmap_unlock(pte, ptl);
 	return ret;
 }
--- a/mm/userfaultfd.c~mm-more-ptep_get-conversion
+++ a/mm/userfaultfd.c
@@ -312,7 +312,7 @@ static int mfill_atomic_pte_poison(pmd_t
 
 	ret = -EEXIST;
 	/* Refuse to overwrite any PTE, even a PTE marker (e.g. UFFD WP). */
-	if (!pte_none(*dst_pte))
+	if (!pte_none(ptep_get(dst_pte)))
 		goto out_unlock;
 
 	set_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
_

Patches currently in -mm which might be from ryan.roberts@arm.com are



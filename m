Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 666C3C4167D
	for <mm-commits@archiver.kernel.org>; Tue, 14 Nov 2023 22:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbjKNWx4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Nov 2023 17:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbjKNWx4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Nov 2023 17:53:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649BCE0
        for <mm-commits@vger.kernel.org>; Tue, 14 Nov 2023 14:53:50 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020DFC433C8;
        Tue, 14 Nov 2023 22:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700002430;
        bh=Dv5xn1YHKlDCPnSp59I3nSmSJuFTEdHSYzd80QEBJy8=;
        h=Date:To:From:Subject:From;
        b=c4jvmPfsnPetTkmHz17Bj5WT1S/bAlamaDhZqGjCXgjKdKXf45lIjBbsdmLEsCbmw
         K2hHkZchZZCBqVXjZsqxUZmVKuf+IGlvVaI2pW0tD5jW4rswPwn5cI9Np7NumokOae
         n2hGKK/wj8fRT3iNlgegZOqJMWu05qmz7Pc1+CYg=
Date:   Tue, 14 Nov 2023 14:53:49 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ryan.roberts@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-more-ptep_get-conversion.patch added to mm-hotfixes-unstable branch
Message-Id: <20231114225350.020DFC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: more ptep_get() conversion
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-more-ptep_get-conversion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-more-ptep_get-conversion.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-more-ptep_get-conversion.patch


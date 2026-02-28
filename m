Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C0633FE26
	for <mm-commits@vger.kernel.org>; Sat, 28 Feb 2026 19:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772308444; cv=none; b=YAqgzAsdBLQAF+xfsWC7KV9bPtWyUehZTra26oSgG6bTjF30QN3UOmKh/ACuh+Cjm6+9cHDpSKzv/hUll+vL54hIZ+OLbua2e8lUCkyPWrP2ubeKwa5MPFDUNgcPnNGC6B+n9U9+AAX3yxlsYGOnO+WYWBE8bnhT37ILe4/NLO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772308444; c=relaxed/simple;
	bh=/Rti3XQWb1zPEkBkN6fG7vgF4ua29uiN785aodNiSs0=;
	h=Date:To:From:Subject:Message-Id; b=d7Z0Ibpm/rZ2aTfBVQ6tK218PxXAkI1es4BuJwtMhRSg4HP0IDSXhW/8bI38dXXsz7lPBktOErdGnC9gdwmK2F6n3X22hIX0u26FWwVCuI1p8qymOSsqQrRXO3GDsfxA1A5o3QKGmrWzqS3gETZuNr5ZVxcdPLgMs81XnU2RYII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nWBDVsWl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nWBDVsWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABCDDC116D0;
	Sat, 28 Feb 2026 19:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772308443;
	bh=/Rti3XQWb1zPEkBkN6fG7vgF4ua29uiN785aodNiSs0=;
	h=Date:To:From:Subject:From;
	b=nWBDVsWlqDmRu38L2USJsSFrN2fuPn3rW2D/RLzEI72A0NlaEK6yq9UfTkuiTJG45
	 3kPxKW0f7w6l/JPpB2lAvuam8G0JiTih5M+rlSo6vsD3LpabQt4/gGdRIQejImdTqU
	 TtnSgtllPNIL4R2DBfNM74Nc+hE2Rvr2tXVG/BK0=
Date: Sat, 28 Feb 2026 11:54:03 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagewalk-drop-fw_migration.patch added to mm-new branch
Message-Id: <20260228195403.ABCDDC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/pagewalk: drop FW_MIGRATION
has been added to the -mm mm-new branch.  Its filename is
     mm-pagewalk-drop-fw_migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagewalk-drop-fw_migration.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/pagewalk: drop FW_MIGRATION
Date: Fri, 27 Feb 2026 22:29:52 +0100

We removed the last user of FW_MIGRATION in commit 912aa825957f ("Revert
"mm/ksm: convert break_ksm() from walk_page_range_vma() to folio_walk"").

So let's remove FW_MIGRATION and assign FW_ZEROPAGE bit 0.  Including
leafops.h is no longer required.

While at it, convert "expose_page" to "zeropage", as zeropages are now the
only remaining use case for not exposing a page.

Link: https://lkml.kernel.org/r/20260227212952.190691-1-david@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagewalk.h |    8 -------
 mm/pagewalk.c            |   40 +++++++------------------------------
 2 files changed, 9 insertions(+), 39 deletions(-)

--- a/include/linux/pagewalk.h~mm-pagewalk-drop-fw_migration
+++ a/include/linux/pagewalk.h
@@ -148,14 +148,8 @@ int walk_page_mapping(struct address_spa
 
 typedef int __bitwise folio_walk_flags_t;
 
-/*
- * Walk migration entries as well. Careful: a large folio might get split
- * concurrently.
- */
-#define FW_MIGRATION			((__force folio_walk_flags_t)BIT(0))
-
 /* Walk shared zeropages (small + huge) as well. */
-#define FW_ZEROPAGE			((__force folio_walk_flags_t)BIT(1))
+#define FW_ZEROPAGE			((__force folio_walk_flags_t)BIT(0))
 
 enum folio_walk_level {
 	FW_LEVEL_PTE,
--- a/mm/pagewalk.c~mm-pagewalk-drop-fw_migration
+++ a/mm/pagewalk.c
@@ -5,7 +5,6 @@
 #include <linux/hugetlb.h>
 #include <linux/mmu_context.h>
 #include <linux/swap.h>
-#include <linux/leafops.h>
 
 #include <asm/tlbflush.h>
 
@@ -841,9 +840,6 @@ int walk_page_mapping(struct address_spa
  * VM as documented by vm_normal_page(). If requested, zeropages will be
  * returned as well.
  *
- * As default, this function only considers present page table entries.
- * If requested, it will also consider migration entries.
- *
  * If this function returns NULL it might either indicate "there is nothing" or
  * "there is nothing suitable".
  *
@@ -854,11 +850,10 @@ int walk_page_mapping(struct address_spa
  * that call.
  *
  * @fw->page will correspond to the page that is effectively referenced by
- * @addr. However, for migration entries and shared zeropages @fw->page is
- * set to NULL. Note that large folios might be mapped by multiple page table
- * entries, and this function will always only lookup a single entry as
- * specified by @addr, which might or might not cover more than a single page of
- * the returned folio.
+ * @addr. However, for shared zeropages @fw->page is set to NULL. Note that
+ * large folios might be mapped by multiple page table entries, and this
+ * function will always only lookup a single entry as specified by @addr, which
+ * might or might not cover more than a single page of the returned folio.
  *
  * This function must *not* be used as a naive replacement for
  * get_user_pages() / pin_user_pages(), especially not to perform DMA or
@@ -885,7 +880,7 @@ struct folio *folio_walk_start(struct fo
 		folio_walk_flags_t flags)
 {
 	unsigned long entry_size;
-	bool expose_page = true;
+	bool zeropage = false;
 	struct page *page;
 	pud_t *pudp, pud;
 	pmd_t *pmdp, pmd;
@@ -933,10 +928,6 @@ struct folio *folio_walk_start(struct fo
 			if (page)
 				goto found;
 		}
-		/*
-		 * TODO: FW_MIGRATION support for PUD migration entries
-		 * once there are relevant users.
-		 */
 		spin_unlock(ptl);
 		goto not_found;
 	}
@@ -970,16 +961,9 @@ pmd_table:
 			} else if ((flags & FW_ZEROPAGE) &&
 				    is_huge_zero_pmd(pmd)) {
 				page = pfn_to_page(pmd_pfn(pmd));
-				expose_page = false;
+				zeropage = true;
 				goto found;
 			}
-		} else if ((flags & FW_MIGRATION) &&
-			   pmd_is_migration_entry(pmd)) {
-			const softleaf_t entry = softleaf_from_pmd(pmd);
-
-			page = softleaf_to_page(entry);
-			expose_page = false;
-			goto found;
 		}
 		spin_unlock(ptl);
 		goto not_found;
@@ -1004,15 +988,7 @@ pte_table:
 		if ((flags & FW_ZEROPAGE) &&
 		    is_zero_pfn(pte_pfn(pte))) {
 			page = pfn_to_page(pte_pfn(pte));
-			expose_page = false;
-			goto found;
-		}
-	} else if (!pte_none(pte)) {
-		const softleaf_t entry = softleaf_from_pte(pte);
-
-		if ((flags & FW_MIGRATION) && softleaf_is_migration(entry)) {
-			page = softleaf_to_page(entry);
-			expose_page = false;
+			zeropage = true;
 			goto found;
 		}
 	}
@@ -1021,7 +997,7 @@ not_found:
 	vma_pgtable_walk_end(vma);
 	return NULL;
 found:
-	if (expose_page)
+	if (!zeropage)
 		/* Note: Offset from the mapped page, not the folio start. */
 		fw->page = page + ((addr & (entry_size - 1)) >> PAGE_SHIFT);
 	else
_

Patches currently in -mm which might be from david@kernel.org are

mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap.patch
mm-pagewalk-drop-fw_migration.patch


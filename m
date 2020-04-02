From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-gup-track-foll_pin-pages-fix-2-fix.patch removed from -mm tree
Date: Wed, 01 Apr 2020 20:25:27 -0700
Message-ID: <20200402032527.3D7Lkubof%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732664AbgDBDZ2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 1 Apr 2020 23:25:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, imbrenda@linux.ibm.com, jhubbard@nvidia.com, mm-commits@vger.kernel.org, sfr@canb.auug.org.au


The patch titled
     Subject: mm-gup-track-foll_pin-pages-fix-2-fix
has been removed from the -mm tree.  Its filename was
     mm-gup-track-foll_pin-pages-fix-2-fix.patch

This patch was dropped because it was folded into mm-gup-track-foll_pin-pages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-gup-track-foll_pin-pages-fix-2-fix

fix put_compound_head defined but not used

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

--- a/mm/gup.c~mm-gup-track-foll_pin-pages-fix-2-fix
+++ a/mm/gup.c
@@ -78,21 +78,6 @@ static __maybe_unused struct page *try_g
 	return NULL;
 }
 
-static void put_compound_head(struct page *page, int refs, unsigned int flags)
-{
-	if (flags & FOLL_PIN)
-		refs *= GUP_PIN_COUNTING_BIAS;
-
-	VM_BUG_ON_PAGE(page_ref_count(page) < refs, page);
-	/*
-	 * Calling put_page() for each ref is unnecessarily slow. Only the last
-	 * ref needs a put_page().
-	 */
-	if (refs > 1)
-		page_ref_sub(page, refs - 1);
-	put_page(page);
-}
-
 /**
  * try_grab_page() - elevate a page's refcount by a flag-dependent amount
  *
@@ -1967,7 +1952,24 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
  * This code is based heavily on the PowerPC implementation by Nick Piggin.
  */
 #ifdef CONFIG_HAVE_FAST_GUP
+
+static void put_compound_head(struct page *page, int refs, unsigned int flags)
+{
+	if (flags & FOLL_PIN)
+		refs *= GUP_PIN_COUNTING_BIAS;
+
+	VM_BUG_ON_PAGE(page_ref_count(page) < refs, page);
+	/*
+	 * Calling put_page() for each ref is unnecessarily slow. Only the last
+	 * ref needs a put_page().
+	 */
+	if (refs > 1)
+		page_ref_sub(page, refs - 1);
+	put_page(page);
+}
+
 #ifdef CONFIG_GUP_GET_PTE_LOW_HIGH
+
 /*
  * WARNING: only to be used in the get_user_pages_fast() implementation.
  *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-gup-track-foll_pin-pages.patch
mm-swap-make-page_evictable-inline-fix.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-mmap-add-trace-point-of-vm_unmapped_area-fix.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch

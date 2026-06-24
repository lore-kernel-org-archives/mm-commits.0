Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBF936EA8D
	for <mm-commits@vger.kernel.org>; Wed, 24 Jun 2026 20:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782333598; cv=none; b=FQKIJmSycBB0BosuBZB0Qn4wvT8V964NQcPPh8G797Dllc++i6krn7ClVWeNjitQTNd7ASuY9ddjP15VB0qfVnobSeAyDu5v+0CAMFWabUarpfS7jVC/IMdu+mkN0bZqopAT4P4WBSfCbfoStb5qSY7hHZXHz5cc1fzu1cBsaYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782333598; c=relaxed/simple;
	bh=5DrMgnzsb1/4y2dOkgqXC9u4O1iqnsqI7SQZiWQk7ag=;
	h=Date:To:From:Subject:Message-Id; b=W2w0Dnu9B8TB8SPQaZqmSujXgVNOlhuX82wNlJaGMf6GQL+uOqbYbjz5JsS2Tl2HWiZkK7Qngi82lYoyHNYwZFgnIwHmuLfF7yOUI3GM3mXgeHEu2gWSa54IY84oAQGxqR4Wr3Rao7UhcZMLCTCltIuqmUC+YHztbPaKGZ0XYsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LBtqifRZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LBtqifRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328291F000E9;
	Wed, 24 Jun 2026 20:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782333591;
	bh=wZY1JigYN1YWzgoaJP8aYZEIFb2SMOIB/EfEsAhILY4=;
	h=Date:To:From:Subject;
	b=LBtqifRZzPVpIq4svt79O65No15dP55g9Z0ECLaPXmhZMxfKus+rHzMK+CcbNCvHl
	 C/T6TaDuf5DogMHp05Jl1RML/dfT724s38MbteG1+oUNCypIBrtmwakAL0x6nOIGk2
	 B6A5TiVBHy3Ia+h+NapKsIzcr/ze5IyzQ3HCRHjs=
Date: Wed, 24 Jun 2026 13:39:50 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,shikemeng@huaweicloud.com,ryan.roberts@arm.com,pfalcato@suse.de,nphamcs@gmail.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,jannh@google.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-rename-subpage-page-in-folio_dup_swap-folio_put_swap.patch added to mm-new branch
Message-Id: <20260624203951.328291F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: rename subpage->page in folio_dup_swap/folio_put_swap
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-rename-subpage-page-in-folio_dup_swap-folio_put_swap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-rename-subpage-page-in-folio_dup_swap-folio_put_swap.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Dev Jain <dev.jain@arm.com>
Subject: mm/swap: rename subpage->page in folio_dup_swap/folio_put_swap
Date: Tue, 23 Jun 2026 12:57:21 +0000

Patch series "mm: drop "sub" prefix from various places".

Patch 1 converts subpage->page : folios have pages, not subpages.

Patch 2 drops "sub" from a function and a variable because the context
is clear enough.


This patch (of 2):

Folios have pages, not subpages. Rename 'subpage' parameters to 'page'.

Link: https://lore.kernel.org/20260623125723.2503832-1-dev.jain@arm.com
Link: https://lore.kernel.org/20260623125723.2503832-2-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h     |    4 ++--
 mm/swapfile.c |   16 ++++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/mm/swapfile.c~mm-swap-rename-subpage-page-in-folio_dup_swap-folio_put_swap
+++ a/mm/swapfile.c
@@ -1781,7 +1781,7 @@ again:
 /**
  * folio_dup_swap() - Increase swap count of swap entries of a folio.
  * @folio: folio with swap entries bounded.
- * @subpage: if not NULL, only increase the swap count of this subpage.
+ * @page: if not NULL, only increase the swap count of this page.
  *
  * Typically called when the folio is unmapped and have its swap entry to
  * take its place: Swap entries allocated to a folio has count == 0 and pinned
@@ -1795,7 +1795,7 @@ again:
  * swap_put_entries_direct on its swap entry before this helper returns, or
  * the swap count may underflow.
  */
-int folio_dup_swap(struct folio *folio, struct page *subpage)
+int folio_dup_swap(struct folio *folio, struct page *page)
 {
 	swp_entry_t entry = folio->swap;
 	unsigned long nr_pages = folio_nr_pages(folio);
@@ -1803,8 +1803,8 @@ int folio_dup_swap(struct folio *folio,
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
-	if (subpage) {
-		entry.val += folio_page_idx(folio, subpage);
+	if (page) {
+		entry.val += folio_page_idx(folio, page);
 		nr_pages = 1;
 	}
 
@@ -1815,13 +1815,13 @@ int folio_dup_swap(struct folio *folio,
 /**
  * folio_put_swap() - Decrease swap count of swap entries of a folio.
  * @folio: folio with swap entries bounded, must be in swap cache and locked.
- * @subpage: if not NULL, only decrease the swap count of this subpage.
+ * @page: if not NULL, only decrease the swap count of this page.
  *
  * This won't free the swap slots even if swap count drops to zero, they are
  * still pinned by the swap cache. User may call folio_free_swap to free them.
  * Context: Caller must ensure the folio is locked and in the swap cache.
  */
-void folio_put_swap(struct folio *folio, struct page *subpage)
+void folio_put_swap(struct folio *folio, struct page *page)
 {
 	swp_entry_t entry = folio->swap;
 	unsigned long nr_pages = folio_nr_pages(folio);
@@ -1830,8 +1830,8 @@ void folio_put_swap(struct folio *folio,
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
-	if (subpage) {
-		entry.val += folio_page_idx(folio, subpage);
+	if (page) {
+		entry.val += folio_page_idx(folio, page);
 		nr_pages = 1;
 	}
 
--- a/mm/swap.h~mm-swap-rename-subpage-page-in-folio_dup_swap-folio_put_swap
+++ a/mm/swap.h
@@ -230,8 +230,8 @@ extern int swap_retry_table_alloc(swp_en
  * folio_put_swap(): does the opposite thing of folio_dup_swap().
  */
 int folio_alloc_swap(struct folio *folio);
-int folio_dup_swap(struct folio *folio, struct page *subpage);
-void folio_put_swap(struct folio *folio, struct page *subpage);
+int folio_dup_swap(struct folio *folio, struct page *page);
+void folio_put_swap(struct folio *folio, struct page *page);
 
 /* For internal use */
 extern void __swap_cluster_free_entries(struct swap_info_struct *si,
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-swap-rename-subpage-page-in-folio_dup_swap-folio_put_swap.patch
mm-mprotect-drop-sub-from-batching-context.patch


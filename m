Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4F01E86C
	for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2024 20:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712868461; cv=none; b=CfKQlZscGsvaCvxnDpuz4CEKM9mlzpc+QeUtVId5+SrJdqOct7qKZbi0ytl+aWO7/t1+JMJPtE3MozlARZwrfYgfUirFNnXmQvYO0du3EWbikXH3EkAcMesbYPt6KxJ3MwpMYK0BWkWSC17XtgwOxq5uVzmXvax7Pd7Sn5B2G6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712868461; c=relaxed/simple;
	bh=LZ2oe5eXzeUvt9fpNyNdu3cRjYvT0fRdPvncDF8dy2I=;
	h=Date:To:From:Subject:Message-Id; b=j7cugqQXgGcM4kyTf86DyurIwOUb5tlFHmqDpy2l7jQ9OYIKo4A7le/4Oc9A9YNY1JAHL4xs6r74x9pMBbvXiKak2bI+dsvNIbL2VSPyOI62wf3w6nhwVFcs1R3i8ZLwfd3G/Ryw4Ubri020qUI+Yu76nulU0yDx1nT4K81gjro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RXQTZ7uJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RXQTZ7uJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA3DC072AA;
	Thu, 11 Apr 2024 20:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712868461;
	bh=LZ2oe5eXzeUvt9fpNyNdu3cRjYvT0fRdPvncDF8dy2I=;
	h=Date:To:From:Subject:From;
	b=RXQTZ7uJbGskkq8rNLJ0j3TZtVO0eK5fFW4l0KduHup33kizDLRc7pMu3qNWbdVIv
	 KI2mIY4575o8INO6pfUdsb7CUKgukPFYVLLjWH4BKHlsiw96RXDMDpcbVMKBcntAdF
	 2S1Qjf1zq9JcyYQUV+5ky0V0Z0DYZ/iBng/Sp5oY=
Date: Thu, 11 Apr 2024 13:47:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,izik.eidus@ravellosystems.com,hughd@google.com,chrisw@sous-sol.org,alexs@kernel.org,aarcange@redhat.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-rename-get_ksm_page_flags-to-ksm_get_folio_flags.patch added to mm-unstable branch
Message-Id: <20240411204741.4AA3DC072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: rename get_ksm_page_flags to ksm_get_folio_flags
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-rename-get_ksm_page_flags-to-ksm_get_folio_flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-rename-get_ksm_page_flags-to-ksm_get_folio_flags.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/ksm: rename get_ksm_page_flags to ksm_get_folio_flags
Date: Thu, 11 Apr 2024 14:17:10 +0800

As we are removing get_ksm_page_flags(), make the flags match the new
function name.

Link: https://lkml.kernel.org/r/20240411061713.1847574-10-alexs@kernel.org
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Alex Shi <alexs@kernel.org>
Reviewed-by: Alex Shi <alexs@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/mm/ksm.c~mm-ksm-rename-get_ksm_page_flags-to-ksm_get_folio_flags
+++ a/mm/ksm.c
@@ -890,10 +890,10 @@ static void remove_node_from_stable_tree
 	free_stable_node(stable_node);
 }
 
-enum get_ksm_page_flags {
-	GET_KSM_PAGE_NOLOCK,
-	GET_KSM_PAGE_LOCK,
-	GET_KSM_PAGE_TRYLOCK
+enum ksm_get_folio_flags {
+	KSM_GET_FOLIO_NOLOCK,
+	KSM_GET_FOLIO_LOCK,
+	KSM_GET_FOLIO_TRYLOCK
 };
 
 /*
@@ -916,7 +916,7 @@ enum get_ksm_page_flags {
  * is on its way to being freed; but it is an anomaly to bear in mind.
  */
 static struct folio *ksm_get_folio(struct ksm_stable_node *stable_node,
-				 enum get_ksm_page_flags flags)
+				 enum ksm_get_folio_flags flags)
 {
 	struct folio *folio;
 	void *expected_mapping;
@@ -959,15 +959,15 @@ again:
 		goto stale;
 	}
 
-	if (flags == GET_KSM_PAGE_TRYLOCK) {
+	if (flags == KSM_GET_FOLIO_TRYLOCK) {
 		if (!folio_trylock(folio)) {
 			folio_put(folio);
 			return ERR_PTR(-EBUSY);
 		}
-	} else if (flags == GET_KSM_PAGE_LOCK)
+	} else if (flags == KSM_GET_FOLIO_LOCK)
 		folio_lock(folio);
 
-	if (flags != GET_KSM_PAGE_NOLOCK) {
+	if (flags != KSM_GET_FOLIO_NOLOCK) {
 		if (READ_ONCE(folio->mapping) != expected_mapping) {
 			folio_unlock(folio);
 			folio_put(folio);
@@ -1001,7 +1001,7 @@ static void remove_rmap_item_from_tree(s
 		struct folio *folio;
 
 		stable_node = rmap_item->head;
-		folio = ksm_get_folio(stable_node, GET_KSM_PAGE_LOCK);
+		folio = ksm_get_folio(stable_node, KSM_GET_FOLIO_LOCK);
 		if (!folio)
 			goto out;
 
@@ -1116,7 +1116,7 @@ static int remove_stable_node(struct ksm
 	struct folio *folio;
 	int err;
 
-	folio = ksm_get_folio(stable_node, GET_KSM_PAGE_LOCK);
+	folio = ksm_get_folio(stable_node, KSM_GET_FOLIO_LOCK);
 	if (!folio) {
 		/*
 		 * ksm_get_folio did remove_node_from_stable_tree itself.
@@ -1656,7 +1656,7 @@ static struct folio *stable_node_dup(str
 		 * stable_node parameter itself will be freed from
 		 * under us if it returns NULL.
 		 */
-		folio = ksm_get_folio(dup, GET_KSM_PAGE_NOLOCK);
+		folio = ksm_get_folio(dup, KSM_GET_FOLIO_NOLOCK);
 		if (!folio)
 			continue;
 		nr += 1;
@@ -1779,7 +1779,7 @@ static struct folio *__stable_node_chain
 	if (!is_stable_node_chain(stable_node)) {
 		if (is_page_sharing_candidate(stable_node)) {
 			*_stable_node_dup = stable_node;
-			return ksm_get_folio(stable_node, GET_KSM_PAGE_NOLOCK);
+			return ksm_get_folio(stable_node, KSM_GET_FOLIO_NOLOCK);
 		}
 		/*
 		 * _stable_node_dup set to NULL means the stable_node
@@ -1887,7 +1887,7 @@ again:
 			 * fine to continue the walk.
 			 */
 			tree_folio = ksm_get_folio(stable_node_any,
-						   GET_KSM_PAGE_NOLOCK);
+						   KSM_GET_FOLIO_NOLOCK);
 		}
 		VM_BUG_ON(!stable_node_dup ^ !!stable_node_any);
 		if (!tree_folio) {
@@ -1948,7 +1948,7 @@ again:
 			 * than kpage, but that involves more changes.
 			 */
 			tree_folio = ksm_get_folio(stable_node_dup,
-						   GET_KSM_PAGE_TRYLOCK);
+						   KSM_GET_FOLIO_TRYLOCK);
 
 			if (PTR_ERR(tree_folio) == -EBUSY)
 				return ERR_PTR(-EBUSY);
@@ -2120,7 +2120,7 @@ again:
 			 * fine to continue the walk.
 			 */
 			tree_folio = ksm_get_folio(stable_node_any,
-						   GET_KSM_PAGE_NOLOCK);
+						   KSM_GET_FOLIO_NOLOCK);
 		}
 		VM_BUG_ON(!stable_node_dup ^ !!stable_node_any);
 		if (!tree_folio) {
@@ -2611,7 +2611,7 @@ static struct ksm_rmap_item *scan_get_ne
 			list_for_each_entry_safe(stable_node, next,
 						 &migrate_nodes, list) {
 				folio = ksm_get_folio(stable_node,
-						      GET_KSM_PAGE_NOLOCK);
+						      KSM_GET_FOLIO_NOLOCK);
 				if (folio)
 					folio_put(folio);
 				cond_resched();
_

Patches currently in -mm which might be from david@redhat.com are

mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly.patch
mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch
mm-userfaultfd-dont-place-zeropages-when-zeropages-are-disallowed.patch
s390-mm-re-enable-the-shared-zeropage-for-pv-and-skeys-kvm-guests.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix.patch
selftests-memfd_secret-add-vmsplice-test.patch
mm-merge-folio_is_secretmem-and-folio_fast_pin_allowed-into-gup_fast_folio_allowed.patch
mm-optimize-config_per_vma_lock-member-placement-in-vm_area_struct.patch
mm-remove-prot-parameter-from-move_pte.patch
mm-gup-consistently-name-gup-fast-functions.patch
mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast.patch
mm-use-gup-fast-instead-fast-gup-in-remaining-comments.patch
drivers-virt-acrn-fix-pfnmap-pte-checks-in-acrn_vm_ram_map.patch
mm-pass-vma-instead-of-mm-to-follow_pte.patch
mm-follow_pte-improvements.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again.patch
mm-rmap-always-inline-anon-file-rmap-duplication-of-a-single-pte.patch
mm-rmap-add-fast-path-for-small-folios-when-adding-removing-duplicating.patch
mm-track-mapcount-of-large-folios-in-single-value.patch
mm-improve-folio_likely_mapped_shared-using-the-mapcount-of-large-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios.patch
mm-memory-use-folio_mapcount-in-zap_present_folio_ptes.patch
mm-huge_memory-use-folio_mapcount-in-zap_huge_pmd-sanity-check.patch
mm-memory-failure-use-folio_mapcount-in-hwpoison_user_mappings.patch
mm-page_alloc-use-folio_mapped-in-__alloc_contig_migrate_range.patch
mm-migrate-use-folio_likely_mapped_shared-in-add_page_for_migration.patch
sh-mm-cache-use-folio_mapped-in-copy_from_user_page.patch
mm-filemap-use-folio_mapcount-in-filemap_unaccount_folio.patch
mm-migrate_device-use-folio_mapcount-in-migrate_vma_check_page.patch
trace-events-page_ref-trace-the-raw-page-mapcount-value.patch
xtensa-mm-convert-check_tlb_entry-to-sanity-check-folios.patch
mm-debug-print-only-page-mapcount-excluding-folio-entire-mapcount-in-__dump_folio.patch
documentation-admin-guide-cgroup-v1-memoryrst-dont-reference-page_mapcount.patch
mm-ksm-rename-get_ksm_page_flags-to-ksm_get_folio_flags.patch


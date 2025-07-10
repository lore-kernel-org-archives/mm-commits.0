Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460FA469D
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 04:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752122172; cv=none; b=dwZttXOiN+xA7JqGBV+3AH7KBfeZgrOvQavHVQ1q9TpYyMKBpzlmT/+cUNRgGQPR4kgu0HaV6v0novcaN2+w/rbYmnePGbMVFTTn7AzFtf8+fUXZKrzZkWMDpemQWP3D2YtCBAiMrvpY15rIzhMUqKMJBXSsv/21wRHrEib49z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752122172; c=relaxed/simple;
	bh=e73q7XtVk9yaM3n44rtc2k1wma0o8q3baK+sTBugC5I=;
	h=Date:To:From:Subject:Message-Id; b=LVQC1RAvcXQYhboehlukpWS934Rt4Zq0kO4L2+k8EIna6/fv5e6e8WoBXepK+NWLOgqTFwLEcUNZ9k2FvoifKj8w5fgY7jobG4jeIp50NsQY1Ow67BfGs7Y1fjGTzVrXpmF3ZrB7q95t4wTl+Lvf1bmHv6LRKxDG7xMI3ewwDx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UnxgR48S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UnxgR48S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE664C4CEE3;
	Thu, 10 Jul 2025 04:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752122171;
	bh=e73q7XtVk9yaM3n44rtc2k1wma0o8q3baK+sTBugC5I=;
	h=Date:To:From:Subject:From;
	b=UnxgR48SvhnhhcpdxEuivoYlSZwcn+BQe/NGOc50xO+/aGObT+/a03WZHgyHXdys9
	 Czo9opKDekCe1qmy34DO1G8fT0VfEKD3KUBc4pjqpeywSbSSXW5XL0Tc4vY3lHJhNA
	 Pq86IgBNsSIJbP1Lo90CiVH/V3BJQKh7oQv1Tvu0=
Date: Wed, 09 Jul 2025 21:36:11 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jhubbard@nvidia.com,jgg@ziepe.ca,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-gup-remove-vm_bug_ons-fix.patch removed from -mm tree
Message-Id: <20250710043611.BE664C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-gup-remove-vm_bug_ons-fix
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-vm_bug_ons-fix.patch

This patch was dropped because it was folded into mm-gup-remove-vm_bug_ons.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm-gup-remove-vm_bug_ons-fix
Date: Fri, 6 Jun 2025 10:08:20 +0200

use the _FOLIO variant where possible, per Lorenzo


Link: https://lkml.kernel.org/r/844bd929-a551-48e3-a12e-285cd65ba580@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-remove-vm_bug_ons-fix
+++ a/mm/gup.c
@@ -64,7 +64,7 @@ static inline void sanity_check_pinned_p
 		    !folio_test_anon(folio))
 			continue;
 		if (!folio_test_large(folio) || folio_test_hugetlb(folio))
-			VM_WARN_ON_ONCE_PAGE(!PageAnonExclusive(&folio->page), page);
+			VM_WARN_ON_ONCE_FOLIO(!PageAnonExclusive(&folio->page), folio);
 		else
 			/* Either a PTE-mapped or a PMD-mapped THP. */
 			VM_WARN_ON_ONCE_PAGE(!PageAnonExclusive(&folio->page) &&
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-remove-vm_bug_ons.patch
mm-huge_memory-dont-ignore-queried-cachemode-in-vmf_insert_pfn_pud.patch
mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pmd.patch
mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pud.patch
mm-balloon_compaction-we-cannot-have-isolated-pages-in-the-balloon-list.patch
mm-balloon_compaction-convert-balloon_page_delete-to-balloon_page_finalize.patch
mm-zsmalloc-drop-pageisolated-related-vm_bug_ons.patch
mm-page_alloc-let-page-freeing-clear-any-set-page-type.patch
mm-balloon_compaction-make-pageoffline-sticky-until-the-page-is-freed.patch
mm-zsmalloc-make-pagezsmalloc-sticky-until-the-page-is-freed.patch
mm-migrate-rename-isolate_movable_page-to-isolate_movable_ops_page.patch
mm-migrate-rename-putback_movable_folio-to-putback_movable_ops_page.patch
mm-migrate-factor-out-movable_ops-page-handling-into-migrate_movable_ops_page.patch
mm-migrate-remove-folio_test_movable-and-folio_movable_ops.patch
mm-migrate-move-movable_ops-page-handling-out-of-move_to_new_folio.patch
mm-zsmalloc-stop-using-__clearpagemovable.patch
mm-balloon_compaction-stop-using-__clearpagemovable.patch
mm-migrate-remove-__clearpagemovable.patch
mm-migration-remove-pagemovable.patch
mm-rename-__pagemovable-to-page_has_movable_ops.patch
mm-page_isolation-drop-__folio_test_movable-check-for-large-folios.patch
mm-remove-__folio_test_movable.patch
mm-stop-storing-migration_ops-in-page-mapping.patch
mm-convert-movable-flag-in-page-mapping-to-a-page-flag.patch
mm-rename-pg_isolated-to-pg_movable_ops_isolated.patch
mm-page-flags-rename-page_mapping_movable-to-page_mapping_anon_ksm.patch
mm-page-alloc-remove-pagemappingflags.patch
mm-page-flags-remove-folio_mapping_flags.patch
mm-simplify-folio_expected_ref_count.patch
mm-rename-page_mapping_-to-folio_mapping_.patch
docs-mm-convert-from-non-lru-page-migration-to-movable_ops-page-migration.patch
mm-balloon_compaction-movable_ops-doc-updates.patch
mm-balloon_compaction-provide-single-balloon_page_insert-and-balloon_mapping_gfp_mask.patch
mm-convert-fpb_ignore_-into-fpb_respect_.patch
mm-smaller-folio_pte_batch-improvements.patch
mm-split-folio_pte_batch-into-folio_pte_batch-and-folio_pte_batch_flags.patch
mm-remove-boolean-output-parameters-from-folio_pte_batch_ext.patch
mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd.patch


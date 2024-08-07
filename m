Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424E61448C7
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 19:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723060061; cv=none; b=dTwdxRnu6JysskWFuTyNLsF+QjoDWE9Id/+D1B7EKwnAWoEabvNym9os8OE8YkU9Gz7gxwgG/UNaDyJgpi5QlyPjsVcDPUh96UFZBSGl6EyXB5v1sxbDEu9jhWfomGqtfHa2Q/qIkNAeWU5WzrSHrvyFE7b1MLNlMC3gvPtxNDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723060061; c=relaxed/simple;
	bh=m0zNDHWyoPfecLZeewoHI3SknwEAFBRMJjDSiDQwXhY=;
	h=Date:To:From:Subject:Message-Id; b=WhBRMZDloBz2JEf1nyYTvYB3+4m9dTi9SVU1CQLmRIrQB9wJjqWS12dIKC/EkmaEl19gnPhfd+vTpMo1L7trCBPbYfXnEw9jwig25Vk4Xg5uR+H9N+r7jMILbwGORG+k9YnsxG5inm1B3A6nDXdlztgtk7+vtXW13XgKXPAWpp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dpuK46Id; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dpuK46Id"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD663C32781;
	Wed,  7 Aug 2024 19:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723060060;
	bh=m0zNDHWyoPfecLZeewoHI3SknwEAFBRMJjDSiDQwXhY=;
	h=Date:To:From:Subject:From;
	b=dpuK46IdHDGfFn02dIwOQDrtyy4bQc7saDby4EnINI/rscljI6Ng2YLlHUkiD1IUS
	 TfHzmzap/21TN1n7ThBzkUjLAkX4JxZHRwgqNx88PBYUtHeqrWS3ohO/vci4sEleYj
	 DVQgI1Pu5kRslnlHKLIdL7GRsOzkWjPWB1rxf2ig=
Date: Wed, 07 Aug 2024 12:47:40 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-minimize-folio-_nr_pages_mapped-updates-when-batching-pte-unmapping.patch added to mm-unstable branch
Message-Id: <20240807194740.AD663C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: minimize folio->_nr_pages_mapped updates when batching PTE (un)mapping
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-minimize-folio-_nr_pages_mapped-updates-when-batching-pte-unmapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-minimize-folio-_nr_pages_mapped-updates-when-batching-pte-unmapping.patch

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
Subject: mm/rmap: minimize folio->_nr_pages_mapped updates when batching PTE (un)mapping
Date: Wed, 7 Aug 2024 13:55:15 +0200

It is not immediately obvious, but we can move the folio->_nr_pages_mapped
update out of the loop and reduce the number of atomic ops without
affecting the stats.

The important point to realize is that only removing the last PMD mapping
will result in _nr_pages_mapped going below ENTIRELY_MAPPED, not the
individual atomic_inc_return_relaxed() calls.  Concurrent races with
removal of PMD mappings should be handled as expected, just like when we
would have such races right now on a single mapcount update.

In a simple munmap() microbenchmark [1] on 1 GiB of memory backed by the
same PTE-mapped folio size (only mapped by a single process such that they
will get completely unmapped), this change results in a speedup (positive
is good) per folio size on a x86-64 Intel machine of roughly (a bit of
noise expected):

* 16 KiB: +10%
* 32 KiB: +15%
* 64 KiB: +17%
* 128 KiB: +21%
* 256 KiB: +22%
* 512 KiB: +22%
* 1024 KiB: +23%
* 2048 KiB: +27%

[1] https://gitlab.com/davidhildenbrand/scratchspace/-/blob/main/pte-mapped-folio-benchmarks.c

Link: https://lkml.kernel.org/r/20240807115515.1640951-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/mm/rmap.c~mm-rmap-minimize-folio-_nr_pages_mapped-updates-when-batching-pte-unmapping
+++ a/mm/rmap.c
@@ -1158,7 +1158,7 @@ static __always_inline unsigned int __fo
 {
 	atomic_t *mapped = &folio->_nr_pages_mapped;
 	const int orig_nr_pages = nr_pages;
-	int first, nr = 0;
+	int first = 0, nr = 0;
 
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
@@ -1170,13 +1170,13 @@ static __always_inline unsigned int __fo
 		}
 
 		do {
-			first = atomic_inc_and_test(&page->_mapcount);
-			if (first) {
-				first = atomic_inc_return_relaxed(mapped);
-				if (first < ENTIRELY_MAPPED)
-					nr++;
-			}
+			first += atomic_inc_and_test(&page->_mapcount);
 		} while (page++, --nr_pages > 0);
+
+		if (first &&
+		    atomic_add_return_relaxed(first, mapped) < ENTIRELY_MAPPED)
+			nr = first;
+
 		atomic_add(orig_nr_pages, &folio->_large_mapcount);
 		break;
 	case RMAP_LEVEL_PMD:
@@ -1527,7 +1527,7 @@ static __always_inline void __folio_remo
 		enum rmap_level level)
 {
 	atomic_t *mapped = &folio->_nr_pages_mapped;
-	int last, nr = 0, nr_pmdmapped = 0;
+	int last = 0, nr = 0, nr_pmdmapped = 0;
 	bool partially_mapped = false;
 
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
@@ -1541,14 +1541,13 @@ static __always_inline void __folio_remo
 
 		atomic_sub(nr_pages, &folio->_large_mapcount);
 		do {
-			last = atomic_add_negative(-1, &page->_mapcount);
-			if (last) {
-				last = atomic_dec_return_relaxed(mapped);
-				if (last < ENTIRELY_MAPPED)
-					nr++;
-			}
+			last += atomic_add_negative(-1, &page->_mapcount);
 		} while (page++, --nr_pages > 0);
 
+		if (last &&
+		    atomic_sub_return_relaxed(last, mapped) < ENTIRELY_MAPPED)
+			nr = last;
+
 		partially_mapped = nr && atomic_read(mapped);
 		break;
 	case RMAP_LEVEL_PMD:
_

Patches currently in -mm which might be from david@redhat.com are

mm-turn-use_split_pte_ptlocks-use_split_pte_ptlocks-into-kconfig-options.patch
mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks.patch
powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch
mm-simplify-arch_make_folio_accessible.patch
mm-gup-convert-to-arch_make_folio_accessible.patch
s390-uv-drop-arch_make_page_accessible.patch
mm-hugetlb-remove-hugetlb_follow_page_mask-leftover.patch
mm-rmap-cleanup-partially-mapped-handling-in-__folio_remove_rmap.patch
mm-clarify-folio_likely_mapped_shared-documentation-for-ksm-folios.patch
mm-provide-vm_normal_pagefolio_pmd-with-config_pgtable_has_huge_leaves.patch
mm-pagewalk-introduce-folio_walk_start-folio_walk_end.patch
mm-migrate-convert-do_pages_stat_array-from-follow_page-to-folio_walk.patch
mm-migrate-convert-add_page_for_migration-from-follow_page-to-folio_walk.patch
mm-ksm-convert-get_mergeable_page-from-follow_page-to-folio_walk.patch
mm-ksm-convert-scan_get_next_rmap_item-from-follow_page-to-folio_walk.patch
mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk.patch
mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk-fix.patch
s390-uv-convert-gmap_destroy_page-from-follow_page-to-folio_walk.patch
s390-mm-fault-convert-do_secure_storage_access-from-follow_page-to-folio_walk.patch
mm-remove-follow_page.patch
mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch
mm-rmap-minimize-folio-_nr_pages_mapped-updates-when-batching-pte-unmapping.patch


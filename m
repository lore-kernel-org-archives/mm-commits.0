Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566094315D
	for <mm-commits@vger.kernel.org>; Fri, 16 Aug 2024 21:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723844015; cv=none; b=ShefpkDPc9dHBqR7QC7P2iccH9tZrZLQaqqy267xNKs9Wz2A22W3mY6R9/oaqGeAlChJYrTcbGs4AoPEl6sxoUHJRPX9omou8u93igID5Hp5SbUVmW0u8Zqy2t5RNcsNeeAaKyv8Sjo6sRT56+sipMM4BdjxEWGt+wRw8C0gnx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723844015; c=relaxed/simple;
	bh=NLl78eCwMBvi6wGVl0X79TBYFXFeE+H1DQTucn+wji4=;
	h=Date:To:From:Subject:Message-Id; b=Uv6iV1r0KgOtsb/GW7LQbkR9tBn/GAa04pb77JqScyWapMJSnkWf3p1kTg7GbTjZsTmwq+hVZskTCPNTi2ouBd6z4FfggwKa/TB7EFJnGrVlxGPsnaD3Me3a/JKmVjSdvplHMXcpjsHpnbUMNWKQzmf3DqnRz9uIEY/yWUWmNwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iIVv++f+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iIVv++f+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7800C32782;
	Fri, 16 Aug 2024 21:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723844014;
	bh=NLl78eCwMBvi6wGVl0X79TBYFXFeE+H1DQTucn+wji4=;
	h=Date:To:From:Subject:From;
	b=iIVv++f+VG93onp0n0ICzU8tVjNf+1T8Z388lRMyhizMOGVAOg6ckDq9CFUkvWrxt
	 C6zlrtlHN4cp2HXBph1zfxDvYWOuS/dz+RI3TAT9oLTK48F+AHzEHMzWzcboPI5MbO
	 h2FmHqeHAn5K0sZH5VF+vwhHx3kvF6keUyl+h5x0=
Date: Fri, 16 Aug 2024 14:33:34 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-use-folio-_mapcount-for-small-folios.patch added to mm-unstable branch
Message-Id: <20240816213334.B7800C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: use folio->_mapcount for small folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-use-folio-_mapcount-for-small-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-use-folio-_mapcount-for-small-folios.patch

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
Subject: mm/rmap: use folio->_mapcount for small folios
Date: Fri, 16 Aug 2024 12:32:46 +0200

We have some cases left whereby we operate on small folios and still refer
to page->_mapcount.  Let's just use folio->_mapcount instead, which
currently still overlays page->_mapcount, so no change.

This change will make it easier to later spot any remaining users of
page->_mapcount that target tail pages.

Link: https://lkml.kernel.org/r/20240816103246.719209-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    4 ++--
 mm/rmap.c            |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-use-folio-_mapcount-for-small-folios
+++ a/include/linux/rmap.h
@@ -331,7 +331,7 @@ static __always_inline void __folio_dup_
 	switch (level) {
 	case RMAP_LEVEL_PTE:
 		if (!folio_test_large(folio)) {
-			atomic_inc(&page->_mapcount);
+			atomic_inc(&folio->_mapcount);
 			break;
 		}
 
@@ -425,7 +425,7 @@ static __always_inline int __folio_try_d
 		if (!folio_test_large(folio)) {
 			if (PageAnonExclusive(page))
 				ClearPageAnonExclusive(page);
-			atomic_inc(&page->_mapcount);
+			atomic_inc(&folio->_mapcount);
 			break;
 		}
 
--- a/mm/rmap.c~mm-rmap-use-folio-_mapcount-for-small-folios
+++ a/mm/rmap.c
@@ -1165,7 +1165,7 @@ static __always_inline unsigned int __fo
 	switch (level) {
 	case RMAP_LEVEL_PTE:
 		if (!folio_test_large(folio)) {
-			nr = atomic_inc_and_test(&page->_mapcount);
+			nr = atomic_inc_and_test(&folio->_mapcount);
 			break;
 		}
 
@@ -1535,7 +1535,7 @@ static __always_inline void __folio_remo
 	switch (level) {
 	case RMAP_LEVEL_PTE:
 		if (!folio_test_large(folio)) {
-			nr = atomic_add_negative(-1, &page->_mapcount);
+			nr = atomic_add_negative(-1, &folio->_mapcount);
 			break;
 		}
 
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
mm-rmap-use-folio-_mapcount-for-small-folios.patch


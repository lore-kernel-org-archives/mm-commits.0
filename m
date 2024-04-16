Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA7113957E
	for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2024 19:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713296520; cv=none; b=BP253tllSC3mS113m1NAj4sQb9n/82Op6AjS+IxIWmGhl/XBUjqsQB/wkynkgGrZytk7pANJ9mixqdWkhT51pkmFZRwZmXJlaY0/kTWulq3Ss4+zlenMguSC2b6rKxXZLH+V4x2A2OXwZuXc0ecNw9+31WjFhtsk1bxl7K9JXr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713296520; c=relaxed/simple;
	bh=YBzqI3eiPyJ7rnirldOny1VA8011L5tnaZ2x5x6v5fY=;
	h=Date:To:From:Subject:Message-Id; b=J0BsOn6E1NPuUxo009xXAmz3fFUK36S5CYeITAmXhkJThtyp1oYewuSuZ6hRYGH9jDdo4R8LmuOq39OytJ4zrrwR6IXxHERpiWZzxy1kjXXLaAzHNoap7aSdaz9qRt8LTz2HIPL31LUO73AYUfxuLSZQdvXeT3dx/Q/rKBB1UZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kd8a9g9/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kd8a9g9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884F9C3277B;
	Tue, 16 Apr 2024 19:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713296519;
	bh=YBzqI3eiPyJ7rnirldOny1VA8011L5tnaZ2x5x6v5fY=;
	h=Date:To:From:Subject:From;
	b=Kd8a9g9/8rk9ya9kD1sKZKRt4yCQPH6w6z0kqp/Cqj+Z/fbeCYmB1BtthEuGiUxY4
	 8Se7uleMsv/TCauNhvLOJgoMVByTNJBWuIvnSr6SAP4rUVdZja1kAVjNEhmodfVG9e
	 dAWQGNdg2mYnmVE8No3cnm7wYZCgOxbnbfidbjxs=
Date: Tue, 16 Apr 2024 12:41:58 -0700
To: mm-commits@vger.kernel.org,alexs@kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-remove-page_mapcount-usage-in-stable_tree_search.patch added to mm-unstable branch
Message-Id: <20240416194159.884F9C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: remove page_mapcount() usage in stable_tree_search()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-remove-page_mapcount-usage-in-stable_tree_search.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-remove-page_mapcount-usage-in-stable_tree_search.patch

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
Subject: mm/ksm: remove page_mapcount() usage in stable_tree_search()
Date: Tue, 16 Apr 2024 19:25:33 +0200

We want to limit the use of page_mapcount() to the places where it is
absolutely necessary.

If our folio has a stable node, it is a (small) KSM folio -- see
folio_stable_node().  Let's use folio_mapcount() in stable_tree_search()
instead, which results in no functional change.

The mapcount > 1 check is a bit confusing, because that's usually a check
for page sharing.  Looks like the reason is that we are guaranteed to not
exceed ksm_max_page_sharing for the tree KSM folio when merging with that.
Let's update the documentation to make that clearer.

Link: https://lkml.kernel.org/r/20240416172533.663418-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alex Shi (tencent) <alexs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/ksm.c~mm-ksm-remove-page_mapcount-usage-in-stable_tree_search
+++ a/mm/ksm.c
@@ -1909,12 +1909,15 @@ again:
 			if (page_node) {
 				VM_BUG_ON(page_node->head != &migrate_nodes);
 				/*
-				 * Test if the migrated page should be merged
-				 * into a stable node dup. If the mapcount is
-				 * 1 we can migrate it with another KSM page
-				 * without adding it to the chain.
+				 * If the mapcount of our migrated KSM folio is
+				 * at most 1, we can merge it with another
+				 * KSM folio where we know that we have space
+				 * for one more mapping without exceeding the
+				 * ksm_max_page_sharing limit: see
+				 * chain_prune(). This way, we can avoid adding
+				 * this stable node to the chain.
 				 */
-				if (page_mapcount(page) > 1)
+				if (folio_mapcount(folio) > 1)
 					goto chain_append;
 			}
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly.patch
mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch
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
mm-ksm-remove-page_mapcount-usage-in-stable_tree_search.patch
loongarch-tlb-fix-error-parameter-ptep-set-but-not-used-due-to-__tlb_remove_tlb_entry.patch


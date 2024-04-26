Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387297EF06
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104075; cv=none; b=fIm5SSqN3pOX2hxwFs5elMv471D+ErGdHM+rReM3PLJsUfd3yDOZ+onuCJU0PIMtJKKrQfNTHv3GSdaH5dI3U9S73I6FnRyAEuzoH/OUPP2GL57NMQ+9SBX0rGwrSkWSh224P7JXEu1HKOj1YwKY3sTdVjA7j8WNAi3wbkV5exU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104075; c=relaxed/simple;
	bh=nKWYwKE5c0C+7B0XJUx06185InsWqq0fWsEv4E5lZcs=;
	h=Date:To:From:Subject:Message-Id; b=axU5tZ6e+rWBDcSgMqY3PulzC8b4bY14RD/go1dUQorWJHwYRl6JQQU9KhY8zwJWjj+rmG7FoIteOR+9ZD0raQhCZ6Xgk3fJ6HAqLEOk139IuynoOqgAh74A72kIplKJ3YKjZocq2DXrBaxKhP27fnuPdmLldyaEtu8KuQU+eVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g5ZK/VX6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g5ZK/VX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDDCC113CD;
	Fri, 26 Apr 2024 04:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104075;
	bh=nKWYwKE5c0C+7B0XJUx06185InsWqq0fWsEv4E5lZcs=;
	h=Date:To:From:Subject:From;
	b=g5ZK/VX6KQ3LSaK3faeAUu4YY0PokUnYEheTCHHhC+MxrrECSF7AG1g8N3CY+/5Ye
	 RvaoYuxfS4Y01jP/js/49W0liA8YIsbLccYFkWveZSZAXUy7cC6S+dgjys8oWtjCK0
	 APOErd7AgpBkPfMoxFGzOQimyOeLsq4hPexZAzBk=
Date: Thu, 25 Apr 2024 21:01:14 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-optimize-config_per_vma_lock-member-placement-in-vm_area_struct.patch removed from -mm tree
Message-Id: <20240426040115.0DDDCC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: optimize CONFIG_PER_VMA_LOCK member placement in vm_area_struct
has been removed from the -mm tree.  Its filename was
     mm-optimize-config_per_vma_lock-member-placement-in-vm_area_struct.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: optimize CONFIG_PER_VMA_LOCK member placement in vm_area_struct
Date: Wed, 27 Mar 2024 15:35:48 +0100

Currently, we end up wasting some memory in each vm_area_struct. Pahole
states that:
	[...]
	int                        vm_lock_seq;          /*    40     4 */

	/* XXX 4 bytes hole, try to pack */

	struct vma_lock *          vm_lock;              /*    48     8 */
	bool                       detached;             /*    56     1 */

	/* XXX 7 bytes hole, try to pack */
	[...]

Let's reduce the holes and memory wastage by moving the bool:
	[...]
	bool                       detached;             /*    40     1 */

	/* XXX 3 bytes hole, try to pack */

	int                        vm_lock_seq;          /*    44     4 */
	struct vma_lock *          vm_lock;              /*    48     8 */
	[...]

Effectively shrinking the vm_area_struct with CONFIG_PER_VMA_LOCK by
8 byte.

Likely, we could place "detached" in the lowest bit of vm_lock, but at
least on 64bit that won't really make a difference, so keep it simple.

Link: https://lkml.kernel.org/r/20240327143548.744070-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/mm_types.h~mm-optimize-config_per_vma_lock-member-placement-in-vm_area_struct
+++ a/include/linux/mm_types.h
@@ -671,6 +671,9 @@ struct vm_area_struct {
 	};
 
 #ifdef CONFIG_PER_VMA_LOCK
+	/* Flag to indicate areas detached from the mm->mm_mt tree */
+	bool detached;
+
 	/*
 	 * Can only be written (using WRITE_ONCE()) while holding both:
 	 *  - mmap_lock (in write mode)
@@ -687,9 +690,6 @@ struct vm_area_struct {
 	 */
 	int vm_lock_seq;
 	struct vma_lock *vm_lock;
-
-	/* Flag to indicate areas detached from the mm->mm_mt tree */
-	bool detached;
 #endif
 
 	/*
_

Patches currently in -mm which might be from david@redhat.com are

drivers-virt-acrn-fix-pfnmap-pte-checks-in-acrn_vm_ram_map.patch
mm-pass-vma-instead-of-mm-to-follow_pte.patch
mm-follow_pte-improvements.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again-fix.patch
mm-rmap-always-inline-anon-file-rmap-duplication-of-a-single-pte.patch
mm-rmap-add-fast-path-for-small-folios-when-adding-removing-duplicating.patch
mm-track-mapcount-of-large-folios-in-single-value.patch
mm-improve-folio_likely_mapped_shared-using-the-mapcount-of-large-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios-fix.patch
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
fs-proc-task_mmu-convert-pagemap_hugetlb_range-to-work-on-folios.patch
fs-proc-task_mmu-convert-smaps_hugetlb_range-to-work-on-folios.patch
mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation.patch
mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation-v2.patch
mm-khugepaged-replace-page_mapcount-check-by-folio_likely_mapped_shared.patch
loongarch-tlb-fix-error-parameter-ptep-set-but-not-used-due-to-__tlb_remove_tlb_entry.patch


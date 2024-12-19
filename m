Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D848614E;
	Thu, 19 Dec 2024 03:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734577535; cv=none; b=MvuUNhCTs6eposuzhYHoz6gHFANDKEGmSfxZXyMiiTm4/bN0VtnrPkwy1AWwuFqp8GApquta1izzP2wzBtpAV/x+4y37dFrjlJ6GkOAPWZMwsVZc47g5gooFAgq5wAD8dgvBA6pRvvsQnnLedme+QEByZFLjnEKU/U/EvyM9WFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734577535; c=relaxed/simple;
	bh=yNofCBze4cmuccg4vjZ/QguhtfLtEWoRHZRJIeaBhRc=;
	h=Date:To:From:Subject:Message-Id; b=V40xyLgLrsKA3ZfE616CcAfSrl4qrmU5tlqgV6H5gYLVBT9fVgMtkSxGMg2UB9HkUTdbcvpmKJkPj6YHXoD9OIyVx9NzH3jYAMfcuuY636hdaMjlSbrEmUFtIoF/ZUdtoKLv8fNAmRS8U1Lmm0W3WJAfJzLbLGSbD5GY2L1ZWdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aZggatLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aZggatLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7A9C4CECD;
	Thu, 19 Dec 2024 03:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734577535;
	bh=yNofCBze4cmuccg4vjZ/QguhtfLtEWoRHZRJIeaBhRc=;
	h=Date:To:From:Subject:From;
	b=aZggatLD8DofVhvvEBXwWcCYC3pSgPhY+VZVkLsBOu6oWd6k+bpgpCIOkrv08VeP3
	 sVY/38bc3C6wmmFXJnQyHRks+o4wALODh3WaxmP+VH3Y+e1XqyJEMHDmWpduHY47R2
	 UcPXW74vR9ddxKcPgzmvHofeWyIm0F+kwysNxAU0=
Date: Wed, 18 Dec 2024 19:05:34 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,vbabka@suse.cz,stable@vger.kernel.org,hannes@cmpxchg.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_alloc-dont-call-pfn_to_page-on-possibly-non-existent-pfn-in-split_large_buddy.patch removed from -mm tree
Message-Id: <20241219030535.2D7A9C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: don't call pfn_to_page() on possibly non-existent PFN in split_large_buddy()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-dont-call-pfn_to_page-on-possibly-non-existent-pfn-in-split_large_buddy.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_alloc: don't call pfn_to_page() on possibly non-existent PFN in split_large_buddy()
Date: Tue, 10 Dec 2024 10:34:37 +0100

In split_large_buddy(), we might call pfn_to_page() on a PFN that might
not exist.  In corner cases, such as when freeing the highest pageblock in
the last memory section, this could result with CONFIG_SPARSEMEM &&
!CONFIG_SPARSEMEM_EXTREME in __pfn_to_section() returning NULL and and
__section_mem_map_addr() dereferencing that NULL pointer.

Let's fix it, and avoid doing a pfn_to_page() call for the first
iteration, where we already have the page.

So far this was found by code inspection, but let's just CC stable as the
fix is easy.

Link: https://lkml.kernel.org/r/20241210093437.174413-1-david@redhat.com
Fixes: fd919a85cd55 ("mm: page_isolation: prepare for hygienic freelists")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Closes: https://lkml.kernel.org/r/e1a898ba-a717-4d20-9144-29df1a6c8813@suse.cz
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-dont-call-pfn_to_page-on-possibly-non-existent-pfn-in-split_large_buddy
+++ a/mm/page_alloc.c
@@ -1238,13 +1238,15 @@ static void split_large_buddy(struct zon
 	if (order > pageblock_order)
 		order = pageblock_order;
 
-	while (pfn != end) {
+	do {
 		int mt = get_pfnblock_migratetype(page, pfn);
 
 		__free_one_page(page, pfn, zone, order, mt, fpi);
 		pfn += 1 << order;
+		if (pfn == end)
+			break;
 		page = pfn_to_page(pfn);
-	}
+	} while (1);
 }
 
 static void free_one_page(struct zone *zone, struct page *page,
_

Patches currently in -mm which might be from david@redhat.com are

fs-proc-task_mmu-fix-pagemap-flags-with-pmd-thp-entries-on-32bit.patch
docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch
mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range.patch
mm-page_isolation-dont-pass-gfp-flags-to-isolate_single_pageblock.patch
mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range.patch
mm-page_alloc-make-__alloc_contig_migrate_range-static.patch
mm-page_alloc-sort-out-the-alloc_contig_range-gfp-flags-mess.patch
mm-page_alloc-forward-the-gfp-flags-from-alloc_contig_range-to-post_alloc_hook.patch
powernv-memtrace-use-__gfp_zero-with-alloc_contig_pages.patch
mm-hugetlb-dont-map-folios-writable-without-vm_write-when-copying-during-fork.patch
fs-proc-vmcore-convert-vmcore_cb_lock-into-vmcore_mutex.patch
fs-proc-vmcore-replace-vmcoredd_mutex-by-vmcore_mutex.patch
fs-proc-vmcore-disallow-vmcore-modifications-while-the-vmcore-is-open.patch
fs-proc-vmcore-prefix-all-pr_-with-vmcore.patch
fs-proc-vmcore-move-vmcore-definitions-out-of-kcoreh.patch
fs-proc-vmcore-factor-out-allocating-a-vmcore-range-and-adding-it-to-a-list.patch
fs-proc-vmcore-factor-out-freeing-a-list-of-vmcore-ranges.patch
fs-proc-vmcore-introduce-proc_vmcore_device_ram-to-detect-device-ram-ranges-in-2nd-kernel.patch
virtio-mem-mark-device-ready-before-registering-callbacks-in-kdump-mode.patch
virtio-mem-remember-usable-region-size.patch
virtio-mem-support-config_proc_vmcore_device_ram.patch
s390-kdump-virtio-mem-kdump-support-config_proc_vmcore_device_ram.patch
mm-page_alloc-dont-use-__gfp_hardwall-when-migrating-pages-via-alloc_contig.patch
mm-memory_hotplug-dont-use-__gfp_hardwall-when-migrating-pages-via-memory-offlining.patch


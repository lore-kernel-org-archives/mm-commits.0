Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED352451D8;
	Wed, 11 Dec 2024 01:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733878823; cv=none; b=THXXKyUgfGmfMM0QPrn3eyPubpUHI7ceZ8D4YlZ49f6Ef4QMbhCiwXVlbICsVu+VeGjv4rMbxkyvLXIwyt6CT32NKeJ8TuNG44X52oOlnpsUdqtPHrdpS1IGquzr7xC3g8A6t/n7bn8fNPFMUIhRY0hph/0MeUo8gv4UAl66WQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733878823; c=relaxed/simple;
	bh=MqE2UwP5ICjZdKuZPqbaWVQ3bB7TDZj0joRcXI0FMC8=;
	h=Date:To:From:Subject:Message-Id; b=MGkUv5bqecuOl058+v8MORZTgW/7LpWvQKbUJGvn26zPKj9kSnlCHqO37Cg1yuQ2PWyA1nAjTXyxgYpAc4B8g7ZrHBffC3/+0XmWIswr4hlMkK5GH9OmViXtt2zC2YbD2LC14YKe50yiLu0m3rZz2SQzv1cnp/M/UNNKFqT9+k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MPZCIbpi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MPZCIbpi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2314C4CED6;
	Wed, 11 Dec 2024 01:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733878822;
	bh=MqE2UwP5ICjZdKuZPqbaWVQ3bB7TDZj0joRcXI0FMC8=;
	h=Date:To:From:Subject:From;
	b=MPZCIbpiFLQPCXbA7t4EMlY6axCwWjPzwJRn1Ma89vFIKD4WP4xPyRVhfef4rVXN+
	 3erx8+5AH7HDtU/dHcgrsdrOBe39XcABfOxVgKTC1lSbr/OPBP2L/SK6AAJN/DG3HM
	 tY04zdYUZKhCavP+0AiwgQMkIw1zwWHXHFqKjYWQ=
Date: Tue, 10 Dec 2024 17:00:22 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,vbabka@suse.cz,stable@vger.kernel.org,hannes@cmpxchg.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-dont-call-pfn_to_page-on-possibly-non-existent-pfn-in-split_large_buddy.patch added to mm-hotfixes-unstable branch
Message-Id: <20241211010022.D2314C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: don't call pfn_to_page() on possibly non-existent PFN in split_large_buddy()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-dont-call-pfn_to_page-on-possibly-non-existent-pfn-in-split_large_buddy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-dont-call-pfn_to_page-on-possibly-non-existent-pfn-in-split_large_buddy.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-page_alloc-dont-call-pfn_to_page-on-possibly-non-existent-pfn-in-split_large_buddy.patch
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
mm-page_alloc-conditionally-split-pageblock_order-pages-in-free_one_page-and-move_freepages_block_isolate.patch
mm-page_isolation-fixup-isolate_single_pageblock-comment-regarding-splitting-free-pages.patch
mm-page_alloc-dont-use-__gfp_hardwall-when-migrating-pages-via-alloc_contig.patch
mm-memory_hotplug-dont-use-__gfp_hardwall-when-migrating-pages-via-memory-offlining.patch


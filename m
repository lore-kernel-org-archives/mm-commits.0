Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0140A21518B
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188205; cv=none; b=Nav+2K+wbOj+h05bc1DhOxDScS9MeR98UPGXOFs+bba8YYeOB3lw801udHDeuH/cWpdtcrmpASerQSB6LJ9SHIWZ5P2dcg9oXUiZ9HaU0UN7kaoYHTopVSvqz/ou1O7NdwOsLDTV2zHDDLrOwh74AZ/ptI8WfiGDKLWN8vNN2Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188205; c=relaxed/simple;
	bh=/2GOS29hAeyybHUQCF53mYKT/SReI/XXrl9omNtKgBM=;
	h=Date:To:From:Subject:Message-Id; b=ufDXgYReMPJjILgEoLggZk6il36LPjJNJt64sgo2FW45Evxns6B6h+OL1zvAoW53xevEeXrS84KxAKKXqzKlZT8eraXGu3+3nN4a1YcQwYPV7HPQgnPAJ7uirncNg/eguMVNgoasdp+VmqevN9mNRFpa8ELBRS8YRcdh3yHAzJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZHcdtlBI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZHcdtlBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE722C4CEEC;
	Mon, 17 Mar 2025 05:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188204;
	bh=/2GOS29hAeyybHUQCF53mYKT/SReI/XXrl9omNtKgBM=;
	h=Date:To:From:Subject:From;
	b=ZHcdtlBIYzBZUmwkSZ9EeyN1x92AuQ+C8jpLRGrdM0Iv7VcCoGouTgvXtF66p33Ne
	 0eTh31g6CEFz29ZqkAmD7GbjtME2T4DEUjL9tlA3QU3Qt5GqNitr4hue6PFM7bmYcq
	 XFSyGC2Y4jDp+iftuzQveIlovhotDuWIPwMlLjVs=
Date: Sun, 16 Mar 2025 22:10:04 -0700
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,sj@kernel.org,si.yanteng@linux.dev,simona.vetter@ffwll.ch,peterz@infradead.org,peterx@redhat.com,pasha.tatashin@soleen.com,oleg@redhat.com,mhiramat@kernel.org,lyude@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kherbst@redhat.com,jhubbard@nvidia.com,jglisse@redhat.com,jgg@nvidia.com,jannh@google.com,dakr@kernel.org,corbet@lwn.net,apopple@nvidia.com,alexs@kernel.org,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-handle-device-exclusive-entries-correctly-in-damon_folio_mkold_one.patch removed from -mm tree
Message-Id: <20250317051004.BE722C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: handle device-exclusive entries correctly in damon_folio_mkold_one()
has been removed from the -mm tree.  Its filename was
     mm-damon-handle-device-exclusive-entries-correctly-in-damon_folio_mkold_one.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/damon: handle device-exclusive entries correctly in damon_folio_mkold_one()
Date: Mon, 10 Feb 2025 20:37:57 +0100

Ever since commit b756a3b5e7ea ("mm: device exclusive memory access") we
can return with a device-exclusive entry from page_vma_mapped_walk().

damon_folio_mkold_one() is not prepared for that and calls
damon_ptep_mkold() with PFN swap PTEs.  Teach damon_ptep_mkold() to deal
with these PFN swap PTEs.  Note that device-private entries are so far not
applicable on that path, as damon_get_folio() filters out non-lru folios.

Should we just skip PFN swap PTEs completely?  Possible, but it seems
straight forward to just handle it correctly.

Note that we could currently only run into this case with device-exclusive
entries on THPs.  We still adjust the mapcount on conversion to
device-exclusive; this makes the rmap walk abort early for small folios,
because we'll always have !folio_mapped() with a single device-exclusive
entry.  We'll adjust the mapcount logic once all page_vma_mapped_walk()
users can properly handle device-exclusive entries.

Link: https://lkml.kernel.org/r/20250210193801.781278-16-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Tested-by: Alistair Popple <apopple@nvidia.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Lyude <lyude@redhat.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Simona Vetter <simona.vetter@ffwll.ch>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yanteng Si <si.yanteng@linux.dev>
Cc: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-handle-device-exclusive-entries-correctly-in-damon_folio_mkold_one
+++ a/mm/damon/ops-common.c
@@ -9,6 +9,8 @@
 #include <linux/page_idle.h>
 #include <linux/pagemap.h>
 #include <linux/rmap.h>
+#include <linux/swap.h>
+#include <linux/swapops.h>
 
 #include "ops-common.h"
 
@@ -39,12 +41,29 @@ struct folio *damon_get_folio(unsigned l
 
 void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr)
 {
-	struct folio *folio = damon_get_folio(pte_pfn(ptep_get(pte)));
+	pte_t pteval = ptep_get(pte);
+	struct folio *folio;
+	bool young = false;
+	unsigned long pfn;
+
+	if (likely(pte_present(pteval)))
+		pfn = pte_pfn(pteval);
+	else
+		pfn = swp_offset_pfn(pte_to_swp_entry(pteval));
 
+	folio = damon_get_folio(pfn);
 	if (!folio)
 		return;
 
-	if (ptep_clear_young_notify(vma, addr, pte))
+	/*
+	 * PFN swap PTEs, such as device-exclusive ones, that actually map pages
+	 * are "old" from a CPU perspective. The MMU notifier takes care of any
+	 * device aspects.
+	 */
+	if (likely(pte_present(pteval)))
+		young |= ptep_test_and_clear_young(vma, addr, pte);
+	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
+	if (young)
 		folio_set_young(folio);
 
 	folio_set_idle(folio);
_

Patches currently in -mm which might be from david@redhat.com are

mm-factor-out-large-folio-handling-from-folio_order-into-folio_large_order.patch
mm-factor-out-large-folio-handling-from-folio_nr_pages-into-folio_large_nr_pages.patch
mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page.patch
mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page-fix.patch
mm-move-hugetlb-specific-things-in-folio-to-page.patch
mm-move-_pincount-in-folio-to-page-on-32bit.patch
mm-move-_entire_mapcount-in-folio-to-page-on-32bit.patch
mm-rmap-pass-dst_vma-to-folio_dup_file_rmap_pte-and-friends.patch
mm-rmap-pass-vma-to-__folio_add_rmap.patch
mm-rmap-abstract-large-mapcount-operations-for-large-folios-hugetlb.patch
bit_spinlock-__always_inline-unlock-functions.patch
mm-rmap-use-folio_large_nr_pages-in-add-remove-functions.patch
mm-rmap-basic-mm-owner-tracking-for-large-folios-hugetlb.patch
mm-copy-on-write-cow-reuse-support-for-pte-mapped-thp.patch
mm-convert-folio_likely_mapped_shared-to-folio_maybe_mapped_shared.patch
mm-config_no_page_mapcount-to-prepare-for-not-maintain-per-page-mapcounts-in-large-folios.patch
fs-proc-page-remove-per-page-mapcount-dependency-for-proc-kpagecount-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-pm_mmap_exclusive-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-mapmax-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-smaps-smaps_rollup-config_no_page_mapcount.patch
mm-stop-maintaining-the-per-page-mapcount-of-large-folios-config_no_page_mapcount.patch


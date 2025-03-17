Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA7A21516B
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188193; cv=none; b=QyAeRUWVV5vdeC0/SXTBlj4ODAmWopp+anMg5G/YcAqnZuAeLOGsLZ8s+GwTO+CvSKHrT02yLK4vFQmQTAuJ9bLLxwiCZQ1CStU8OM6zpIpFSCGZ+wqotE4xZAMZ/qhPc8F5bgAivH+W45tjjRD7fwMBeDk0kgwMJuhllR1LQoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188193; c=relaxed/simple;
	bh=H0BPCfBJhO3XxJ789Bu/gPNSyeQZHzi4Z0jgCkBcoRo=;
	h=Date:To:From:Subject:Message-Id; b=Q4fjIq5fiDHaWSPLq8fyboKn4JXxDH9rcGGyxTsUd5eCe4Vxi3k1SxRK21Lg0OJAX1aOEBPxj6qRLoWe8Pi2XSQAUgPlLlB9xSfWy1eA3HDUZwrvKNk2ybtDVzhs7+5WNfD+Ivg7UB+MwHcIj7i5/2EUoUldH8zTBfkedJsYokE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jNY1b6kN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jNY1b6kN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6EDC4CEEC;
	Mon, 17 Mar 2025 05:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188193;
	bh=H0BPCfBJhO3XxJ789Bu/gPNSyeQZHzi4Z0jgCkBcoRo=;
	h=Date:To:From:Subject:From;
	b=jNY1b6kNbEFiTwPSNcT2dySZoiEubLnl8r9J5nsdxwUmKAiH9GodpM0W/+sARp5CV
	 XxZRomDvzJZY7Gc9MtU+dNTooz9hK7dscqdwoSfCfRRrdHCalAp3Gkp0D6VKMk4iaY
	 x4Suny6k/3n8b3PkcEn6ZH/bT4p8D3RtUsLlPjvw=
Date: Sun, 16 Mar 2025 22:09:53 -0700
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,sj@kernel.org,si.yanteng@linux.dev,simona.vetter@ffwll.ch,peterz@infradead.org,peterx@redhat.com,pasha.tatashin@soleen.com,oleg@redhat.com,mhiramat@kernel.org,lyude@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kherbst@redhat.com,jhubbard@nvidia.com,jglisse@redhat.com,jgg@nvidia.com,jannh@google.com,dakr@kernel.org,corbet@lwn.net,apopple@nvidia.com,alexs@kernel.org,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_vma_mapped-device-exclusive-entries-are-not-migration-entries.patch removed from -mm tree
Message-Id: <20250317050953.7C6EDC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_vma_mapped: device-exclusive entries are not migration entries
has been removed from the -mm tree.  Its filename was
     mm-page_vma_mapped-device-exclusive-entries-are-not-migration-entries.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_vma_mapped: device-exclusive entries are not migration entries
Date: Mon, 10 Feb 2025 20:37:49 +0100

It's unclear why they would be considered migration entries; they are not.

Likely we'll never really trigger that case in practice, because migration
(including folio split) of a folio that has device-exclusive entries is
never started, as we would detect "additional references":
device-exclusive entries adjust the mapcount, but not the refcount.

Link: https://lkml.kernel.org/r/20250210193801.781278-8-david@redhat.com
Fixes: b756a3b5e7ea ("mm: device exclusive memory access")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
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
Cc: SeongJae Park <sj@kernel.org>
Cc: Simona Vetter <simona.vetter@ffwll.ch>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yanteng Si <si.yanteng@linux.dev>
Cc: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped-device-exclusive-entries-are-not-migration-entries
+++ a/mm/page_vma_mapped.c
@@ -111,8 +111,7 @@ static bool check_pte(struct page_vma_ma
 			return false;
 		entry = pte_to_swp_entry(ptent);
 
-		if (!is_migration_entry(entry) &&
-		    !is_device_exclusive_entry(entry))
+		if (!is_migration_entry(entry))
 			return false;
 
 		pfn = swp_offset_pfn(entry);
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


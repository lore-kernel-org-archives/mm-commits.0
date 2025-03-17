Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500BDA59
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188190; cv=none; b=Upq3kIYeHXL8IZBC/WSpo6RfVXLkFHBRCjKrTr8MzE7fu6AdOaj4v+Ddy28TaONIybLY2J0GLxI7Ty7H3+oZhXHsG0M212egx2vcgXQgTSTrX5PNVQobIxpLKzAApoD/eRV//yKzz+bHl8KmbVBsiKY5rMnXAwrx6KA9yOiCSyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188190; c=relaxed/simple;
	bh=TBQSw3CzAvtq1KvNZBiHZxd3PXir57kQXaY7oNItaZ4=;
	h=Date:To:From:Subject:Message-Id; b=KACubo9Nn+N8wii/LERBifX3c3kWWU8hu50FAXKCXsrEYNdaENqYQ/FUQJYZnZ3Nwt50DfGJp2KP0EWuCwXJkw276spGVqvC5U9Jk5jAn/Gz/mdLECDYfpn+IvBLkXBs1wvKdIl4J53swAHhnLj8LC7PQnox/ll8oVABmTw3d9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xY13slrU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xY13slrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25357C4CEEC;
	Mon, 17 Mar 2025 05:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188190;
	bh=TBQSw3CzAvtq1KvNZBiHZxd3PXir57kQXaY7oNItaZ4=;
	h=Date:To:From:Subject:From;
	b=xY13slrUgTFdJMxWzttM6wsrB9h9wg+dkbDP3skaPxCqpyK+KHX6q2oWOkUKQnmdn
	 ZweDlU9BV3ReSQo3XTvxcdkuiCsiE/hcHskxeFBieRSLWJ8x+0hFFHoSBQc5G4IJcV
	 A4jgggMskQnMHMBNxVpkKeFvl/3VnJ/DYGe7ak6w=
Date: Sun, 16 Mar 2025 22:09:49 -0700
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,sj@kernel.org,si.yanteng@linux.dev,simona.vetter@ffwll.ch,peterz@infradead.org,peterx@redhat.com,pasha.tatashin@soleen.com,oleg@redhat.com,mhiramat@kernel.org,lyude@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kherbst@redhat.com,jhubbard@nvidia.com,jglisse@redhat.com,jgg@nvidia.com,jannh@google.com,dakr@kernel.org,corbet@lwn.net,apopple@nvidia.com,alexs@kernel.org,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-detect-writability-in-restore_exclusive_pte-through-can_change_pte_writable.patch removed from -mm tree
Message-Id: <20250317050950.25357C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: detect writability in restore_exclusive_pte() through can_change_pte_writable()
has been removed from the -mm tree.  Its filename was
     mm-memory-detect-writability-in-restore_exclusive_pte-through-can_change_pte_writable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: detect writability in restore_exclusive_pte() through can_change_pte_writable()
Date: Mon, 10 Feb 2025 20:37:47 +0100

Let's do it just like mprotect write-upgrade or during NUMA-hinting faults
on PROT_NONE PTEs: detect if the PTE can be writable by using
can_change_pte_writable().

Set the PTE only dirty if the folio is dirty: we might not necessarily
have a write access, and setting the PTE writable doesn't require setting
the PTE dirty.

From a CPU perspective, these entries are clean.  So only set the PTE
dirty if the folios is dirty.

With this change in place, there is no need to have separate readable and
writable device-exclusive entry types, and we'll merge them next
separately.

Note that, during fork(), we first convert the device-exclusive entries
back to ordinary PTEs, and we only ever allow conversion of writable PTEs
to device-exclusive -- only mprotect can currently change them to
readable-device-exclusive.  Consequently, we always expect
PageAnonExclusive(page)==true and can_change_pte_writable()==true, unless
we are dealing with soft-dirty tracking or uffd-wp.  But reusing
can_change_pte_writable() for now is cleaner.

Link: https://lkml.kernel.org/r/20250210193801.781278-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
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

 mm/memory.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-memory-detect-writability-in-restore_exclusive_pte-through-can_change_pte_writable
+++ a/mm/memory.c
@@ -723,18 +723,21 @@ static void restore_exclusive_pte(struct
 	struct folio *folio = page_folio(page);
 	pte_t orig_pte;
 	pte_t pte;
-	swp_entry_t entry;
 
 	orig_pte = ptep_get(ptep);
 	pte = pte_mkold(mk_pte(page, READ_ONCE(vma->vm_page_prot)));
 	if (pte_swp_soft_dirty(orig_pte))
 		pte = pte_mksoft_dirty(pte);
 
-	entry = pte_to_swp_entry(orig_pte);
 	if (pte_swp_uffd_wp(orig_pte))
 		pte = pte_mkuffd_wp(pte);
-	else if (is_writable_device_exclusive_entry(entry))
-		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
+
+	if ((vma->vm_flags & VM_WRITE) &&
+	    can_change_pte_writable(vma, address, pte)) {
+		if (folio_test_dirty(folio))
+			pte = pte_mkdirty(pte);
+		pte = pte_mkwrite(pte, vma);
+	}
 
 	VM_BUG_ON_FOLIO(pte_write(pte) && (!folio_test_anon(folio) &&
 					   PageAnonExclusive(page)), folio);
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF74625EF92
	for <mm-commits@vger.kernel.org>; Mon, 10 Feb 2025 23:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739228771; cv=none; b=GGxzeIswCc+DgPGsxVezwnOAMZlzLIDiWEuIJ9QKcigSbENYyinZ67cB2pBfKLcR1beNY96u0+a3gxj4t4DauggNYG2glrEhgDpZplGh7wUJ27TlDJzXYk3HhV/BE7d94g2vloL0b9VkS1tcBBacUd7VkWpzhJ9owFPDo2bl8Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739228771; c=relaxed/simple;
	bh=Hlat8vPbIl3TIYbKW9Rnj5yGV2F1/WJZSywgghtbsVY=;
	h=Date:To:From:Subject:Message-Id; b=UfAbH0EfAlS/iuwfW9+Jo/v3it4LEBTEMFXGgrOyOICSMYRuHQO6bSTGSp6S7gxgmkCUzNZgTB9B5V4IGIrJZkWps19TohpH2Rdow2m91DDzRxaik1R2HKgNTija03kyhjwOtpPl4r0GMJHmQV6OzvTJuNl3N/g1N2Qz+8/Ji7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sAcPHwDV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sAcPHwDV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9464C4CED1;
	Mon, 10 Feb 2025 23:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739228770;
	bh=Hlat8vPbIl3TIYbKW9Rnj5yGV2F1/WJZSywgghtbsVY=;
	h=Date:To:From:Subject:From;
	b=sAcPHwDVtusLsQr2Ub2E5/xaK8ZxLxIBuftd0bZs2NLBIIXr6ctf6LoLXgILQ+XOU
	 pyygAFIU3NLJt3L9RaijJSGPmzClQcBYvEEh71ye8xiVQbletPUXfSXRQVVAXCXJ7j
	 Yxc+oWblYwe5m9o4dMrnT2zzzI/ehQiOve+wxVog=
Date: Mon, 10 Feb 2025 15:06:10 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,sj@kernel.org,si.yanteng@linux.dev,simona.vetter@ffwll.ch,peterz@infradead.org,peterx@redhat.com,pasha.tatashin@soleen.com,oleg@redhat.com,mhiramat@kernel.org,lyude@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kherbst@redhat.com,jhubbard@nvidia.com,jglisse@redhat.com,jgg@nvidia.com,jannh@google.com,dakr@kernel.org,corbet@lwn.net,apopple@nvidia.com,alexs@kernel.org,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-events-uprobes-handle-device-exclusive-entries-correctly-in-__replace_page.patch added to mm-unstable branch
Message-Id: <20250210230610.B9464C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/events/uprobes: handle device-exclusive entries correctly in __replace_page()
has been added to the -mm mm-unstable branch.  Its filename is
     kernel-events-uprobes-handle-device-exclusive-entries-correctly-in-__replace_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-events-uprobes-handle-device-exclusive-entries-correctly-in-__replace_page.patch

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
Subject: kernel/events/uprobes: handle device-exclusive entries correctly in __replace_page()
Date: Mon, 10 Feb 2025 20:37:50 +0100

Ever since commit b756a3b5e7ea ("mm: device exclusive memory access") we
can return with a device-exclusive entry from page_vma_mapped_walk().

__replace_page() is not prepared for that, so teach it about these PFN
swap PTEs.  Note that device-private entries are so far not applicable on
that path, because GUP would never have returned such folios (conversion
to device-private happens by page migration, not in-place conversion of
the PTE).

There is a race between GUP and us locking the folio to look it up using
page_vma_mapped_walk(), so this is likely a fix (unless something else
could prevent that race, but it doesn't look like).  pte_pfn() on
something that is not a present pte could give use garbage, and we'd
wrongly mess up the mapcount because it was already adjusted by calling
folio_remove_rmap_pte() when making the entry device-exclusive.

Link: https://lkml.kernel.org/r/20250210193801.781278-9-david@redhat.com
Fixes: b756a3b5e7ea ("mm: device exclusive memory access")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
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

 kernel/events/uprobes.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/kernel/events/uprobes.c~kernel-events-uprobes-handle-device-exclusive-entries-correctly-in-__replace_page
+++ a/kernel/events/uprobes.c
@@ -173,6 +173,7 @@ static int __replace_page(struct vm_area
 	DEFINE_FOLIO_VMA_WALK(pvmw, old_folio, vma, addr, 0);
 	int err;
 	struct mmu_notifier_range range;
+	pte_t pte;
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, addr,
 				addr + PAGE_SIZE);
@@ -192,6 +193,16 @@ static int __replace_page(struct vm_area
 	if (!page_vma_mapped_walk(&pvmw))
 		goto unlock;
 	VM_BUG_ON_PAGE(addr != pvmw.address, old_page);
+	pte = ptep_get(pvmw.pte);
+
+	/*
+	 * Handle PFN swap PTES, such as device-exclusive ones, that actually
+	 * map pages: simply trigger GUP again to fix it up.
+	 */
+	if (unlikely(!pte_present(pte))) {
+		page_vma_mapped_walk_done(&pvmw);
+		goto unlock;
+	}
 
 	if (new_page) {
 		folio_get(new_folio);
@@ -206,7 +217,7 @@ static int __replace_page(struct vm_area
 		inc_mm_counter(mm, MM_ANONPAGES);
 	}
 
-	flush_cache_page(vma, addr, pte_pfn(ptep_get(pvmw.pte)));
+	flush_cache_page(vma, addr, pte_pfn(pte));
 	ptep_clear_flush(vma, addr, pvmw.pte);
 	if (new_page)
 		set_pte_at(mm, addr, pvmw.pte,
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-reject-foll_split_pmd-with-hugetlb-vmas.patch
mm-rmap-reject-hugetlb-folios-in-folio_make_device_exclusive.patch
mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive.patch
mm-rmap-implement-make_device_exclusive-using-folio_walk-instead-of-rmap-walk.patch
mm-memory-detect-writability-in-restore_exclusive_pte-through-can_change_pte_writable.patch
mm-use-single-swp_device_exclusive-entry-type.patch
mm-page_vma_mapped-device-exclusive-entries-are-not-migration-entries.patch
kernel-events-uprobes-handle-device-exclusive-entries-correctly-in-__replace_page.patch
mm-ksm-handle-device-exclusive-entries-correctly-in-write_protect_page.patch
mm-rmap-handle-device-exclusive-entries-correctly-in-try_to_unmap_one.patch
mm-rmap-handle-device-exclusive-entries-correctly-in-try_to_migrate_one.patch
mm-rmap-handle-device-exclusive-entries-correctly-in-page_vma_mkclean_one.patch
mm-page_idle-handle-device-exclusive-entries-correctly-in-page_idle_clear_pte_refs_one.patch
mm-damon-handle-device-exclusive-entries-correctly-in-damon_folio_young_one.patch
mm-damon-handle-device-exclusive-entries-correctly-in-damon_folio_mkold_one.patch
mm-rmap-keep-mapcount-untouched-for-device-exclusive-entries.patch
mm-rmap-avoid-ebusy-from-make_device_exclusive.patch


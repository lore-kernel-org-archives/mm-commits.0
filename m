Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0852586FA
	for <mm-commits@vger.kernel.org>; Mon, 10 Feb 2025 23:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739228762; cv=none; b=R7aB85gKztihdHcoRIODdqJSZVaSums8iTwGRTFpLWXul8PL0IYGmcOjkyyy0LmMOqLdVk2TFZzXre7itwX4cXH2gVqqMv93YB0Yf+/6Tb6HJD6mmkMkX482mebvLFe4ZKMNdhO9KsylrphOwYrbRy/YGeGpxbHg778Yx5uofGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739228762; c=relaxed/simple;
	bh=Mzl7wcgCGNdkMtccrX7ZQMha+om2rh3xV59mPb7Vw1U=;
	h=Date:To:From:Subject:Message-Id; b=q8cogsCODsfZXffVmLAJHYT4MoquuycmeUFqc0dug5cNRboPKyDd5Gq5v8XuGMZOoz+q9fn1LHOGQ978NhXP4tsDr8ZvVuTIdaUVd2Ip7+W6ZDub6zOe/xKvCV4FS7tXk2b0wH5jWPCS2lYt7gZeiNeTqRAaLZRxsYnJWylNpNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YDq/glB6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YDq/glB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A762C4CED1;
	Mon, 10 Feb 2025 23:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739228762;
	bh=Mzl7wcgCGNdkMtccrX7ZQMha+om2rh3xV59mPb7Vw1U=;
	h=Date:To:From:Subject:From;
	b=YDq/glB62pu4eAtQY4zf/tUgFcLDwY+nJyqiLP9co0xVzyCS3I/FpGsC0vUhKUn2f
	 5DibxreuUe3xK8GGv7PRYzlNZvpjwyQmnoU4zgmKDfF95dCsNolcEgj1V3H6RtAo59
	 0V6zWSkKxLQ2wjcXnzUBnwJpFgEOatdyXJYEkS5E=
Date: Mon, 10 Feb 2025 15:06:01 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,sj@kernel.org,si.yanteng@linux.dev,simona.vetter@ffwll.ch,peterz@infradead.org,peterx@redhat.com,pasha.tatashin@soleen.com,oleg@redhat.com,mhiramat@kernel.org,lyude@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kherbst@redhat.com,jhubbard@nvidia.com,jglisse@redhat.com,jgg@nvidia.com,jannh@google.com,dakr@kernel.org,corbet@lwn.net,apopple@nvidia.com,alexs@kernel.org,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-detect-writability-in-restore_exclusive_pte-through-can_change_pte_writable.patch added to mm-unstable branch
Message-Id: <20250210230602.3A762C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: detect writability in restore_exclusive_pte() through can_change_pte_writable()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-detect-writability-in-restore_exclusive_pte-through-can_change_pte_writable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-detect-writability-in-restore_exclusive_pte-through-can_change_pte_writable.patch

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
Subject: mm/memory: detect writability in restore_exclusive_pte() through can_change_pte_writable()
Date: Mon, 10 Feb 2025 20:37:47 +0100

Let's do it just like mprotect write-upgrade or during NUMA-hinting faults
on PROT_NONE PTEs: detect if the PTE can be writable by using
can_change_pte_writable().

Set the PTE only dirty if the folio is dirty: we might not necessarily
have a write access, and setting the PTE writable doesn't require setting
the PTE dirty.

>From a CPU perspective, these entries are clean.  So only set the PTE
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

 mm/memory.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-memory-detect-writability-in-restore_exclusive_pte-through-can_change_pte_writable
+++ a/mm/memory.c
@@ -725,18 +725,21 @@ static void restore_exclusive_pte(struct
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


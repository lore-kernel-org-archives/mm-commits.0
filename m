Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070EA2586FA
	for <mm-commits@vger.kernel.org>; Mon, 10 Feb 2025 23:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739228785; cv=none; b=RVS/YWsvwDWDnpCjk2K9aKxpIF5+vmS6oJlMxIu8eLZP73h/nFJG+oOQPR9w+pVsLX7aa4UW1WhIjlmGqUSOCgkJQIFbnMz4aDHsjpa4xVjcx4HZHJFc46vrOB6AmTTW53amPDsBc3jqdCvr93qANd35HGCsZYxpPVuRLVv/8V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739228785; c=relaxed/simple;
	bh=EjOhZZQkqPoMj4XWlVFsVM4ChtxuhHte1GDqlF+HeKM=;
	h=Date:To:From:Subject:Message-Id; b=rXh73aVHd/VGdF5yERUGzauszeXeK9JCuu5Fw2GgD/N1wf0+VC7gC6yrQZT3grJ8G18OIMMjZGzt8Wd6LJuAxmyDwmX7n5SoBf+uVrOxeScamo4SaIbgXCTdkD6yaNhlcQ19kTauIQt+yuv3K26hDdFYT38kya2i6wHL1up2r24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KxKh95Ge; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KxKh95Ge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75171C4CED1;
	Mon, 10 Feb 2025 23:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739228784;
	bh=EjOhZZQkqPoMj4XWlVFsVM4ChtxuhHte1GDqlF+HeKM=;
	h=Date:To:From:Subject:From;
	b=KxKh95Gel8kKlBLFzwxEPzHx3QWQWkomPoeNzsvLCuFkK/MZxMR+20Iq2EhxIb/Le
	 lNCxOVqvr3lQuOfSpJEVifP9i7Uddr9m8tvNif0nw5X0lh+nb71/36qXAcDeuKfnfX
	 Y/i4bO3iuTVdU1j/pObwZp3yURCihjT4F/lbgWTc=
Date: Mon, 10 Feb 2025 15:06:23 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,sj@kernel.org,si.yanteng@linux.dev,simona.vetter@ffwll.ch,peterz@infradead.org,peterx@redhat.com,pasha.tatashin@soleen.com,oleg@redhat.com,mhiramat@kernel.org,lyude@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kherbst@redhat.com,jhubbard@nvidia.com,jglisse@redhat.com,jgg@nvidia.com,jannh@google.com,dakr@kernel.org,corbet@lwn.net,apopple@nvidia.com,alexs@kernel.org,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-handle-device-exclusive-entries-correctly-in-damon_folio_young_one.patch added to mm-unstable branch
Message-Id: <20250210230624.75171C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: handle device-exclusive entries correctly in damon_folio_young_one()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-handle-device-exclusive-entries-correctly-in-damon_folio_young_one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-handle-device-exclusive-entries-correctly-in-damon_folio_young_one.patch

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
Subject: mm/damon: handle device-exclusive entries correctly in damon_folio_young_one()
Date: Mon, 10 Feb 2025 20:37:56 +0100

Ever since commit b756a3b5e7ea ("mm: device exclusive memory access") we
can return with a device-exclusive entry from page_vma_mapped_walk().

damon_folio_young_one() is not prepared for that, so teach it about these
PFN swap PTEs.  Note that device-private entries are so far not applicable
on that path, as we expect ZONE_DEVICE pages so far only in migration code
when it comes to the RMAP.

The impact is rather small: we'd be calling pte_young() on a non-present
PTE, which is not really defined to have semantic.

Note that we could currently only run into this case with device-exclusive
entries on THPs.  We still adjust the mapcount on conversion to
device-exclusive; this makes the rmap walk abort early for small folios,
because we'll always have !folio_mapped() with a single device-exclusive
entry.  We'll adjust the mapcount logic once all page_vma_mapped_walk()
users can properly handle device-exclusive entries.

Link: https://lkml.kernel.org/r/20250210193801.781278-15-david@redhat.com
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

 mm/damon/paddr.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/damon/paddr.c~mm-damon-handle-device-exclusive-entries-correctly-in-damon_folio_young_one
+++ a/mm/damon/paddr.c
@@ -92,12 +92,20 @@ static bool damon_folio_young_one(struct
 {
 	bool *accessed = arg;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, addr, 0);
+	pte_t pte;
 
 	*accessed = false;
 	while (page_vma_mapped_walk(&pvmw)) {
 		addr = pvmw.address;
 		if (pvmw.pte) {
-			*accessed = pte_young(ptep_get(pvmw.pte)) ||
+			pte = ptep_get(pvmw.pte);
+
+			/*
+			 * PFN swap PTEs, such as device-exclusive ones, that
+			 * actually map pages are "old" from a CPU perspective.
+			 * The MMU notifier takes care of any device aspects.
+			 */
+			*accessed = (pte_present(pte) && pte_young(pte)) ||
 				!folio_test_idle(folio) ||
 				mmu_notifier_test_young(vma->vm_mm, addr);
 		} else {
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


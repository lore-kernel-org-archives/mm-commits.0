Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A6E2586FA
	for <mm-commits@vger.kernel.org>; Mon, 10 Feb 2025 23:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739228782; cv=none; b=tahSViEGiziaH705LKVBp2FIfW+CEfTmFxa9EUstvZhb+Op+W4jgcU3oaztKwGumVNGorhUbCXvLJEzguSxtR7FOuUrIfvMqHtLtEjusW30RW7EeGpfAdPWioM8Bu2bGnhf1BacuCS+sqQZd+t6go+OfcpRc80rDKH5BURqliiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739228782; c=relaxed/simple;
	bh=8TuJiWSf4roC7tQJkWrRbFCwCfmyDz4Xsk2DnvgC6tc=;
	h=Date:To:From:Subject:Message-Id; b=USBd1imVHx2F1TLK55qKcdNhCSeUS5COzUNQ3BhD7NwYLcWIAUlihhBihsF/4uIxhr5pumN+NE7PG/6oykRxq5b7a6RcidKpr6MtwjFb2vMP5WbFAteh4PrV7FCmb/EL5sFMJeUaMnEqG8UJ4tBOUaSMdMN+CUciou2gz7EDWOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LCxMSPU+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LCxMSPU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41064C4CED1;
	Mon, 10 Feb 2025 23:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739228782;
	bh=8TuJiWSf4roC7tQJkWrRbFCwCfmyDz4Xsk2DnvgC6tc=;
	h=Date:To:From:Subject:From;
	b=LCxMSPU+h3QX7SeU5cv6X9xw+EgtiLsqcPk0IRPycki53bM6gKbzCphcTv46G9rmm
	 kYJ3fpW7FNmjIgkZ36XGhvIhR4/Ecu96i3NLBmQ4d4fBsTmXzlASHLQKOW2itkEwP7
	 5vVxLwJ1Wlt9e8RZkRXCjkLQmIvt12RbpmvFlFUE=
Date: Mon, 10 Feb 2025 15:06:21 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,sj@kernel.org,si.yanteng@linux.dev,simona.vetter@ffwll.ch,peterz@infradead.org,peterx@redhat.com,pasha.tatashin@soleen.com,oleg@redhat.com,mhiramat@kernel.org,lyude@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kherbst@redhat.com,jhubbard@nvidia.com,jglisse@redhat.com,jgg@nvidia.com,jannh@google.com,dakr@kernel.org,corbet@lwn.net,apopple@nvidia.com,alexs@kernel.org,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_idle-handle-device-exclusive-entries-correctly-in-page_idle_clear_pte_refs_one.patch added to mm-unstable branch
Message-Id: <20250210230622.41064C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_idle: handle device-exclusive entries correctly in page_idle_clear_pte_refs_one()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_idle-handle-device-exclusive-entries-correctly-in-page_idle_clear_pte_refs_one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_idle-handle-device-exclusive-entries-correctly-in-page_idle_clear_pte_refs_one.patch

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
Subject: mm/page_idle: handle device-exclusive entries correctly in page_idle_clear_pte_refs_one()
Date: Mon, 10 Feb 2025 20:37:55 +0100

Ever since commit b756a3b5e7ea ("mm: device exclusive memory access") we
can return with a device-exclusive entry from page_vma_mapped_walk().

page_idle_clear_pte_refs_one() is not prepared for that, so let's teach it
what to do with these PFN swap PTEs.  Note that device-private entries are
so far not applicable on that path, as page_idle_get_folio() filters out
non-lru folios.

Should we just skip PFN swap PTEs completely?  Possible, but it seems
straight forward to just handle them correctly.

Note that we could currently only run into this case with device-exclusive
entries on THPs.  We still adjust the mapcount on conversion to
device-exclusive; this makes the rmap walk abort early for small folios,
because we'll always have !folio_mapped() with a single device-exclusive
entry.  We'll adjust the mapcount logic once all page_vma_mapped_walk()
users can properly handle device-exclusive entries.

Link: https://lkml.kernel.org/r/20250210193801.781278-14-david@redhat.com
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

 mm/page_idle.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/page_idle.c~mm-page_idle-handle-device-exclusive-entries-correctly-in-page_idle_clear_pte_refs_one
+++ a/mm/page_idle.c
@@ -62,9 +62,14 @@ static bool page_idle_clear_pte_refs_one
 			/*
 			 * For PTE-mapped THP, one sub page is referenced,
 			 * the whole THP is referenced.
+			 *
+			 * PFN swap PTEs, such as device-exclusive ones, that
+			 * actually map pages are "old" from a CPU perspective.
+			 * The MMU notifier takes care of any device aspects.
 			 */
-			if (ptep_clear_young_notify(vma, addr, pvmw.pte))
-				referenced = true;
+			if (likely(pte_present(ptep_get(pvmw.pte))))
+				referenced |= ptep_test_and_clear_young(vma, addr, pvmw.pte);
+			referenced |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 			if (pmdp_clear_young_notify(vma, addr, pvmw.pmd))
 				referenced = true;
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


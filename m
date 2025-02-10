Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EEB2586FA
	for <mm-commits@vger.kernel.org>; Mon, 10 Feb 2025 23:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739228773; cv=none; b=k/bzYnNxiHqs/90mCxra3CWBdKlRU0JFv6XDum3QDQ7jZqKGlyNYThKQIE/HknpYmtvSW4Kwq1pTTGykKVOkyWlJ+wvAiaOjL+2TPUiqnUSMl+Ml1OagUEnceqwC5f7pfcMVyEIzhDVj4BXvvmuElODyWo3mPO/lOwuwkmMWLXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739228773; c=relaxed/simple;
	bh=KIY98H9m3uksbCq9JyeUudSvfXh4Knn37HxlWTuSXKI=;
	h=Date:To:From:Subject:Message-Id; b=tci0QkJmCmZbt8pXQgyjpDVG6gUJCMp31KLNbXLtVlo5xuRGjNk4bluLoc+Bm/fq5t4j1CZAjlhcfzV09av2iTBYzcqCkdhBmQombXuSoTj9uPVN0PjnGFu2CkRkQWbJxAKCG6TmoBnhzijrXbLQVDSGlJ/RUNOcSRYsf83pMHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BvRNvRe9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BvRNvRe9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0448BC4CED1;
	Mon, 10 Feb 2025 23:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739228773;
	bh=KIY98H9m3uksbCq9JyeUudSvfXh4Knn37HxlWTuSXKI=;
	h=Date:To:From:Subject:From;
	b=BvRNvRe9PSAFfxzA5C234unq7KznJJXyJXwc3anu3TGKd/m1ynTvltrwDSCpsjoO0
	 9Uunw0DKR94D03wHeJsT7IVc4SEPYh+EjOueyGCy4wtc39aBL714ALMDPaBMSn8ALs
	 NVaeh6nNj5mkBwZqGIeW/TxafEnO7QMuyz5jUtXM=
Date: Mon, 10 Feb 2025 15:06:12 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,sj@kernel.org,si.yanteng@linux.dev,simona.vetter@ffwll.ch,peterz@infradead.org,peterx@redhat.com,pasha.tatashin@soleen.com,oleg@redhat.com,mhiramat@kernel.org,lyude@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kherbst@redhat.com,jhubbard@nvidia.com,jglisse@redhat.com,jgg@nvidia.com,jannh@google.com,dakr@kernel.org,corbet@lwn.net,apopple@nvidia.com,alexs@kernel.org,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-handle-device-exclusive-entries-correctly-in-write_protect_page.patch added to mm-unstable branch
Message-Id: <20250210230613.0448BC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: handle device-exclusive entries correctly in write_protect_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-handle-device-exclusive-entries-correctly-in-write_protect_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-handle-device-exclusive-entries-correctly-in-write_protect_page.patch

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
Subject: mm/ksm: handle device-exclusive entries correctly in write_protect_page()
Date: Mon, 10 Feb 2025 20:37:51 +0100

Ever since commit b756a3b5e7ea ("mm: device exclusive memory access") we
can return with a device-exclusive entry from page_vma_mapped_walk().

write_protect_page() is not prepared for that, so teach it about these PFN
swap PTEs.  Note that device-private entries are so far not applicable on
that path, because GUP would never have returned such folios (conversion
to device-private happens by page migration, not in-place conversion of
the PTE).

There is a race between performing the folio_walk (which fails on
non-present PTEs) and locking the folio to look it up using
page_vma_mapped_walk() again, so this is likely a fix (unless something
else could prevent that race, but it doesn't look like).  In the future it
could be handled if ever required, for now just give up and ignore them
like folio_walk would.

Link: https://lkml.kernel.org/r/20250210193801.781278-10-david@redhat.com
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

 mm/ksm.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/ksm.c~mm-ksm-handle-device-exclusive-entries-correctly-in-write_protect_page
+++ a/mm/ksm.c
@@ -1270,8 +1270,15 @@ static int write_protect_page(struct vm_
 	if (WARN_ONCE(!pvmw.pte, "Unexpected PMD mapping?"))
 		goto out_unlock;
 
-	anon_exclusive = PageAnonExclusive(&folio->page);
 	entry = ptep_get(pvmw.pte);
+	/*
+	 * Handle PFN swap PTEs, such as device-exclusive ones, that actually
+	 * map pages: give up just like the next folio_walk would.
+	 */
+	if (unlikely(!pte_present(entry)))
+		goto out_unlock;
+
+	anon_exclusive = PageAnonExclusive(&folio->page);
 	if (pte_write(entry) || pte_dirty(entry) ||
 	    anon_exclusive || mm_tlb_flush_pending(mm)) {
 		swapped = folio_test_swapcache(folio);
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


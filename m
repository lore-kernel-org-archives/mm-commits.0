Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793768275;
	b=Qyw6r24rb8J8F5+a2jWfe0uOakje25Y2iZYRQExTmgrygqb7C9aumgDt4qtzBqWJxXsH
	 hgOqHR4NlWrqJ9FJRYN9rkMEvoZ2tbTVeSKHfbPcnR4liD8ssYRc3pbrqGYZtSR76saYB
	 tmZNm48cpBKYiRTosjLRuRoeLYUH2IEvqlu5HwVHoY2eBOeHK6Gu8LuQ6vdcTVQkvWLxe
	 ZqpsxSMrGl95eHwtqVPjrzUjJy/fANe7pPHZXgKR3Fn8ufSS3HkOwix1VzKMSV4ox8KCM
	 ghDhjPOKxlZNA8jCpViaItegBV1Zt4jwER0VZ+wJ5sYlcuXoAHM3Nar3KBrZdf7e+8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793768275;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=AVGRVfxRuWzcEsvbhCfWvK6UcTncYsy5J83is/iQk5A=;
	b=ltcdiVjT4O7Zhp3yABaf7RgbusOqm+9l98yGBLScNyZXHga8H59iQHKs7snolFDMXQRO
	 h/KmSynvGhP+5Bd/hti4Kh+5bRi9IBVTvyNrL/NEg9XtLEaOUlPFAw6JOli8scA3/0UEI
	 REyclo9y0kHBlf6zhN1jdKKDt76WLNvfyzBO6mGcufECssabA4rZhdi1UrBHw4GXqDiky
	 3UAr0VzibfRlEN763KnPfsZJJ8C+gUSZ+dVSKbiFm1wTIzaLHjGrpJlMkvnEXkTbok0Cw
	 ARFp8XMQSmlYz2taiBjhPAD0reuUugRF70MoKMoBs5JjkI4tY0IYM3Z0EV7H1556A+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="HKgs4J/7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9208C606A329
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 04:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HKgs4J/7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2665D1F000C1;
	Wed,  4 Nov 2026 04:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793768275;
	bh=AVGRVfxRuWzcEsvbhCfWvK6UcTncYsy5J83is/iQk5A=;
	h=Date:To:From:Subject;
	b=HKgs4J/7hZO+4ZnJJsFZ+ImPD959G7KE1Ei77tlTXiGyG60tQn8K3C5zPaL0HFgSq
	 LrIa8syBYsydAucEz1P25kG9cliPfTc9Ypxlk4P26U6eTXjpxBwvLxeEzmIoKBH+xJ
	 7cdgtXwme/weDPKkJ4qJmNE+l/kklodcA5JV4KI8=
Date: Tue, 03 Nov 2026 20:57:54 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,qi.zheng@linux.dev,
	osalvador@suse.de,lance.yang@linux.dev,jthoughton@google.com,
	david@kernel.org,chenhuacai@kernel.org,muchun.song@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-rename-vmemmap_remap_pte-to-vmemmap_optimize_pte.patch added to mm-new branch
Message-Id: <20261104045755.2665D1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: hugetlb_vmemmap: rename vmemmap_remap_pte() to vmemmap_optimize_pte()
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb_vmemmap-rename-vmemmap_remap_pte-to-vmemmap_optimize_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-rename-vmemmap_remap_pte-to-vmemmap_optimize_pte.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm: hugetlb_vmemmap: rename vmemmap_remap_pte() to vmemmap_optimize_pte()
Date: Wed, 04 Nov 2026 10:35:04 +0800

Both optimization and restoration update vmemmap PTEs by remapping them,
so "remap" does not identify the callback's role.  Use "optimize" for the
optimization callback to match "restore" and make the two directions
explicit and consistent.

No functional change intended.

Link: https://lore.kernel.org/20261104023510.260766-7-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: James Houghton <jthoughton@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
---

 mm/hugetlb_vmemmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-rename-vmemmap_remap_pte-to-vmemmap_optimize_pte
+++ a/mm/hugetlb_vmemmap.c
@@ -213,8 +213,8 @@ static struct page *vmemmap_dup_page_fro
 	return dst;
 }
 
-static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
-			      struct vmemmap_remap_walk *walk)
+static void vmemmap_optimize_pte(pte_t *pte, unsigned long addr,
+		struct vmemmap_remap_walk *walk)
 {
 	struct page *page = pte_page(ptep_get(pte));
 	pte_t entry;
@@ -302,7 +302,7 @@ static int vmemmap_remap_free(unsigned l
 {
 	int ret;
 	struct vmemmap_remap_walk walk = {
-		.remap_pte	= vmemmap_remap_pte,
+		.remap_pte	= vmemmap_optimize_pte,
 		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= flags,
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch
mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only.patch
powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only.patch
mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo.patch
mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios.patch
mm-generalize-kernel-pte-table-allocation.patch
mm-generalize-pmd-page-table-allocation.patch
mm-generalize-pud-page-table-allocation.patch
mm-remove-pagetable_dtor_free.patch
mm-remove-redundant-pagetable_dtor-calls.patch
mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros.patch
mm-hugetlb_vmemmap-unify-vmemmap_splitremap_no_tlb_flush.patch
mm-hugetlb_vmemmap-simplify-vmemmap-head-page-handling.patch
mm-hugetlb_vmemmap-generalize-vmemmap-page-allocation.patch
mm-hugetlb_vmemmap-unify-writable-vmemmap-page-preparation.patch
mm-hugetlb_vmemmap-rename-vmemmap_remap_pte-to-vmemmap_optimize_pte.patch
mm-hugetlb_vmemmap-simplify-shared-tail-page-handling.patch
mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch
mm-hugetlb_vmemmap-make-vmemmap-optimization-folio-oriented.patch
mm-hugetlb_vmemmap-make-vmemmap-restoration-folio-oriented.patch
mm-hugetlb_vmemmap-unify-vmemmap-range-restoration.patch
mm-hugetlb_vmemmap-make-vmemmap-pte-conversion-folio-oriented.patch


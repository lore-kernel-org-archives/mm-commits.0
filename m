Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1A07E1
	for <mm-commits@vger.kernel.org>; Mon, 29 Jul 2024 23:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722295888; cv=none; b=PU1l8E7UajQNq2hr4ikJPma4bKK7Q6DX5iqcdN+aARUHTaKEly9dqEjwVTAzKzbH8AHPQliLyXLyS2WT4m+oM/DM4neKQysPr3TvE7LBhBg/U4depWQDJCnZpilccjRSqQOEmGT/5sz7m+40ps8MyDnAlA1HUorM5xIdXXCzJ9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722295888; c=relaxed/simple;
	bh=EdMThh3+rVxBiJ+F7RV5Q0zQmOR5kYsgXy8WqK0tcUM=;
	h=Date:To:From:Subject:Message-Id; b=mjtjBdpDoK8MSPUizy1R54+kuEurr1qU4sHprwBpjdzAnOZJns3qEcmZy3n7vbTMZFGRFAg9rbZEGylWBJoCWvE5SXTtRXebXANCmGol6c4V8NZhHc6VjGaZGA/IN5gNY0wsFcPn3wPABT5Ixglh9ztKT74jiBQdqNuQcm1+rOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dnpuIk97; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dnpuIk97"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09189C32786;
	Mon, 29 Jul 2024 23:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722295888;
	bh=EdMThh3+rVxBiJ+F7RV5Q0zQmOR5kYsgXy8WqK0tcUM=;
	h=Date:To:From:Subject:From;
	b=dnpuIk97YEKyllJkf+5WQg7E/6aXMdqK2zncf6Djdy1lEdh1nAbPVhxsd6fLb51zo
	 RpZnNltOf7DM09YSbulnWTqc7/hU0Itxv/6WodAfmlXULBP+qBaGQ0bzd4BX8MoGN8
	 vxCyv7w95JP73JgkLdVlDJipfTx3avVXHdhH8oVs=
Date: Mon, 29 Jul 2024 16:31:27 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,peterx@redhat.com,muchun.song@linux.dev,mhocko@suse.com,donettom@linux.ibm.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-teach-generic_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch added to mm-unstable branch
Message-Id: <20240729233128.09189C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmap: teach generic_get_unmapped_area{_topdown} to handle hugetlb mappings
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-teach-generic_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-teach-generic_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch

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
From: Oscar Salvador <osalvador@suse.de>
Subject: mm/mmap: teach generic_get_unmapped_area{_topdown} to handle hugetlb mappings
Date: Mon, 29 Jul 2024 11:10:10 +0200

Patch series "Unify hugetlb into arch_get_unmapped_area functions", v2.

This is an attempt to get rid of a fair amount of duplicated code wrt. 
hugetlb and *get_unmapped_area* functions.

HugeTLB registers a .get_unmapped_area function which gets called from
__get_unmapped_area().

hugetlb_get_unmapped_area() is defined by a bunch of architectures and it
also has a generic definition for those that do not define it.  Short-long
story is that there is a ton of duplicated code between specific hugetlb
*_get_unmapped_area_* functions and mm-core functions, so we can do better
by teaching arch_get_unmapped_area* functions how to deal with hugetlb
mappings.

Note that not a lot of things need to be taught though. 
hugetlb_mmap_check_and_align(), that gets called for hugetlb mappings
prior to call mm_get_unmapped_area_vmflags(), runs some sanity checks and
aligns the addr to huge_page_size(), so we do not need to that down the
road in the respective {generic,arch}_get_unmapped_area* functions.

More information can be found in the respective patches.


This patch (of 9):

We want to stop special casing hugetlb mappings and make them go through
generic channels, so teach generic_get_unmapped_area{_topdown} to handle
those.

The main difference is that we set info.align_mask for huge mappings.

Link: https://lkml.kernel.org/r/20240729091018.2152-2-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   10 ++++++++++
 mm/mmap.c               |    4 ++++
 2 files changed, 14 insertions(+)

--- a/include/linux/hugetlb.h~mm-mmap-teach-generic_get_unmapped_area_topdown-to-handle-hugetlb-mappings
+++ a/include/linux/hugetlb.h
@@ -1026,9 +1026,19 @@ void hugetlb_unregister_node(struct node
  */
 bool is_raw_hwpoison_page_in_hugepage(struct page *page);
 
+static inline unsigned long huge_page_mask_align(struct file *file)
+{
+	return PAGE_MASK & ~huge_page_mask(hstate_file(file));
+}
+
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 
+static inline unsigned long huge_page_mask_align(struct file *file)
+{
+	return 0;
+}
+
 static inline struct hugepage_subpool *hugetlb_folio_subpool(struct folio *folio)
 {
 	return NULL;
--- a/mm/mmap.c~mm-mmap-teach-generic_get_unmapped_area_topdown-to-handle-hugetlb-mappings
+++ a/mm/mmap.c
@@ -762,6 +762,8 @@ generic_get_unmapped_area(struct file *f
 	info.length = len;
 	info.low_limit = mm->mmap_base;
 	info.high_limit = mmap_end;
+	if (filp && is_file_hugepages(filp))
+		info.align_mask = huge_page_mask_align(filp);
 	return vm_unmapped_area(&info);
 }
 
@@ -810,6 +812,8 @@ generic_get_unmapped_area_topdown(struct
 	info.length = len;
 	info.low_limit = PAGE_SIZE;
 	info.high_limit = arch_get_mmap_base(addr, mm->mmap_base);
+	if (filp && is_file_hugepages(filp))
+		info.align_mask = huge_page_mask_align(filp);
 	addr = vm_unmapped_area(&info);
 
 	/*
_

Patches currently in -mm which might be from osalvador@suse.de are

mm-mmap-teach-generic_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch
arch-s390-teach-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch
arch-x86-teach-arch_get_unmapped_area_vmflags-to-handle-hugetlb-mappings.patch
arch-sparc-teach-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch
arch-powerpc-teach-book3s64-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch
mm-make-hugetlb-mappings-go-through-mm_get_unmapped_area_vmflags.patch
mm-drop-hugetlb_get_unmapped_area_-functions.patch
arch-s390-clean-up-hugetlb-definitions.patch
mm-consolidate-common-checks-in-hugetlb_mmap_check_and_align.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F9E189BBD
	for <mm-commits@vger.kernel.org>; Mon,  7 Oct 2024 21:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728335252; cv=none; b=K1FPnU8CnhYEY4U1i4vByd+WHG4Z68SYsxLc8VO2uLsAWhVbJzPA39SFCxFSyFlhGAuIghLyZIDjnm/2u43fo9bHnWkiuBNgRAI0pAX2ltCQuTDumGimHyLMXoTKkxDWs6AuBbsWdl2rtGhWFrRp8e9s2o8HyjWYtWN5ot5Bb2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728335252; c=relaxed/simple;
	bh=NC/eyf6i+K141Xj2qsCtG9YrjT8cnDV2/Z4k86E/XfU=;
	h=Date:To:From:Subject:Message-Id; b=mFIC/RU97rPQ7T08JxBcN35oAbqaCYvfdqqr0dQfUe1Qa3y27nOAraV+oIDc+oyLqACBQi1wHPmxibQP0pO8rDEXAExVMKM95b1qlZS4OLxbvveQ/28P+xs3jAZYN405jwqJ0OGPLDbxBYNQXX/KSLtsvewxjwT7E9k1VruixJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tw5N0DFI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tw5N0DFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD51C4CEC6;
	Mon,  7 Oct 2024 21:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728335251;
	bh=NC/eyf6i+K141Xj2qsCtG9YrjT8cnDV2/Z4k86E/XfU=;
	h=Date:To:From:Subject:From;
	b=Tw5N0DFI4KfLxfZ9FJ8p3DLd9vAIYncgkeA+Dxz63rSibh2NZrVvXsfwLi3wlAjOA
	 moFGj0gHNlfspSpFyhRdIRObZLbK36shcYpyefFJPFA9Rh0j6r8qaM3k6aANB41pv+
	 zyz0hHnyRG3Rg3CYaDA+JxXxIO0gyGVXhfr9NYIg=
Date: Mon, 07 Oct 2024 14:07:30 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterx@redhat.com,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,donettom@linux.ibm.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-teach-generic_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch added to mm-unstable branch
Message-Id: <20241007210731.6FD51C4CEC6@smtp.kernel.org>
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
Date: Mon, 7 Oct 2024 09:50:29 +0200

Patch series "Unify hugetlb into arch_get_unmapped_area functions", v4.

This is an attempt to get rid of a fair amount of duplicated code wrt. 
hugetlb and *get_unmapped_area* functions.

HugeTLB registers a .get_unmapped_area function which gets called from
__get_unmapped_area().
hugetlb_get_unmapped_area() is defined by a bunch of architectures and
it also has a generic definition for those that do not define it.
Short-long story is that there is a ton of duplicated code between
specific hugetlb *_get_unmapped_area_* functions and mm-core functions,
so we can do better by teaching arch_get_unmapped_area* functions how
to deal with hugetlb mappings.

Note that not a lot of things need to be taught though. 
hugetlb_get_unmapped_area, that gets called for hugetlb mappings, runs
some sanity checks prior to calling mm_get_unmapped_area_vmflags(), so we
do not need to that down the road in the respective
{generic,arch}_get_unmapped_area* functions.

More information can be found in the respective patches.

LTP mmapstress hugetlb selftests were ran succesfully on:


This patch (of 9):

We want to stop special casing hugetlb mappings and make them go through
generic channels, so teach generic_get_unmapped_area{_topdown} to handle
those.  The main difference is that we set info.align_mask for huge
mappings.

Link: https://lkml.kernel.org/r/20241007075037.267650-1-osalvador@suse.de
Link: https://lkml.kernel.org/r/20241007075037.267650-2-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
@@ -1035,9 +1035,19 @@ void hugetlb_unregister_node(struct node
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
@@ -776,6 +776,8 @@ generic_get_unmapped_area(struct file *f
 	info.low_limit = mm->mmap_base;
 	info.high_limit = mmap_end;
 	info.start_gap = stack_guard_placement(vm_flags);
+	if (filp && is_file_hugepages(filp))
+		info.align_mask = huge_page_mask_align(filp);
 	return vm_unmapped_area(&info);
 }
 
@@ -826,6 +828,8 @@ generic_get_unmapped_area_topdown(struct
 	info.low_limit = PAGE_SIZE;
 	info.high_limit = arch_get_mmap_base(addr, mm->mmap_base);
 	info.start_gap = stack_guard_placement(vm_flags);
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
mm-consolidate-common-checks-in-hugetlb_get_unmapped_area.patch


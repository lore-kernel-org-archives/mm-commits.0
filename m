Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F12E155C97
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854770; cv=none; b=HC4rbDufdtnxhspDfoo3jE5ND6/vcaqbkH79SIMS3CQAvlJq9EjcpfnL7sRRUyW8Q74A8YbNYJP83egpvLCRsj5tGCpghHXt5Eewn8Yn5XpJGpp6bEMBzbJpCwCGw9qGEY9V5ciJaD4UYtsCYwEV0cZwa9L8KaNpHSuGq4czzWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854770; c=relaxed/simple;
	bh=mjCVa+8j9P0gFbL3wqZWj5Z687FZiVJo/N9WjTfcSGU=;
	h=Date:To:From:Subject:Message-Id; b=Uu9Fx01czev/kVTj1M5IO84dX8iuQ7WdRQJeSJT8C8633Cq2EkBlHGgFysyHul0kiTeJJ79g5xS/FDdK5/WG/VRMpgzlP/3rqhvWMAvgO+IT9qwrE/NX9zq87J6r9o51xhHPi161zcxwejjbeNlmyOYc9bauu0iAsATd4/92vCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZEew78Dr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZEew78Dr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26493C4CECF;
	Wed,  6 Nov 2024 00:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854770;
	bh=mjCVa+8j9P0gFbL3wqZWj5Z687FZiVJo/N9WjTfcSGU=;
	h=Date:To:From:Subject:From;
	b=ZEew78DrFWLC3WuY0SAecfGGRlzRngMazYLDXEQ+JphYcreT9EfI7+7o4aOoqH/vx
	 Wy4NaGFWb3dYy6yXHXs4U01XM89+boNvPepXwq1/BK4YyI9/1D5KkyW+dk0g5qim/Z
	 ao1th9objFsOUP14CjW35vhWqjpamYM+SB0zY2MQ=
Date: Tue, 05 Nov 2024 16:59:29 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterx@redhat.com,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,donettom@linux.ibm.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-teach-generic_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch removed from -mm tree
Message-Id: <20241106005930.26493C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmap: teach generic_get_unmapped_area{_topdown} to handle hugetlb mappings
has been removed from the -mm tree.  Its filename was
     mm-mmap-teach-generic_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



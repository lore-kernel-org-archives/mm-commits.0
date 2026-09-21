Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBABA46D551
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 22:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030987; cv=none; b=szWrhzs8lnBpYqW6muVhnOjacauHzvK0N8yISiJ/i5NpbUBAm9jqgZdvzmMQ/oYy5NN1wpyV67Y/c9KebfHUX7OTjFDn+uPRvmw/uvR52lumX1XaplughbjRzTtMnE0Ck5Db8OBlQ46cDMwQ3fN7yKWmN97sRNhMgZn/wpmyRHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030987; c=relaxed/simple;
	bh=RX2uMcVoA9aK9b6o2W2u33ZQXkKif2SGoGqKkJF3Z0A=;
	h=Date:To:From:Subject:Message-Id; b=QV8VYHmbQQfm2C7K4i4mGOCQT+gEgUUILvOEf5EaiV46jzCMwXzQCfdbVPvujWpZudt2LgJvfjRh9hm3nfFjog2nCLL+Qj0FIaj85WETVVHYJWYaeF93rNGC8rSV9ewTCOS7l2a2hpl3nFWOADwwjFgR3Fl/6MhGpM0F4MD60bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R/5NgiGb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R/5NgiGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614DE1F00893;
	Mon, 21 Sep 2026 22:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790030985;
	bh=2QFPhQtUMrpyxZIc50+nyLDomzsMHXgNladvqJOCl78=;
	h=Date:To:From:Subject;
	b=R/5NgiGb5Sy/YiMLd94GOBjk9hqwiO7exoA2H35JS9X8RV/iGm+acJVq2u835dOoc
	 SndIbz6Vv7wcn4Q7DZgqwSk15fnVVAtFaReuiJkt/yXun0PV9byjFYE5rVjjXmC6eB
	 4HNVVPdiJDCnAjOwdbPdangBPp0xYQwHBbZ/MDVw=
Date: Mon, 21 Sep 2026 15:49:45 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-move-__highest_used_section_nr-handling.patch added to mm-new branch
Message-Id: <20260921224945.614DE1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: move __highest_used_section_nr handling
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-move-__highest_used_section_nr-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-move-__highest_used_section_nr-handling.patch

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/sparse: move __highest_used_section_nr handling
Date: Mon, 21 Sep 2026 21:59:00 +0200

In preparation for removing __section_mark_present(), let's move
__highest_used_section_nr handling into its callers.  Verify in
sparse_init_one_section() that it was properly updated.

In sparse_sections_init() we can just set it to the last processed
section_nr.

No functional change intended.

Link: https://lore.kernel.org/20260921-b4-sparsemem_cleanups-v2-8-54d81d65e125@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
---

 mm/sparse-vmemmap.c |    1 +
 mm/sparse.c         |    5 +++--
 mm/sparse.h         |    4 +---
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/mm/sparse.c~mm-sparse-move-__highest_used_section_nr-handling
+++ a/mm/sparse.c
@@ -177,7 +177,7 @@ static inline unsigned long first_presen
 
 void __init sparse_sections_init(void)
 {
-	unsigned long pfn, start_pfn, end_pfn;
+	unsigned long pfn, start_pfn, end_pfn, section_nr;
 	int i, nid;
 
 	sparse_extreme_init();
@@ -187,9 +187,9 @@ void __init sparse_sections_init(void)
 		mminit_validate_memmodel_limits(&start_pfn, &end_pfn);
 
 		for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
-			unsigned long section_nr = pfn_to_section_nr(pfn);
 			struct mem_section *ms;
 
+			section_nr = pfn_to_section_nr(pfn);
 			sparse_index_init(section_nr, nid);
 			ms = __nr_to_section(section_nr);
 			if (ms->section_mem_map)
@@ -201,6 +201,7 @@ void __init sparse_sections_init(void)
 			__section_mark_present(ms, section_nr);
 		}
 	}
+	__highest_used_section_nr = section_nr;
 }
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
 struct page __init *__populate_section_memmap(unsigned long pfn,
--- a/mm/sparse.h~mm-sparse-move-__highest_used_section_nr-handling
+++ a/mm/sparse.h
@@ -26,6 +26,7 @@ static inline void sparse_init_one_secti
 	unsigned long coded_mem_map;
 
 	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
+	VM_WARN_ON_ONCE(section_nr > __highest_used_section_nr);
 
 	/*
 	 * We encode the start PFN of the section into the mem_map such that
@@ -44,9 +45,6 @@ static inline void sparse_init_one_secti
 static inline void __section_mark_present(struct mem_section *ms,
 		unsigned long section_nr)
 {
-	if (section_nr > __highest_used_section_nr)
-		__highest_used_section_nr = section_nr;
-
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 }
 
--- a/mm/sparse-vmemmap.c~mm-sparse-move-__highest_used_section_nr-handling
+++ a/mm/sparse-vmemmap.c
@@ -865,6 +865,7 @@ int __meminit sparse_add_section(int nid
 		page_init_poison(memmap, sizeof(struct page) * nr_pages);
 
 	__section_mark_present(ms, section_nr);
+	__highest_used_section_nr = max(section_nr, __highest_used_section_nr);
 
 	/* Align memmap to section boundary in the subsection case */
 	if (section_nr_to_pfn(section_nr) != start_pfn)
_

Patches currently in -mm which might be from david@kernel.org are

maintainers-split-up-memory-management-memory-policy-and-migration.patch
maintainers-move-memory-tiering-under-memory-management-numa-placement.patch
maintainers-make-gregory-a-co-maintainer-of-memory-management-numa-placement.patch
selftests-mm-khugepaged-remove-str_dup-usage.patch
mm-sparse-move-mem_section-init-to-sparse_extreme_init.patch
mm-sparse-refactor-sparse_sections_init.patch
mm-sparse-move-initialization-of-section-metadata-to-sparse_metadata_init.patch
mm-sparse-rename-and-cleanup-sparse_init_nid.patch
mm-sparse-cleanup-sparse_init_one_section.patch
mm-sparse-rename-__highest_present_section_nr-to-__highest_used_section_nr.patch
mm-sparse-remove-pfn_in_present_section.patch
mm-sparse-move-__highest_used_section_nr-handling.patch
scripts-gdb-mmpy-remove-fallbacks-for-section_has_mem_map-and-section_is_early.patch
mm-sparse-remove-section_marked_present.patch
mm-sparse-remove-flags-parameter-from-sparse_init_one_section.patch
fs-proc-page-clarify-comment-in-get_max_dump_pfn.patch
mm-memory_hotplug-drop-config_have_arch_pfn_valid-handling-from-pfn_to_online_page.patch


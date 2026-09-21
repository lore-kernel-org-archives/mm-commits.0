Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7819846D551
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 22:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790031001; cv=none; b=M/Eigre8YU0ps5vk+FS0mPDwemcDQLiNvN5wjAOlyPum/eVIaUOQuPO1ik9pC1cHoWOMV178jG2r+95Dw68wnIiwnC+E4pnbYYptQcTuzWDEqkkAPTuGNBe4HWeO6QnImXXJFxfP6idZMsvlEHd4sWaGkeyXSMpmzyluBj0sLCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790031001; c=relaxed/simple;
	bh=XHejnW4CYFjYVKKcLPWMOfgjSODw40QWt9ICC1PbMz8=;
	h=Date:To:From:Subject:Message-Id; b=BRLQVazhAan9RvLL4cELmrvrJgTnmbu9NlF6ppGNL2yOkUajsMpbKGAtAvpCh4ILR+Bh4A9s5WsZjOIsVo/leENzgRbDzR4cYT0pkm9XFW5j9L7TI2wY4E42IlV42n4xcyDK9KHgWU13DWD8WpIr7tRpeUS0lvXyuesnPaxjGFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CxMKY9bu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CxMKY9bu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C781F000FF;
	Mon, 21 Sep 2026 22:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790030994;
	bh=SjjUi4cssDg7Dv4gpYr4k0tHu9OAEC1afKYXMumzT34=;
	h=Date:To:From:Subject;
	b=CxMKY9bu4DT7RvyTI1+LdE1b2g1TU+sOB10VHFYRhEsG/U2j9D86P9bDB19SP0IP2
	 pRHle/CzYImqM2n9N6OGL9uPw3u41JdIFrwf9uqkONKT+Dcv+e3He3GLYzr72HZ5Mn
	 6GsZQoKdazqddtA6h52GtCui/hlQliRxASlMzECs=
Date: Mon, 21 Sep 2026 15:49:54 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-remove-flags-parameter-from-sparse_init_one_section.patch added to mm-new branch
Message-Id: <20260921224954.72C781F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: remove flags parameter from sparse_init_one_section()
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-remove-flags-parameter-from-sparse_init_one_section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-remove-flags-parameter-from-sparse_init_one_section.patch

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
Subject: mm/sparse: remove flags parameter from sparse_init_one_section()
Date: Mon, 21 Sep 2026 21:59:03 +0200

The last user of the flags parameter that used to pass SECTION_IS_EARLY
was removed, so let's remove the parameter.

Link: https://lore.kernel.org/20260921-b4-sparsemem_cleanups-v2-11-54d81d65e125@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
---

 mm/sparse-vmemmap.c |    2 +-
 mm/sparse.c         |    2 +-
 mm/sparse.h         |    5 ++---
 3 files changed, 4 insertions(+), 5 deletions(-)

--- a/mm/sparse.c~mm-sparse-remove-flags-parameter-from-sparse_init_one_section
+++ a/mm/sparse.c
@@ -243,7 +243,7 @@ static void __init sparse_metadata_init_
 			      section_nr);
 		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
 		sparse_init_one_section(__nr_to_section(section_nr), section_nr,
-					mem_map, usage, 0);
+					mem_map, usage);
 		usage = (void *)usage + mem_section_usage_size();
 	}
 }
--- a/mm/sparse.h~mm-sparse-remove-flags-parameter-from-sparse_init_one_section
+++ a/mm/sparse.h
@@ -21,7 +21,7 @@ int sparse_index_init(unsigned long sect
 
 static inline void sparse_init_one_section(struct mem_section *ms,
 		unsigned long section_nr, struct page *mem_map,
-		struct mem_section_usage *usage, unsigned long flags)
+		struct mem_section_usage *usage)
 {
 	unsigned long coded_mem_map;
 
@@ -37,8 +37,7 @@ static inline void sparse_init_one_secti
 	VM_WARN_ON_ONCE(coded_mem_map & ~SECTION_MAP_MASK);
 
 	ms->section_mem_map &= ~SECTION_MAP_MASK;
-	ms->section_mem_map |= coded_mem_map;
-	ms->section_mem_map |= flags | SECTION_HAS_MEM_MAP;
+	ms->section_mem_map |= coded_mem_map | SECTION_HAS_MEM_MAP;
 	ms->usage = usage;
 }
 
--- a/mm/sparse-vmemmap.c~mm-sparse-remove-flags-parameter-from-sparse_init_one_section
+++ a/mm/sparse-vmemmap.c
@@ -869,7 +869,7 @@ int __meminit sparse_add_section(int nid
 	/* Align memmap to section boundary in the subsection case */
 	if (section_nr_to_pfn(section_nr) != start_pfn)
 		memmap = pfn_to_page(section_nr_to_pfn(section_nr));
-	sparse_init_one_section(ms, section_nr, memmap, ms->usage, 0);
+	sparse_init_one_section(ms, section_nr, memmap, ms->usage);
 
 	return 0;
 }
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


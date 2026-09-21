Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A7B46D551
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 22:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030980; cv=none; b=qf8XecxdMXi0+dmtOgxcrqqtPar+/7RGPLwcjMF0+Khfs7cpyJrkqJt7zexOfRtyNROkXsg5943QLuL9DfcgXNfR60A8hhHw5WQN9evLQAdkkMnBtbgY+PXWqtsjWSqnBH9ifYOKa9sRGe7Kz0oCIY9Jf4sSMIQrjCebfyDaMmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030980; c=relaxed/simple;
	bh=tccaq55EaFGexc5SwOMaB90NIVg3saIGFPShEjdBz28=;
	h=Date:To:From:Subject:Message-Id; b=HeWXO9t67YxkC+1BmX9cD05Vn/OUW/cgbpMzI6xndDRIH3iMb5mRq/ZsBd9g0PnVPMiuNbh42ANJbmWT/NvKzks/iYZOKlmPB2rihSZSml9Xz5LEM6Tj+wtNus5KsagqyNRG9KiPOp+ncWCgj2ukDqW07XtWlr1nERRUDc+rTvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g1OciXB4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g1OciXB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597DB1F000FF;
	Mon, 21 Sep 2026 22:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790030978;
	bh=9pMtZMIoscGk07LIEwoZ4iX5feMkcGfvbx92faLCOqg=;
	h=Date:To:From:Subject;
	b=g1OciXB4SKXg3XSZEFn+f7HdXYkInZMatFQ6tfellJwUEWGxIpGZjEI40bkgDMn7g
	 H77qH513Lb2SUdP44pKMVvQOUf79P3lpAOy5Hb+6OG4FptAT/+1LVpZMcIpTO6Tge0
	 5Tp0nquYX3JxEnNV3KaObcZgwi6NXKyFUUUSPEjA=
Date: Mon, 21 Sep 2026 15:49:37 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-cleanup-sparse_init_one_section.patch added to mm-new branch
Message-Id: <20260921224938.597DB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: cleanup sparse_init_one_section()
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-cleanup-sparse_init_one_section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-cleanup-sparse_init_one_section.patch

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
Subject: mm/sparse: cleanup sparse_init_one_section()
Date: Mon, 21 Sep 2026 21:58:57 +0200

Let's avoid the "pnum" terminology.

Link: https://lore.kernel.org/20260921-b4-sparsemem_cleanups-v2-5-54d81d65e125@kernel.org
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

 mm/sparse.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/sparse.h~mm-sparse-cleanup-sparse_init_one_section
+++ a/mm/sparse.h
@@ -20,7 +20,7 @@ void sparse_sections_init(void);
 int sparse_index_init(unsigned long section_nr, int nid);
 
 static inline void sparse_init_one_section(struct mem_section *ms,
-		unsigned long pnum, struct page *mem_map,
+		unsigned long section_nr, struct page *mem_map,
 		struct mem_section_usage *usage, unsigned long flags)
 {
 	unsigned long coded_mem_map;
@@ -32,7 +32,7 @@ static inline void sparse_init_one_secti
 	 * page_to_pfn() on !CONFIG_SPARSEMEM_VMEMMAP can simply subtract it
 	 * from the page pointer to obtain the PFN.
 	 */
-	coded_mem_map = (unsigned long)(mem_map - section_nr_to_pfn(pnum));
+	coded_mem_map = (unsigned long)(mem_map - section_nr_to_pfn(section_nr));
 	VM_WARN_ON_ONCE(coded_mem_map & ~SECTION_MAP_MASK);
 
 	ms->section_mem_map &= ~SECTION_MAP_MASK;
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


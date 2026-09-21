Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044293ED3B4
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 22:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030976; cv=none; b=QbWmi5k3MMS8wMPffZzn5LIee/OBiMtA4YvoNy1Wxb+2f7SqGs4Tcsf8BM9IhZU9SwmjYKdQJR2zFbIbOC14s1iFE2ZDSQerdT7Og24+r1M6urlQbHC6gunTmusD1ug/QXJGwjZU86HGHKZ9WOXVEH2MUXl5qv/yCrlQiNfnEAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030976; c=relaxed/simple;
	bh=zb0qinRzIOjwvSZWmPvkOSmWQ9cDx2q5+BQYn8FydUc=;
	h=Date:To:From:Subject:Message-Id; b=Oj2fkOv8/Ib1HZC2nWsfGdCBIOmUL6bKSWlj4kiufO+266jWxqlkriOwmIo2DYfzUz/wlVcNoxIRS5AKxMzGgMC4CbTztHqMcixgAnT6yhZPuI/mLPPhcQiEXyGcfFV0yLIS9rFTXQdorpUJYRqz/Tm3I8f3fYX5s/VbL0GWRVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eSSN1sG+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eSSN1sG+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0CC1F000FF;
	Mon, 21 Sep 2026 22:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790030974;
	bh=MvgFFcoDcgk9/HsEoR/K454ln9bJHqsunwWd9Q4FUU4=;
	h=Date:To:From:Subject;
	b=eSSN1sG+PxaKjx2LNvsxHLqc1r3WfGJ5xA0OFOebaNp6fQcSw6zUcOAuQ8ZoZvMMp
	 fnWprNw4fW9moDqjTiluNmSwnhvsjAFrMT18Wfj//wuTrZaDFmwOwDTpGR2Ul/1V2Z
	 uRLo/NNcD6S7FA49//UJLDCHG0zQ2Ylf9O26gPN4=
Date: Mon, 21 Sep 2026 15:49:34 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-move-initialization-of-section-metadata-to-sparse_metadata_init.patch added to mm-new branch
Message-Id: <20260921224934.6C0CC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: move initialization of section metadata to sparse_metadata_init()
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-move-initialization-of-section-metadata-to-sparse_metadata_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-move-initialization-of-section-metadata-to-sparse_metadata_init.patch

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
Subject: mm/sparse: move initialization of section metadata to sparse_metadata_init()
Date: Mon, 21 Sep 2026 21:58:55 +0200

Let's move the code responsible for initializing sparse metadata (usemap,
memmap) into a helper.  Cleanup the variable while at it (e.g.,
"map_count").

Drop the rather obvious code comments.

No functional change intended.

Link: https://lore.kernel.org/20260921-b4-sparsemem_cleanups-v2-3-54d81d65e125@kernel.org
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

 mm/sparse.c |   43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

--- a/mm/sparse.c~mm-sparse-move-initialization-of-section-metadata-to-sparse_metadata_init
+++ a/mm/sparse.c
@@ -255,38 +255,39 @@ static void __init sparse_init_nid(int n
 	}
 }
 
+static void __init sparse_metadata_init(void)
+{
+	unsigned long start_section_nr = first_present_section_nr();
+	int nid_begin = sparse_early_nid(__nr_to_section(start_section_nr));
+	unsigned long section_nr, nr_sections = 1;
+
+	for_each_present_section_nr(start_section_nr + 1, section_nr) {
+		const int nid = sparse_early_nid(__nr_to_section(section_nr));
+
+		if (nid == nid_begin) {
+			nr_sections++;
+			continue;
+		}
+		sparse_init_nid(nid_begin, start_section_nr, section_nr, nr_sections);
+		nid_begin = nid;
+		start_section_nr = section_nr;
+		nr_sections = 1;
+	}
+	sparse_init_nid(nid_begin, start_section_nr, section_nr, nr_sections);
+}
+
 /*
  * Allocate the accumulated non-linear sections, allocate a mem_map
  * for each and record the physical to section mapping.
  */
 void __init sparse_init(void)
 {
-	unsigned long pnum_end, pnum_begin, map_count = 1;
-	int nid_begin;
-
 	if (compound_info_has_mask()) {
 		VM_WARN_ON_ONCE(!IS_ALIGNED((unsigned long) pfn_to_page(0),
 				    MAX_FOLIO_VMEMMAP_ALIGN));
 	}
 
-	pnum_begin = first_present_section_nr();
-	nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
-
-	for_each_present_section_nr(pnum_begin + 1, pnum_end) {
-		int nid = sparse_early_nid(__nr_to_section(pnum_end));
-
-		if (nid == nid_begin) {
-			map_count++;
-			continue;
-		}
-		/* Init node with sections in range [pnum_begin, pnum_end) */
-		sparse_init_nid(nid_begin, pnum_begin, pnum_end, map_count);
-		nid_begin = nid;
-		pnum_begin = pnum_end;
-		map_count = 1;
-	}
-	/* cover the last node */
-	sparse_init_nid(nid_begin, pnum_begin, pnum_end, map_count);
+	sparse_metadata_init();
 	sparse_init_subsection_map();
 	vmemmap_populate_print_last();
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0947946D551
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 22:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030985; cv=none; b=nONNE0ejEWHr6sGZk5xTNxorAbUxlAVM9kFA3N+AmtJAHagxfp7ne4v0RIEmbmzYGH4QxEmhZBb3yC0q53i4e/HoyvYYNf6C7pDO6SdmXgJ4Xc6beKRzjAaAXmDOrLleJeCuIiJO5TJV50KAb0mkzK1Ut2CSce36qdTloEhL4lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030985; c=relaxed/simple;
	bh=Tx0Og21cR5e4I56E7c3TFOWUJ5wQM+icYc8GWaXsYgE=;
	h=Date:To:From:Subject:Message-Id; b=Mbh+ztx8fv2gCMXcPPm47IPgB74gI6rLMtn8R1uycxBOKyAXe+KD38tygPicInu6d8mMBY1hg3VdUzBhqWD3eQuhHJTUEiXNVoJlq9MswAxxijZ7Gvav+OfQzzVjUuTZ2mypIE266hPyR0DDyZolI6gyqKWV4hGYc2wnjKJG1gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g7GKHrBz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g7GKHrBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF1E1F000FF;
	Mon, 21 Sep 2026 22:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790030983;
	bh=PatdxLkaYy1P33eQoNMbxzBpwQs5OEO07CV6oPYRAm4=;
	h=Date:To:From:Subject;
	b=g7GKHrBzn1stX94SjGZABvOlyU6JJpHBdQjTKqFRohTQby4rRuCAAXHbbEJHWaYY9
	 wN44d98tK9klSGllnrwCHHLo6m4nGUIti8do2/vDm3pTcBoE/qZLu8m0+yF02sbOGS
	 3PxPR4xYQ4UK55HIla6czBwxD1KifQFKhrX/zeOA=
Date: Mon, 21 Sep 2026 15:49:43 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-remove-pfn_in_present_section.patch added to mm-new branch
Message-Id: <20260921224943.8CF1E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: remove pfn_in_present_section()
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-remove-pfn_in_present_section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-remove-pfn_in_present_section.patch

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
Subject: mm/sparse: remove pfn_in_present_section()
Date: Mon, 21 Sep 2026 21:58:59 +0200

Unused, let's remove it.

Link: https://lore.kernel.org/20260921-b4-sparsemem_cleanups-v2-7-54d81d65e125@kernel.org
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

 include/linux/mmzone.h |   10 ----------
 1 file changed, 10 deletions(-)

--- a/include/linux/mmzone.h~mm-sparse-remove-pfn_in_present_section
+++ a/include/linux/mmzone.h
@@ -2326,13 +2326,6 @@ static inline unsigned long next_valid_p
 
 #endif
 
-static inline int pfn_in_present_section(unsigned long pfn)
-{
-	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
-		return 0;
-	return present_section(__pfn_to_section(pfn));
-}
-
 static inline unsigned long next_present_section_nr(unsigned long section_nr)
 {
 	while (++section_nr <= __highest_used_section_nr) {
@@ -2362,9 +2355,6 @@ static inline unsigned long next_present
 #else
 #define pfn_to_nid(pfn)		(0)
 #endif
-
-#else
-#define pfn_in_present_section pfn_valid
 #endif /* CONFIG_SPARSEMEM */
 
 /*
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


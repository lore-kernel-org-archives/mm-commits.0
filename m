Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43783ED5A1
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 22:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030982; cv=none; b=idAyZ8to/V8jVaYV4C+HtNurjIdzg9u+ijzSDItzR/hVMtSpUm9/ZW9klsuAU/UEOs9JaQEWR2DhWCtB8XAJ5Z4iA1oAjk9Tg6dp6/Gf6ib6898JBEcSLVULpfkxvcvhHlRlf+TgSOoMmQeSNINrw5iPKEjOpQeJPmkNlUikik8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030982; c=relaxed/simple;
	bh=GM0RrFL0/YmQoqdbmQhbyHwMU6nPYuacSAJ6qDnHy2E=;
	h=Date:To:From:Subject:Message-Id; b=aAcZvZzfIqSVw2ozQqd9jlIIkU5IbMOGULbUFKZhdWdFvp6tTiVWfJPlSX5OTC+5tOIfWlTK3IlyApd/R54Q/B+kancp+twnArh1LFgDHNFF93LNYUxueSv2eywQQA/7RnCgriC1K5NVuvjn7T8K4NHrJUJLLHYzcYpK6hvvu4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AmCNpSNr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AmCNpSNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468A81F00893;
	Mon, 21 Sep 2026 22:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790030980;
	bh=DMo6sLmgle045h7hR+uSrs7o0YLFrfSQ3Z3wdfB6hyI=;
	h=Date:To:From:Subject;
	b=AmCNpSNrJmELL0w3LSI/+ig9a9ds4P6pZLmK2OdlODAMC0GkJNxIi83rVPo8YoT1L
	 pq5XFbgRg3S0cioz5DU6aJ+X6kBPsRfuJaDtw+RX8c1DrUkW+LZEoGK9GU9sGh/qqW
	 srJo/cPuIQRgp2nTPWv3uB7x6puvq+coQ10wa1vk=
Date: Mon, 21 Sep 2026 15:49:39 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-rename-__highest_present_section_nr-to-__highest_used_section_nr.patch added to mm-new branch
Message-Id: <20260921224940.468A81F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: rename __highest_present_section_nr to __highest_used_section_nr
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-rename-__highest_present_section_nr-to-__highest_used_section_nr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-rename-__highest_present_section_nr-to-__highest_used_section_nr.patch

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
Subject: mm/sparse: rename __highest_present_section_nr to __highest_used_section_nr
Date: Mon, 21 Sep 2026 21:58:58 +0200

In preparation for getting rid of SECTION_MARKED_PRESENT, rename
__highest_present_section_nr and clarify the comment.

Link: https://lore.kernel.org/20260921-b4-sparsemem_cleanups-v2-6-54d81d65e125@kernel.org
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

 include/linux/mmzone.h |    6 +++---
 mm/compaction.c        |    2 +-
 mm/sparse.c            |   12 ++++--------
 mm/sparse.h            |    4 ++--
 4 files changed, 10 insertions(+), 14 deletions(-)

--- a/include/linux/mmzone.h~mm-sparse-rename-__highest_present_section_nr-to-__highest_used_section_nr
+++ a/include/linux/mmzone.h
@@ -2181,7 +2181,7 @@ static inline struct mem_section *__pfn_
 	return __nr_to_section(pfn_to_section_nr(pfn));
 }
 
-extern unsigned long __highest_present_section_nr;
+extern unsigned long __highest_used_section_nr;
 
 static inline int subsection_map_index(unsigned long pfn)
 {
@@ -2280,7 +2280,7 @@ static inline unsigned long first_valid_
 
 	rcu_read_lock_sched();
 
-	while (nr <= __highest_present_section_nr && pfn < end_pfn) {
+	while (nr <= __highest_used_section_nr && pfn < end_pfn) {
 		struct mem_section *ms = __pfn_to_section(pfn);
 
 		if (valid_section(ms) &&
@@ -2335,7 +2335,7 @@ static inline int pfn_in_present_section
 
 static inline unsigned long next_present_section_nr(unsigned long section_nr)
 {
-	while (++section_nr <= __highest_present_section_nr) {
+	while (++section_nr <= __highest_used_section_nr) {
 		if (present_section_nr(section_nr))
 			return section_nr;
 	}
--- a/mm/compaction.c~mm-sparse-rename-__highest_present_section_nr-to-__highest_used_section_nr
+++ a/mm/compaction.c
@@ -216,7 +216,7 @@ static unsigned long skip_offline_sectio
 	if (online_section_nr(start_nr))
 		return 0;
 
-	while (++start_nr <= __highest_present_section_nr) {
+	while (++start_nr <= __highest_used_section_nr) {
 		if (online_section_nr(start_nr))
 			return section_nr_to_pfn(start_nr);
 	}
--- a/mm/sparse.c~mm-sparse-rename-__highest_present_section_nr-to-__highest_used_section_nr
+++ a/mm/sparse.c
@@ -164,15 +164,11 @@ static void __init mminit_validate_memmo
 }
 
 /*
- * There are a number of times that we loop over NR_MEM_SECTIONS,
- * looking for section_present() on each.  But, when we have very
- * large physical address spaces, NR_MEM_SECTIONS can also be
- * very large which makes the loops quite long.
- *
- * Keeping track of this gives us an easy way to break out of
- * those loops early.
+ * Looping over all possible memory sections is expensive, especially if
+ * NR_MEM_SECTIONS is large but only a fraction is actually used. Keep track of
+ * the highest section number we ever used.
  */
-unsigned long __highest_present_section_nr;
+unsigned long __highest_used_section_nr;
 
 static inline unsigned long first_present_section_nr(void)
 {
--- a/mm/sparse.h~mm-sparse-rename-__highest_present_section_nr-to-__highest_used_section_nr
+++ a/mm/sparse.h
@@ -44,8 +44,8 @@ static inline void sparse_init_one_secti
 static inline void __section_mark_present(struct mem_section *ms,
 		unsigned long section_nr)
 {
-	if (section_nr > __highest_present_section_nr)
-		__highest_present_section_nr = section_nr;
+	if (section_nr > __highest_used_section_nr)
+		__highest_used_section_nr = section_nr;
 
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
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


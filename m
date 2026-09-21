Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25374AB1B8
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 22:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790031002; cv=none; b=PqD8Nlvax8o+bNv4xWo5vhArYQeAwQ6N27OjrDDrVvvhfhjudo7MA9xWbvgGdtfQ5HdJ5RJpwDD3OtZl+/JZD1Hd1vSIIaz243ako33//OXwoMDnB18RhVxKWMj8nGrj92NwmOhMRQeJ+XNNdyf0rJcOEBczL8ztZ6zkOIflerk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790031002; c=relaxed/simple;
	bh=K9VCdHt9n3jkHC8rZoYmilhZtY0fHitf0oNz7IPlz+s=;
	h=Date:To:From:Subject:Message-Id; b=fmxlYs8Tkiy2Q3xSYNs2mntY7v1SHUhkEfRaN37/YZD+zr/KNlMuJnx2ZiS4fKqC4RSkT+JCmhjSn9JB1RmFXaHDMzID+Ck2yGFq/4/1h0uAsZ4S1T8X4HBCJEBwy6A2I33bhili6EiMD8fzWNruzT0waYJZMWBQzoCOYPFWw8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p0EtRMQ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p0EtRMQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DEF1F00893;
	Mon, 21 Sep 2026 22:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790030997;
	bh=xPu8ksH9mp/TEJDJOBQcbPuDWuxA+lqVieb2Q6pThLc=;
	h=Date:To:From:Subject;
	b=p0EtRMQ13rzXW9c2GKoM9ay/YrCa6RVkmlY7I9tXmg/B1Mdm8IJZzCvPIjYJ1kXqF
	 /329Ks0TN1llYLA7d6gmk4QadbbFIkHjiGcbhKry/5xOqsl8/uX+B7fX/ZahJ4hTnt
	 LW+V3bALPGJfM8ikniJMjkDvuJqu4eBQYopdfCH0=
Date: Mon, 21 Sep 2026 15:49:56 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-page-clarify-comment-in-get_max_dump_pfn.patch added to mm-new branch
Message-Id: <20260921224957.50DEF1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/page: clarify comment in get_max_dump_pfn()
has been added to the -mm mm-new branch.  Its filename is
     fs-proc-page-clarify-comment-in-get_max_dump_pfn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-page-clarify-comment-in-get_max_dump_pfn.patch

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
Subject: fs/proc/page: clarify comment in get_max_dump_pfn()
Date: Mon, 21 Sep 2026 21:59:04 +0200

pfn_to_online_page() will only succeed on some PFNs within the same
section, not necessarily all.  Let's make that clearer.

While at it, rephrase it to "Allow inspection of".

Link: https://lore.kernel.org/20260921-b4-sparsemem_cleanups-v2-12-54d81d65e125@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
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

 fs/proc/page.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/proc/page.c~fs-proc-page-clarify-comment-in-get_max_dump_pfn
+++ a/fs/proc/page.c
@@ -31,10 +31,9 @@ static inline unsigned long get_max_dump
 {
 #ifdef CONFIG_SPARSEMEM
 	/*
-	 * The memmap of early sections is completely populated and marked
-	 * online even if max_pfn does not fall on a section boundary -
-	 * pfn_to_online_page() will succeed on all pages. Allow inspecting
-	 * these memmaps.
+	 * If max_pfn does not fall on a section boundary, pfn_to_online_page()
+	 * can succeed on PFNs beyond max_pfn within the same section. Allow
+	 * inspection of these memmaps.
 	 */
 	return round_up(max_pfn, PAGES_PER_SECTION);
 #else
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


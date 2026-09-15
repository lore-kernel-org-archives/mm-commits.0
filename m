Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C1F23B63E
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 00:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789433094; cv=none; b=PQCKqZn4hq1sdk5zfbmsM7lokwFKaHSdN1AIXSuZaieovUZk8E7Y7ygfK0zR1Kshp3ee4xUMKHb/5ewHxZWOjqhA6O/jjuVJ4l/9uDr+H+uXTMtzkQQjMNVzoK4B4uMFZ0ditlJ0tcyNriZFN4rP+cMTDPsXe9Kv3bebuaSBqL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789433094; c=relaxed/simple;
	bh=m/gkpnKnXAY9WO2vb81KHSMkIU9HJAjhjO1iozw9RmE=;
	h=Date:To:From:Subject:Message-Id; b=Qv4lqds5obTCEs/q45atavHyLisxa8MaocioxVYvLDVhSnmGhyZsKvmvZM4xFc3WglDm4onAVhm36/1w8GWGMF7fzphEBz3nqxYxpMI8yWIWrjzbGnxxfat+emT0m8/ctrEJgUVk+oV6LaeED0qsxJ1OJHq5Fk70BuYzeW3OO48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jqWM/vBh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jqWM/vBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D700D1F000FF;
	Tue, 15 Sep 2026 00:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789433093;
	bh=6EIWzn86j2jGfmU7KUhe/UTQ5ZIWRkja13u+lK0e4n0=;
	h=Date:To:From:Subject;
	b=jqWM/vBh7ikWrUH9dYTM7IEmyuOuMfu0fzCNnA+34Av+1rswosYzN2oviTAafAlyU
	 q9IGyRpvWnCAJWKeqWfmhUVKIv6yVti9ZIUjl4YeXrcJldN2zs2FnsSwloRohrTGJ+
	 IuX8yYxJrk7hn5d69hJtcpuPSBEzZZ+z2saJqt5g=
Date: Mon, 14 Sep 2026 17:44:52 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-fix-off-by-one-in-swap-cache-replace-sanity-check.patch added to mm-new branch
Message-Id: <20260915004452.D700D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: fix off-by-one in swap cache replace sanity check
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-fix-off-by-one-in-swap-cache-replace-sanity-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-fix-off-by-one-in-swap-cache-replace-sanity-check.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/swap: fix off-by-one in swap cache replace sanity check
Date: Tue, 15 Sep 2026 01:14:42 +0800

Patch series "mm/huge_memory: clean up and decouple the anon and file
split helpers", v5.

The folio split path handles anon, page cache and swap cache folios in one
routine.  That mixing is what makes the swap cache split restrictions hard
to lift and to review.  We now support uniform split to order-0 only, and
no mappingless swap cache folios.  And it has left a fair number of dead
or redundant checks behind.

This series prepares for lifting those restrictions by cleaning up the
code first: split the routine into an anon and a file helper, and keep all
swap cache handling in the anon helper.  The file helper never sees a swap
cache folio, folio_check_splittable() rejects them up front.

Apart from two bug fixes (patch 1 and 2) and a slight adjustment of anon
splitting (patch 12), this is a pure cleanup.

Testing:

The in-tree split_huge_page_test selftest (uniform, non-uniform and
in-folio-offset splits of anon and pagecache folios) passes 62/62 over 600
runs on the patched kernel.

ftrace function_graph tracing filtered on __folio_split() was used to
compare per-call durations between the base and the patched kernel on the
same x86-64 box (interleaved runs across alternating reboots.  135 split
calls per run, 600 test runs):

Before: 68.52 us, stddev: 1.58
After:  67.38 us, stddev: 1.33

The patched kernel is slightly faster.  The stack usage and object size
change as the config and compiler change, but in general the stack usage
is reduced and object size is basically unchanged.


This patch (of 17):

The DEBUG_VM sanity check in __swap_cache_replace_folio() iterates the old
folio's range with "while (ci_off++ < ci_end)", so the loop body runs on
the already-incremented offset: the first entry is skipped and one entry
past the range is read.  For a folio split that entry belongs to the first
after-split folio and was just repointed by the replacement loop above, so
the check would warn spuriously whenever sub-folio orders differ from the
head folio's.

Currently we don't support non-uniform swapcache split, but this still
needs a fix to clean it up and prepare for non-uniform swap cache split.

Use the same do-while pattern as the replacement loop.

Link: https://lore.kernel.org/20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com
Link: https://lore.kernel.org/20260915-swap-thp-cleanup-v5-1-39878b37dfb0@tencent.com
Fixes: 8578e0c00dcf ("mm, swap: use the swap table for the swap cache and switch API")
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/swap_state.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/swap_state.c~mm-swap-fix-off-by-one-in-swap-cache-replace-sanity-check
+++ a/mm/swap_state.c
@@ -396,8 +396,9 @@ void __swap_cache_replace_folio(struct s
 	    folio_order(old) != folio_order(new)) {
 		ci_off = swp_cluster_offset(old->swap);
 		ci_end = ci_off + folio_nr_pages(old);
-		while (ci_off++ < ci_end)
+		do {
 			WARN_ON_ONCE(swp_tb_to_folio(__swap_table_get(ci, ci_off)) != old);
+		} while (++ci_off < ci_end);
 	}
 }
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memcontrol-move-the-lru_zone_size-sanity-check-to-the-reader-side.patch
mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags.patch
mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch
mm-mglru-move-max_seq-read-into-walk_update_folio.patch
mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch
mm-mglru-fix-potential-generation-folio-number-leak.patch
mm-swap-fix-off-by-one-in-swap-cache-replace-sanity-check.patch
mm-huge_memory-fix-rejection-of-swap-cache-folios-with-a-mapping.patch
mm-huge_memory-invert-folio_ref_freeze-check-to-reduce-indentation.patch
mm-huge_memory-split-the-routine-for-splitting-anon-and-file-folio.patch
mm-huge_memory-rename-__split_unmapped_folio-to-__split_frozen_folio.patch
mm-huge_memory-consolidate-irq-and-locking-for-folio-split.patch
mm-huge_memory-move-eof-trimming-into-the-file-split-helper.patch
mm-huge_memory-move-unmap-and-remap-into-the-split-helpers.patch
mm-huge_memory-rename-remap_page-to-remap_anon_folio.patch
mm-huge_memory-move-the-racy-refcount-check-into-unmap_folio.patch
mm-huge_memory-move-filemap-management-into-the-file-split-helper.patch
mm-huge_memory-move-anon_vma-handling-into-the-anon-split-helper.patch
mm-huge_memory-move-memcg-switch-into-the-file-split-helper.patch
mm-huge_memory-drop-the-unused-do_lru-argument-of-the-file-split-helper.patch
mm-huge_memory-clean-up-after-split-folio-freeing-in-__folio_split.patch
mm-huge_memory-count-only-swap-cache-refs-in-anon-folio-split.patch
mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio.patch


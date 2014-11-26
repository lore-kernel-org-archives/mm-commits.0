From: akpm@linux-foundation.org
Subject: + mm-oom-remove-gfp-helper-function.patch added to -mm tree
Date: Wed, 26 Nov 2014 14:30:01 -0800
Message-ID: <54765469.KYqNb18xsIIb44g8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43994 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaKZWaC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Nov 2014 17:30:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: remove gfp helper function
has been added to the -mm tree.  Its filename is
     mm-oom-remove-gfp-helper-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-remove-gfp-helper-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-remove-gfp-helper-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: remove gfp helper function

Commit b9921ecdee66 ("mm: add a helper function to check may oom
condition") was added because the gfp criteria for oom killing was checked
in both the page allocator and memcg.

That was true for about nine months, but then commit 0029e19ebf84 ("mm:
memcontrol: remove explicit OOM parameter in charge path") removed the
memcg usecase.

Fold the implementation into its only caller.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    5 -----
 mm/page_alloc.c     |    2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

diff -puN include/linux/oom.h~mm-oom-remove-gfp-helper-function include/linux/oom.h
--- a/include/linux/oom.h~mm-oom-remove-gfp-helper-function
+++ a/include/linux/oom.h
@@ -85,11 +85,6 @@ static inline void oom_killer_enable(voi
 	oom_killer_disabled = false;
 }
 
-static inline bool oom_gfp_allowed(gfp_t gfp_mask)
-{
-	return (gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY);
-}
-
 extern struct task_struct *find_lock_task_mm(struct task_struct *p);
 
 /* sysctls */
diff -puN mm/page_alloc.c~mm-oom-remove-gfp-helper-function mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-remove-gfp-helper-function
+++ a/mm/page_alloc.c
@@ -2789,7 +2789,7 @@ rebalance:
 	 * running out of options and have to consider going OOM
 	 */
 	if (!did_some_progress) {
-		if (oom_gfp_allowed(gfp_mask)) {
+		if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
 			if (oom_killer_disabled)
 				goto nopage;
 			/* Coredumps can quickly deplete all memory reserves */
_

Patches currently in -mm which might be from rientjes@google.com are

mm-slab-slub-coding-style-whitespaces-and-tabs-mixture.patch
slab-print-slabinfo-header-in-seq-show.patch
mm-slab-reverse-iteration-on-find_mergeable.patch
mm-slub-fix-format-mismatches-in-slab_err-callers.patch
slab-improve-checking-for-invalid-gfp_flags.patch
slab-replace-smp_read_barrier_depends-with-lockless_dereference.patch
mm-memcontrol-lockless-page-counters.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
mm-verify-compound-order-when-freeing-a-page.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking-fix.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-always-update-cached-scanner-positions-fix.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch
mm-compaction-more-focused-lru-and-pcplists-draining-fix.patch
mm-numa-balancing-rearrange-kconfig-entry.patch
memcg-use-generic-slab-iterators-for-showing-slabinfo.patch
mm-hugetlb-fix-__unmap_hugepage_range.patch
hugetlb-fix-hugepages=-entry-in-kernel-parameterstxt.patch
hugetlb-alloc_bootmem_huge_page-use-is_aligned.patch
hugetlb-hugetlb_register_all_nodes-add-__init-marker.patch
memory-hotplug-remove-redundant-call-of-page_to_pfn.patch
mm-gfp-escalatedly-define-gfp_highuser-and-gfp_highuser_movable.patch
fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes.patch
fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes-fix.patch
mm-oom-remove-gfp-helper-function.patch
mm-utilc-add-kstrimdup.patch
sysctl-terminate-strings-also-on-r.patch
sysctl-terminate-strings-also-on-r-fix.patch
linux-next.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch


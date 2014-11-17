From: akpm@linux-foundation.org
Subject: + mm-move-swp_entry_t-definition-to-include-linux-mm_typesh.patch added to -mm tree
Date: Mon, 17 Nov 2014 13:34:23 -0800
Message-ID: <546a69df.Kg3HB7rujP1psI5V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbaKQVeZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Nov 2014 16:34:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, hannes@cmpxchg.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move swp_entry_t definition to include/linux/mm_types.h
has been added to the -mm tree.  Its filename is
     mm-move-swp_entry_t-definition-to-include-linux-mm_typesh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-swp_entry_t-definition-to-include-linux-mm_typesh.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-swp_entry_t-definition-to-include-linux-mm_typesh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: mm: move swp_entry_t definition to include/linux/mm_types.h

swp_entry_t being defined in include/linux/swap.h instead of
include/linux/mm_types.h causes cyclic include dependency later when
include/linux/page_cgroup.h is included from writeback path.  Move the
definition to include/linux/mm_types.h.

While at it, reformat the comment above it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    8 ++++++++
 include/linux/swap.h     |    8 --------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN include/linux/mm_types.h~mm-move-swp_entry_t-definition-to-include-linux-mm_typesh include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-move-swp_entry_t-definition-to-include-linux-mm_typesh
+++ a/include/linux/mm_types.h
@@ -530,4 +530,12 @@ enum tlb_flush_reason {
 	NR_TLB_FLUSH_REASONS,
 };
 
+ /*
+  * A swap entry has to fit into a "unsigned long", as the entry is hidden
+  * in the "index" field of the swapper address space.
+  */
+typedef struct {
+	unsigned long val;
+} swp_entry_t;
+
 #endif /* _LINUX_MM_TYPES_H */
diff -puN include/linux/swap.h~mm-move-swp_entry_t-definition-to-include-linux-mm_typesh include/linux/swap.h
--- a/include/linux/swap.h~mm-move-swp_entry_t-definition-to-include-linux-mm_typesh
+++ a/include/linux/swap.h
@@ -102,14 +102,6 @@ union swap_header {
 	} info;
 };
 
- /* A swap entry has to fit into a "unsigned long", as
-  * the entry is hidden in the "index" field of the
-  * swapper address space.
-  */
-typedef struct {
-	unsigned long val;
-} swp_entry_t;
-
 /*
  * current->reclaim_state points to one of these when a task is running
  * memory reclaim
_

Patches currently in -mm which might be from tj@kernel.org are

block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
mm-memcontrol-lockless-page-counters.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
mm-embed-the-memcg-pointer-directly-into-struct-page.patch
mm-embed-the-memcg-pointer-directly-into-struct-page-fix.patch
mm-page_cgroup-rename-file-to-mm-swap_cgroupc.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch
mm-move-swp_entry_t-definition-to-include-linux-mm_typesh.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
linux-next.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch


From: akpm@linux-foundation.org
Subject: [merged]
 mm-revert-page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:43:01 -0700
Message-ID: <52321945.peej6BIUdb5WaqaB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58078 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab3ILTnB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:43:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, psz@maths.usyd.edu.au, minchan@kernel.org, hannes@cmpxchg.org

Subject: [merged] mm-revert-page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory.patch removed from -mm tree
To: hannes@cmpxchg.org,minchan@kernel.org,psz@maths.usyd.edu.au,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:43:01 -0700


The patch titled
     Subject: mm: revert "page-writeback.c: subtract min_free_kbytes from dirtyable memory"
has been removed from the -mm tree.  Its filename was
     mm-revert-page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: revert "page-writeback.c: subtract min_free_kbytes from dirtyable memory"

This reverts 75f7ad8e043.  It was the result of a problem observed with a
3.2 kernel and merged in 3.9, while the issue had been resolved upstream
in 3.3 (ab8fabd mm: exclude reserved pages from dirtyable memory).

The "reserved pages" are a superset of min_free_kbytes, thus this change
is redundant and confusing.  Revert it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Paul Szabo <psz@maths.usyd.edu.au>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/page-writeback.c~mm-revert-page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory mm/page-writeback.c
--- a/mm/page-writeback.c~mm-revert-page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory
+++ a/mm/page-writeback.c
@@ -241,9 +241,6 @@ static unsigned long global_dirtyable_me
 	if (!vm_highmem_is_dirtyable)
 		x -= highmem_dirtyable_memory(x);
 
-	/* Subtract min_free_kbytes */
-	x -= min_t(unsigned long, x, min_free_kbytes >> (PAGE_SHIFT - 10));
-
 	return x + 1;	/* Ensure that we never return 0 */
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
memcg-remove-redundant-code-in-mem_cgroup_force_empty_write.patch
memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
memcg-get-rid-of-soft-limit-tree-infrastructure.patch
vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
memcg-enhance-memcg-iterator-to-support-predicates.patch
memcg-enhance-memcg-iterator-to-support-predicates-fix.patch
memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
memcg-track-all-children-over-limit-in-the-root.patch
memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
arch-mm-remove-obsolete-init-oom-protection.patch
arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom.patch
arch-mm-pass-userspace-fault-flag-to-generic-fault-handler.patch
x86-finish-user-fault-error-path-with-fatal-signal.patch
mm-memcg-enable-memcg-oom-killer-only-for-user-faults.patch
mm-memcg-rework-and-document-oom-waiting-and-wakeup.patch
mm-memcg-do-not-trap-chargers-with-full-callstack-on-oom.patch
memcg-remove-memcg_nr_file_mapped.patch
memcg-check-for-proper-lock-held-in-mem_cgroup_update_page_stat.patch
memcg-add-per-cgroup-writeback-pages-accounting.patch
memcg-document-cgroup-dirty-writeback-memory-statistics.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch


From: akpm@linux-foundation.org
Subject: + oom-serialize-out-of-memory-calls.patch added to -mm tree
Date: Fri, 21 Sep 2007 02:11:05 -0700
Message-ID: <200709210911.l8L9B5Gi028207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57113 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752859AbXIUJLP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 05:11:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, andrea@suse.de, clameter@sgi.com


The patch titled
     oom: serialize out of memory calls
has been added to the -mm tree.  Its filename is
     oom-serialize-out-of-memory-calls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: oom: serialize out of memory calls
From: David Rientjes <rientjes@google.com>

Before invoking the OOM killer, a final allocation attempt with a very high
watermark is attempted.  Serialization needs to occur at this point or it may
be possible that the allocation could succeed after acquiring the lock.  If
the lock is contended, the task is put to sleep and the allocation attempt is
retried when rescheduled.

Cc: Andrea Arcangeli <andrea@suse.de>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~oom-serialize-out-of-memory-calls mm/page_alloc.c
--- a/mm/page_alloc.c~oom-serialize-out-of-memory-calls
+++ a/mm/page_alloc.c
@@ -1608,6 +1608,11 @@ nofail_alloc:
 		if (page)
 			goto got_pg;
 	} else if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
+		if (!try_set_zone_oom(zonelist)) {
+			schedule_timeout_uninterruptible(1);
+			goto restart;
+		}
+
 		/*
 		 * Go through the zonelist yet one more time, keep
 		 * very high watermark here, this is only to catch
@@ -1616,14 +1621,19 @@ nofail_alloc:
 		 */
 		page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, order,
 				zonelist, ALLOC_WMARK_HIGH|ALLOC_CPUSET);
-		if (page)
+		if (page) {
+			clear_zonelist_oom(zonelist);
 			goto got_pg;
+		}
 
 		/* The OOM killer will not help higher order allocs so fail */
-		if (order > PAGE_ALLOC_COSTLY_ORDER)
+		if (order > PAGE_ALLOC_COSTLY_ORDER) {
+			clear_zonelist_oom(zonelist);
 			goto nopage;
+		}
 
 		out_of_memory(zonelist, gfp_mask, order);
+		clear_zonelist_oom(zonelist);
 		goto restart;
 	}
 
_

Patches currently in -mm which might be from rientjes@google.com are

maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
oom-move-prototypes-to-appropriate-header-file.patch
oom-move-constraints-to-enum.patch
oom-change-all_unreclaimable-zone-member-to-flags.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-add-per-zone-locking.patch
oom-serialize-out-of-memory-calls.patch
oom-add-oom_kill_allocating_task-sysctl.patch
oom-suppress-extraneous-stack-and-memory-dump.patch
oom-compare-cpuset-mems_allowed-instead-of-exclusive.patch
oom-do-not-take-callback_mutex.patch
add-a-missing-00-index-file-for-documentation-vm-fix.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch

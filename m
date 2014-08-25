From: akpm@linux-foundation.org
Subject: +
 mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
 added to -mm tree
Date: Mon, 25 Aug 2014 15:32:19 -0700
Message-ID: <53fbb973.uEpIPZdTA1I3goxZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:36679 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148AbaHYWcV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Aug 2014 18:32:21 -0400
Received: by mail-qc0-f201.google.com with SMTP id c9so1650500qcz.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Aug 2014 15:32:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix
has been added to the -mm tree.  Its filename is
     mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix

fix warnings

mm/page_alloc.c: In function '__alloc_pages_slowpath':
mm/page_alloc.c:2649: warning: passing argument 11 of '__alloc_pages_direct_compact' from incompatible pointer type
mm/page_alloc.c:2369: note: expected 'bool *' but argument is of type 'int *'
mm/page_alloc.c:2762: warning: passing argument 11 of '__alloc_pages_direct_compact' from incompatible pointer type
mm/page_alloc.c:2369: note: expected 'bool *' but argument is of type 'int *'

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix
+++ a/mm/page_alloc.c
@@ -2370,7 +2370,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
 	int classzone_idx, int migratetype, enum migrate_mode mode,
-	bool *contended_compaction, bool *deferred_compaction)
+	int *contended_compaction, bool *deferred_compaction)
 {
 	return NULL;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable-checkpatch-fixes.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
checkpatch-fix-spello.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
watchdog-control-hard-lockup-detection-default-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


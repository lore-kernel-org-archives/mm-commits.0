From: akpm@linux-foundation.org
Subject: + debugging-keep-track-of-page-owners-fix.patch added to -mm tree
Date: Mon, 25 Aug 2014 15:52:38 -0700
Message-ID: <53fbbe36.jtx2p8uG36Cay9pp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:47078 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933608AbaHYWwj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Aug 2014 18:52:39 -0400
Received: by mail-ie0-f202.google.com with SMTP id rl12so1525716iec.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Aug 2014 15:52:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: debugging-keep-track-of-page-owners-fix
has been added to the -mm tree.  Its filename is
     debugging-keep-track-of-page-owners-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/debugging-keep-track-of-page-owners-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/debugging-keep-track-of-page-owners-fix.patch

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
Subject: debugging-keep-track-of-page-owners-fix



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pageowner.c |    2 +-
 mm/vmstat.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/pageowner.c~debugging-keep-track-of-page-owners-fix mm/pageowner.c
--- a/mm/pageowner.c~debugging-keep-track-of-page-owners-fix
+++ a/mm/pageowner.c
@@ -95,7 +95,7 @@ read_page_owner(struct file *file, char
 
 	/* Print information relevant to grouping pages by mobility */
 	blocktype = get_pageblock_migratetype(page);
-	pagetype  = allocflags_to_migratetype(page->gfp_mask);
+	pagetype  = gfpflags_to_migratetype(page->gfp_mask);
 	ret += snprintf(kbuf+ret, count-ret,
 			"PFN %lu Block %lu type %d %s "
 			"Flags %s%s%s%s%s%s%s%s%s%s%s%s\n",
diff -puN mm/vmstat.c~debugging-keep-track-of-page-owners-fix mm/vmstat.c
--- a/mm/vmstat.c~debugging-keep-track-of-page-owners-fix
+++ a/mm/vmstat.c
@@ -1059,7 +1059,7 @@ static void pagetypeinfo_showmixedcount_
 			if (page->order < 0)
 				continue;
 
-			pagetype = allocflags_to_migratetype(page->gfp_mask);
+			pagetype = gfpflags_to_migratetype(page->gfp_mask);
 			if (pagetype != mtype) {
 				if (is_migrate_cma(pagetype))
 					count[MIGRATE_MOVABLE]++;
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
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


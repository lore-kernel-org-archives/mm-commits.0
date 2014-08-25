From: akpm@linux-foundation.org
Subject: [wrecked] put_bh-debug.patch removed from -mm tree
Date: Mon, 25 Aug 2014 16:08:43 -0700
Message-ID: <53fbc1fb.qLgIgnClakHEMqIx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:34313 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbaHYXIo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Aug 2014 19:08:44 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so552287igi.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Aug 2014 16:08:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: put_bh() debug
has been removed from the -mm tree.  Its filename was
     put_bh-debug.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: put_bh() debug

Detect bh refcount underflows.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |    8 ++++++++
 include/linux/buffer_head.h |    6 +-----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff -puN fs/buffer.c~put_bh-debug fs/buffer.c
--- a/fs/buffer.c~put_bh-debug
+++ a/fs/buffer.c
@@ -47,6 +47,14 @@ static int fsync_buffers_list(spinlock_t
 
 #define BH_ENTRY(list) list_entry((list), struct buffer_head, b_assoc_buffers)
 
+void put_bh(struct buffer_head *bh)
+{
+	WARN_ON(atomic_read(&bh->b_count) <= 0);
+	smp_mb__before_atomic_dec();
+	atomic_dec(&bh->b_count);
+}
+EXPORT_SYMBOL(put_bh);
+
 void init_buffer(struct buffer_head *bh, bh_end_io_t *handler, void *private)
 {
 	bh->b_end_io = handler;
diff -puN include/linux/buffer_head.h~put_bh-debug include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~put_bh-debug
+++ a/include/linux/buffer_head.h
@@ -274,11 +274,7 @@ static inline void get_bh(struct buffer_
         atomic_inc(&bh->b_count);
 }
 
-static inline void put_bh(struct buffer_head *bh)
-{
-        smp_mb__before_atomic();
-        atomic_dec(&bh->b_count);
-}
+void put_bh(struct buffer_head *bh);
 
 static inline void brelse(struct buffer_head *bh)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
mm-slab_commonc-suppress-warning.patch
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


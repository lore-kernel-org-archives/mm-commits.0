From: akpm@linux-foundation.org
Subject: + mm-page_ext-remove-unnecessary-stack_trace-field-fix.patch
 added to -mm tree
Date: Tue, 27 Jan 2015 14:43:59 -0800
Message-ID: <54c814af.tBBVCk0xEISo3Cr8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38949 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbbA0WoA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Jan 2015 17:44:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, rogachevsergei@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_ext-remove-unnecessary-stack_trace-field-fix
has been added to the -mm tree.  Its filename is
     mm-page_ext-remove-unnecessary-stack_trace-field-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_ext-remove-unnecessary-stack_trace-field-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_ext-remove-unnecessary-stack_trace-field-fix.patch

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
Subject: mm-page_ext-remove-unnecessary-stack_trace-field-fix

use struct initializers

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Sergei Rogachev <rogachevsergei@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff -puN mm/page_owner.c~mm-page_ext-remove-unnecessary-stack_trace-field-fix mm/page_owner.c
--- a/mm/page_owner.c~mm-page_ext-remove-unnecessary-stack_trace-field-fix
+++ a/mm/page_owner.c
@@ -59,15 +59,14 @@ void __reset_page_owner(struct page *pag
 
 void __set_page_owner(struct page *page, unsigned int order, gfp_t gfp_mask)
 {
-	struct page_ext *page_ext;
-	struct stack_trace trace;
+	struct page_ext *page_ext = lookup_page_ext(page);
+	struct stack_trace trace = {
+		.nr_entries = 0,
+		.max_entries = ARRAY_SIZE(page_ext->trace_entries),
+		.entries = &page_ext->trace_entries[0],
+		.skip = 3,
+	};
 
-	page_ext = lookup_page_ext(page);
-
-	trace.nr_entries = 0;
-	trace.max_entries = ARRAY_SIZE(page_ext->trace_entries);
-	trace.entries = &page_ext->trace_entries[0];
-	trace.skip = 3;
 	save_stack_trace(&trace);
 
 	page_ext->order = order;
@@ -83,8 +82,11 @@ print_page_owner(char __user *buf, size_
 {
 	int ret;
 	int pageblock_mt, page_mt;
-	struct stack_trace trace;
 	char *kbuf;
+	struct stack_trace trace = {
+		.nr_entries = page_ext->nr_entries,
+		.entries = &page_ext->trace_entries[0],
+	};
 
 	kbuf = kmalloc(count, GFP_KERNEL);
 	if (!kbuf)
@@ -122,9 +124,6 @@ print_page_owner(char __user *buf, size_
 	if (ret >= count)
 		goto err;
 
-	trace.nr_entries = page_ext->nr_entries;
-	trace.entries = &page_ext->trace_entries[0];
-
 	ret += snprint_stack_trace(kbuf + ret, count - ret, &trace, 0);
 	if (ret >= count)
 		goto err;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
mm.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
docs-procs-describe-proc-pid-map_files-entry-fix.patch
mm-page_ext-remove-unnecessary-stack_trace-field-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality-fix.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch


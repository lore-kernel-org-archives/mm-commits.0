From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes.patch added to -mm tree
Date: Mon, 12 Jan 2015 15:39:19 -0800
Message-ID: <54b45b27.XjEauKOqAygxldaJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36961 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbbALXjU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 18:39:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gthelen@google.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes.patch

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
Subject: mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes

Cc: Greg Thelen <gthelen@google.com>

WARNING: Prefer seq_puts to seq_printf
#315: FILE: mm/memcontrol.c:5340:
+		seq_printf(m, "none\n");

WARNING: Prefer seq_puts to seq_printf
#349: FILE: mm/memcontrol.c:5374:
+		seq_printf(m, "none\n");

WARNING: Prefer seq_puts to seq_printf
#383: FILE: mm/memcontrol.c:5408:
+		seq_printf(m, "none\n");

total: 0 errors, 3 warnings, 431 lines checked

./patches/mm-memcontrol-default-hierarchy-interface-for-memory.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes
+++ a/mm/memcontrol.c
@@ -5337,7 +5337,7 @@ static int memory_low_show(struct seq_fi
 	unsigned long low = ACCESS_ONCE(memcg->low);
 
 	if (low == 0)
-		seq_printf(m, "none\n");
+		seq_puts(m, "none\n");
 	else
 		seq_printf(m, "%llu\n", (u64)low * PAGE_SIZE);
 
@@ -5371,7 +5371,7 @@ static int memory_high_show(struct seq_f
 	unsigned long high = ACCESS_ONCE(memcg->high);
 
 	if (high == PAGE_COUNTER_MAX)
-		seq_printf(m, "none\n");
+		seq_puts(m, "none\n");
 	else
 		seq_printf(m, "%llu\n", (u64)high * PAGE_SIZE);
 
@@ -5405,7 +5405,7 @@ static int memory_max_show(struct seq_fi
 	unsigned long max = ACCESS_ONCE(memcg->memory.limit);
 
 	if (max == PAGE_COUNTER_MAX)
-		seq_printf(m, "none\n");
+		seq_puts(m, "none\n");
 	else
 		seq_printf(m, "%llu\n", (u64)max * PAGE_SIZE);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
dax-add-dax_zero_page_range-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch


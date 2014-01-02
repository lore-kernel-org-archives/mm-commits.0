From: akpm@linux-foundation.org
Subject: + printk-flush-conflicting-continuation-line-fix.patch added to
 -mm tree
Date: Thu, 02 Jan 2014 14:57:45 -0800
Message-ID: <52c5eee9.mF9jZsk31HhHV3pb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43122 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaABW5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jan 2014 17:57:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, paul.gortmaker@windriver.com, joe@perches.com, getarunks@gmail.com, fweisbec@gmail.com, arunks.linux@gmail.com, arun.ks@broadcom.com, akpm@linux-foundation.org

Subject: + printk-flush-conflicting-continuation-line-fix.patch added to -mm tree
To: akpm@linux-foundation.org,arun.ks@broadcom.com,arunks.linux@gmail.com,fweisbec@gmail.com,getarunks@gmail.com,joe@perches.com,paul.gortmaker@windriver.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 02 Jan 2014 14:57:45 -0800


The patch titled
     Subject: printk-flush-conflicting-continuation-line-fix
has been added to the -mm tree.  Its filename is
     printk-flush-conflicting-continuation-line-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-flush-conflicting-continuation-line-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-flush-conflicting-continuation-line-fix.patch

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
Subject: printk-flush-conflicting-continuation-line-fix

simplify and condense the code

Cc: Joe Perches <joe@perches.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Arun KS <arun.ks@broadcom.com>
Cc: Arun KS <arunks.linux@gmail.com>
Cc: Arun KS <getarunks@gmail.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN kernel/printk/printk.c~printk-flush-conflicting-continuation-line-fix kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-flush-conflicting-continuation-line-fix
+++ a/kernel/printk/printk.c
@@ -1595,15 +1595,15 @@ asmlinkage int vprintk_emit(int facility
 		 * either merge it with the current buffer and flush, or if
 		 * there was a race with interrupts (prefix == true) then just
 		 * flush it out and store this line separately.
+		 * If the preceding printk was from a different task and missed
+		 * a newline, flush and append the newline.
 		 */
-		if (cont.len && cont.owner == current) {
-			if (!(lflags & LOG_PREFIX))
-				stored = cont_add(facility, level, text, text_len);
-			cont_flush(LOG_NEWLINE);
-		/* Flush conflicting buffer. An earlier newline was missing
-		* and current print is from different task */
-		} else if (cont.len && cont.owner != current)
+		if (cont.len) {
+			if (cont.owner == current && !(lflags & LOG_PREFIX))
+				stored = cont_add(facility, level, text,
+						  text_len);
 			cont_flush(LOG_NEWLINE);
+		}
 
 		if (!stored)
 			log_store(facility, level, lflags, 0,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-remap_file_pages-remove-unneeded-access_once.patch
dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path-fix-2.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
mm-show_mem-remove-show_mem_filter_page_count-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch
mm-add-overcommit_kbytes-sysctl-variable-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-fix-2.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions-checkpatch-fixes.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
mm-print-more-details-for-bad_page-fix.patch
mm-munlock-fix-potential-race-with-thp-page-split-fix.patch
mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
printk-flush-conflicting-continuation-line-fix.patch
drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


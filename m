From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
 added to -mm tree
Date: Fri, 27 Dec 2013 14:23:03 -0800
Message-ID: <52bdfdc7.bXCzt8NXPGiCe+xW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab3L0WXE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Dec 2013 17:23:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, robh+dt@kernel.org, julia.lawall@lip6.fr, john.stultz@linaro.org, grant.likely@linaro.org, akpm@linux-foundation.org

Subject: + drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch added to -mm tree
To: akpm@linux-foundation.org,grant.likely@linaro.org,john.stultz@linaro.org,julia.lawall@lip6.fr,robh+dt@kernel.org
From: akpm@linux-foundation.org
Date: Fri, 27 Dec 2013 14:23:03 -0800


The patch titled
     Subject: drivers/rtc/rtc-cmos.c: propagate hpet_register_irq_handler() failure
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch

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
Subject: drivers/rtc/rtc-cmos.c: propagate hpet_register_irq_handler() failure

If hpet_register_irq_handler() fails, cmos_do_probe() will incorrectly
return 0.

Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure
+++ a/drivers/rtc/rtc-cmos.c
@@ -708,11 +708,9 @@ cmos_do_probe(struct device *dev, struct
 		irq_handler_t rtc_cmos_int_handler;
 
 		if (is_hpet_enabled()) {
-			int err;
-
 			rtc_cmos_int_handler = hpet_rtc_interrupt;
-			err = hpet_register_irq_handler(cmos_interrupt);
-			if (err != 0) {
+			retval = hpet_register_irq_handler(cmos_interrupt);
+			if (retval) {
 				dev_warn(dev, "hpet_register_irq_handler "
 						" failed in rtc_init().");
 				goto cleanup1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-munlock-fix-deadlock-in-__munlock_pagevec-fix.patch
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
lib-parserc-put-export_symbols-in-the-conventional-place.patch
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


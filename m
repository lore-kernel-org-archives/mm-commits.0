From: akpm@linux-foundation.org
Subject: + mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch added to -mm tree
Date: Tue, 23 Nov 2010 15:11:13 -0800
Message-ID: <201011232343.oANNhgQg012955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137Ab0KWXog (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Nov 2010 18:44:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aarcange@redhat.com, apw@shadowen.org, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com


The patch titled
     mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix
has been added to the -mm tree.  Its filename is
     mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix
From: Andrew Morton <akpm@linux-foundation.org>

mm/vmscan.o: In function `cpu_callback':
include/linux/compaction.h:74: multiple definition of `compact_zone_order'
mm/page_alloc.o:include/linux/compaction.h:74: first defined here
mm/vmstat.o: In function `setup_vmstat':
include/linux/compaction.h:74: multiple definition of `compact_zone_order'

copy-n-paste strikes again.  Thwap for not testing with CONFIG_COMPATION=n!

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/compaction.h~mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix include/linux/compaction.h
--- a/include/linux/compaction.h~mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix
+++ a/include/linux/compaction.h
@@ -67,7 +67,7 @@ static inline unsigned long compaction_s
 	return COMPACT_SKIPPED;
 }
 
-extern unsigned long compact_zone_order(struct zone *zone, int order,
+static inline unsigned long compact_zone_order(struct zone *zone, int order,
 						gfp_t gfp_mask)
 {
 	return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
memcg-fix-false-positive-vm_bug-on-non-smp-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
aesni-nfg.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-page_allocc-fix-build_all_zonelist-where-percpu_alloc-is-wrongly-called-under-stop_machine_run-cleanup.patch
scripts-fix-gfp-translate-for-recent-changes-to-gfph-fix.patch
mm-vmap-area-cache.patch
arch-x86-kernel-entry_32s-i386-too.patch
arch-x86-include-asm-fixmaph-mark-__set_fixmap_offset-as-__always_inline.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
irq-use-per_cpu-kstat_irqs-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-deactivate-invalidated-pages-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch


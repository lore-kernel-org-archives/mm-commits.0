From: akpm@linux-foundation.org
Subject: + mm-page_allocc-fix-build_all_zonelist-where-percpu_alloc-is-wrongly-called-under-stop_machine_run-cleanup.patch added to -mm tree
Date: Thu, 18 Nov 2010 17:27:43 -0800
Message-ID: <201011190127.oAJ1RhnN017311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982Ab0KSB3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Nov 2010 20:29:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, akataria@vmware.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, penberg@cs.helsinki.fi, petr@vmware.com, tj@kernel.org


The patch titled
     mm-page_allocc-fix-build_all_zonelist-where-percpu_alloc-is-wrongly-called-under-stop_machine_run-cleanup
has been added to the -mm tree.  Its filename is
     mm-page_allocc-fix-build_all_zonelist-where-percpu_alloc-is-wrongly-called-under-stop_machine_run-cleanup.patch

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
Subject: mm-page_allocc-fix-build_all_zonelist-where-percpu_alloc-is-wrongly-called-under-stop_machine_run-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

we don't actually need the cast or the local, but I suppose the cast is
useful for documentation purposes, and for future type-safety.

Cc: Alok Kataria <akataria@vmware.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Petr Vandrovec <petr@vmware.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-fix-build_all_zonelist-where-percpu_alloc-is-wrongly-called-under-stop_machine_run-cleanup mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-fix-build_all_zonelist-where-percpu_alloc-is-wrongly-called-under-stop_machine_run-cleanup
+++ a/mm/page_alloc.c
@@ -3057,10 +3057,8 @@ void build_all_zonelists(void *data)
 		/* we have to stop all cpus to guarantee there is no user
 		   of zonelist */
 #ifdef CONFIG_MEMORY_HOTPLUG
-		if (data) {
-			struct zone *zone = (struct zone *)data;
-			setup_zone_pageset(zone);
-		}
+		if (data)
+			setup_zone_pageset((struct zone *)data);
 #endif
 		stop_machine(__build_all_zonelists, NULL, NULL);
 		/* cpuset refresh routine should be here */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

hpet-factor-timer-allocate-from-open.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
aesni-nfg.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-page_allocc-fix-build_all_zonelist-where-percpu_alloc-is-wrongly-called-under-stop_machine_run-cleanup.patch
mm-vmap-area-cache.patch
arch-x86-kernel-entry_32s-work-around-gas-2161-glitch.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
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
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
lib-add-generic-exponentially-weighted-moving-average-ewma-function-fix.patch
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


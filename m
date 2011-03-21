From: akpm@linux-foundation.org
Subject: + memcg-change-page_cgroup_zoneinfo-signature-fix.patch added to -mm tree
Date: Mon, 21 Mar 2011 15:51:38 -0700
Message-ID: <201103212326.p2LNQoC0031994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932321Ab1CUX1k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Mar 2011 19:27:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg-change-page_cgroup_zoneinfo-signature-fix
has been added to the -mm tree.  Its filename is
     memcg-change-page_cgroup_zoneinfo-signature-fix.patch

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
Subject: memcg-change-page_cgroup_zoneinfo-signature-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-change-page_cgroup_zoneinfo-signature-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-change-page_cgroup_zoneinfo-signature-fix
+++ a/mm/memcontrol.c
@@ -835,7 +835,7 @@ void mem_cgroup_rotate_reclaimable_page(
 	smp_rmb();
 	if (mem_cgroup_is_root(pc->mem_cgroup))
 		return;
-	mz = page_cgroup_zoneinfo(pc);
+	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
 	list_move_tail(&pc->lru, &mz->lists[lru]);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-asm-generic-unistdh-fix-syncfs-syscall-number.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
mm-vmap-area-cache.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-batch-free-pcp-list-if-possible-fix.patch
memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list-fix.patch
pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix.patch
mm-add-__gfp_other_node-flag-checkpatch-fixes.patch
mm-use-__gfp_other_node-for-transparent-huge-pages-checkpatch-fixes.patch
drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv-fix.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
calibrate-retry-with-wider-bounds-when-converge-seems-to-fail-fix.patch
kernel-watchdogc-allow-hardlockup-to-panic-by-default-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
fs-coda-fix-compile-warning-when-config_sysctl=n-fix.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix.patch
linux-next.patch
linux-next-rejects.patch
next-remove-localversion.patch
revert-kbuild-reenable-section-mismatch-analysis.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-usb-serial-usb_wwanc-unbork.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix-fix.patch
mm-add-vm-counters-for-transparent-hugepages-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
memcg-change-page_cgroup_zoneinfo-signature-fix.patch
memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp-checkpatch-fixes.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix-fix.patch
userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks-checkpatch-fixes.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch


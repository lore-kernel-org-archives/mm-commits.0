From: akpm@google.com
Subject: + drivers-power-intel_mid_batteryc-fix-build.patch added to -mm tree
Date: Tue, 27 Sep 2011 15:31:33 -0700
Message-ID: <201109272311.p8RNBIK6020199@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:19013 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab1I0XL2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Sep 2011 19:11:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@linux.intel.com, cbouatmailru@gmail.com, nithish.mahalingam@intel.com


The patch titled
     drivers/power/intel_mid_battery.c: fix build
has been added to the -mm tree.  Its filename is
     drivers-power-intel_mid_batteryc-fix-build.patch

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
Subject: drivers/power/intel_mid_battery.c: fix build
From: Andrew Morton <akpm@linux-foundation.org>

Seems that nobody's even trying any more.

Cc: Nithish Mahalingam <nithish.mahalingam@intel.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/power/intel_mid_battery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/power/intel_mid_battery.c~drivers-power-intel_mid_batteryc-fix-build drivers/power/intel_mid_battery.c
--- a/drivers/power/intel_mid_battery.c~drivers-power-intel_mid_batteryc-fix-build
+++ a/drivers/power/intel_mid_battery.c
@@ -314,7 +314,7 @@ static void pmic_battery_read_status(str
 			pbi->batt_health = POWER_SUPPLY_HEALTH_GOOD;
 			if (r8 & PMIC_BATT_CHR_SDCLMT_MASK) {
 				/* PMIC will change charging current automatically */
-				pmic_battery_log_event(pbi, BATT_EVENT_DCLMT_EXCPT);
+				pmic_battery_log_event(BATT_EVENT_DCLMT_EXCPT);
 			}
 		}
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
include-linux-dmarh-forward-declare-struct-acpi_dmar_header.patch
arch-x86-kernel-cpu-perf_event_amdc-needs-asm-apicdefh.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
drivers-block-mtip32xx-mtip32xxc-fix-warning.patch
drivers-block-mtip32xx-mtip32xxc-needs-compath.patch
mm.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-neaten-warn_alloc_failed-fix.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
mm-compaction-compact-unevictable-pages-checkpatch-fixes.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch
mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions.patch
dynamic_debug-use-a-single-printk-to-emit-messages.patch
treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes.patch
fs-nameic-remove-unused-getname_flags.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
sysctl-add-support-for-poll-fix.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes.patch
dio-inline-the-complete-submission-path-v2-checkpatch-fixes.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch
drivers-power-intel_mid_batteryc-fix-build.patch


From: akpm@linux-foundation.org
Subject: + pwm_backlight-add-device-tree-support-for-low-threshold-brightness-fix.patch added to -mm tree
Date: Thu, 27 Sep 2012 14:33:22 -0700
Message-ID: <20120927213323.D16EF5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:63455 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab2I0Vd0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Sep 2012 17:33:26 -0400
Received: by weyx43 with SMTP id x43so112954wey.1
        for <mm-commits@vger.kernel.org>; Thu, 27 Sep 2012 14:33:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, FlorianSchandinat@gmx.de, avinashphilip@ti.com, grant.likely@secretlab.ca, rpurdie@rpsys.net, thierry.reding@avionic-design.de


The patch titled
     Subject: pwm_backlight-add-device-tree-support-for-low-threshold-brightness-fix
has been added to the -mm tree.  Its filename is
     pwm_backlight-add-device-tree-support-for-low-threshold-brightness-fix.patch

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
Subject: pwm_backlight-add-device-tree-support-for-low-threshold-brightness-fix

Cc: "Philip, Avinash" <avinashphilip@ti.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Philip, Avinash <avinashphilip@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt |   18 +++++-----
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt~pwm_backlight-add-device-tree-support-for-low-threshold-brightness-fix Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
--- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt~pwm_backlight-add-device-tree-support-for-low-threshold-brightness-fix
+++ a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
@@ -14,15 +14,15 @@ Required properties:
 Optional properties:
   - pwm-names: a list of names for the PWM devices specified in the
                "pwms" property (see PWM binding[0])
-  - low-threshold-brightness: brightness threshold low level. Low threshold
-    brightness set to value so that backlight present on low end of
-    brightness.
-    Some panels, backlight would absent if duty percentage of PWM wave is less
-    than certain level (say 20%). By setting low-threshold-brightness to a
-    value above (percentage of brightness-levels max) 50 (20% of 255, if 255
-    is max). On setting low-threshold-brightness, range of brightness-levels
-    is calculated in a region of low-threshold-brightness to brightness-levels
-    max.
+  - low-threshold-brightness: brightness threshold low level. Sets the lowest
+    brightness value.
+    On some panels the backlight misbehaves if the duty cycle percentage of the
+    PWM wave is less than a certain level (say 20%).  In this example the user
+    can set low-threshold-brightness to a value above 50 (ie, 20% of 255), thus
+    preventing the PWM duty cycle from going too low.
+    On setting low-threshold-brightness the range of brightness levels is
+    calculated in the range low-threshold-brightness to the maximum value in
+    brightness-levels, described above.
 
 [0]: Documentation/devicetree/bindings/pwm/pwm.txt
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
audith-replace-defines-with-c-stubs.patch
audith-replace-defines-with-c-stubs-fix.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix-fix.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-count-free-cma-pages-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix-fix.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
sections-fix-section-conflicts-in-arch-h8300-checkpatch-fixes.patch
sections-fix-section-conflicts-in-drivers-macintosh-checkpatch-fixes.patch
sectons-fix-const-sections-for-crc32-table-checkpatch-fixes.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
backlight-platform-lcd-add-support-for-device-tree-based-probe-fix.patch
pwm_backlight-add-device-tree-support-for-low-threshold-brightness-fix.patch
idr-rename-max_level-to-max_idr_level-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2.patch
idr-rename-max_level-to-max_idr_level-fix-3.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


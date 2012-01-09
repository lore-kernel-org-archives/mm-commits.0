From: akpm@linux-foundation.org
Subject: + drivers-video-nvidia-nvidiac-fix-warning.patch added to -mm tree
Date: Mon, 09 Jan 2012 13:54:35 -0800
Message-ID: <20120109223646.E17EC1000B5@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:64426 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932738Ab2AIWgr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2012 17:36:47 -0500
Received: by yhpp56 with SMTP id p56so202889yhp.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Jan 2012 14:36:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, FlorianSchandinat@gmx.de


The patch titled
     Subject: drivers/video/nvidia/nvidia.c: fix warning
has been added to the -mm tree.  Its filename is
     drivers-video-nvidia-nvidiac-fix-warning.patch

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
Subject: drivers/video/nvidia/nvidia.c: fix warning

drivers/video/nvidia/nvidia.c:1602: warning: return from incompatible pointer type

Fix the int/bool confusion in there.

Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nvidia.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/nvidia/nvidia.c~drivers-video-nvidia-nvidiac-fix-warning drivers/video/nvidia/nvidia.c
--- a/drivers/video/nvidia/nvidia.c~drivers-video-nvidia-nvidiac-fix-warning
+++ a/drivers/video/nvidia/nvidia.c
@@ -81,7 +81,7 @@ static int vram __devinitdata = 0;
 static int bpp __devinitdata = 8;
 static int reverse_i2c __devinitdata;
 #ifdef CONFIG_MTRR
-static int nomtrr __devinitdata = 0;
+static bool nomtrr __devinitdata = false;
 #endif
 #ifdef CONFIG_PMAC_BACKLIGHT
 static int backlight __devinitdata = 1;
@@ -1509,7 +1509,7 @@ static int __devinit nvidiafb_setup(char
 			backlight = simple_strtoul(this_opt+10, NULL, 0);
 #ifdef CONFIG_MTRR
 		} else if (!strncmp(this_opt, "nomtrr", 6)) {
-			nomtrr = 1;
+			nomtrr = true;
 #endif
 		} else if (!strncmp(this_opt, "fpdither:", 9)) {
 			fpdither = simple_strtol(this_opt+9, NULL, 0);
@@ -1599,7 +1599,7 @@ MODULE_PARM_DESC(bpp, "pixel width in bi
 module_param(reverse_i2c, int, 0);
 MODULE_PARM_DESC(reverse_i2c, "reverse port assignment of the i2c bus");
 #ifdef CONFIG_MTRR
-module_param(nomtrr, bool, 0);
+module_param(nomtrr, bool, false);
 MODULE_PARM_DESC(nomtrr, "Disables MTRR support (0 or 1=disabled) "
 		 "(default=0)");
 #endif
_
Subject: Subject: drivers/video/nvidia/nvidia.c: fix warning

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-checkpatch-fixes.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-v2-checkpatch-fixes.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
drivers-usb-misc-emi26c-emi62c-fix-warnings.patch
slub-document-setting-min-order-with-debug_guardpage_minorder-0-checkpatch-fixes.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
mm-more-intensive-memory-corruption-debug-fix.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
mm-simplify-find_vma_prev-fix.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma-fix.patch
mempool-fix-first-round-failure-behavior-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call-fix.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
backlight-convert-pwm_bl-to-dev_pm_ops-fix.patch
leds-add-driver-for-tca6507-led-controller.patch
checkpatch-improve-memset-and-min-max-with-cast-checking-fix.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch
drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-2-fix.patch
memcg-simplify-lru-handling-by-new-rule-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix-3.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
procfs-parse-mount-options-fix.patch
procfs-add-hidepid=-and-gid=-mount-options-fix-2.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
kexec-remove-kmsg_dump_kexec.patch
panic-dont-print-redundant-backtraces-on-oops-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
drivers-video-nvidia-nvidiac-fix-warning.patch


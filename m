From: akpm@linux-foundation.org
Subject: + drivers-usb-misc-emi26c-emi62c-fix-warnings.patch added to -mm tree
Date: Mon, 09 Jan 2012 13:51:19 -0800
Message-ID: <20120109223332.66BF92000AB@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:46381 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874Ab2AIWjR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2012 17:39:17 -0500
Received: by eaak10 with SMTP id k10so134994eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Jan 2012 14:39:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com


The patch titled
     Subject: drivers/usb/misc/emi26.c & emi62.c: fix warnings
has been added to the -mm tree.  Its filename is
     drivers-usb-misc-emi26c-emi62c-fix-warnings.patch

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
Subject: drivers/usb/misc/emi26.c & emi62.c: fix warnings

drivers/usb/misc/emi26.c:40: warning: 'emi26_init' declared 'static' but never defined
drivers/usb/misc/emi26.c:41: warning: 'emi26_exit' declared 'static' but never defined
drivers/usb/misc/emi62.c:49: warning: 'emi62_init' declared 'static' but never defined
drivers/usb/misc/emi62.c:50: warning: 'emi62_exit' declared 'static' but never defined

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/emi26.c |    3 ---
 drivers/usb/misc/emi62.c |    3 ---
 2 files changed, 6 deletions(-)

diff -puN drivers/usb/misc/emi26.c~drivers-usb-misc-emi26c-emi62c-fix-warnings drivers/usb/misc/emi26.c
--- a/drivers/usb/misc/emi26.c~drivers-usb-misc-emi26c-emi62c-fix-warnings
+++ a/drivers/usb/misc/emi26.c
@@ -37,9 +37,6 @@ static int emi26_set_reset(struct usb_de
 static int emi26_load_firmware (struct usb_device *dev);
 static int emi26_probe(struct usb_interface *intf, const struct usb_device_id *id);
 static void emi26_disconnect(struct usb_interface *intf);
-static int __init emi26_init (void);
-static void __exit emi26_exit (void);
-
 
 /* thanks to drivers/usb/serial/keyspan_pda.c code */
 static int emi26_writememory (struct usb_device *dev, int address,
diff -puN drivers/usb/misc/emi62.c~drivers-usb-misc-emi26c-emi62c-fix-warnings drivers/usb/misc/emi62.c
--- a/drivers/usb/misc/emi62.c~drivers-usb-misc-emi26c-emi62c-fix-warnings
+++ a/drivers/usb/misc/emi62.c
@@ -46,9 +46,6 @@ static int emi62_set_reset(struct usb_de
 static int emi62_load_firmware (struct usb_device *dev);
 static int emi62_probe(struct usb_interface *intf, const struct usb_device_id *id);
 static void emi62_disconnect(struct usb_interface *intf);
-static int __init emi62_init (void);
-static void __exit emi62_exit (void);
-
 
 /* thanks to drivers/usb/serial/keyspan_pda.c code */
 static int emi62_writememory(struct usb_device *dev, int address,
_
Subject: Subject: drivers/usb/misc/emi26.c & emi62.c: fix warnings

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


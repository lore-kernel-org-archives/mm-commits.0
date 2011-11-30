From: akpm@linux-foundation.org
Subject: + x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix.patch added to -mm tree
Date: Wed, 30 Nov 2011 15:30:26 -0800
Message-ID: <201111302330.pAUNURwa013030@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:52772 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab1K3Xa3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2011 18:30:29 -0500
Received: by ywb26 with SMTP id 26so162399ywb.1
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2011 15:30:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dilinger@queued.net, dsd@laptop.org, hpa@zytor.com, mingo@elte.hu, mjg@redhat.com, tglx@linutronix.de


The patch titled
     Subject: x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix
has been added to the -mm tree.  Its filename is
     x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix

fix sscanf checking

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andres Salomon <dilinger@queued.net>
Cc: Daniel Drake <dsd@laptop.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/olpc/olpc-xo15-sci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86/platform/olpc/olpc-xo15-sci.c~x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix arch/x86/platform/olpc/olpc-xo15-sci.c
--- a/arch/x86/platform/olpc/olpc-xo15-sci.c~x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix
+++ a/arch/x86/platform/olpc/olpc-xo15-sci.c
@@ -58,7 +58,8 @@ static ssize_t lid_wake_on_close_store(s
 				       const char *buf, size_t n)
 {
 	unsigned int val;
-	if (!sscanf(buf, "%u", &val) == 1)
+
+	if (sscanf(buf, "%u", &val) != 1)
 		return -EINVAL;
 
 	set_lid_wake_behavior(!!val);
_
Subject: Subject: x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
vmscan-use-atomic-long-for-shrinker-batching.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
debugobjects-extend-to-assert-that-an-object-is-initialized.patch
kernel-timerc-use-debugobjects-to-catch-deletion-of-uninitialized-timers.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
mm-more-intensive-memory-corruption-debug-fix.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
checkpatch-improve-memset-and-min-max-with-cast-checking-fix.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch
drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
kexec-remove-kmsg_dump_kexec.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch


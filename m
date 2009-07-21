From: akpm@linux-foundation.org
Subject: + exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch added to -mm tree
Date: Tue, 21 Jul 2009 16:57:52 -0700
Message-ID: <200907212357.n6LNvqS2021862@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbZGUX6T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 19:58:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, nhorman@tuxdriver.com


The patch titled
     exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch

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
Subject: exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: suspect code indent for conditional statements (16, 25)
#48: FILE: fs/exec.c:1796:
+		if (core_limit == 0) {
+			 /*

WARNING: line over 80 characters
#57: FILE: fs/exec.c:1805:
+			  * but it runs as root, and can do lots of stupid things

WARNING: line over 80 characters
#58: FILE: fs/exec.c:1806:
+			  * Note that we use task_tgid_vnr here to grab the pid of the

WARNING: line over 80 characters
#59: FILE: fs/exec.c:1807:
+			  * process group leader.  That way we get the right pid if a thread

total: 0 errors, 4 warnings, 59 lines checked

./patches/exec-make-do_coredump-more-resilient-to-recursive-crashes-v9.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff -puN fs/exec.c~exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes fs/exec.c
--- a/fs/exec.c~exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes
+++ a/fs/exec.c
@@ -1794,21 +1794,23 @@ void do_coredump(long signr, int exit_co
 
  	if (ispipe) {
 		if (core_limit == 0) {
-			 /*
-			  * Normally core limits are irrelevant to pipes, since
-			  * we're not writing to the file system, but we use
-			  * core_limit of 0 here as a speacial value. Any
-			  * non-zero limit gets set to RLIM_INFINITY below, but
-			  * a limit of 0 skips the dump.  This is a consistent
-			  * way to catch recursive crashes.  We can still crash
-			  * if the core_pattern binary sets RLIM_CORE =  !0
-			  * but it runs as root, and can do lots of stupid things
-			  * Note that we use task_tgid_vnr here to grab the pid of the
-			  * process group leader.  That way we get the right pid if a thread
-			  * in a multi-threaded core_pattern process dies.
-			  */
-			printk(KERN_WARNING "Process %d(%s) has RLIMIT_CORE set to 0\n",
-			       task_tgid_vnr(current), current->comm);
+			/*
+			 * Normally core limits are irrelevant to pipes, since
+			 * we're not writing to the file system, but we use
+			 * core_limit of 0 here as a speacial value. Any
+			 * non-zero limit gets set to RLIM_INFINITY below, but
+			 * a limit of 0 skips the dump.  This is a consistent
+			 * way to catch recursive crashes.  We can still crash
+			 * if the core_pattern binary sets RLIM_CORE =  !0
+			 * but it runs as root, and can do lots of stupid things
+			 * Note that we use task_tgid_vnr here to grab the pid
+			 * of the process group leader.  That way we get the
+			 * right pid if a thread in a multi-threaded
+			 * core_pattern process dies.
+			 */
+			printk(KERN_WARNING
+				"Process %d(%s) has RLIMIT_CORE set to 0\n",
+				task_tgid_vnr(current), current->comm);
 			printk(KERN_WARNING "Aborting core\n");
 			goto fail_unlock;
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
arch-x86-kernel-tscc-smi-workaround-for-pit_expect_msb-checkpatch-fixes.patch
dmaengine-dmatest-add-a-maximum-number-of-test-iterations-checkpatch-fixes.patch
platform_device_add_data-use-kmemdup.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
leds-gpio-leds-fix-typographics-fault-checkpatch-fixes.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
scsi-make-scsi-sg-v4-driver-enabled-by-default-and-remove-experimental-dependency-since-udev-depends-on-bsg-checkpatch-fixes.patch
drivers-usb-gadget-s3c2410_udcc-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls-fix.patch
vfs-optimize-touch_time-too-fix.patch
revert-mm-prevent-balance_dirty_pages-from-doing-too-much-work.patch
arch-x86-oprofile-op_model_amdc-fix-op_amd_handle_ibs-return-type.patch
include-linux-clocksourceh-coding-style-tweaks.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
rtc-philips-nxp-pcf2123-driver-v03-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-fix.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch


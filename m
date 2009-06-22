From: akpm@linux-foundation.org
Subject: + proc-connector-add-event-for-process-becoming-session-leader-checkpatch-fixes.patch added to -mm tree
Date: Mon, 22 Jun 2009 16:20:20 -0700
Message-ID: <200906222320.n5MNKLic022354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751577AbZFVXUV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 19:20:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, matthltc@us.ibm.com, scott@ubuntu.com


The patch titled
     proc-connector-add-event-for-process-becoming-session-leader-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     proc-connector-add-event-for-process-becoming-session-leader-checkpatch-fixes.patch

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
Subject: proc-connector-add-event-for-process-becoming-session-leader-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "(foo*)" should be "(foo *)"
#47: FILE: drivers/connector/cn_proc.c:152:
+	msg = (struct cn_msg*)buffer;

ERROR: "(foo*)" should be "(foo *)"
#48: FILE: drivers/connector/cn_proc.c:153:
+	ev = (struct proc_event*)msg->data;

total: 2 errors, 0 warnings, 76 lines checked

./patches/proc-connector-add-event-for-process-becoming-session-leader.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Scott James Remnant <scott@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/connector/cn_proc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/connector/cn_proc.c~proc-connector-add-event-for-process-becoming-session-leader-checkpatch-fixes drivers/connector/cn_proc.c
--- a/drivers/connector/cn_proc.c~proc-connector-add-event-for-process-becoming-session-leader-checkpatch-fixes
+++ a/drivers/connector/cn_proc.c
@@ -149,8 +149,8 @@ void proc_sid_connector(struct task_stru
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
-	msg = (struct cn_msg*)buffer;
-	ev = (struct proc_event*)msg->data;
+	msg = (struct cn_msg *)buffer;
+	ev = (struct proc_event *)msg->data;
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
jsm-clean-up-serial-jsm-correctly-support-4-8-port-boards.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
proc-connector-add-event-for-process-becoming-session-leader-checkpatch-fixes.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch


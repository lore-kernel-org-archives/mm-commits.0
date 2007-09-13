From: akpm@linux-foundation.org
Subject: + softlockup-improve-debug-output-fix.patch added to -mm tree
Date: Thu, 13 Sep 2007 00:47:26 -0700
Message-ID: <200709130747.l8D7lQY0008372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59204 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751769AbXIMHsY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 03:48:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org, mingo@elte.hu


The patch titled
     softlockup-improve-debug-output fix
has been added to the -mm tree.  Its filename is
     softlockup-improve-debug-output-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: softlockup-improve-debug-output fix
From: Satyam Sharma <satyam@infradead.org>

On Sun, 2 Sep 2007, Satyam Sharma wrote:
>
> --- kernel/softlockup.c~fix	2007-09-02 04:23:49.000000000 +0530
> +++ kernel/softlockup.c	2007-09-02 04:34:45.000000000 +0530
  ^^^^^^^^^^

Ick, I botched a trivial patch, it doesn't even apply. Updated one below
(with indentation fix as added bonus :-)

[PATCH -mm] softlockup-improve-debug-output.patch fix (v2)

kernel/softlockup.c: In function 'softlockup_tick':
kernel/softlockup.c:125: warning: 'regs' is used uninitialized in this function

is a genuine bug (will cause an oops in all probability,
or cause wrong info to be printed, if we're lucky). So let's fix the
softlockup-improve-debug-output.patch to actually work as intended.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softlockup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/softlockup.c~softlockup-improve-debug-output-fix kernel/softlockup.c
--- a/kernel/softlockup.c~softlockup-improve-debug-output-fix
+++ a/kernel/softlockup.c
@@ -79,7 +79,7 @@ void softlockup_tick(void)
 	int this_cpu = smp_processor_id();
 	unsigned long touch_timestamp = per_cpu(touch_timestamp, this_cpu);
 	unsigned long print_timestamp;
-	struct pt_regs *regs;
+	struct pt_regs *regs = get_irq_regs();
 	unsigned long now;
 
 	if (touch_timestamp == 0) {
_

Patches currently in -mm which might be from satyam@infradead.org are

h8-300-fix-misnamed-config_blkdev_reserve_address-kconfig-variable.patch
cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch
cpufreq-implement-config_cpu_freq-stub-for.patch
cpufreq_stats-misc-cpuinit-section-annotations.patch
git-hwmon.patch
ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
git-ieee1394.patch
ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups.patch
git-netdev-all.patch
git-net.patch
net-sched-sch_cbqc-shut-up-uninitialized-variable.patch
git-s390.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch
git-watchdog.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
therm_throtc-fix-section-mismatch.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
softlockup-improve-debug-output-fix.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
remove-superfluous-definition-of-__setup_null_param-macro-and-broken-for-module-__setup_param.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch
x86-msr-driver-misc-cpuinit-annotations.patch
i386-cpuid-misc-cpuinit-annotations.patch

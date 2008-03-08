From: akpm@linux-foundation.org
Subject: - revert-dcdbas-add-dmi-based-module-autloading.patch removed from -mm tree
Date: Sat, 08 Mar 2008 11:02:56 -0800
Message-ID: <200803081902.m28J2v5f029879@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756786AbYCHTEO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 8 Mar 2008 14:04:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, Matt_Domsch@dell.com, frank@tuxrocks.com, greg@kroah.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     revert "dcdbas: add DMI-based module autloading"
has been removed from the -mm tree.  Its filename was
     revert-dcdbas-add-dmi-based-module-autloading.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "dcdbas: add DMI-based module autloading"
From: Ingo Molnar <mingo@elte.hu>

Frank Sorenson reported that 2.6.25-rc OOMs on his box and
tracked it down to commit 8f47f0b688bba7642dac4e979896e4692177670b,
"dcdbas: add DMI-based module autloading". Frank says:

> What actually happens is that when udev loads the dcdbas module at
> startup, modprobe apparently calls "modprobe dcdbas" itself, repeating
> until the system runs out of resources (in this case, it OOMs).

revert the commit.

Bisected-by: Frank Sorenson <frank@tuxrocks.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dcdbas.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/firmware/dcdbas.c~revert-dcdbas-add-dmi-based-module-autloading drivers/firmware/dcdbas.c
--- a/drivers/firmware/dcdbas.c~revert-dcdbas-add-dmi-based-module-autloading
+++ a/drivers/firmware/dcdbas.c
@@ -658,5 +658,4 @@ MODULE_DESCRIPTION(DRIVER_DESCRIPTION " 
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_AUTHOR("Dell Inc.");
 MODULE_LICENSE("GPL");
-/* Any System or BIOS claiming to be by Dell */
-MODULE_ALIAS("dmi:*:[bs]vnD[Ee][Ll][Ll]*:*");
+
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
poweroff-workaround.patch
typo-in-documentation-scheduler-sched-statstxt.patch
alpha-fix-iommu-related-boot-panic.patch
revert-dcdbas-add-dmi-based-module-autloading.patch
git-x86.patch
arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
documentation-i386-io-apictxt-fix-description.patch
add-the-dff-desktop-form-factor-dell-optiplex-745-to-the-reboot-errata-list.patch
git-kgdb-light.patch
git-kgdb-light-kconfig-fix.patch
git-acpi-fixup.patch
git-hrt.patch
git-kvm.patch
git-sched.patch
execute-tasklets-in-the-same-order-they-were-queued.patch
git-semaphore.patch
git-semaphore-git-rejects.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
rcu-move-preempt_rcu-config-option-back-under-preempt.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
x86-fix-clearcopy_user_page-declarations-in-pageh.patch
x86-visws-fix-printk-format-warnings.patch
cpu-hotplug-adjust-root-domain-online-span-in-response-to-hotplug-event.patch
time-prevent-the-loop-in-timespec_add_ns-from-being-optimised-away.patch
time-dont-touch-an-offlined-cpus-ts-tick_stopped-in-tick_cancel_sched_timer.patch
taint-kernel-after-warn_oncondition.patch
add-rusage_thread.patch
proper-__do_softirq-prototype.patch
proper-extern-for-late_time_init.patch
x86-configurable-dmi-scanning-code.patch
cgroups-_s64-files-add-cgroups-read_s64-write_s64-file-methods.patch
cgroups-_s64-files-use-read_s64-write_s64-in-cfs-cgroup-for-rt_runtime-file.patch
simplify-cpu_hotplug_begin-put_online_cpus.patch
asm-futexh-should-include-linux-uaccessh.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch


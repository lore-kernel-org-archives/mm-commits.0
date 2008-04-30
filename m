From: akpm@linux-foundation.org
Subject: + acpi-fix-drivers-acpi-gluec-build-error.patch added to -mm tree
Date: Wed, 30 Apr 2008 14:18:14 -0700
Message-ID: <200804302118.m3ULIFIr003605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758234AbYD3VSk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 17:18:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, bjorn.helgaas@hp.com


The patch titled
     acpi: fix drivers/acpi/glue.c build error
has been added to the -mm tree.  Its filename is
     acpi-fix-drivers-acpi-gluec-build-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: fix drivers/acpi/glue.c build error
From: Ingo Molnar <mingo@elte.hu>

x86.git testing found the following build bug:

  drivers/built-in.o: In function `acpi_rtc_init':
  glue.c:(.init.text+0x16c3): undefined reference to `pnp_bus_type'

this tries to use PNP bus infrastructure even in the !PNP case.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/glue.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/acpi/glue.c~acpi-fix-drivers-acpi-gluec-build-error drivers/acpi/glue.c
--- a/drivers/acpi/glue.c~acpi-fix-drivers-acpi-gluec-build-error
+++ a/drivers/acpi/glue.c
@@ -299,6 +299,7 @@ static void rtc_wake_off(struct device *
 
 static struct cmos_rtc_board_info rtc_info;
 
+#ifdef CONFIG_PNP
 
 /* PNP devices are registered in a subsys_initcall();
  * ACPI specifies the PNP IDs to use.
@@ -360,4 +361,6 @@ static int __init acpi_rtc_init(void)
 /* do this between RTC subsys_initcall() and rtc_cmos driver_initcall() */
 fs_initcall(acpi_rtc_init);
 
+#endif /* CONFIG_PNP */
+
 #endif
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
signals-add-set_restore_sigmask.patch
signals-set_restore_sigmask-tif_sigpending.patch
signals-s390-renumber-tif_restore_sigmask.patch
signals-ia64-renumber-tif_restore_sigmask.patch
signals-use-have_set_restore_sigmask.patch
signals-x86-ts_restore_sigmask.patch
char-serial-switch-drivers-to-ioremap_nocache.patch
make-marker_debug-static.patch
asm-futexh-should-include-linux-uaccessh.patch
slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
kernel-replace-remaining-__function__-occurances.patch
cpusets-update-maintainers.patch
fix-cpu-hotplug-problem-in-softirq-code.patch
rename-div64_64-to-div64_u64.patch
remove-div_long_long_rem.patch
isdn-hysdn_procconfc-build-fix.patch
pci-export-resource_wc-in-pci-sysfs.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
mm-filemapc-generic_write_checks-mustnt-be-inline.patch
acpi-acpi_numa_init-build-fix.patch
acpi-fix-drivers-acpi-gluec-build-error.patch
x86-ioremap-ram-check-fix.patch
git-x86.patch
git-x86-fixup.patch
x86_64-restore-mask_bits-in-msi-shutdown.patch
arch-x86-video-fbdevc-add-module_license.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup.patch
fix-drivers-media-common-tuners-build-bug.patch
git-kvm.patch
git-sched.patch
sched-add-debug-checks-to-idle-functions.patch
mutex-debug-check-mutex-magic-before-owner.patch
show_schedstat-fix-memleak.patch
drivers-base-topologyc-add-conditionals-around-show_cpumap.patch
rcu-fix-rcu_try_flip_waitack_needed-to-prevent-grace-period-stall.patch
rcu-add-call_rcu_sched.patch
rcu-add-memory-barriers-and-comments-to-rcu_check_callbacks.patch
rcu-add-call_rcu_sched-and-friends-to-rcutorture.patch
rcu-1q08-rcu-doc-update-add-call_rcu_sched.patch
aes-x86_64-asm-implementation-optimization.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
accounting-account-for-user-time-when-updating-memory-integrals.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
x86-ioremap-add-checks-for-virtual-addresses.patch
x86-ioremap-add-checks-for-virtual-addresses-fix.patch


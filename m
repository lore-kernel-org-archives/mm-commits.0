From: akpm@linux-foundation.org
Subject: [obsolete] drivers-mfd-twl-corec-wtf-isnt-this-fixed-yet.patch removed from -mm tree
Date: Fri, 23 Mar 2012 11:16:28 -0700
Message-ID: <20120323181629.F205EA0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:35362 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab2CWSQe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 14:16:34 -0400
Received: by wejx9 with SMTP id x9so184398wej.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 11:16:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, b-cousson@ti.com, balajitk@ti.com, gg@slimlogic.co.uk, grant.likely@secretlab.ca, rob.herring@calxeda.com, sameo@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/mfd/twl-core.c: wtf isn't this fixed yet??
has been removed from the -mm tree.  Its filename was
     drivers-mfd-twl-corec-wtf-isnt-this-fixed-yet.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/mfd/twl-core.c: wtf isn't this fixed yet??

drivers/mfd/twl-core.c: In function 'twl_probe':
drivers/mfd/twl-core.c:1237: error: implicit declaration of function 'irq_alloc_descs'
drivers/mfd/twl-core.c:1245: error: implicit declaration of function 'irq_domain_add_legacy'
drivers/mfd/twl-core.c:1246: error: 'irq_domain_simple_ops' undeclared (first use in this function)
drivers/mfd/twl-core.c:1246: error: (Each undeclared identifier is reported only once
drivers/mfd/twl-core.c:1246: error: for each function it appears in.)

Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Balaji T K <balajitk@ti.com>
Cc: Graeme Gregory <gg@slimlogic.co.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/twl-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/mfd/twl-core.c~drivers-mfd-twl-corec-wtf-isnt-this-fixed-yet drivers/mfd/twl-core.c
--- a/drivers/mfd/twl-core.c~drivers-mfd-twl-corec-wtf-isnt-this-fixed-yet
+++ a/drivers/mfd/twl-core.c
@@ -1259,7 +1259,7 @@ twl_probe(struct i2c_client *client, con
 		return -EINVAL;
 	}
 
-	status = irq_alloc_descs(-1, pdata->irq_base, nr_irqs, 0);
+	status = 0;
 	if (IS_ERR_VALUE(status)) {
 		dev_err(&client->dev, "Fail to allocate IRQ descs\n");
 		return status;
@@ -1267,8 +1267,8 @@ twl_probe(struct i2c_client *client, con
 
 	pdata->irq_base = status;
 	pdata->irq_end = pdata->irq_base + nr_irqs;
-	irq_domain_add_legacy(node, nr_irqs, pdata->irq_base, 0,
-			      &irq_domain_simple_ops, NULL);
+//	irq_domain_add_legacy(node, nr_irqs, pdata->irq_base, 0,
+//			      &irq_domain_simple_ops, NULL);
 
 	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C) == 0) {
 		dev_dbg(&client->dev, "can't talk I2C?\n");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-mfd-twl-corec-unbork.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
drivers-platform-x86-samsung-laptopc-fix-build.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
thermal-thermal_sys-fix-build-warning.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
sched-fix-compiler-warning-about-declared-inline-after-use.patch
brlocks-lglocks-cleanups.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions-fix.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-change-behavior-of-moving-charges-at-task-move-fix.patch
cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch
kernel-watchdogc-convert-to-pr_foo.patch
kernel-watchdogc-add-comment-to-watchdog-exit-path.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
backlight-use-id-driver_data-to-differentiate-lp855x-chips-fix.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


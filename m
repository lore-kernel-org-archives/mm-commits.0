From: akpm@linux-foundation.org
Subject: + drivers-mfd-twl-corec-wtf-isnt-this-fixed-yet.patch added to -mm tree
Date: Fri, 24 Feb 2012 14:27:28 -0800
Message-ID: <20120224231044.753EC10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:47298 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab2BXXKp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2012 18:10:45 -0500
Received: by ggnp1 with SMTP id p1so345048ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2012 15:10:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, b-cousson@ti.com, balajitk@ti.com, gg@slimlogic.co.uk, grant.likely@secretlab.ca, rob.herring@calxeda.com, sameo@linux.intel.com


The patch titled
     Subject: drivers/mfd/twl-core.c: wtf isn't this fixed yet??
has been added to the -mm tree.  Its filename is
     drivers-mfd-twl-corec-wtf-isnt-this-fixed-yet.patch

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
@@ -1234,7 +1234,7 @@ twl_probe(struct i2c_client *client, con
 		return -EINVAL;
 	}
 
-	status = irq_alloc_descs(-1, pdata->irq_base, nr_irqs, 0);
+	status = 0;
 	if (IS_ERR_VALUE(status)) {
 		dev_err(&client->dev, "Fail to allocate IRQ descs\n");
 		return status;
@@ -1242,8 +1242,8 @@ twl_probe(struct i2c_client *client, con
 
 	pdata->irq_base = status;
 	pdata->irq_end = pdata->irq_base + nr_irqs;
-	irq_domain_add_legacy(node, nr_irqs, pdata->irq_base, 0,
-			      &irq_domain_simple_ops, NULL);
+//	irq_domain_add_legacy(node, nr_irqs, pdata->irq_base, 0,
+//			      &irq_domain_simple_ops, NULL);
 
 	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C) == 0) {
 		dev_dbg(&client->dev, "can't talk I2C?\n");
_
Subject: Subject: drivers/mfd/twl-core.c: wtf isn't this fixed yet??

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
ata-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-change-percpu_read_stable-to-this_cpu_read_stable-fix.patch
x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics-v2-fix.patch
hpet-factor-timer-allocate-from-open.patch
thermal-thermal_sys-fix-build-warning.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines-fix.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines-fix-fix.patch
slab-introduce-kmalloc_array.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-compaction-make-compact_control-order-signed-fix.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
thp-optimize-away-unnecessary-page-table-locking-fix-checkpatch-fixes.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix-fix.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps-checkpatch-fixes.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
memcg-simplify-move_account-check-fix.patch
memcg-use-new-logic-for-page-stat-accounting-fix.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch
mm-memcontrolc-s-stealed-stolen.patch
percpu-remove-percpu_xxx-functions-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
posix_types-remove-fd_set-macros-checkpatch-fixes.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions-fix.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
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
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
drivers-mfd-twl-corec-wtf-isnt-this-fixed-yet.patch


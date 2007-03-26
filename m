From: akpm@linux-foundation.org
Subject: + integrity-ima-integrity_measure-support-fix-2.patch added to -mm tree
Date: Mon, 26 Mar 2007 04:40:25 -0700
Message-ID: <200703261142.l2QBgSdW017883@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54516 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbXCZLmg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 07:42:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kjhall@us.ibm.com, zohar@linux.vnet.ibm.com, zohar@us.ibm.com


The patch titled
     integrity-ima-integrity_measure-support-fix-2
has been added to the -mm tree.  Its filename is
     integrity-ima-integrity_measure-support-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: integrity-ima-integrity_measure-support-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

Fix ia64 buid:

ima_fs_cleanup: discarded in section `.exit.text' from security/built-in.o

Cc: Kylene Hall <kjhall@us.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 evm/ima/ima_queue.c       |    0 
 security/evm/ima/ima_fs.c |    2 +-
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN security/evm/Kconfig~integrity-ima-integrity_measure-support-fix-2 security/evm/Kconfig
diff -puN security/evm/Makefile~integrity-ima-integrity_measure-support-fix-2 security/evm/Makefile
diff -puN security/evm/evm_integrity.h~integrity-ima-integrity_measure-support-fix-2 security/evm/evm_integrity.h
diff -puN security/evm/evm_secfs.c~integrity-ima-integrity_measure-support-fix-2 security/evm/evm_secfs.c
diff -puN security/evm/ima/Kconfig~integrity-ima-integrity_measure-support-fix-2 security/evm/ima/Kconfig
diff -puN security/evm/ima/ima.h~integrity-ima-integrity_measure-support-fix-2 security/evm/ima/ima.h
diff -puN security/evm/ima/ima_evm.h~integrity-ima-integrity_measure-support-fix-2 security/evm/ima/ima_evm.h
diff -puN security/evm/ima/ima_fs.c~integrity-ima-integrity_measure-support-fix-2 security/evm/ima/ima_fs.c
--- a/security/evm/ima/ima_fs.c~integrity-ima-integrity_measure-support-fix-2
+++ a/security/evm/ima/ima_fs.c
@@ -269,7 +269,7 @@ out:
 	return -1;
 }
 
-void __exit ima_fs_cleanup(void)
+void ima_fs_cleanup(void)
 {
 	securityfs_remove(violations);
 	securityfs_remove(runtime_measurements_count);
diff -puN security/evm/ima/ima_init.c~integrity-ima-integrity_measure-support-fix-2 security/evm/ima/ima_init.c
diff -puN security/evm/ima/ima_main.c~integrity-ima-integrity_measure-support-fix-2 security/evm/ima/ima_main.c
diff -puN security/evm/ima/ima_queue.c~integrity-ima-integrity_measure-support-fix-2 security/evm/ima/ima_queue.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
git-acpi-fixup.patch
git-alsa.patch
git-alsa-fixup.patch
git-avr32.patch
git-avr32-fixup.patch
git-drm.patch
git-dvb.patch
revert-jdelvare-hwmon-hwmon-coretemp-new-driver.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-ieee1394-vs-gregkh-driver-driver-core-use-attribute-groups-in-struct-device_type.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
git-libata-all-ipr-fix.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-ubi.patch
git-netdev-all.patch
forcedeth-work-around-null-skb-dereference-crash-fix.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
fix-gregkh-pci-pci-piggy-bus.patch
git-pciseg.patch
git-scsi-rc-fixes.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
allow-i386-crash-kernels-to-handle-x86_64-dumps-fix.patch
prevent-acpi-quirk-warning-mass-spamming-in-logs-tidy.patch
i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda-fix.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
driver_bfin_serial_core-update.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-an-anonymous-inode-source-tidy.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lists-add-list-splice-tail.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
sys_futex64-allows-64bit-futexes-workaround.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
revoke-core-code-fix-shared-mapping-revoke.patch
fbdev-hecuba-framebuffer-driver.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
mm-only-hrtimers-debug-patch-fix.patch

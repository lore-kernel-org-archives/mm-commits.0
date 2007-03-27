From: akpm@linux-foundation.org
Subject: - forcedeth-work-around-null-skb-dereference-crash-fix.patch removed from -mm tree
Date: Mon, 26 Mar 2007 21:45:51 -0800
Message-ID: <200703270545.l2R5jpip008230@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40167 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934025AbXC0Fsm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 01:48:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aabdulla@nvidia.com, jeff@garzik.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     forcedeth-work-around-null-skb-dereference-crash-fix
has been removed from the -mm tree.  Its filename was
     forcedeth-work-around-null-skb-dereference-crash-fix.patch

This patch was dropped because it was folded into forcedeth-work-around-null-skb-dereference-crash.patch

------------------------------------------------------
Subject: forcedeth-work-around-null-skb-dereference-crash-fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/net/forcedeth.c: In function 'nv_tx_done':
drivers/net/forcedeth.c:1906: warning: format '%ld' expects type 'long int', but argument 2 has type 'int'
drivers/net/forcedeth.c:1906: warning: format '%ld' expects type 'long int', but argument 3 has type 'int'
drivers/net/forcedeth.c:1926: warning: format '%ld' expects type 'long int', but argument 2 has type 'int'
drivers/net/forcedeth.c:1926: warning: format '%ld' expects type 'long int', but argument 3 has type 'int'

- Print ptrdiff_t's correctly

- My xterms aren't as studly as yours.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN drivers/net/forcedeth.c~forcedeth-work-around-null-skb-dereference-crash-fix drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-work-around-null-skb-dereference-crash-fix
+++ a/drivers/net/forcedeth.c
@@ -1903,7 +1903,12 @@ static void nv_tx_done(struct net_device
 					np->stats.tx_errors++;
 				} else {
 					if (!np->get_tx_ctx->skb) {
-						printk("get_tx: %ld, put_tx: %ld\n", np->get_tx_ctx - np->first_tx_ctx, np->put_tx_ctx - np->first_tx_ctx);
+						printk("get_tx: %td, put_tx: "
+							"%td\n",
+							np->get_tx_ctx -
+							    np->first_tx_ctx,
+							np->put_tx_ctx -
+							    np->first_tx_ctx);
 						WARN_ON(1);
 						break;
 					}
@@ -1923,7 +1928,12 @@ static void nv_tx_done(struct net_device
 					np->stats.tx_errors++;
 				} else {
 					if (!np->get_tx_ctx->skb) {
-						printk("get_tx: %ld, put_tx: %ld\n", np->get_tx_ctx - np->first_tx_ctx, np->put_tx_ctx - np->first_tx_ctx);
+						printk("get_tx: %td, put_tx: "
+							"%td\n",
+							np->get_tx_ctx -
+							    np->first_tx_ctx,
+							np->put_tx_ctx -
+							    np->first_tx_ctx);
 						WARN_ON(1);
 						break;
 					}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-avr32.patch
git-avr32-fixup.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-ieee1394-vs-gregkh-driver-driver-core-use-attribute-groups-in-struct-device_type.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
git-libata-all-ipr-fix.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-ubi.patch
git-netdev-all.patch
forcedeth-work-around-null-skb-dereference-crash.patch
forcedeth-work-around-null-skb-dereference-crash-fix.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
fix-gregkh-pci-pci-piggy-bus.patch
fix-gregkh-pci-pci-cleanup-the-includes-of-linux-pcih.patch
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
make-aout-executables-work-again-fix.patch
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
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch
add-an-anonymous-inode-source-tidy.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
time-smp-friendly-alignment-of-struct-clocksource-fix.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
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

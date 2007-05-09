From: akpm@linux-foundation.org
Subject: - lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch removed from -mm tree
Date: Wed, 09 May 2007 02:42:47 -0700
Message-ID: <200705090942.l499gl2h020181@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755907AbXEIJn1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:43:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@suse.de, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest-the-host-code vs x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.txt
has been removed from the -mm tree.  Its filename was
     lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch

This patch was dropped because it was folded into lguest-the-host-code.patch

------------------------------------------------------
Subject: lguest-the-host-code vs x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.txt
From: Andrew Morton <akpm@linux-foundation.org>

Looks like Andi did the deed.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lg.h |   27 ---------------------------
 1 files changed, 27 deletions(-)

diff -puN drivers/lguest/lg.h~lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions drivers/lguest/lg.h
--- a/drivers/lguest/lg.h~lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions
+++ a/drivers/lguest/lg.h
@@ -85,33 +85,6 @@ struct pgdir
 	spgd_t *pgdir;
 };
 
-/* FIXME: When this is defined in processor.h, delete this definition. */
-struct i386_hw_tss {
-	unsigned short	back_link,__blh;
-	unsigned long	esp0;
-	unsigned short	ss0,__ss0h;
-	unsigned long	esp1;
-	unsigned short	ss1,__ss1h;	/* ss1 is used to cache MSR_IA32_SYSENTER_CS */
-	unsigned long	esp2;
-	unsigned short	ss2,__ss2h;
-	unsigned long	__cr3;
-	unsigned long	eip;
-	unsigned long	eflags;
-	unsigned long	eax,ecx,edx,ebx;
-	unsigned long	esp;
-	unsigned long	ebp;
-	unsigned long	esi;
-	unsigned long	edi;
-	unsigned short	es, __esh;
-	unsigned short	cs, __csh;
-	unsigned short	ss, __ssh;
-	unsigned short	ds, __dsh;
-	unsigned short	fs, __fsh;
-	unsigned short	gs, __gsh;
-	unsigned short	ldt, __ldth;
-	unsigned short	trace, io_bitmap_base;
-};
-
 /* This is a guest-specific page (mapped ro) into the guest. */
 struct lguest_ro_state
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmc-build-fix.patch
slub-add-support-for-dynamic-cacheline-size-determination.patch
swsusp-clean-up-print.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
nbd-check-the-return-value-of-sysfs_create_file.patch
mutex_lock_interruptible-add-__must_check.patch
afs-implement-basic-file-write-support.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
kthread-dont-depend-on-work-queues-take-2.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
make-cancel_rearming_delayed_work-reliable.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
fs-convert-core-functions-to-zero_user_page.patch
rename-thread_info-to-stack.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-avr32.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
cinergyt2-fix-file-release-handler.patch
git-hid-fixup.patch
git-ia64-sa_interrupt-is-deprecated.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix-2.patch
git-ieee1394.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
git-mtd.patch
git-battery-fix.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-watchdog.patch
git-wireless.patch
git-wireless-fixup.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-add-support-for-picopower-irq-router-fix.patch
xfs-clean-up-shrinker-games.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
upper-32-bits.patch
lib-hexdump-fix.patch
tty-add-compat_ioctl-fix.patch
blacklist-dell-optiplex-320-from-using-the-hpet-fix.patch
linux-kernel-markers-i386-optimization.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
ntfs-use-zero_user_page.patch
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
w1-build-fix.patch

From: akpm@linux-foundation.org
Subject: + git-acpi-fixup.patch added to -mm tree
Date: Mon, 25 Jun 2007 01:57:25 -0700
Message-ID: <200706250857.l5P8vRmv030665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39147 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153AbXFYI5i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 04:57:38 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l5P8vaLU021886
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 25 Jun 2007 01:57:37 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     git-acpi-fixup
has been added to the -mm tree.  Its filename is
     git-acpi-fixup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-acpi-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c |  374 --------------------------------
 1 file changed, 374 deletions(-)

diff -puN drivers/acpi/processor_idle.c~git-acpi-fixup drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~git-acpi-fixup
+++ a/drivers/acpi/processor_idle.c
@@ -252,380 +252,6 @@ static void acpi_state_timer_broadcast(s
 
 #endif
 
-<<<<<<< HEAD/drivers/acpi/processor_idle.c
-static void acpi_processor_idle(void)
-{
-	struct acpi_processor *pr = NULL;
-	struct acpi_processor_cx *cx = NULL;
-	struct acpi_processor_cx *next_state = NULL;
-	int sleep_ticks = 0;
-	u32 t1, t2 = 0;
-
-	/*
-	 * Interrupts must be disabled during bus mastering calculations and
-	 * for C2/C3 transitions.
-	 */
-	local_irq_disable();
-
-	pr = processors[smp_processor_id()];
-	if (!pr) {
-		local_irq_enable();
-		return;
-	}
-
-	/*
-	 * Check whether we truly need to go idle, or should
-	 * reschedule:
-	 */
-	if (unlikely(need_resched())) {
-		local_irq_enable();
-		return;
-	}
-
-	cx = pr->power.state;
-	if (!cx) {
-		if (pm_idle_save)
-			pm_idle_save();
-		else
-			acpi_safe_halt();
-		return;
-	}
-
-	/*
-	 * Check BM Activity
-	 * -----------------
-	 * Check for bus mastering activity (if required), record, and check
-	 * for demotion.
-	 */
-	if (pr->flags.bm_check) {
-		u32 bm_status = 0;
-		unsigned long diff = jiffies - pr->power.bm_check_timestamp;
-
-		if (diff > 31)
-			diff = 31;
-
-		pr->power.bm_activity <<= diff;
-
-		acpi_get_register(ACPI_BITREG_BUS_MASTER_STATUS, &bm_status);
-		if (bm_status) {
-			pr->power.bm_activity |= 0x1;
-			acpi_set_register(ACPI_BITREG_BUS_MASTER_STATUS, 1);
-		}
-		/*
-		 * PIIX4 Erratum #18: Note that BM_STS doesn't always reflect
-		 * the true state of bus mastering activity; forcing us to
-		 * manually check the BMIDEA bit of each IDE channel.
-		 */
-		else if (errata.piix4.bmisx) {
-			if ((inb_p(errata.piix4.bmisx + 0x02) & 0x01)
-			    || (inb_p(errata.piix4.bmisx + 0x0A) & 0x01))
-				pr->power.bm_activity |= 0x1;
-		}
-
-		pr->power.bm_check_timestamp = jiffies;
-
-		/*
-		 * If bus mastering is or was active this jiffy, demote
-		 * to avoid a faulty transition.  Note that the processor
-		 * won't enter a low-power state during this call (to this
-		 * function) but should upon the next.
-		 *
-		 * TBD: A better policy might be to fallback to the demotion
-		 *      state (use it for this quantum only) istead of
-		 *      demoting -- and rely on duration as our sole demotion
-		 *      qualification.  This may, however, introduce DMA
-		 *      issues (e.g. floppy DMA transfer overrun/underrun).
-		 */
-		if ((pr->power.bm_activity & 0x1) &&
-		    cx->demotion.threshold.bm) {
-			local_irq_enable();
-			next_state = cx->demotion.state;
-			goto end;
-		}
-	}
-
-#ifdef CONFIG_HOTPLUG_CPU
-	/*
-	 * Check for P_LVL2_UP flag before entering C2 and above on
-	 * an SMP system. We do it here instead of doing it at _CST/P_LVL
-	 * detection phase, to work cleanly with logical CPU hotplug.
-	 */
-	if ((cx->type != ACPI_STATE_C1) && (num_online_cpus() > 1) && 
-	    !pr->flags.has_cst && !(acpi_gbl_FADT.flags & ACPI_FADT_C2_MP_SUPPORTED))
-		cx = &pr->power.states[ACPI_STATE_C1];
-#endif
-
-	/*
-	 * Sleep:
-	 * ------
-	 * Invoke the current Cx state to put the processor to sleep.
-	 */
-	if (cx->type == ACPI_STATE_C2 || cx->type == ACPI_STATE_C3) {
-		current_thread_info()->status &= ~TS_POLLING;
-		/*
-		 * TS_POLLING-cleared state must be visible before we
-		 * test NEED_RESCHED:
-		 */
-		smp_mb();
-		if (need_resched()) {
-			current_thread_info()->status |= TS_POLLING;
-			local_irq_enable();
-			return;
-		}
-	}
-
-	switch (cx->type) {
-
-	case ACPI_STATE_C1:
-		/*
-		 * Invoke C1.
-		 * Use the appropriate idle routine, the one that would
-		 * be used without acpi C-states.
-		 */
-		if (pm_idle_save)
-			pm_idle_save();
-		else
-			acpi_safe_halt();
-
-		/*
-		 * TBD: Can't get time duration while in C1, as resumes
-		 *      go to an ISR rather than here.  Need to instrument
-		 *      base interrupt handler.
-		 */
-		sleep_ticks = 0xFFFFFFFF;
-		break;
-
-	case ACPI_STATE_C2:
-		/* Get start time (ticks) */
-		t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
-		/* Invoke C2 */
-		acpi_state_timer_broadcast(pr, cx, 1);
-		acpi_cstate_enter(cx);
-		/* Get end time (ticks) */
-		t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
-
-#ifdef CONFIG_GENERIC_TIME
-		/* TSC halts in C2, so notify users */
-		mark_tsc_unstable("possible TSC halt in C2");
-#endif
-		/* Re-enable interrupts */
-		local_irq_enable();
-		current_thread_info()->status |= TS_POLLING;
-		/* Compute time (ticks) that we were actually asleep */
-		sleep_ticks =
-		    ticks_elapsed(t1, t2) - cx->latency_ticks - C2_OVERHEAD;
-		acpi_state_timer_broadcast(pr, cx, 0);
-		break;
-
-	case ACPI_STATE_C3:
-
-		if (pr->flags.bm_check) {
-			if (atomic_inc_return(&c3_cpu_count) ==
-			    num_online_cpus()) {
-				/*
-				 * All CPUs are trying to go to C3
-				 * Disable bus master arbitration
-				 */
-				acpi_set_register(ACPI_BITREG_ARB_DISABLE, 1);
-			}
-		} else {
-			/* SMP with no shared cache... Invalidate cache  */
-			ACPI_FLUSH_CPU_CACHE();
-		}
-
-		/* Get start time (ticks) */
-		t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
-		/* Invoke C3 */
-		acpi_state_timer_broadcast(pr, cx, 1);
-		acpi_cstate_enter(cx);
-		/* Get end time (ticks) */
-		t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
-		if (pr->flags.bm_check) {
-			/* Enable bus master arbitration */
-			atomic_dec(&c3_cpu_count);
-			acpi_set_register(ACPI_BITREG_ARB_DISABLE, 0);
-		}
-
-#ifdef CONFIG_GENERIC_TIME
-		/* TSC halts in C3, so notify users */
-		mark_tsc_unstable("TSC halts in C3");
-#endif
-		/* Re-enable interrupts */
-		local_irq_enable();
-		current_thread_info()->status |= TS_POLLING;
-		/* Compute time (ticks) that we were actually asleep */
-		sleep_ticks =
-		    ticks_elapsed(t1, t2) - cx->latency_ticks - C3_OVERHEAD;
-		acpi_state_timer_broadcast(pr, cx, 0);
-		break;
-
-	default:
-		local_irq_enable();
-		return;
-	}
-	cx->usage++;
-	if ((cx->type != ACPI_STATE_C1) && (sleep_ticks > 0))
-		cx->time += sleep_ticks;
-
-	next_state = pr->power.state;
-
-#ifdef CONFIG_HOTPLUG_CPU
-	/* Don't do promotion/demotion */
-	if ((cx->type == ACPI_STATE_C1) && (num_online_cpus() > 1) &&
-	    !pr->flags.has_cst && !(acpi_gbl_FADT.flags & ACPI_FADT_C2_MP_SUPPORTED)) {
-		next_state = cx;
-		goto end;
-	}
-#endif
-
-	/*
-	 * Promotion?
-	 * ----------
-	 * Track the number of longs (time asleep is greater than threshold)
-	 * and promote when the count threshold is reached.  Note that bus
-	 * mastering activity may prevent promotions.
-	 * Do not promote above max_cstate.
-	 */
-	if (cx->promotion.state &&
-	    ((cx->promotion.state - pr->power.states) <= max_cstate)) {
-		if (sleep_ticks > cx->promotion.threshold.ticks &&
-		  cx->promotion.state->latency <= system_latency_constraint()) {
-			cx->promotion.count++;
-			cx->demotion.count = 0;
-			if (cx->promotion.count >=
-			    cx->promotion.threshold.count) {
-				if (pr->flags.bm_check) {
-					if (!
-					    (pr->power.bm_activity & cx->
-					     promotion.threshold.bm)) {
-						next_state =
-						    cx->promotion.state;
-						goto end;
-					}
-				} else {
-					next_state = cx->promotion.state;
-					goto end;
-				}
-			}
-		}
-	}
-
-	/*
-	 * Demotion?
-	 * ---------
-	 * Track the number of shorts (time asleep is less than time threshold)
-	 * and demote when the usage threshold is reached.
-	 */
-	if (cx->demotion.state) {
-		if (sleep_ticks < cx->demotion.threshold.ticks) {
-			cx->demotion.count++;
-			cx->promotion.count = 0;
-			if (cx->demotion.count >= cx->demotion.threshold.count) {
-				next_state = cx->demotion.state;
-				goto end;
-			}
-		}
-	}
-
-      end:
-	/*
-	 * Demote if current state exceeds max_cstate
-	 * or if the latency of the current state is unacceptable
-	 */
-	if ((pr->power.state - pr->power.states) > max_cstate ||
-		pr->power.state->latency > system_latency_constraint()) {
-		if (cx->demotion.state)
-			next_state = cx->demotion.state;
-	}
-
-	/*
-	 * New Cx State?
-	 * -------------
-	 * If we're going to start using a new Cx state we must clean up
-	 * from the previous and prepare to use the new.
-	 */
-	if (next_state != pr->power.state)
-		acpi_processor_power_activate(pr, next_state);
-}
-
-static int acpi_processor_set_power_policy(struct acpi_processor *pr)
-{
-	unsigned int i;
-	unsigned int state_is_set = 0;
-	struct acpi_processor_cx *lower = NULL;
-	struct acpi_processor_cx *higher = NULL;
-	struct acpi_processor_cx *cx;
-
-
-	if (!pr)
-		return -EINVAL;
-
-	/*
-	 * This function sets the default Cx state policy (OS idle handler).
-	 * Our scheme is to promote quickly to C2 but more conservatively
-	 * to C3.  We're favoring C2  for its characteristics of low latency
-	 * (quick response), good power savings, and ability to allow bus
-	 * mastering activity.  Note that the Cx state policy is completely
-	 * customizable and can be altered dynamically.
-	 */
-
-	/* startup state */
-	for (i = 1; i < ACPI_PROCESSOR_MAX_POWER; i++) {
-		cx = &pr->power.states[i];
-		if (!cx->valid)
-			continue;
-
-		if (!state_is_set)
-			pr->power.state = cx;
-		state_is_set++;
-		break;
-	}
-
-	if (!state_is_set)
-		return -ENODEV;
-
-	/* demotion */
-	for (i = 1; i < ACPI_PROCESSOR_MAX_POWER; i++) {
-		cx = &pr->power.states[i];
-		if (!cx->valid)
-			continue;
-
-		if (lower) {
-			cx->demotion.state = lower;
-			cx->demotion.threshold.ticks = cx->latency_ticks;
-			cx->demotion.threshold.count = 1;
-			if (cx->type == ACPI_STATE_C3)
-				cx->demotion.threshold.bm = bm_history;
-		}
-
-		lower = cx;
-	}
-
-	/* promotion */
-	for (i = (ACPI_PROCESSOR_MAX_POWER - 1); i > 0; i--) {
-		cx = &pr->power.states[i];
-		if (!cx->valid)
-			continue;
-
-		if (higher) {
-			cx->promotion.state = higher;
-			cx->promotion.threshold.ticks = cx->latency_ticks;
-			if (cx->type >= ACPI_STATE_C2)
-				cx->promotion.threshold.count = 4;
-			else
-				cx->promotion.threshold.count = 10;
-			if (higher->type == ACPI_STATE_C3)
-				cx->promotion.threshold.bm = bm_history;
-		}
-
-		higher = cx;
-	}
-
-	return 0;
-}
-
-=======
->>>>>>> /drivers/acpi/processor_idle.c
 static int acpi_processor_get_power_info_fadt(struct acpi_processor *pr)
 {
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

git-acpi.patch
git-acpi-fixup.patch
git-acpi-tickh-needs-hrtimerh.patch
git-acpi-add-exports.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-avr32.patch
git-cpufreq-fix.patch
bugfix-cpufreq-in-combination-with-performance-governor-fix.patch
8xx-mpc885ads-pcmcia-support.patch
revert-gregkh-driver-block-device.patch
driver-core-check-return-code-of-sysfs_create_link.patch
git-dvb.patch
git-gfs2-nmw.patch
git-infiniband.patch
git-input.patch
serio_raw_read-warning-fix.patch
git-kbuild.patch
git-kbuild-fixup.patch
git-kvm.patch
git-leds.patch
led_colour_show-warning-fix.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
ide_scan_pcibus-cehck-__pci_register_driver-return-value.patch
git-md-accel.patch
git-mips-fixup.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
git-ubi.patch
git-netdev-all.patch
sundance-phy-address-form-0-only-for-device-id-0x0200-fix.patch
wrong-timeout-value-in-sk_wait_data-v2-fix.patch
git-battery.patch
git-ioat-vs-git-md-accel.patch
git-nfs-server-cluster-locking-api-fixup.patch
pa-risc-use-page-allocator-instead-of-slab-allocator-fix.patch
git-selinux.patch
git-selinux-fixup.patch
revert-gregkh-pci-pci_bridge-device.patch
pci-x-pci-express-read-control-interfaces-fix.patch
git-scsi-misc.patch
scsi-dont-build-scsi_dma_mapunmap-for-has_dma-fix.patch
git-unionfs.patch
fix-gregkh-usb-usb-ehci-cpufreq-fix.patch
git-watchdog.patch
git-wireless.patch
x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch
revert-x86_64-mm-verify-cpu-rename.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
fix-x86_64-mm-sched-clock-share.patch
fix-x86_64-mm-add-common-orderly_poweroff.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
x86_64-fix-smp_call_function_single-return-value.patch
i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
mmconfig-validate-against-acpi-motherboard-resources-fix.patch
mmconfig-validate-against-acpi-motherboard-resources-fix-2.patch
mmconfig-validate-against-acpi-motherboard-resources-fix-3.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
x86-64-calgary-introduce-chipset-specific-ops-fix.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2-fix.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions-fix.patch
i386-do-not-restore-reserved-memory-after-hibernation-fix.patch
paravirt-helper-to-disable-all-io-space-fix.patch
i386-x86_64-trim-memory-not-covered-by-wb-mtrrs-fix.patch
i386-x86_64-trim-memory-not-covered-by-wb-mtrrs-fix-2.patch
i386-mtrr-clean-up-usage_table.patch
i386-show-unhandled-signals-fix.patch
git-newsetup-fixup.patch
git-xfs.patch
git-cryptodev.patch
git-cryptodev-fixup.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
change-zonelist-order-v6-zonelist-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
slub-support-slub_debug-on-by-default-tidy.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-fix.patch
nick-broke-stuff.patch
nick-broke-more-stuff.patch
nick-broke-even-more-stuff.patch
nick-really-did-it-this-time.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
create-the-zone_movable-zone-fix.patch
create-the-zone_movable-zone-fix-2.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-3.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-add-proc-pid-pagemap-interface.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely-fix.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-fix.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-introduce-hibernation-and-suspend-notifiers-fix.patch
pm-introduce-hibernation-and-suspend-notifiers-tidy.patch
pm-introduce-hibernation-and-suspend-notifiers-fix-fix.patch
pm-disable-usermode-helper-before-hibernation-and-suspend-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
fuse-warning-fix.patch
vxfs-warning-fixes.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
mpu401-warning-fixes.patch
procfs-directory-entry-cleanup-fix.patch
vdso-print-fatal-signals.patch
reduce-cpusetc-write_lock_irq-to-read_lock-fix.patch
o_cloexec-for-scm_rights-fix.patch
o_cloexec-for-scm_rights-fix-2.patch
atmel_serial-fix-break-handling.patch
lib-add-idr_for_each-fix.patch
ext3-ext4-orphan-list-check-on-destroy_inode-fix.patch
taskstats-add-context-switch-counters-fix.patch
improve-behaviour-of-spurious-irq-detect-fix.patch
revert-vanishing-ioctl-handler-debugging.patch
binfmt_elf-warning-fix.patch
dirty_writeback_centisecs_handler-cleanup.patch
blink-only-blink-when-parameter-is-set-fix.patch
hfsplus-fix-mount-uid-gid-bug-tidy.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support-fix.patch
isdn-capi-warning-fixes.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
nfsd-warning-fix.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-net-driver.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver-fix-2.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer-fix.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-warning-fixes.patch
cfs-warning-fixes.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
drivers-edac-new-i82443bxgz-mc-driver-broken.patch
containersv10-basic-container-framework-fix.patch
containersv10-basic-container-framework-fix-2.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
add-containerstats-v3-fix.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
lockstat-core-infrastructure-fix-fix-fix.patch
lockdep-various-fixes-checkpatch.patch
lockstat-measure-lock-bouncing-checkpatch.patch
reiser4.patch
reiser4-fix.patch
nick-broke-reiser4-too.patch
check_dirty_inode_list.patch
w1-build-fix.patch

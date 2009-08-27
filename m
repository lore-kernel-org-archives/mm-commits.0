From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 27 Aug 2009 15:34:39 -0700
Message-ID: <200908272234.n7RMYdOJ004963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751166AbZH0Wej (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Aug 2009 18:34:39 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n7RMYdTC025779
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 27 Aug 2009 15:34:40 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_throttling.c |   34 +++++++-------------------
 drivers/net/virtio_net.c            |    7 -----
 2 files changed, 10 insertions(+), 31 deletions(-)

diff -puN drivers/acpi/processor_throttling.c~linux-next-git-rejects drivers/acpi/processor_throttling.c
--- a/drivers/acpi/processor_throttling.c~linux-next-git-rejects
+++ a/drivers/acpi/processor_throttling.c
@@ -1015,14 +1015,11 @@ static int acpi_processor_set_throttling
 	return 0;
 }
 
-<<<<<<< HEAD:drivers/acpi/processor_throttling.c
-int acpi_processor_set_throttling(struct acpi_processor *pr,
-						int state, bool force)
-=======
 struct set_throttling_info {
 	struct acpi_processor *pr;
 	struct acpi_processor_throttling *p_throttling;
 	int target_state;
+	bool force;
 	int ret;
 };
 
@@ -1031,11 +1028,11 @@ static void set_throttling(void *_sti)
 	struct set_throttling_info *s = _sti;
 
 	s->ret = s->p_throttling->acpi_processor_set_throttling(s->pr,
-								s->target_state);
+						s->target_state, s->force);
 }
 
-int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
->>>>>>> FETCH_HEAD:drivers/acpi/processor_throttling.c
+int acpi_processor_set_throttling(struct acpi_processor *pr, int state,
+				bool force)
 {
 	int ret = 0;
 	unsigned int i;
@@ -1077,17 +1074,13 @@ int acpi_processor_set_throttling(struct
 	 * it can be called only for the cpu pointed by pr.
 	 */
 	if (p_throttling->shared_type == DOMAIN_COORD_TYPE_SW_ANY) {
-<<<<<<< HEAD:drivers/acpi/processor_throttling.c
-		/* FIXME: use work_on_cpu() */
-		set_cpus_allowed_ptr(current, cpumask_of(pr->id));
-		ret = p_throttling->acpi_processor_set_throttling(pr,
-						t_state.target_state, force);
-=======
-		struct set_throttling_info sti
-			= { pr, p_throttling, t_state.target_state };
+		struct set_throttling_info sti = {
+			.pr = pr,
+			.p_throttling = p_throttling,
+			.target_state = t_state.target_state,
+			.force = force, };
 		smp_call_function_single(pr->id, set_throttling, &sti, 1);
 		ret = sti.ret;
->>>>>>> FETCH_HEAD:drivers/acpi/processor_throttling.c
 	} else {
 		/*
 		 * When the T-state coordination is SW_ALL or HW_ALL,
@@ -1118,19 +1111,12 @@ int acpi_processor_set_throttling(struct
 				continue;
 			}
 			t_state.cpu = i;
-<<<<<<< HEAD:drivers/acpi/processor_throttling.c
-			/* FIXME: use work_on_cpu() */
-			set_cpus_allowed_ptr(current, cpumask_of(i));
-			ret = match_pr->throttling.
-				acpi_processor_set_throttling(
-				match_pr, t_state.target_state, force);
-=======
 			sti.pr = match_pr;
 			sti.p_throttling = &match_pr->throttling;
 			sti.target_state = t_state.target_state;
+			sti.force = force;
 			smp_call_function_single(i, set_throttling, &sti, 1);
 			ret = sti.ret;
->>>>>>> FETCH_HEAD:drivers/acpi/processor_throttling.c
 		}
 	}
 	/*
diff -puN drivers/net/virtio_net.c~linux-next-git-rejects drivers/net/virtio_net.c
--- a/drivers/net/virtio_net.c~linux-next-git-rejects
+++ a/drivers/net/virtio_net.c
@@ -884,13 +884,6 @@ static int virtnet_probe(struct virtio_d
 	vdev->priv = vi;
 	vi->pages = NULL;
 	INIT_DELAYED_WORK(&vi->refill, refill_work);
-<<<<<<< HEAD:drivers/net/virtio_net.c
-
-	/* If they give us a callback when all buffers are done, we don't need
-	 * the timer. */
-	vi->free_in_tasklet = virtio_has_feature(vdev,VIRTIO_F_NOTIFY_ON_EMPTY);
-=======
->>>>>>> FETCH_HEAD:drivers/net/virtio_net.c
 
 	/* If we can receive ANY GSO packets, we must allocate large ones. */
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
video-initial-support-for-adv7180-update-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
checkincludespl-add-option-to-remove-duplicates-in-place.patch
leds-gpio-leds-fix-typographics-fault.patch
leds-fix-coding-style-in-worker-thread-code-for-ledtrig-gpio.patch
slram-read-buffer-overflow.patch
zorro8390-fix-read-buffer-overflow-in-zorro8390_init_one-checkpatch-fixes.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
serial167-fix-read-buffer-overflow.patch
waitqueues-give-waitqueue-spinlocks-their-own-lockdep-classes-checkpatch-fixes.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls.patch
vfs-optimize-touch_time-too.patch
fs-improve-remountro-vs-buffercache-coherency-fix.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
arches-drop-superfluous-casts-in-nr_free_pages-callers-checkpatch-fixes.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
kernel-smpc-relocate-some-code.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-add-cd-disable-support-cleanup.patch
sdio-add-mmc_quirk_lenient_fn0-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
rtc-philips-nxp-pcf2123-driver-v03-fix.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch
drivers-video-add-kmalloc-null-tests-fix.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch
cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memcg-improve-resource-counter-scalability-checkpatch-fixes.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch


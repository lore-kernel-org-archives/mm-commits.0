From: akpm@linux-foundation.org
Subject: + memstick-add-driver-for-ricoh-r5c592-card-reader-cleanups.patch added to -mm tree
Date: Thu, 05 Aug 2010 16:04:00 -0700
Message-ID: <201008052304.o75N402a010771@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760224Ab0HEXEW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Aug 2010 19:04:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, maximlevitsky@gmail.com, oakad@yahoo.com


The patch titled
     memstick-add-driver-for-ricoh-r5c592-card-reader-cleanups
has been added to the -mm tree.  Its filename is
     memstick-add-driver-for-ricoh-r5c592-card-reader-cleanups.patch

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
Subject: memstick-add-driver-for-ricoh-r5c592-card-reader-cleanups
From: Andrew Morton <akpm@linux-foundation.org>

- fix checkpatch warnings
- tidy up comments, fix spelling mistake
- make things static

Cc: Alex Dubov <oakad@yahoo.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/host/r592.c |   36 +++++++++++++++++----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff -puN drivers/memstick/host/r592.c~memstick-add-driver-for-ricoh-r5c592-card-reader-cleanups drivers/memstick/host/r592.c
--- a/drivers/memstick/host/r592.c~memstick-add-driver-for-ricoh-r5c592-card-reader-cleanups
+++ a/drivers/memstick/host/r592.c
@@ -25,7 +25,7 @@
 static int enable_dma = 1;
 static int debug;
 
-static char *tpc_names[] = {
+static const char *tpc_names[] = {
 	"MS_TPC_READ_MG_STATUS",
 	"MS_TPC_READ_LONG_DATA",
 	"MS_TPC_READ_SHORT_DATA",
@@ -42,7 +42,7 @@ static char *tpc_names[] = {
 	"MS_TPC_SET_CMD",
 };
 
-static char *dbg_tpc_name(int tpc)
+static const char *dbg_tpc_name(int tpc)
 {
 	return tpc_names[tpc-1];
 }
@@ -77,7 +77,7 @@ static inline void r592_write_reg_be(str
 	return r592_write_reg(dev, address, cpu_to_be32(value));
 }
 
-/* Set specific bits in a register (little endian)*/
+/* Set specific bits in a register (little endian) */
 static inline void r592_set_reg_mask(struct r592_device *dev,
 							int address, u32 mask)
 {
@@ -87,7 +87,7 @@ static inline void r592_set_reg_mask(str
 	mmiowb();
 }
 
-/* Clear specific bits in a register (little endian)*/
+/* Clear specific bits in a register (little endian) */
 static inline void r592_clear_reg_mask(struct r592_device *dev,
 						int address, u32 mask)
 {
@@ -280,10 +280,12 @@ static int r592_transfer_fifo_dma(struct
 	return dev->dma_error;
 }
 
-/* writes the FIFO in 4 byte chunks
-   if lenght isn't 4 byte aligned, it spills remaining bytes into 'spill' buffer
-   it also accepts spill from former write
-   to flush a write, just call this with null  buffer */
+/*
+ * Writes the FIFO in 4 byte chunks.
+ * If length isn't 4 byte aligned, it spills remaining bytes into 'spill'
+ * buffer.  It also accepts spill from former write to flush a write, just call
+ * this with null  buffer
+ */
 static void r592_write_fifo_pio(struct r592_device *dev,
 	struct dword_buffer *spill, unsigned char *buffer, int len)
 {
@@ -321,11 +323,11 @@ static void r592_write_fifo_pio(struct r
 		spill->dword[spill->len++] = *buffer++;
 }
 
-/* Read a fifo in 4 bytes chunks.
-   if input doesn't fit the buffer, it places bytes of last dword in spill
-   buffer, so that they don't get lost
-   on last read, just throw these away
-*/
+/*
+ * Read a fifo in 4 bytes chunks.
+ * If input doesn't fit the buffer, it places bytes of last dword in spill
+ * buffer, so that they don't get lost on last read, just throw these away.
+ */
 static void r592_read_fifo_pio(struct r592_device *dev,
 		struct dword_buffer *spill, unsigned char *buffer, int len)
 {
@@ -686,7 +688,7 @@ static const struct pci_device_id r592_p
 };
 
 /* Main entry */
-int r592_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+static int r592_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	int error = -ENOMEM;
 	struct memstick_host *host;
@@ -774,7 +776,7 @@ error1:
 	return error;
 }
 
-void r592_remove(struct pci_dev *pdev)
+static void r592_remove(struct pci_dev *pdev)
 {
 	int error = 0;
 	struct r592_device *dev = pci_get_drvdata(pdev);
@@ -800,7 +802,7 @@ void r592_remove(struct pci_dev *pdev)
 			dev->dummy_dma_page_physical_address);
 }
 
-int r592_suspend(struct device *core_dev)
+static int r592_suspend(struct device *core_dev)
 {
 	struct pci_dev *pdev = to_pci_dev(core_dev);
 	struct r592_device *dev = pci_get_drvdata(pdev);
@@ -811,7 +813,7 @@ int r592_suspend(struct device *core_dev
 	return 0;
 }
 
-int r592_resume(struct device *core_dev)
+static int r592_resume(struct device *core_dev)
 {
 	struct pci_dev *pdev = to_pci_dev(core_dev);
 	struct r592_device *dev = pci_get_drvdata(pdev);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
mm-vmap-area-cache.patch
acpi-fix-bogus-preemption-logic.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
hpet-factor-timer-allocate-from-open.patch
revert-old-timer-added-usleep_range-timer.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
scsi-remove-private-bit-macros.patch
fs-bio-integrityc-return-enomem-on-kmalloc-failure.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
mm-track-the-root-oldest-anon_vma-fix.patch
oom-improve-commentary-in-dump_tasks.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
shmem-reduce-one-time-of-locking-in-pagefault-fix.patch
rmap-always-use-anon_vma-root-pointer-fix-false-positive-bug_on-in-__page_set_anon_rmap-checkpatch-fixes.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation-checkpatch-fixes.patch
vmscan-simplify-shrink_inactive_list-checkpatch-fixes.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages-checkpatch-fixes.patch
oom-dont-try-to-kill-oom_unkillable-child-checkpatch-fixes.patch
oom-move-badness-declaration-into-oomh.patch
oom-move-badness-declaration-into-oomh-fix.patch
writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds-fix.patch
vmscan-shrink_slab-require-number-of-lru_pages-not-page-order-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-fix.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update-checkpatch-fixes.patch
flex_array-add-helpers-to-get-and-put-to-make-pointers-easy-to-use-cleanup.patch
edd-fix-possible-memory-leak-in-edd_init-error-path-fix.patch
mmc-recognize-csd-structure-fix.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
checkpatch-prefer-usleep_range-over-udelay-fix.patch
hwmon-add-support-for-jedec-jc-424-compliant-temperature-sensors.patch
drivers-hwmon-coretempc-remove-unneeded-ifdef-config_hotplug_cpu.patch
fix-vc-vc_origin-on-take_over_console-checkpatch-fixes.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
rtc-add-support-for-ds3232-rtc-fix.patch
drivers-video-via-via-gpioc-fix-warning.patch
drivers-video-igafbc-make-igafb_setup-and-igafb_init-static.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
lib-bugc-make-warn-implementation-match-the-kernel-panicc-one-checkpatch-fixes.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-cleanups.patch
fs-sysv-v7-adjust-sanity-checks-for-some-volumes-checkpatch-fixes.patch
fs-sysv-superc-add-support-for-non-pdp11-v7-filesystems-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch


From: akpm@linux-foundation.org
Subject: + gcc-46-acpi-fix-unused-but-set-variables-in-acpi.patch added to -mm tree
Date: Fri, 18 Jun 2010 16:31:35 -0700
Message-ID: <201006182331.o5INVZDa029550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752884Ab0FRXbl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 19:31:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, lenb@kernel.org


The patch titled
     gcc-4.6: acpi: fix unused but set variables in ACPI
has been added to the -mm tree.  Its filename is
     gcc-46-acpi-fix-unused-but-set-variables-in-acpi.patch

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
Subject: gcc-4.6: acpi: fix unused but set variables in ACPI
From: Andi Kleen <andi@firstfloor.org>

Some minor improvements in error handling, but overall it was mostly dead
code.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/acpica/utmutex.c    |    5 +----
 drivers/acpi/numa.c              |    4 +---
 drivers/acpi/osl.c               |    7 +++----
 drivers/acpi/power.c             |    6 +-----
 drivers/acpi/processor_idle.c    |    3 +--
 drivers/acpi/processor_thermal.c |    2 ++
 drivers/acpi/video.c             |   10 +++++-----
 drivers/ata/libata-acpi.c        |    6 ------
 8 files changed, 14 insertions(+), 29 deletions(-)

diff -puN drivers/acpi/acpica/utmutex.c~gcc-46-acpi-fix-unused-but-set-variables-in-acpi drivers/acpi/acpica/utmutex.c
--- a/drivers/acpi/acpica/utmutex.c~gcc-46-acpi-fix-unused-but-set-variables-in-acpi
+++ a/drivers/acpi/acpica/utmutex.c
@@ -279,13 +279,10 @@ acpi_status acpi_ut_acquire_mutex(acpi_m
 
 acpi_status acpi_ut_release_mutex(acpi_mutex_handle mutex_id)
 {
-	acpi_thread_id this_thread_id;
-
 	ACPI_FUNCTION_NAME(ut_release_mutex);
 
-	this_thread_id = acpi_os_get_thread_id();
 	ACPI_DEBUG_PRINT((ACPI_DB_MUTEX, "Thread %p releasing Mutex [%s]\n",
-			  ACPI_CAST_PTR(void, this_thread_id),
+			  ACPI_CAST_PTR(void, acpi_os_get_thread_id()),
 			  acpi_ut_get_mutex_name(mutex_id)));
 
 	if (mutex_id > ACPI_MAX_MUTEX) {
diff -puN drivers/acpi/numa.c~gcc-46-acpi-fix-unused-but-set-variables-in-acpi drivers/acpi/numa.c
--- a/drivers/acpi/numa.c~gcc-46-acpi-fix-unused-but-set-variables-in-acpi
+++ a/drivers/acpi/numa.c
@@ -255,12 +255,10 @@ acpi_parse_memory_affinity(struct acpi_s
 
 static int __init acpi_parse_srat(struct acpi_table_header *table)
 {
-	struct acpi_table_srat *srat;
-
 	if (!table)
 		return -EINVAL;
 
-	srat = (struct acpi_table_srat *)table;
+	/* Real work done in acpi_table_parse_srat below. */
 
 	return 0;
 }
diff -puN drivers/acpi/osl.c~gcc-46-acpi-fix-unused-but-set-variables-in-acpi drivers/acpi/osl.c
--- a/drivers/acpi/osl.c~gcc-46-acpi-fix-unused-but-set-variables-in-acpi
+++ a/drivers/acpi/osl.c
@@ -141,15 +141,14 @@ static struct osi_linux {
 static void __init acpi_request_region (struct acpi_generic_address *addr,
 	unsigned int length, char *desc)
 {
-	struct resource *res;
-
 	if (!addr->address || !length)
 		return;
 
+	/* Resources are never freed */
 	if (addr->space_id == ACPI_ADR_SPACE_SYSTEM_IO)
-		res = request_region(addr->address, length, desc);
+		request_region(addr->address, length, desc);
 	else if (addr->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
-		res = request_mem_region(addr->address, length, desc);
+		request_mem_region(addr->address, length, desc);
 }
 
 static int __init acpi_reserve_resources(void)
diff -puN drivers/acpi/power.c~gcc-46-acpi-fix-unused-but-set-variables-in-acpi drivers/acpi/power.c
--- a/drivers/acpi/power.c~gcc-46-acpi-fix-unused-but-set-variables-in-acpi
+++ a/drivers/acpi/power.c
@@ -553,8 +553,6 @@ static int acpi_power_seq_show(struct se
 	int result = 0, state;
 	struct acpi_power_resource *resource = NULL;
 	struct list_head *node, *next;
-	struct acpi_power_reference *ref;
-
 
 	resource = seq->private;
 
@@ -579,10 +577,8 @@ static int acpi_power_seq_show(struct se
 	}
 
 	mutex_lock(&resource->resource_lock);
-	list_for_each_safe(node, next, &resource->reference) {
-		ref = container_of(node, struct acpi_power_reference, node);
+	list_for_each_safe(node, next, &resource->reference)
 		count++;
-	}
 	mutex_unlock(&resource->resource_lock);
 
 	seq_printf(seq, "system level:            S%d\n"
diff -puN drivers/acpi/processor_idle.c~gcc-46-acpi-fix-unused-but-set-variables-in-acpi drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~gcc-46-acpi-fix-unused-but-set-variables-in-acpi
+++ a/drivers/acpi/processor_idle.c
@@ -798,13 +798,12 @@ static inline void acpi_idle_do_entry(st
 	} else if (cx->entry_method == ACPI_CSTATE_HALT) {
 		acpi_safe_halt();
 	} else {
-		int unused;
 		/* IO port based C-state */
 		inb(cx->address);
 		/* Dummy wait op - must do something useless after P_LVL2 read
 		   because chipsets cannot guarantee that STPCLK# signal
 		   gets asserted in time to freeze execution properly. */
-		unused = inl(acpi_gbl_FADT.xpm_timer_block.address);
+		inl(acpi_gbl_FADT.xpm_timer_block.address);
 	}
 	start_critical_timings();
 }
diff -puN drivers/acpi/processor_thermal.c~gcc-46-acpi-fix-unused-but-set-variables-in-acpi drivers/acpi/processor_thermal.c
--- a/drivers/acpi/processor_thermal.c~gcc-46-acpi-fix-unused-but-set-variables-in-acpi
+++ a/drivers/acpi/processor_thermal.c
@@ -506,6 +506,8 @@ static ssize_t acpi_processor_write_limi
 	}
 
 	result = acpi_processor_apply_limit(pr);
+	if (result < 0)
+		return result;
 
 	return count;
 }
diff -puN drivers/acpi/video.c~gcc-46-acpi-fix-unused-but-set-variables-in-acpi drivers/acpi/video.c
--- a/drivers/acpi/video.c~gcc-46-acpi-fix-unused-but-set-variables-in-acpi
+++ a/drivers/acpi/video.c
@@ -2140,7 +2140,7 @@ acpi_video_bus_get_devices(struct acpi_v
 		status = acpi_video_bus_get_one_device(dev, video);
 		if (ACPI_FAILURE(status)) {
 			printk(KERN_WARNING PREFIX
-					"Cant attach device");
+					"Cant attach device\n");
 			continue;
 		}
 	}
@@ -2150,19 +2150,19 @@ acpi_video_bus_get_devices(struct acpi_v
 static int acpi_video_bus_put_one_device(struct acpi_video_device *device)
 {
 	acpi_status status;
-	struct acpi_video_bus *video;
-
 
 	if (!device || !device->video)
 		return -ENOENT;
 
-	video = device->video;
-
 	acpi_video_device_remove_fs(device->dev);
 
 	status = acpi_remove_notify_handler(device->dev->handle,
 					    ACPI_DEVICE_NOTIFY,
 					    acpi_video_device_notify);
+	if (ACPI_FAILURE(status)) {
+		printk(KERN_WARNING PREFIX
+		       "Cant remove video notify handler\n");
+	}
 	if (device->backlight) {
 		sysfs_remove_link(&device->backlight->dev.kobj, "device");
 		backlight_device_unregister(device->backlight);
diff -puN drivers/ata/libata-acpi.c~gcc-46-acpi-fix-unused-but-set-variables-in-acpi drivers/ata/libata-acpi.c
--- a/drivers/ata/libata-acpi.c~gcc-46-acpi-fix-unused-but-set-variables-in-acpi
+++ a/drivers/ata/libata-acpi.c
@@ -145,12 +145,6 @@ static void ata_acpi_handle_hotplug(stru
 	struct ata_eh_info *ehi = &ap->link.eh_info;
 	int wait = 0;
 	unsigned long flags;
-	acpi_handle handle;
-
-	if (dev)
-		handle = dev->acpi_handle;
-	else
-		handle = ap->acpi_handle;
 
 	spin_lock_irqsave(ap->lock, flags);
 	/*
_

Patches currently in -mm which might be from andi@firstfloor.org are

linux-next.patch
percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch
modpost-support-objects-with-more-than-64k-sections.patch
kernelh-add-hw_err-printk-prefix-for-hardware-error-logging.patch
x86-use-hw_err-in-mce-handler.patch
gcc-46-irq-move-alloc_desk_mask-variables-inside-ifdef.patch
gcc-46-x86-avoid-unused-by-set-variables-in-rdmsr.patch
gcc-46-pagemap-avoid-unused-but-set-variable.patch
gcc-46-perf-fix-set-but-unused-variables-in-perf.patch
gcc-46-x86-fix-set-but-not-read-variables.patch
gcc-46-kgdb-remove-set-but-unused-newpc.patch
gcc-46-printk-use-stable-variable-to-dump-kmsg-buffer.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
gcc-46-btrfs-clean-up-unused-variables-nonbugs.patch
gcc-46-nfsd-fix-initialized-but-not-read-warnings.patch
gcc-46-acpi-fix-unused-but-set-variables-in-acpi.patch
gcc-46-mm-fix-unused-but-set-warnings.patch
gcc-46-kernel-fix-unused-but-set-warnings.patch
gcc-46-block-fix-unused-but-set-variables-in-blk-merge.patch
gcc-46-fs-fix-unused-but-set-warnings.patch


From: akpm@linux-foundation.org
Subject: + firmware_map-make-firmware_map_add_early-argument-consistent-with-firmware_map_add_hotplug.patch added to -mm tree
Date: Tue, 24 Jul 2012 15:06:57 -0700
Message-ID: <20120724220658.5BB3D1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:62238 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab2GXWG7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jul 2012 18:06:59 -0400
Received: by vcqp1 with SMTP id p1so9251vcq.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Jul 2012 15:06:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: isimatu.yasuaki@jp.fujitsu.com, dave@linux.vnet.ibm.com, hpa@zytor.com, mingo@kernel.org, tglx@linutronix.de, tj@kernel.org


The patch titled
     Subject: firmware_map: make firmware_map_add_early() argument consistent with firmware_map_add_hotplug()
has been added to the -mm tree.  Its filename is
     firmware_map-make-firmware_map_add_early-argument-consistent-with-firmware_map_add_hotplug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: firmware_map: make firmware_map_add_early() argument consistent with firmware_map_add_hotplug()

There are two ways to create /sys/firmware/memmap/X sysfs:

  - firmware_map_add_early
    When the system starts, it is calledd from e820_reserve_resources()
  - firmware_map_add_hotplug
    When the memory is hot plugged, it is called from add_memory()

But these functions are called without unifying value of end argument as
below:

  - end argument of firmware_map_add_early()   : start + size - 1
  - end argument of firmware_map_add_hogplug() : start + size

The patch unifies them to "start + size".  Even if applying the patch,
/sys/firmware/memmap/X/end file content does not change.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Reviewed-by: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/e820.c    |    2 +-
 drivers/firmware/memmap.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/x86/kernel/e820.c~firmware_map-make-firmware_map_add_early-argument-consistent-with-firmware_map_add_hotplug arch/x86/kernel/e820.c
--- a/arch/x86/kernel/e820.c~firmware_map-make-firmware_map_add_early-argument-consistent-with-firmware_map_add_hotplug
+++ a/arch/x86/kernel/e820.c
@@ -944,7 +944,7 @@ void __init e820_reserve_resources(void)
 	for (i = 0; i < e820_saved.nr_map; i++) {
 		struct e820entry *entry = &e820_saved.map[i];
 		firmware_map_add_early(entry->addr,
-			entry->addr + entry->size - 1,
+			entry->addr + entry->size,
 			e820_type_to_string(entry->type));
 	}
 }
diff -puN drivers/firmware/memmap.c~firmware_map-make-firmware_map_add_early-argument-consistent-with-firmware_map_add_hotplug drivers/firmware/memmap.c
--- a/drivers/firmware/memmap.c~firmware_map-make-firmware_map_add_early-argument-consistent-with-firmware_map_add_hotplug
+++ a/drivers/firmware/memmap.c
@@ -98,7 +98,7 @@ static LIST_HEAD(map_entries);
 /**
  * firmware_map_add_entry() - Does the real work to add a firmware memmap entry.
  * @start: Start of the memory range.
- * @end:   End of the memory range (inclusive).
+ * @end:   End of the memory range.
  * @type:  Type of the memory range.
  * @entry: Pre-allocated (either kmalloc() or bootmem allocator), uninitialised
  *         entry.
@@ -113,7 +113,7 @@ static int firmware_map_add_entry(u64 st
 	BUG_ON(start > end);
 
 	entry->start = start;
-	entry->end = end;
+	entry->end = end - 1;
 	entry->type = type;
 	INIT_LIST_HEAD(&entry->list);
 	kobject_init(&entry->kobj, &memmap_ktype);
@@ -148,7 +148,7 @@ static int add_sysfs_fw_map_entry(struct
  * firmware_map_add_hotplug() - Adds a firmware mapping entry when we do
  * memory hotplug.
  * @start: Start of the memory range.
- * @end:   End of the memory range (inclusive).
+ * @end:   End of the memory range.
  * @type:  Type of the memory range.
  *
  * Adds a firmware mapping entry. This function is for memory hotplug, it is
@@ -175,7 +175,7 @@ int __meminit firmware_map_add_hotplug(u
 /**
  * firmware_map_add_early() - Adds a firmware mapping entry.
  * @start: Start of the memory range.
- * @end:   End of the memory range (inclusive).
+ * @end:   End of the memory range.
  * @type:  Type of the memory range.
  *
  * Adds a firmware mapping entry. This function uses the bootmem allocator
_
Subject: Subject: firmware_map: make firmware_map_add_early() argument consistent with firmware_map_add_hotplug()

Patches currently in -mm which might be from isimatu.yasuaki@jp.fujitsu.com are

acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
firmware_map-make-firmware_map_add_early-argument-consistent-with-firmware_map_add_hotplug.patch
firmware_map-make-firmware_map_add_early-argument-consistent-with-firmware_map_add_hotplug-fix.patch


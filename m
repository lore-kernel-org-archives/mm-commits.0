From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 047/127] mm/memory_hotplug: introduce
 add_memory_driver_managed()
Date: Thu, 04 Jun 2020 16:48:41 -0700
Message-ID: <20200604234841.73rfF4V0E%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXso (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:48:44 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, dan.j.williams@intel.com, dave.hansen@linux.intel.com, david@redhat.com, ebiederm@xmission.com, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, pasha.tatashin@soleen.com, richard.weiyang@gmail.com, torvalds@linux-foundation.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: introduce add_memory_driver_managed()

Patch series "mm/memory_hotplug: Interface to add driver-managed system
ram", v4.

kexec (via kexec_load()) can currently not properly handle memory added
via dax/kmem, and will have similar issues with virtio-mem.  kexec-tools
will currently add all memory to the fixed-up initial firmware memmap.  In
case of dax/kmem, this means that - in contrast to a proper reboot - how
that persistent memory will be used can no longer be configured by the
kexec'd kernel.  In case of virtio-mem it will be harmful, because that
memory might contain inaccessible pieces that require coordination with
hypervisor first.

In both cases, we want to let the driver in the kexec'd kernel handle
detecting and adding the memory, like during an ordinary reboot. 
Introduce add_memory_driver_managed().  More on the samentics are in patch
#1.

In the future, we might want to make this behavior configurable for
dax/kmem- either by configuring it in the kernel (which would then also
allow to configure kexec_file_load()) or in kexec-tools by also adding
"System RAM (kmem)" memory from /proc/iomem to the fixed-up initial
firmware memmap.

More on the motivation can be found in [1] and [2].

[1] https://lkml.kernel.org/r/20200429160803.109056-1-david@redhat.com
[2] https://lkml.kernel.org/r/20200430102908.10107-1-david@redhat.com


This patch (of 3):

Some device drivers rely on memory they managed to not get added to the
initial (firmware) memmap as system RAM - so it's not used as initial
system RAM by the kernel and the driver is under control.  While this is
the case during cold boot and after a reboot, kexec is not aware of that
and might add such memory to the initial (firmware) memmap of the kexec
kernel.  We need ways to teach kernel and userspace that this system ram
is different.

For example, dax/kmem allows to decide at runtime if persistent memory is
to be used as system ram.  Another future user is virtio-mem, which has to
coordinate with its hypervisor to deal with inaccessible parts within
memory resources.

We want to let users in the kernel (esp. kexec) but also user space
(esp. kexec-tools) know that this memory has different semantics and
needs to be handled differently:
1. Don't create entries in /sys/firmware/memmap/
2. Name the memory resource "System RAM ($DRIVER)" (exposed via
   /proc/iomem) ($DRIVER might be "kmem", "virtio_mem").
3. Flag the memory resource IORESOURCE_MEM_DRIVER_MANAGED

/sys/firmware/memmap/ [1] represents the "raw firmware-provided memory
map" because "on most architectures that firmware-provided memory map is
modified afterwards by the kernel itself".  The primary user is kexec on
x86-64.  Since commit d96ae5309165 ("memory-hotplug: create
/sys/firmware/memmap entry for new memory"), we add all hotplugged memory
to that firmware memmap - which makes perfect sense for traditional memory
hotplug on x86-64, where real HW will also add hotplugged DIMMs to the
firmware memmap.  We replicate what the "raw firmware-provided memory map"
looks like after hot(un)plug.

To keep things simple, let the user provide the full resource name instead
of only the driver name - this way, we don't have to manually
allocate/craft strings for memory resources.  Also use the resource name
to make decisions, to avoid passing additional flags.  In case the name
isn't "System RAM", it's special.

We don't have to worry about firmware_map_remove() on the removal path. 
If there is no entry, it will simply return with -EINVAL.

We'll adapt dax/kmem in a follow-up patch.

[1] https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-firmware-memmap

Link: http://lkml.kernel.org/r/20200508084217.9160-1-david@redhat.com
Link: http://lkml.kernel.org/r/20200508084217.9160-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h         |    1 
 include/linux/memory_hotplug.h |    2 +
 mm/memory_hotplug.c            |   62 +++++++++++++++++++++++++++++--
 3 files changed, 61 insertions(+), 4 deletions(-)

--- a/include/linux/ioport.h~mm-memory_hotplug-introduce-add_memory_driver_managed
+++ a/include/linux/ioport.h
@@ -103,6 +103,7 @@ struct resource {
 #define IORESOURCE_MEM_32BIT		(3<<3)
 #define IORESOURCE_MEM_SHADOWABLE	(1<<5)	/* dup: IORESOURCE_SHADOWABLE */
 #define IORESOURCE_MEM_EXPANSIONROM	(1<<6)
+#define IORESOURCE_MEM_DRIVER_MANAGED	(1<<7)
 
 /* PnP I/O specific bits (IORESOURCE_BITS) */
 #define IORESOURCE_IO_16BIT_ADDR	(1<<0)
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-introduce-add_memory_driver_managed
+++ a/include/linux/memory_hotplug.h
@@ -342,6 +342,8 @@ extern void __ref free_area_init_core_ho
 extern int __add_memory(int nid, u64 start, u64 size);
 extern int add_memory(int nid, u64 start, u64 size);
 extern int add_memory_resource(int nid, struct resource *resource);
+extern int add_memory_driver_managed(int nid, u64 start, u64 size,
+				     const char *resource_name);
 extern void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 		unsigned long nr_pages, struct vmem_altmap *altmap);
 extern void remove_pfn_range_from_zone(struct zone *zone,
--- a/mm/memory_hotplug.c~mm-memory_hotplug-introduce-add_memory_driver_managed
+++ a/mm/memory_hotplug.c
@@ -98,11 +98,14 @@ void mem_hotplug_done(void)
 u64 max_mem_size = U64_MAX;
 
 /* add this memory to iomem resource */
-static struct resource *register_memory_resource(u64 start, u64 size)
+static struct resource *register_memory_resource(u64 start, u64 size,
+						 const char *resource_name)
 {
 	struct resource *res;
 	unsigned long flags =  IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
-	char *resource_name = "System RAM";
+
+	if (strcmp(resource_name, "System RAM"))
+		flags |= IORESOURCE_MEM_DRIVER_MANAGED;
 
 	/*
 	 * Make sure value parsed from 'mem=' only restricts memory adding
@@ -1057,7 +1060,8 @@ int __ref add_memory_resource(int nid, s
 	BUG_ON(ret);
 
 	/* create new memmap entry */
-	firmware_map_add_hotplug(start, start + size, "System RAM");
+	if (!strcmp(res->name, "System RAM"))
+		firmware_map_add_hotplug(start, start + size, "System RAM");
 
 	/* device_online() will take the lock when calling online_pages() */
 	mem_hotplug_done();
@@ -1083,7 +1087,7 @@ int __ref __add_memory(int nid, u64 star
 	struct resource *res;
 	int ret;
 
-	res = register_memory_resource(start, size);
+	res = register_memory_resource(start, size, "System RAM");
 	if (IS_ERR(res))
 		return PTR_ERR(res);
 
@@ -1105,6 +1109,56 @@ int add_memory(int nid, u64 start, u64 s
 }
 EXPORT_SYMBOL_GPL(add_memory);
 
+/*
+ * Add special, driver-managed memory to the system as system RAM. Such
+ * memory is not exposed via the raw firmware-provided memmap as system
+ * RAM, instead, it is detected and added by a driver - during cold boot,
+ * after a reboot, and after kexec.
+ *
+ * Reasons why this memory should not be used for the initial memmap of a
+ * kexec kernel or for placing kexec images:
+ * - The booting kernel is in charge of determining how this memory will be
+ *   used (e.g., use persistent memory as system RAM)
+ * - Coordination with a hypervisor is required before this memory
+ *   can be used (e.g., inaccessible parts).
+ *
+ * For this memory, no entries in /sys/firmware/memmap ("raw firmware-provided
+ * memory map") are created. Also, the created memory resource is flagged
+ * with IORESOURCE_MEM_DRIVER_MANAGED, so in-kernel users can special-case
+ * this memory as well (esp., not place kexec images onto it).
+ *
+ * The resource_name (visible via /proc/iomem) has to have the format
+ * "System RAM ($DRIVER)".
+ */
+int add_memory_driver_managed(int nid, u64 start, u64 size,
+			      const char *resource_name)
+{
+	struct resource *res;
+	int rc;
+
+	if (!resource_name ||
+	    strstr(resource_name, "System RAM (") != resource_name ||
+	    resource_name[strlen(resource_name) - 1] != ')')
+		return -EINVAL;
+
+	lock_device_hotplug();
+
+	res = register_memory_resource(start, size, resource_name);
+	if (IS_ERR(res)) {
+		rc = PTR_ERR(res);
+		goto out_unlock;
+	}
+
+	rc = add_memory_resource(nid, res);
+	if (rc < 0)
+		release_memory_resource(res);
+
+out_unlock:
+	unlock_device_hotplug();
+	return rc;
+}
+EXPORT_SYMBOL_GPL(add_memory_driver_managed);
+
 #ifdef CONFIG_MEMORY_HOTREMOVE
 /*
  * Confirm all pages in a range [start, end) belong to the same zone (skipping
_

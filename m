From: akpm@linux-foundation.org
Subject: [merged]
 device-dax-add-memory-via-add_memory_driver_managed.patch removed from -mm
 tree
Date: Fri, 05 Jun 2020 13:18:09 -0700
Message-ID: <20200605201809.adnfdCaeD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728126AbgFEUSK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:18:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, dan.j.williams@intel.com, dave.hansen@linux.intel.com, david@redhat.com, ebiederm@xmission.com, mhocko@suse.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, pasha.tatashin@soleen.com, richard.weiyang@gmail.com


The patch titled
     Subject: device-dax: add memory via add_memory_driver_managed()
has been removed from the -mm tree.  Its filename was
     device-dax-add-memory-via-add_memory_driver_managed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: device-dax: add memory via add_memory_driver_managed()

Currently, when adding memory, we create entries in /sys/firmware/memmap/
as "System RAM".  This will lead to kexec-tools to add that memory to the
fixed-up initial memmap for a kexec kernel (loaded via kexec_load()).  The
memory will be considered initial System RAM by the kexec'd kernel and can
no longer be reconfigured.  This is not what happens during a real reboot.

Let's add our memory via add_memory_driver_managed() now, so we won't
create entries in /sys/firmware/memmap/ and indicate the memory as "System
RAM (kmem)" in /proc/iomem.  This allows everybody (especially
kexec-tools) to identify that this memory is special and has to be treated
differently than ordinary (hotplugged) System RAM.

Before configuring the namespace:
	[root@localhost ~]# cat /proc/iomem
	...
	140000000-33fffffff : Persistent Memory
	  140000000-33fffffff : namespace0.0
	3280000000-32ffffffff : PCI Bus 0000:00

After configuring the namespace:
	[root@localhost ~]# cat /proc/iomem
	...
	140000000-33fffffff : Persistent Memory
	  140000000-1481fffff : namespace0.0
	  148200000-33fffffff : dax0.0
	3280000000-32ffffffff : PCI Bus 0000:00

After loading kmem before this change:
	[root@localhost ~]# cat /proc/iomem
	...
	140000000-33fffffff : Persistent Memory
	  140000000-1481fffff : namespace0.0
	  150000000-33fffffff : dax0.0
	    150000000-33fffffff : System RAM
	3280000000-32ffffffff : PCI Bus 0000:00

After loading kmem after this change:
	[root@localhost ~]# cat /proc/iomem
	...
	140000000-33fffffff : Persistent Memory
	  140000000-1481fffff : namespace0.0
	  150000000-33fffffff : dax0.0
	    150000000-33fffffff : System RAM (kmem)
	3280000000-32ffffffff : PCI Bus 0000:00

After a proper reboot:
	[root@localhost ~]# cat /proc/iomem
	...
	140000000-33fffffff : Persistent Memory
	  140000000-1481fffff : namespace0.0
	  148200000-33fffffff : dax0.0
	3280000000-32ffffffff : PCI Bus 0000:00

Within the kexec kernel before this change:
	[root@localhost ~]# cat /proc/iomem
	...
	140000000-33fffffff : Persistent Memory
	  140000000-1481fffff : namespace0.0
	  150000000-33fffffff : System RAM
	3280000000-32ffffffff : PCI Bus 0000:00

Within the kexec kernel after this change:
	[root@localhost ~]# cat /proc/iomem
	...
	140000000-33fffffff : Persistent Memory
	  140000000-1481fffff : namespace0.0
	  148200000-33fffffff : dax0.0
	3280000000-32ffffffff : PCI Bus 0000:00

/sys/firmware/memmap/ before this change:
	0000000000000000-000000000009fc00 (System RAM)
	000000000009fc00-00000000000a0000 (Reserved)
	00000000000f0000-0000000000100000 (Reserved)
	0000000000100000-00000000bffdf000 (System RAM)
	00000000bffdf000-00000000c0000000 (Reserved)
	00000000feffc000-00000000ff000000 (Reserved)
	00000000fffc0000-0000000100000000 (Reserved)
	0000000100000000-0000000140000000 (System RAM)
	0000000150000000-0000000340000000 (System RAM)

/sys/firmware/memmap/ after a proper reboot:
	0000000000000000-000000000009fc00 (System RAM)
	000000000009fc00-00000000000a0000 (Reserved)
	00000000000f0000-0000000000100000 (Reserved)
	0000000000100000-00000000bffdf000 (System RAM)
	00000000bffdf000-00000000c0000000 (Reserved)
	00000000feffc000-00000000ff000000 (Reserved)
	00000000fffc0000-0000000100000000 (Reserved)
	0000000100000000-0000000140000000 (System RAM)

/sys/firmware/memmap/ after this change:
	0000000000000000-000000000009fc00 (System RAM)
	000000000009fc00-00000000000a0000 (Reserved)
	00000000000f0000-0000000000100000 (Reserved)
	0000000000100000-00000000bffdf000 (System RAM)
	00000000bffdf000-00000000c0000000 (Reserved)
	00000000feffc000-00000000ff000000 (Reserved)
	00000000fffc0000-0000000100000000 (Reserved)
	0000000100000000-0000000140000000 (System RAM)

kexec-tools already seem to basically ignore any System RAM that's not on
top level when searching for areas to place kexec images - but also for
determining crash areas to dump via kdump.  Changing the resource name
won't have an impact.

Handle unloading of the driver after memory hotremove failed properly, by
duplicating the string if necessary.

Link: http://lkml.kernel.org/r/20200508084217.9160-5-david@redhat.com
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

 drivers/dax/dax-private.h |    1 +
 drivers/dax/kmem.c        |   28 ++++++++++++++++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

--- a/drivers/dax/dax-private.h~device-dax-add-memory-via-add_memory_driver_managed
+++ a/drivers/dax/dax-private.h
@@ -44,6 +44,7 @@ struct dax_region {
  * @dev - device core
  * @pgmap - pgmap for memmap setup / lifetime (driver owned)
  * @dax_mem_res: physical address range of hotadded DAX memory
+ * @dax_mem_name: name for hotadded DAX memory via add_memory_driver_managed()
  */
 struct dev_dax {
 	struct dax_region *region;
--- a/drivers/dax/kmem.c~device-dax-add-memory-via-add_memory_driver_managed
+++ a/drivers/dax/kmem.c
@@ -14,6 +14,11 @@
 #include "dax-private.h"
 #include "bus.h"
 
+/* Memory resource name used for add_memory_driver_managed(). */
+static const char *kmem_name;
+/* Set if any memory will remain added when the driver will be unloaded. */
+static bool any_hotremove_failed;
+
 int dev_dax_kmem_probe(struct device *dev)
 {
 	struct dev_dax *dev_dax = to_dev_dax(dev);
@@ -70,7 +75,12 @@ int dev_dax_kmem_probe(struct device *de
 	 */
 	new_res->flags = IORESOURCE_SYSTEM_RAM;
 
-	rc = add_memory(numa_node, new_res->start, resource_size(new_res));
+	/*
+	 * Ensure that future kexec'd kernels will not treat this as RAM
+	 * automatically.
+	 */
+	rc = add_memory_driver_managed(numa_node, new_res->start,
+				       resource_size(new_res), kmem_name);
 	if (rc) {
 		release_resource(new_res);
 		kfree(new_res);
@@ -100,6 +110,7 @@ static int dev_dax_kmem_remove(struct de
 	 */
 	rc = remove_memory(dev_dax->target_node, kmem_start, kmem_size);
 	if (rc) {
+		any_hotremove_failed = true;
 		dev_err(dev,
 			"DAX region %pR cannot be hotremoved until the next reboot\n",
 			res);
@@ -124,6 +135,7 @@ static int dev_dax_kmem_remove(struct de
 	 * permanently pinned as reserved by the unreleased
 	 * request_mem_region().
 	 */
+	any_hotremove_failed = true;
 	return 0;
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
@@ -137,12 +149,24 @@ static struct dax_device_driver device_d
 
 static int __init dax_kmem_init(void)
 {
-	return dax_driver_register(&device_dax_kmem_driver);
+	int rc;
+
+	/* Resource name is permanently allocated if any hotremove fails. */
+	kmem_name = kstrdup_const("System RAM (kmem)", GFP_KERNEL);
+	if (!kmem_name)
+		return -ENOMEM;
+
+	rc = dax_driver_register(&device_dax_kmem_driver);
+	if (rc)
+		kfree_const(kmem_name);
+	return rc;
 }
 
 static void __exit dax_kmem_exit(void)
 {
 	dax_driver_unregister(&device_dax_kmem_driver);
+	if (!any_hotremove_failed)
+		kfree_const(kmem_name);
 }
 
 MODULE_AUTHOR("Intel Corporation");
_

Patches currently in -mm which might be from david@redhat.com are

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC4B4C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A432A619EC
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239204AbhKICih (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:38:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:54052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238412AbhKICig (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:38:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80C03619E5;
        Tue,  9 Nov 2021 02:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425350;
        bh=FspEGjq2040LRRy0VnAQUgGXw6OgJbjqHiTdnKuV5xE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=TXMlcVlr9S3J/LFz10cs9JHJwYaiThLLJqDTSRUU/w03hCFGzwabI5vOA1B769uPn
         658hP4dkMDKlenxbxzMiegIWK2LfbvVrNPTv4SWesRSNr1B4KqDarAzt2gbgmh6thU
         9bGL4pN7nJOP4Jt4Aa0IFOR4IDdLXy5HUgFFmk+c=
Date:   Mon, 08 Nov 2021 18:35:50 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andy.shevchenko@gmail.com,
        arnd@arndb.de, dan.j.williams@intel.com, david@redhat.com,
        gregkh@linuxfoundation.org, guohanjun@huawei.com,
        jasowang@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, mst@redhat.com,
        rafael.j.wysocki@intel.com, torvalds@linux-foundation.org
Subject:  [patch 83/87] kernel/resource: disallow access to
 exclusive system RAM regions
Message-ID: <20211109023550.j3kP-Dt-A%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: kernel/resource: disallow access to exclusive system RAM regions

virtio-mem dynamically exposes memory inside a device memory region as
system RAM to Linux, coordinating with the hypervisor which parts are
actually "plugged" and consequently usable/accessible.  On the one hand,
the virtio-mem driver adds/removes whole memory blocks, creating/removing
busy IORESOURCE_SYSTEM_RAM resources, on the other hand, it logically
(un)plugs memory inside added memory blocks, dynamically either exposing
them to the buddy or hiding them from the buddy and marking them
PG_offline.

In contrast to physical devices, like a DIMM, the virtio-mem driver is
required to actually make use of any of the device-provided memory,
because it performs the handshake with the hypervisor.  virtio-mem memory
cannot simply be access via /dev/mem without a driver.

There is no safe way to:
a) Access plugged memory blocks via /dev/mem, as they might contain
   unplugged holes or might get silently unplugged by the virtio-mem
   driver and consequently turned inaccessible.
b) Access unplugged memory blocks via /dev/mem because the virtio-mem
   driver is required to make them actually accessible first.

The virtio-spec states that unplugged memory blocks MUST NOT be written,
and only selected unplugged memory blocks MAY be read.  We want to make
sure, this is the case in sane environments -- where the virtio-mem driver
was loaded.

We want to make sure that in a sane environment, nobody "accidentially"
accesses unplugged memory inside the device managed region.  For example,
a user might spot a memory region in /proc/iomem and try accessing it via
/dev/mem via gdb or dumping it via something else.  By the time the mmap()
happens, the memory might already have been removed by the virtio-mem
driver silently: the mmap() would succeeed and user space might
accidentially access unplugged memory.

So once the driver was loaded and detected the device along the
device-managed region, we just want to disallow any access via /dev/mem to
it.

In an ideal world, we would mark the whole region as busy ("owned by a
driver") and exclude it; however, that would be wrong, as we don't really
have actual system RAM at these ranges added to Linux ("busy system RAM").
Instead, we want to mark such ranges as "not actual busy system RAM but
still soft-reserved and prepared by a driver for future use."

Let's teach iomem_is_exclusive() to reject access to any range with
"IORESOURCE_SYSTEM_RAM | IORESOURCE_EXCLUSIVE", even if not busy and even
if "iomem=relaxed" is set.  Introduce EXCLUSIVE_SYSTEM_RAM to make it
easier for applicable drivers to depend on this setting in their Kconfig.

For now, there are no applicable ranges and we'll modify virtio-mem next
to properly set IORESOURCE_EXCLUSIVE on the parent resource container it
creates to contain all actual busy system RAM added via
add_memory_driver_managed().

Link: https://lkml.kernel.org/r/20210920142856.17758-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   29 +++++++++++++++++++----------
 mm/Kconfig        |    7 +++++++
 2 files changed, 26 insertions(+), 10 deletions(-)

--- a/kernel/resource.c~kernel-resource-disallow-access-to-exclusive-system-ram-regions
+++ a/kernel/resource.c
@@ -1719,26 +1719,23 @@ static int strict_iomem_checks;
 #endif
 
 /*
- * check if an address is reserved in the iomem resource tree
- * returns true if reserved, false if not reserved.
+ * Check if an address is exclusive to the kernel and must not be mapped to
+ * user space, for example, via /dev/mem.
+ *
+ * Returns true if exclusive to the kernel, otherwise returns false.
  */
 bool iomem_is_exclusive(u64 addr)
 {
+	const unsigned int exclusive_system_ram = IORESOURCE_SYSTEM_RAM |
+						  IORESOURCE_EXCLUSIVE;
 	bool skip_children = false, err = false;
 	int size = PAGE_SIZE;
 	struct resource *p;
 
-	if (!strict_iomem_checks)
-		return false;
-
 	addr = addr & PAGE_MASK;
 
 	read_lock(&resource_lock);
 	for_each_resource(&iomem_resource, p, skip_children) {
-		/*
-		 * We can probably skip the resources without
-		 * IORESOURCE_IO attribute?
-		 */
 		if (p->start >= addr + size)
 			break;
 		if (p->end < addr) {
@@ -1748,11 +1745,23 @@ bool iomem_is_exclusive(u64 addr)
 		skip_children = false;
 
 		/*
+		 * IORESOURCE_SYSTEM_RAM resources are exclusive if
+		 * IORESOURCE_EXCLUSIVE is set, even if they
+		 * are not busy and even if "iomem=relaxed" is set. The
+		 * responsible driver dynamically adds/removes system RAM within
+		 * such an area and uncontrolled access is dangerous.
+		 */
+		if ((p->flags & exclusive_system_ram) == exclusive_system_ram) {
+			err = true;
+			break;
+		}
+
+		/*
 		 * A resource is exclusive if IORESOURCE_EXCLUSIVE is set
 		 * or CONFIG_IO_STRICT_DEVMEM is enabled and the
 		 * resource is busy.
 		 */
-		if ((p->flags & IORESOURCE_BUSY) == 0)
+		if (!strict_iomem_checks || !(p->flags & IORESOURCE_BUSY))
 			continue;
 		if (IS_ENABLED(CONFIG_IO_STRICT_DEVMEM)
 				|| p->flags & IORESOURCE_EXCLUSIVE) {
--- a/mm/Kconfig~kernel-resource-disallow-access-to-exclusive-system-ram-regions
+++ a/mm/Kconfig
@@ -109,6 +109,13 @@ config NUMA_KEEP_MEMINFO
 config MEMORY_ISOLATION
 	bool
 
+# IORESOURCE_SYSTEM_RAM regions in the kernel resource tree that are marked
+# IORESOURCE_EXCLUSIVE cannot be mapped to user space, for example, via
+# /dev/mem.
+config EXCLUSIVE_SYSTEM_RAM
+	def_bool y
+	depends on !DEVMEM || STRICT_DEVMEM
+
 #
 # Only be set on architectures that have completely implemented memory hotplug
 # feature. If you are not sure, don't touch it.
_

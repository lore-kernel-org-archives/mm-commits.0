Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E94C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5702B61108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234634AbhKKC5J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:57:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:60352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234632AbhKKC5I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:57:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88C936103C;
        Thu, 11 Nov 2021 02:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599259;
        bh=IU0zsxuwblS3OrMcpSJYVbZIuAyJsp3D3rxzdg1YOS8=;
        h=Date:From:To:Subject:From;
        b=sPMOtyZC9v8yGJZXA1yhhF2J61WbTuN0BxMYkLm9Mo5sAoQM06fni/V4CN9EeoFsi
         Rz57LAzuOM2eAPfCBSu+ihhwXT3kqFF2nuFbkeGwjGBdWK7AWgTJ49Ri6WSBleZcfY
         8gmZhkfqdbSGO/w7k4e8eeT70apgyfhsoY1WvogY=
Date:   Wed, 10 Nov 2021 18:54:19 -0800
From:   akpm@linux-foundation.org
To:     andy.shevchenko@gmail.com, arnd@arndb.de, dan.j.williams@intel.com,
        david@redhat.com, gregkh@linuxfoundation.org, guohanjun@huawei.com,
        jasowang@redhat.com, mm-commits@vger.kernel.org, mst@redhat.com,
        rafael.j.wysocki@intel.com
Subject:  [merged]
 virtio-mem-disallow-mapping-virtio-mem-memory-via-dev-mem.patch removed
 from -mm tree
Message-ID: <20211111025419.8KJt5eC_X%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: virtio-mem: disallow mapping virtio-mem memory via /dev/mem
has been removed from the -mm tree.  Its filename was
     virtio-mem-disallow-mapping-virtio-mem-memory-via-dev-mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: virtio-mem: disallow mapping virtio-mem memory via /dev/mem

We don't want user space to be able to map virtio-mem device memory
directly (e.g., via /dev/mem) in order to have guarantees that in a sane
setup we'll never accidentially access unplugged memory within the
device-managed region of a virtio-mem device, just as required by the
virtio-spec.

As soon as the virtio-mem driver is loaded, the device region is visible
in /proc/iomem via the parent device region.  From that point on user
space is aware of the device region and we want to disallow mapping
anything inside that region (where we will dynamically (un)plug memory)
until the driver has been unloaded cleanly and e.g., another driver might
take over.

By creating our parent IORESOURCE_SYSTEM_RAM resource with
IORESOURCE_EXCLUSIVE, we will disallow any /dev/mem access to our device
region until the driver was unloaded cleanly and removed the parent
region.  This will work even though only some memory blocks are actually
currently added to Linux and appear as busy in the resource tree.

So access to the region from user space is only possible
a) if we don't load the virtio-mem driver.
b) after unloading the virtio-mem driver cleanly.

Don't build virtio-mem if access to /dev/mem cannot be restricticted -- if
we have CONFIG_DEVMEM=y but CONFIG_STRICT_DEVMEM is not set.

Link: https://lkml.kernel.org/r/20210920142856.17758-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/Kconfig      |    1 +
 drivers/virtio/virtio_mem.c |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/virtio/Kconfig~virtio-mem-disallow-mapping-virtio-mem-memory-via-dev-mem
+++ a/drivers/virtio/Kconfig
@@ -101,6 +101,7 @@ config VIRTIO_MEM
 	depends on MEMORY_HOTPLUG
 	depends on MEMORY_HOTREMOVE
 	depends on CONTIG_ALLOC
+	depends on EXCLUSIVE_SYSTEM_RAM
 	help
 	 This driver provides access to virtio-mem paravirtualized memory
 	 devices, allowing to hotplug and hotunplug memory.
--- a/drivers/virtio/virtio_mem.c~virtio-mem-disallow-mapping-virtio-mem-memory-via-dev-mem
+++ a/drivers/virtio/virtio_mem.c
@@ -2672,8 +2672,10 @@ static int virtio_mem_create_resource(st
 	if (!name)
 		return -ENOMEM;
 
+	/* Disallow mapping device memory via /dev/mem completely. */
 	vm->parent_resource = __request_mem_region(vm->addr, vm->region_size,
-						   name, IORESOURCE_SYSTEM_RAM);
+						   name, IORESOURCE_SYSTEM_RAM |
+						   IORESOURCE_EXCLUSIVE);
 	if (!vm->parent_resource) {
 		kfree(name);
 		dev_warn(&vm->vdev->dev, "could not reserve device region\n");
_

Patches currently in -mm which might be from david@redhat.com are



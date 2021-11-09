Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A4F8C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45AAE619EC
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239282AbhKICij (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:38:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:54110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238412AbhKICij (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:38:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6A25619BB;
        Tue,  9 Nov 2021 02:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425354;
        bh=x/2M/nFRhAByDW8f0OwzqySNc8QpWV6+Ngkvq3tu6NM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zQMKaDoKvTh9QUq5/Ju2oyVb3IaQ9ptW8MA4WF8icqTcXSfsO0NYaYlEy0QE7wxLW
         MAznVhRlR+UAT7xr6XF5agVLDyu+voV1mh20f424wc3hIJE3lJ4l7vHY83yLD+Arvo
         HwoPNln2WZxCKlpRxnlXaHtN+W/Pp2I5A/KixhLk=
Date:   Mon, 08 Nov 2021 18:35:53 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andy.shevchenko@gmail.com,
        arnd@arndb.de, dan.j.williams@intel.com, david@redhat.com,
        gregkh@linuxfoundation.org, guohanjun@huawei.com,
        jasowang@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, mst@redhat.com,
        rafael.j.wysocki@intel.com, torvalds@linux-foundation.org
Subject:  [patch 84/87] virtio-mem: disallow mapping virtio-mem
 memory via /dev/mem
Message-ID: <20211109023553.XYnDzjGJh%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

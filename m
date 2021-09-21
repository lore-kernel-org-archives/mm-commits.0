Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC652C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 01:01:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A100461242
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 01:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236770AbhIUBCr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Sep 2021 21:02:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243531AbhIUBAq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Sep 2021 21:00:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9A3761211;
        Tue, 21 Sep 2021 00:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632185959;
        bh=kadFlTxGDlYWWlbQtOojtej4hbhtcrIPMe/xIXP0g3Y=;
        h=Date:From:To:Subject:From;
        b=KXDrZC034dk8+fec3jy/zvvd7sdOJREHSRBvX1j8efsaqij/2zD1EgdYYNvXdWcOT
         8pQ5w3TLdw7oQRKhxhFy2JckfCsrvv4n2zVfYzXf++2UUl8swgPVrh4Y/aD4FFd0at
         oT6XWns/fP+gEB97K2ALDc5XMGpW+PMl4Eqbg7lg=
Date:   Mon, 20 Sep 2021 17:59:18 -0700
From:   akpm@linux-foundation.org
To:     andy.shevchenko@gmail.com, arnd@arndb.de, dan.j.williams@intel.com,
        david@redhat.com, gregkh@linuxfoundation.org, guohanjun@huawei.com,
        jasowang@redhat.com, mm-commits@vger.kernel.org, mst@redhat.com,
        rafael.j.wysocki@intel.com
Subject:  +
 virtio-mem-disallow-mapping-virtio-mem-memory-via-dev-mem.patch added to
 -mm tree
Message-ID: <20210921005918.69eYLcU1a%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: virtio-mem: disallow mapping virtio-mem memory via /dev/mem
has been added to the -mm tree.  Its filename is
     virtio-mem-disallow-mapping-virtio-mem-memory-via-dev-mem.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/virtio-mem-disallow-mapping-virtio-mem-memory-via-dev-mem.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/virtio-mem-disallow-mapping-virtio-mem-memory-via-dev-mem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 	depends on MEMORY_HOTPLUG_SPARSE
 	depends on MEMORY_HOTREMOVE
 	depends on CONTIG_ALLOC
+	depends on EXCLUSIVE_SYSTEM_RAM
 	help
 	 This driver provides access to virtio-mem paravirtualized memory
 	 devices, allowing to hotplug and hotunplug memory.
--- a/drivers/virtio/virtio_mem.c~virtio-mem-disallow-mapping-virtio-mem-memory-via-dev-mem
+++ a/drivers/virtio/virtio_mem.c
@@ -2525,8 +2525,10 @@ static int virtio_mem_create_resource(st
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

kernel-resource-clean-up-and-optimize-iomem_is_exclusive.patch
kernel-resource-disallow-access-to-exclusive-system-ram-regions.patch
virtio-mem-disallow-mapping-virtio-mem-memory-via-dev-mem.patch


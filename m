Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB69C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB2A361361
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbhKKCxy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:53:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:57746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234519AbhKKCxx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:53:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4B1F610A2;
        Thu, 11 Nov 2021 02:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599065;
        bh=5c0+b4I8wAhjJaSjckTGgjn1HoJ5zvT22hU+FuCpfmY=;
        h=Date:From:To:Subject:From;
        b=twUbePg6zSFkYClGp3uvDkQM1GWI9ExpoFnY1LS7ley8daG3pDTCvNPdvG/NXU3j2
         TuGHRiWBIdBOs8gLrZJHMA/f0Px5X2SSXEsq5SNukBG3Zoawoz4tDGa9ZPmIqLKqUs
         kfbOTTcEZFBJ5yHLoAjloYBrlYCadERao4QLXgAU=
Date:   Wed, 10 Nov 2021 18:51:04 -0800
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, boris.ostrovsky@oracle.com, bp@alien8.de,
        david@redhat.com, dyoung@redhat.com, hpa@zytor.com,
        jasowang@redhat.com, jgross@suse.com, mhocko@suse.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, mst@redhat.com,
        osalvador@suse.de, rafael.j.wysocki@intel.com, rppt@kernel.org,
        sstabellini@kernel.org, tglx@linutronix.de, vgoyal@redhat.com
Subject:  [merged]
 =?US-ASCII?Q?virtio-mem-factor-out-hotplug-specifics-from-virtio=5Fmem?=
 =?US-ASCII?Q?=5Finit-into-virtio=5Fmem=5Finit=5Fhotplug.patch?= removed
 from -mm tree
Message-ID: <20211111025104.rbeFWor3J%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: virtio-mem: factor out hotplug specifics from virtio_mem_init() into virtio_mem_init_hotplug()
has been removed from the -mm tree.  Its filename was
     virtio-mem-factor-out-hotplug-specifics-from-virtio_mem_init-into-virtio_mem_init_hotplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: virtio-mem: factor out hotplug specifics from virtio_mem_init() into virtio_mem_init_hotplug()

Let's prepare for a new virtio-mem kdump mode in which we don't actually
hot(un)plug any memory but only observe the state of device blocks.

Link: https://lkml.kernel.org/r/20211005121430.30136-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_mem.c |   81 ++++++++++++++++++----------------
 1 file changed, 44 insertions(+), 37 deletions(-)

--- a/drivers/virtio/virtio_mem.c~virtio-mem-factor-out-hotplug-specifics-from-virtio_mem_init-into-virtio_mem_init_hotplug
+++ a/drivers/virtio/virtio_mem.c
@@ -2392,41 +2392,10 @@ static int virtio_mem_init_vq(struct vir
 	return 0;
 }
 
-static int virtio_mem_init(struct virtio_mem *vm)
+static int virtio_mem_init_hotplug(struct virtio_mem *vm)
 {
 	const struct range pluggable_range = mhp_get_pluggable_range(true);
 	uint64_t sb_size, addr;
-	uint16_t node_id;
-
-	if (!vm->vdev->config->get) {
-		dev_err(&vm->vdev->dev, "config access disabled\n");
-		return -EINVAL;
-	}
-
-	/*
-	 * We don't want to (un)plug or reuse any memory when in kdump. The
-	 * memory is still accessible (but not mapped).
-	 */
-	if (is_kdump_kernel()) {
-		dev_warn(&vm->vdev->dev, "disabled in kdump kernel\n");
-		return -EBUSY;
-	}
-
-	/* Fetch all properties that can't change. */
-	virtio_cread_le(vm->vdev, struct virtio_mem_config, plugged_size,
-			&vm->plugged_size);
-	virtio_cread_le(vm->vdev, struct virtio_mem_config, block_size,
-			&vm->device_block_size);
-	virtio_cread_le(vm->vdev, struct virtio_mem_config, node_id,
-			&node_id);
-	vm->nid = virtio_mem_translate_node_id(vm, node_id);
-	virtio_cread_le(vm->vdev, struct virtio_mem_config, addr, &vm->addr);
-	virtio_cread_le(vm->vdev, struct virtio_mem_config, region_size,
-			&vm->region_size);
-
-	/* Determine the nid for the device based on the lowest address. */
-	if (vm->nid == NUMA_NO_NODE)
-		vm->nid = memory_add_physaddr_to_nid(vm->addr);
 
 	/* bad device setup - warn only */
 	if (!IS_ALIGNED(vm->addr, memory_block_size_bytes()))
@@ -2496,10 +2465,6 @@ static int virtio_mem_init(struct virtio
 					      vm->offline_threshold);
 	}
 
-	dev_info(&vm->vdev->dev, "start address: 0x%llx", vm->addr);
-	dev_info(&vm->vdev->dev, "region size: 0x%llx", vm->region_size);
-	dev_info(&vm->vdev->dev, "device block size: 0x%llx",
-		 (unsigned long long)vm->device_block_size);
 	dev_info(&vm->vdev->dev, "memory block size: 0x%lx",
 		 memory_block_size_bytes());
 	if (vm->in_sbm)
@@ -2508,10 +2473,52 @@ static int virtio_mem_init(struct virtio
 	else
 		dev_info(&vm->vdev->dev, "big block size: 0x%llx",
 			 (unsigned long long)vm->bbm.bb_size);
+
+	return 0;
+}
+
+static int virtio_mem_init(struct virtio_mem *vm)
+{
+	uint16_t node_id;
+
+	if (!vm->vdev->config->get) {
+		dev_err(&vm->vdev->dev, "config access disabled\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * We don't want to (un)plug or reuse any memory when in kdump. The
+	 * memory is still accessible (but not mapped).
+	 */
+	if (is_kdump_kernel()) {
+		dev_warn(&vm->vdev->dev, "disabled in kdump kernel\n");
+		return -EBUSY;
+	}
+
+	/* Fetch all properties that can't change. */
+	virtio_cread_le(vm->vdev, struct virtio_mem_config, plugged_size,
+			&vm->plugged_size);
+	virtio_cread_le(vm->vdev, struct virtio_mem_config, block_size,
+			&vm->device_block_size);
+	virtio_cread_le(vm->vdev, struct virtio_mem_config, node_id,
+			&node_id);
+	vm->nid = virtio_mem_translate_node_id(vm, node_id);
+	virtio_cread_le(vm->vdev, struct virtio_mem_config, addr, &vm->addr);
+	virtio_cread_le(vm->vdev, struct virtio_mem_config, region_size,
+			&vm->region_size);
+
+	/* Determine the nid for the device based on the lowest address. */
+	if (vm->nid == NUMA_NO_NODE)
+		vm->nid = memory_add_physaddr_to_nid(vm->addr);
+
+	dev_info(&vm->vdev->dev, "start address: 0x%llx", vm->addr);
+	dev_info(&vm->vdev->dev, "region size: 0x%llx", vm->region_size);
+	dev_info(&vm->vdev->dev, "device block size: 0x%llx",
+		 (unsigned long long)vm->device_block_size);
 	if (vm->nid != NUMA_NO_NODE && IS_ENABLED(CONFIG_NUMA))
 		dev_info(&vm->vdev->dev, "nid: %d", vm->nid);
 
-	return 0;
+	return virtio_mem_init_hotplug(vm);
 }
 
 static int virtio_mem_create_resource(struct virtio_mem *vm)
_

Patches currently in -mm which might be from david@redhat.com are



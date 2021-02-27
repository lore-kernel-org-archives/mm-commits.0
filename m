Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A2EC433E0
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F221B64F30
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhB0Cac (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:30:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:51006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230095AbhB0CaE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:30:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C241264F3D;
        Sat, 27 Feb 2021 02:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614392986;
        bh=rn3Y990sxrHU+NfIq47Cp0Pikscp68cWJdEtknP7NOo=;
        h=Date:From:To:Subject:From;
        b=GnrEGUCd8O8MNjqConaLGYnKHKWnoXYLEhJpp3iXmCHCiko7vm/qNpC2gpOD4AkLf
         FIgbJYhz+vQyKFCbr2dbJQ7DwxZnit/HHYj1xQUo5QXUW3kjAjlh7znO++dPRZGIVY
         IwKhx2Fx88rlryEnI1yVys8N1J3xnIyEJjN/0Quw=
Date:   Fri, 26 Feb 2021 18:29:45 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, ardb@kernel.org,
        catalin.marinas@arm.com, david@redhat.com, gor@linux.ibm.com,
        hca@linux.ibm.com, jasowang@redhat.com,
        Jonathan.Cameron@huawei.com, mark.rutland@arm.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org, mst@redhat.com,
        osalvador@suse.de, pankaj.gupta.linux@gmail.com,
        pankaj.gupta@cloud.ionos.com, richard.weiyang@linux.alibaba.com,
        teawaterz@linux.alibaba.com, will@kernel.org
Subject:  [merged]
 =?US-ASCII?Q?virtio-mem-check-against-mhp=5Fget=5Fpluggable=5Frange-which?=
 =?US-ASCII?Q?-memory-we-can-hotplug.patch?= removed from -mm tree
Message-ID: <20210227022945.dMQiAoyH3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: virtio-mem: check against mhp_get_pluggable_range() which memory we can hotplug
has been removed from the -mm tree.  Its filename was
     virtio-mem-check-against-mhp_get_pluggable_range-which-memory-we-can-hotplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: virtio-mem: check against mhp_get_pluggable_range() which memory we can hotplug

Right now, we only check against MAX_PHYSMEM_BITS - but turns out there
are more restrictions of which memory we can actually hotplug, especially
om arm64 or s390x once we support them: we might receive something like
-E2BIG or -ERANGE from add_memory_driver_managed(), stopping device
operation.

So, check right when initializing the device which memory we can add,
warning the user.  Try only adding actually pluggable ranges: in the worst
case, no memory provided by our device is pluggable.

In the usual case, we expect all device memory to be pluggable, and in
corner cases only some memory at the end of the device-managed memory
region to not be pluggable.

Link: https://lkml.kernel.org/r/1612149902-7867-5-git-send-email-anshuman.khandual@arm.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: teawater <teawaterz@linux.alibaba.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_mem.c |   41 ++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 14 deletions(-)

--- a/drivers/virtio/virtio_mem.c~virtio-mem-check-against-mhp_get_pluggable_range-which-memory-we-can-hotplug
+++ a/drivers/virtio/virtio_mem.c
@@ -2222,7 +2222,7 @@ static int virtio_mem_unplug_pending_mb(
  */
 static void virtio_mem_refresh_config(struct virtio_mem *vm)
 {
-	const uint64_t phys_limit = 1UL << MAX_PHYSMEM_BITS;
+	const struct range pluggable_range = mhp_get_pluggable_range(true);
 	uint64_t new_plugged_size, usable_region_size, end_addr;
 
 	/* the plugged_size is just a reflection of what _we_ did previously */
@@ -2234,15 +2234,25 @@ static void virtio_mem_refresh_config(st
 	/* calculate the last usable memory block id */
 	virtio_cread_le(vm->vdev, struct virtio_mem_config,
 			usable_region_size, &usable_region_size);
-	end_addr = vm->addr + usable_region_size;
-	end_addr = min(end_addr, phys_limit);
+	end_addr = min(vm->addr + usable_region_size - 1,
+		       pluggable_range.end);
 
-	if (vm->in_sbm)
-		vm->sbm.last_usable_mb_id =
-					 virtio_mem_phys_to_mb_id(end_addr) - 1;
-	else
-		vm->bbm.last_usable_bb_id =
-				     virtio_mem_phys_to_bb_id(vm, end_addr) - 1;
+	if (vm->in_sbm) {
+		vm->sbm.last_usable_mb_id = virtio_mem_phys_to_mb_id(end_addr);
+		if (!IS_ALIGNED(end_addr + 1, memory_block_size_bytes()))
+			vm->sbm.last_usable_mb_id--;
+	} else {
+		vm->bbm.last_usable_bb_id = virtio_mem_phys_to_bb_id(vm,
+								     end_addr);
+		if (!IS_ALIGNED(end_addr + 1, vm->bbm.bb_size))
+			vm->bbm.last_usable_bb_id--;
+	}
+	/*
+	 * If we cannot plug any of our device memory (e.g., nothing in the
+	 * usable region is addressable), the last usable memory block id will
+	 * be smaller than the first usable memory block id. We'll stop
+	 * attempting to add memory with -ENOSPC from our main loop.
+	 */
 
 	/* see if there is a request to change the size */
 	virtio_cread_le(vm->vdev, struct virtio_mem_config, requested_size,
@@ -2364,7 +2374,7 @@ static int virtio_mem_init_vq(struct vir
 
 static int virtio_mem_init(struct virtio_mem *vm)
 {
-	const uint64_t phys_limit = 1UL << MAX_PHYSMEM_BITS;
+	const struct range pluggable_range = mhp_get_pluggable_range(true);
 	uint64_t sb_size, addr;
 	uint16_t node_id;
 
@@ -2405,9 +2415,10 @@ static int virtio_mem_init(struct virtio
 	if (!IS_ALIGNED(vm->addr + vm->region_size, memory_block_size_bytes()))
 		dev_warn(&vm->vdev->dev,
 			 "The alignment of the physical end address can make some memory unusable.\n");
-	if (vm->addr + vm->region_size > phys_limit)
+	if (vm->addr < pluggable_range.start ||
+	    vm->addr + vm->region_size - 1 > pluggable_range.end)
 		dev_warn(&vm->vdev->dev,
-			 "Some memory is not addressable. This can make some memory unusable.\n");
+			 "Some device memory is not addressable/pluggable. This can make some memory unusable.\n");
 
 	/*
 	 * We want subblocks to span at least MAX_ORDER_NR_PAGES and
@@ -2429,7 +2440,8 @@ static int virtio_mem_init(struct virtio
 				     vm->sbm.sb_size;
 
 		/* Round up to the next full memory block */
-		addr = vm->addr + memory_block_size_bytes() - 1;
+		addr = max_t(uint64_t, vm->addr, pluggable_range.start) +
+		       memory_block_size_bytes() - 1;
 		vm->sbm.first_mb_id = virtio_mem_phys_to_mb_id(addr);
 		vm->sbm.next_mb_id = vm->sbm.first_mb_id;
 	} else {
@@ -2450,7 +2462,8 @@ static int virtio_mem_init(struct virtio
 		}
 
 		/* Round up to the next aligned big block */
-		addr = vm->addr + vm->bbm.bb_size - 1;
+		addr = max_t(uint64_t, vm->addr, pluggable_range.start) +
+		       vm->bbm.bb_size - 1;
 		vm->bbm.first_bb_id = virtio_mem_phys_to_bb_id(vm, addr);
 		vm->bbm.next_bb_id = vm->bbm.first_bb_id;
 	}
_

Patches currently in -mm which might be from david@redhat.com are



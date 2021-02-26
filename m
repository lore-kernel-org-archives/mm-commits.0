Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C802FC433E9
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82CF864F03
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhBZBSc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:18:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:50382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230029AbhBZBS2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:18:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E82464F17;
        Fri, 26 Feb 2021 01:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302267;
        bh=GUlb4ot3PATKNmjzlZIrYmnSgP5N8JIp72dLpu6XK/g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VoPGJHQYpAzqfWg/YY2dILNZkTVX2NCitmWK94URar5PFU7ZlwXY/x14f9Q9oY599
         WZjMeO6mG3dZgSqv/+vOhXvx1hwl1QxPyv0FiZkd71ygZhJ4dPKgGQ0eyfgSLfsszI
         mq6dC/T4/cno4SxUFaGyLsJXPpHfdE8rDIu8ksAw=
Date:   Thu, 25 Feb 2021 17:17:45 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        ardb@kernel.org, catalin.marinas@arm.com, david@redhat.com,
        gor@linux.ibm.com, hca@linux.ibm.com, jasowang@redhat.com,
        Jonathan.Cameron@huawei.com, linux-mm@kvack.org,
        mark.rutland@arm.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, mst@redhat.com, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, pankaj.gupta@cloud.ionos.com,
        richard.weiyang@linux.alibaba.com, teawaterz@linux.alibaba.com,
        torvalds@linux-foundation.org, will@kernel.org
Subject:  [patch 038/118] virtio-mem: check against
 mhp_get_pluggable_range() which memory we can hotplug
Message-ID: <20210226011745.cL3woYcnt%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

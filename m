Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB75C4338F
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 19:19:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2270360E96
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 19:19:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhHGTTw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Aug 2021 15:19:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229565AbhHGTTv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Aug 2021 15:19:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE70761042;
        Sat,  7 Aug 2021 19:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628363974;
        bh=VhkH5MBGrGuO7RwqoE4obzhug2M6yRxlMrQeS2EnVws=;
        h=Date:From:To:Subject:From;
        b=f2o02mq4Ad7/GxsLyDpKTNz38l+JHQSMGMyIKR88Mrxjf5kCNpSEQLKOxUMyKDWHF
         n6Dy8mEmz8A/v6QjEKJKlvcd6YdHC30dg/k37syLPTrrJDTCKGFQS+VEo70VYub6D2
         H6fnfG+jSNAyrt+mJ5RuUTBjuw5XInRrtOEyPtPE=
Date:   Sat, 07 Aug 2021 12:19:33 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vkuznets@redhat.com, vbabka@suse.cz,
        teawater@gmail.com, rppt@kernel.org, rjw@rjwysocki.net,
        richard.weiyang@linux.alibaba.com, rafael.j.wysocki@intel.com,
        pasha.tatashin@soleen.com, pankaj.gupta.linux@gmail.com,
        osalvador@suse.de, mst@redhat.com, mkedzier@redhat.com,
        mhocko@kernel.org, lenb@kernel.org, jasowang@redhat.com,
        gregkh@linuxfoundation.org, dave.hansen@linux.intel.com,
        dan.j.williams@intel.com, anshuman.khandual@arm.com,
        david@redhat.com
Subject:  +
 =?us-ascii?Q?virtio-mem-use-a-single-dynamic-memory-group-for-a-single?=
 =?us-ascii?Q?-virtio-mem-device.patch?= added to -mm tree
Message-ID: <20210807191933.-t7gZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: virtio-mem: use a single dynamic memory group for a single virtio-mem device
has been added to the -mm tree.  Its filename is
     virtio-mem-use-a-single-dynamic-memory-group-for-a-single-virtio-mem-device.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/virtio-mem-use-a-single-dynamic-memory-group-for-a-single-virtio-mem-device.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/virtio-mem-use-a-single-dynamic-memory-group-for-a-single-virtio-mem-device.patch

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
Subject: virtio-mem: use a single dynamic memory group for a single virtio-mem device

Let's use a single dynamic memory group.

Link: https://lkml.kernel.org/r/20210806124715.17090-8-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hui Zhu <teawater@gmail.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Marek Kedzierski <mkedzier@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_mem.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--- a/drivers/virtio/virtio_mem.c~virtio-mem-use-a-single-dynamic-memory-group-for-a-single-virtio-mem-device
+++ a/drivers/virtio/virtio_mem.c
@@ -143,6 +143,8 @@ struct virtio_mem {
 	 * add_memory_driver_managed().
 	 */
 	const char *resource_name;
+	/* Memory group identification. */
+	int mgid;
 
 	/*
 	 * We don't want to add too much memory if it's not getting onlined,
@@ -626,8 +628,8 @@ static int virtio_mem_add_memory(struct
 		addr + size - 1);
 	/* Memory might get onlined immediately. */
 	atomic64_add(size, &vm->offline_size);
-	rc = add_memory_driver_managed(vm->nid, addr, size, vm->resource_name,
-				       MHP_MERGE_RESOURCE);
+	rc = add_memory_driver_managed(vm->mgid, addr, size, vm->resource_name,
+				       MHP_MERGE_RESOURCE | MHP_NID_IS_MGID);
 	if (rc) {
 		atomic64_sub(size, &vm->offline_size);
 		dev_warn(&vm->vdev->dev, "adding memory failed: %d\n", rc);
@@ -2562,6 +2564,7 @@ static bool virtio_mem_has_memory_added(
 static int virtio_mem_probe(struct virtio_device *vdev)
 {
 	struct virtio_mem *vm;
+	uint64_t unit_pages;
 	int rc;
 
 	BUILD_BUG_ON(sizeof(struct virtio_mem_req) != 24);
@@ -2596,6 +2599,16 @@ static int virtio_mem_probe(struct virti
 	if (rc)
 		goto out_del_vq;
 
+	/* use a single dynamic memory group to cover the whole memory device */
+	if (vm->in_sbm)
+		unit_pages = PHYS_PFN(memory_block_size_bytes());
+	else
+		unit_pages = PHYS_PFN(vm->bbm.bb_size);
+	rc = memory_group_register_dynamic(vm->nid, unit_pages);
+	if (rc < 0)
+		goto out_del_resource;
+	vm->mgid = rc;
+
 	/*
 	 * If we still have memory plugged, we have to unplug all memory first.
 	 * Registering our parent resource makes sure that this memory isn't
@@ -2610,7 +2623,7 @@ static int virtio_mem_probe(struct virti
 	vm->memory_notifier.notifier_call = virtio_mem_memory_notifier_cb;
 	rc = register_memory_notifier(&vm->memory_notifier);
 	if (rc)
-		goto out_del_resource;
+		goto out_unreg_group;
 	rc = register_virtio_mem_device(vm);
 	if (rc)
 		goto out_unreg_mem;
@@ -2624,6 +2637,8 @@ static int virtio_mem_probe(struct virti
 	return 0;
 out_unreg_mem:
 	unregister_memory_notifier(&vm->memory_notifier);
+out_unreg_group:
+	memory_group_unregister(vm->mgid);
 out_del_resource:
 	virtio_mem_delete_resource(vm);
 out_del_vq:
@@ -2688,6 +2703,7 @@ static void virtio_mem_remove(struct vir
 	} else {
 		virtio_mem_delete_resource(vm);
 		kfree_const(vm->resource_name);
+		memory_group_unregister(vm->mgid);
 	}
 
 	/* remove all tracking data - no locking needed */
_

Patches currently in -mm which might be from david@redhat.com are

mm-madvise-report-sigbus-as-efault-for-madv_populate_readwrite.patch
memory-hotplugrst-remove-locking-details-from-admin-guide.patch
memory-hotplugrst-complete-admin-guide-overhaul.patch
mm-memory_hotplug-use-unsigned-long-for-pfn-in-zone_for_pfn_range.patch
mm-memory_hotplug-remove-nid-parameter-from-arch_remove_memory.patch
mm-memory_hotplug-remove-nid-parameter-from-remove_memory-and-friends.patch
acpi-memhotplug-memory-resources-cannot-be-enabled-yet.patch
mm-track-present-early-pages-per-zone.patch
mm-memory_hotplug-introduce-auto-movable-online-policy.patch
drivers-base-memory-introduce-memory-groups-to-logically-group-memory-blocks.patch
mm-memory_hotplug-track-present-pages-in-memory-groups.patch
acpi-memhotplug-use-a-single-static-memory-group-for-a-single-memory-device.patch
dax-kmem-use-a-single-static-memory-group-for-a-single-probed-unit.patch
virtio-mem-use-a-single-dynamic-memory-group-for-a-single-virtio-mem-device.patch
mm-memory_hotplug-memory-group-aware-auto-movable-online-policy.patch
mm-memory_hotplug-improved-dynamic-memory-group-aware-auto-movable-online-policy.patch


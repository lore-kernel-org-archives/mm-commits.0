Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E8F4C43217
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:55:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A32661102
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:55:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347231AbhIHC4w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:56:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347443AbhIHC4t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:56:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEBD861100;
        Wed,  8 Sep 2021 02:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069742;
        bh=DchOUER2OsRE80GcqDeXr8rX7zI15nJPpLjtfre4Ouk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fo7fFQDi9OqHCkXhw9+p2QH5jYJlCeJUXcUUB/A60tNlu59RX2YlTuHFQkBcAcpoX
         peVlckue6qs6Qr/3QEQQz6JKqxF5MQux3gstr3OiE1Bn0T9Jw7wxnB2TRmzyp3K2KK
         FDEVqCR6VVGWHzINjsuMB/jxtzU+viH81rVS+QJU=
Date:   Tue, 07 Sep 2021 19:55:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, gregkh@linuxfoundation.org, jasowang@redhat.com,
        lenb@kernel.org, linux-mm@kvack.org, mhocko@kernel.org,
        mkedzier@redhat.com, mm-commits@vger.kernel.org, mst@redhat.com,
        osalvador@suse.de, pankaj.gupta.linux@gmail.com,
        pasha.tatashin@soleen.com, rafael.j.wysocki@intel.com,
        richard.weiyang@linux.alibaba.com, rjw@rjwysocki.net,
        rppt@kernel.org, teawater@gmail.com, torvalds@linux-foundation.org,
        vbabka@suse.cz, vkuznets@redhat.com
Subject:  [patch 048/147] virtio-mem: use a single dynamic memory
 group for a single virtio-mem device
Message-ID: <20210908025541.tYYpQHwW-%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -2569,6 +2571,7 @@ static bool virtio_mem_has_memory_added(
 static int virtio_mem_probe(struct virtio_device *vdev)
 {
 	struct virtio_mem *vm;
+	uint64_t unit_pages;
 	int rc;
 
 	BUILD_BUG_ON(sizeof(struct virtio_mem_req) != 24);
@@ -2603,6 +2606,16 @@ static int virtio_mem_probe(struct virti
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
@@ -2617,7 +2630,7 @@ static int virtio_mem_probe(struct virti
 	vm->memory_notifier.notifier_call = virtio_mem_memory_notifier_cb;
 	rc = register_memory_notifier(&vm->memory_notifier);
 	if (rc)
-		goto out_del_resource;
+		goto out_unreg_group;
 	rc = register_virtio_mem_device(vm);
 	if (rc)
 		goto out_unreg_mem;
@@ -2631,6 +2644,8 @@ static int virtio_mem_probe(struct virti
 	return 0;
 out_unreg_mem:
 	unregister_memory_notifier(&vm->memory_notifier);
+out_unreg_group:
+	memory_group_unregister(vm->mgid);
 out_del_resource:
 	virtio_mem_delete_resource(vm);
 out_del_vq:
@@ -2695,6 +2710,7 @@ static void virtio_mem_remove(struct vir
 	} else {
 		virtio_mem_delete_resource(vm);
 		kfree_const(vm->resource_name);
+		memory_group_unregister(vm->mgid);
 	}
 
 	/* remove all tracking data - no locking needed */
_

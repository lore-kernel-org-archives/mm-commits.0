Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19037C433DB
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E13D964F33
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:30:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbhB0Cas (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:30:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:51712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230090AbhB0Ca1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:30:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A21B764F3C;
        Sat, 27 Feb 2021 02:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614392966;
        bh=tiPwmmFhO5JMkuFk77xMkntHX6WIdaJSnqOZoT8Je3Y=;
        h=Date:From:To:Subject:From;
        b=x94Z8y7O3fwtXGj1uMsFlIHvJ/nae/rdF/tYpEYSO4TSvV7I7V6wSCt2cdqDq42h+
         T6mxuIzqlYX7urA42kOiVwMB7xjApmJp8krIj/e7oru0aFps5Uf5okv4Y9zpnI2/um
         sNnwUBoQiSxFoH2keE0vkIGMbibEEKwYxP+fn43U=
Date:   Fri, 26 Feb 2021 18:29:25 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, boris.ostrovsky@oracle.com,
        david@redhat.com, haiyangz@microsoft.com, jasowang@redhat.com,
        jgross@suse.com, kys@microsoft.com, linmiaohe@huawei.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org, mst@redhat.com,
        osalvador@suse.de, pankaj.gupta@cloud.ionos.com,
        richard.weiyang@linux.alibaba.com, sstabellini@kernel.org,
        sthemmin@microsoft.com, wei.liu@kernel.org
Subject:  [merged]
 mm-memory_hotplug-memhp_merge_resource-mhp_merge_resource.patch removed
 from -mm tree
Message-ID: <20210227022925.8AUsszmXk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: MEMHP_MERGE_RESOURCE -> MHP_MERGE_RESOURCE
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-memhp_merge_resource-mhp_merge_resource.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: MEMHP_MERGE_RESOURCE -> MHP_MERGE_RESOURCE

Let's make "MEMHP_MERGE_RESOURCE" consistent with "MHP_NONE", "mhp_t" and
"mhp_flags".  As discussed recently [1], "mhp" is our internal acronym for
memory hotplug now.

[1] https://lore.kernel.org/linux-mm/c37de2d0-28a1-4f7d-f944-cfd7d81c334d@redhat.com/

Link: https://lkml.kernel.org/r/20210126115829.10909-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Wei Liu <wei.liu@kernel.org>
Reviewed-by: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hv/hv_balloon.c        |    2 +-
 drivers/virtio/virtio_mem.c    |    2 +-
 drivers/xen/balloon.c          |    2 +-
 include/linux/memory_hotplug.h |    2 +-
 mm/memory_hotplug.c            |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/hv/hv_balloon.c~mm-memory_hotplug-memhp_merge_resource-mhp_merge_resource
+++ a/drivers/hv/hv_balloon.c
@@ -726,7 +726,7 @@ static void hv_mem_hot_add(unsigned long
 
 		nid = memory_add_physaddr_to_nid(PFN_PHYS(start_pfn));
 		ret = add_memory(nid, PFN_PHYS((start_pfn)),
-				(HA_CHUNK << PAGE_SHIFT), MEMHP_MERGE_RESOURCE);
+				(HA_CHUNK << PAGE_SHIFT), MHP_MERGE_RESOURCE);
 
 		if (ret) {
 			pr_err("hot_add memory failed error is %d\n", ret);
--- a/drivers/virtio/virtio_mem.c~mm-memory_hotplug-memhp_merge_resource-mhp_merge_resource
+++ a/drivers/virtio/virtio_mem.c
@@ -623,7 +623,7 @@ static int virtio_mem_add_memory(struct
 	/* Memory might get onlined immediately. */
 	atomic64_add(size, &vm->offline_size);
 	rc = add_memory_driver_managed(vm->nid, addr, size, vm->resource_name,
-				       MEMHP_MERGE_RESOURCE);
+				       MHP_MERGE_RESOURCE);
 	if (rc) {
 		atomic64_sub(size, &vm->offline_size);
 		dev_warn(&vm->vdev->dev, "adding memory failed: %d\n", rc);
--- a/drivers/xen/balloon.c~mm-memory_hotplug-memhp_merge_resource-mhp_merge_resource
+++ a/drivers/xen/balloon.c
@@ -331,7 +331,7 @@ static enum bp_state reserve_additional_
 	mutex_unlock(&balloon_mutex);
 	/* add_memory_resource() requires the device_hotplug lock */
 	lock_device_hotplug();
-	rc = add_memory_resource(nid, resource, MEMHP_MERGE_RESOURCE);
+	rc = add_memory_resource(nid, resource, MHP_MERGE_RESOURCE);
 	unlock_device_hotplug();
 	mutex_lock(&balloon_mutex);
 
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-memhp_merge_resource-mhp_merge_resource
+++ a/include/linux/memory_hotplug.h
@@ -53,7 +53,7 @@ typedef int __bitwise mhp_t;
  * with this flag set, the resource pointer must no longer be used as it
  * might be stale, or the resource might have changed.
  */
-#define MEMHP_MERGE_RESOURCE	((__force mhp_t)BIT(0))
+#define MHP_MERGE_RESOURCE	((__force mhp_t)BIT(0))
 
 /*
  * Extended parameters for memory hotplug:
--- a/mm/memory_hotplug.c~mm-memory_hotplug-memhp_merge_resource-mhp_merge_resource
+++ a/mm/memory_hotplug.c
@@ -1153,7 +1153,7 @@ int __ref add_memory_resource(int nid, s
 	 * In case we're allowed to merge the resource, flag it and trigger
 	 * merging now that adding succeeded.
 	 */
-	if (mhp_flags & MEMHP_MERGE_RESOURCE)
+	if (mhp_flags & MHP_MERGE_RESOURCE)
 		merge_system_ram_resource(res);
 
 	/* online pages if requested */
_

Patches currently in -mm which might be from david@redhat.com are



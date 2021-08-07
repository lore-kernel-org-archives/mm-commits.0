Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 269B4C432BE
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 19:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06F7261050
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 19:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbhHGTTs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Aug 2021 15:19:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229565AbhHGTTs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Aug 2021 15:19:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABF9E61042;
        Sat,  7 Aug 2021 19:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628363970;
        bh=EtsbGoa6V+VvrmCMJPByX6HZJ4ytuU33mlg+SbaNPRo=;
        h=Date:From:To:Subject:From;
        b=ZeJ1pI/9ofUKTErMw+Ux2KugEnd1L8Gum8PVogNPt63ZybSrUnZN4DkkF4lC0n624
         hLhnLaDXHChsc37OFmhwzF/2AyF/BblRe42N0yR//GXa1IK0p4vupJnY/jSbHM/DB4
         P0KQr+GDk6gRVdEOBFPUBt+SmpgBFwOX8kQinM8w=
Date:   Sat, 07 Aug 2021 12:19:29 -0700
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
 =?us-ascii?Q?acpi-memhotplug-use-a-single-static-memory-group-for-a-si?=
 =?us-ascii?Q?ngle-memory-device.patch?= added to -mm tree
Message-ID: <20210807191929.wuZXM%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ACPI: memhotplug: use a single static memory group for a single memory device
has been added to the -mm tree.  Its filename is
     acpi-memhotplug-use-a-single-static-memory-group-for-a-single-memory-device.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/acpi-memhotplug-use-a-single-static-memory-group-for-a-single-memory-device.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/acpi-memhotplug-use-a-single-static-memory-group-for-a-single-memory-device.patch

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
Subject: ACPI: memhotplug: use a single static memory group for a single memory device

Let's group all memory we add for a single memory device - we want a
single node for that (which also seems to be the sane thing to do).

We won't care for now about memory that was already added to the system
(e.g., via e820) -- usually *all* memory of a memory device was already
added and we'll fail acpi_memory_enable_device().

Link: https://lkml.kernel.org/r/20210806124715.17090-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
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
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/acpi_memhotplug.c |   35 ++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

--- a/drivers/acpi/acpi_memhotplug.c~acpi-memhotplug-use-a-single-static-memory-group-for-a-single-memory-device
+++ a/drivers/acpi/acpi_memhotplug.c
@@ -54,6 +54,7 @@ struct acpi_memory_info {
 struct acpi_memory_device {
 	struct acpi_device *device;
 	struct list_head res_list;
+	int mgid;
 };
 
 static acpi_status
@@ -169,12 +170,33 @@ static void acpi_unbind_memory_blocks(st
 static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
 {
 	acpi_handle handle = mem_device->device->handle;
+	mhp_t mhp_flags = MHP_NID_IS_MGID;
 	int result, num_enabled = 0;
 	struct acpi_memory_info *info;
-	mhp_t mhp_flags = MHP_NONE;
-	int node;
+	u64 total_length = 0;
+	int node, mgid;
 
 	node = acpi_get_node(handle);
+
+	list_for_each_entry(info, &mem_device->res_list, list) {
+		if (!info->length)
+			continue;
+		/* We want a single node for the whole memory group */
+		if (node < 0)
+			node = memory_add_physaddr_to_nid(info->start_addr);
+		total_length += info->length;
+	}
+
+	if (!total_length) {
+		dev_err(&mem_device->device->dev, "device is empty\n");
+		return -EINVAL;
+	}
+
+	mgid = memory_group_register_static(node, PFN_UP(total_length));
+	if (mgid < 0)
+		return mgid;
+	mem_device->mgid = mgid;
+
 	/*
 	 * Tell the VM there is more memory here...
 	 * Note: Assume that this function returns zero on success
@@ -188,12 +210,10 @@ static int acpi_memory_enable_device(str
 		 */
 		if (!info->length)
 			continue;
-		if (node < 0)
-			node = memory_add_physaddr_to_nid(info->start_addr);
 
 		if (mhp_supports_memmap_on_memory(info->length))
 			mhp_flags |= MHP_MEMMAP_ON_MEMORY;
-		result = __add_memory(node, info->start_addr, info->length,
+		result = __add_memory(mgid, info->start_addr, info->length,
 				      mhp_flags);
 
 		/*
@@ -253,6 +273,10 @@ static void acpi_memory_device_free(stru
 	if (!mem_device)
 		return;
 
+	/* In case we succeeded adding *some* memory, unregistering fails. */
+	if (mem_device->mgid >= 0)
+		memory_group_unregister(mem_device->mgid);
+
 	acpi_memory_free_device_resources(mem_device);
 	mem_device->device->driver_data = NULL;
 	kfree(mem_device);
@@ -273,6 +297,7 @@ static int acpi_memory_device_add(struct
 
 	INIT_LIST_HEAD(&mem_device->res_list);
 	mem_device->device = device;
+	mem_device->mgid = -1;
 	sprintf(acpi_device_name(device), "%s", ACPI_MEMORY_DEVICE_NAME);
 	sprintf(acpi_device_class(device), "%s", ACPI_MEMORY_DEVICE_CLASS);
 	device->driver_data = mem_device;
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


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 668F0C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:02:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53BC2611EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347274AbhIIVDc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:03:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347276AbhIIVDF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:03:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8829E611C4;
        Thu,  9 Sep 2021 21:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221315;
        bh=pI/JGQfJEIYFWOhxEn6Zgeu7ix2/TxiPC2nN1+JLfG0=;
        h=Date:From:To:Subject:From;
        b=tO5GpcBF/xkKt8Bk/HA+7PdpxHr6hba+kKwohOjlTBd0GOVj8TQedBlhcUkc+QslS
         MaLOlCUttcYQJxjGOG8p5WcDwFySDjEDOjYCMhYbWn66oYWRp3MxbDOsyTPy/oND06
         EB4lK3fgxxNkxT9QRHkt50uFbZ8+6UM75Kl0e6uI=
Date:   Thu, 09 Sep 2021 14:01:54 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, david@redhat.com,
        gregkh@linuxfoundation.org, jasowang@redhat.com, lenb@kernel.org,
        mhocko@kernel.org, mkedzier@redhat.com, mm-commits@vger.kernel.org,
        mst@redhat.com, osalvador@suse.de, pankaj.gupta.linux@gmail.com,
        pasha.tatashin@soleen.com, rafael.j.wysocki@intel.com,
        richard.weiyang@linux.alibaba.com, rjw@rjwysocki.net,
        rppt@kernel.org, teawater@gmail.com, vbabka@suse.cz,
        vkuznets@redhat.com
Subject:  [merged]
 =?US-ASCII?Q?acpi-memhotplug-use-a-single-static-memory-group-for-a-si?=
 =?US-ASCII?Q?ngle-memory-device.patch?= removed from -mm tree
Message-ID: <20210909210154.POcnRUEwN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ACPI: memhotplug: use a single static memory group for a single memory device
has been removed from the -mm tree.  Its filename was
     acpi-memhotplug-use-a-single-static-memory-group-for-a-single-memory-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



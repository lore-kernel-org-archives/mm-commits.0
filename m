Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D9BEE49A5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjHUUmI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbjHUUlL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:41:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A44AE4A
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AEF06220E
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D80DC433C7;
        Mon, 21 Aug 2023 20:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650448;
        bh=IMdQSYWs2RNuhc6MsuFVYYYIcMqt7BZrjn+66N2JZw8=;
        h=Date:To:From:Subject:From;
        b=nrZ9RCUKW/dQkbOUkhas0I1lMBJ3GaTshl81OszXRu6Ut/CcAG6nHvaAX0T2E8RMH
         9ioamwtxk3Y/PJKPo7ilvC24TRCJ2Ql/3qm83KzxH7PcIQy9qOKRDXEn/kFkvGpAYj
         bKV3pCHuQcoFCi5bURfwGGQXkICjHD6PmD3bsjOQ=
Date:   Mon, 21 Aug 2023 13:40:47 -0700
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        osalvador@suse.de, npiggin@gmail.com, mpe@ellerman.id.au,
        mhocko@suse.com, david@redhat.com, christophe.leroy@csgroup.eu,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-allow-memmap-on-memory-hotplug-request-to-fallback.patch removed from -mm tree
Message-Id: <20230821204048.6D80DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory_hotplug: allow memmap on memory hotplug request to fallback
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-allow-memmap-on-memory-hotplug-request-to-fallback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/memory_hotplug: allow memmap on memory hotplug request to fallback
Date: Tue, 8 Aug 2023 14:44:57 +0530

If not supported, fallback to not using memap on memmory. This avoids
the need for callers to do the fallback.

Link: https://lkml.kernel.org/r/20230808091501.287660-3-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/acpi_memhotplug.c |    3 +--
 include/linux/memory_hotplug.h |    3 ++-
 mm/memory_hotplug.c            |   13 ++++++-------
 3 files changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/acpi/acpi_memhotplug.c~mm-memory_hotplug-allow-memmap-on-memory-hotplug-request-to-fallback
+++ a/drivers/acpi/acpi_memhotplug.c
@@ -211,8 +211,7 @@ static int acpi_memory_enable_device(str
 		if (!info->length)
 			continue;
 
-		if (mhp_supports_memmap_on_memory(info->length))
-			mhp_flags |= MHP_MEMMAP_ON_MEMORY;
+		mhp_flags |= MHP_MEMMAP_ON_MEMORY;
 		result = __add_memory(mgid, info->start_addr, info->length,
 				      mhp_flags);
 
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-allow-memmap-on-memory-hotplug-request-to-fallback
+++ a/include/linux/memory_hotplug.h
@@ -97,6 +97,8 @@ typedef int __bitwise mhp_t;
  * To do so, we will use the beginning of the hot-added range to build
  * the page tables for the memmap array that describes the entire range.
  * Only selected architectures support it with SPARSE_VMEMMAP.
+ * This is only a hint, the core kernel can decide to not do this based on
+ * different alignment checks.
  */
 #define MHP_MEMMAP_ON_MEMORY   ((__force mhp_t)BIT(1))
 /*
@@ -354,7 +356,6 @@ extern struct zone *zone_for_pfn_range(i
 extern int arch_create_linear_mapping(int nid, u64 start, u64 size,
 				      struct mhp_params *params);
 void arch_remove_linear_mapping(u64 start, u64 size);
-extern bool mhp_supports_memmap_on_memory(unsigned long size);
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
--- a/mm/memory_hotplug.c~mm-memory_hotplug-allow-memmap-on-memory-hotplug-request-to-fallback
+++ a/mm/memory_hotplug.c
@@ -1247,7 +1247,7 @@ static int online_memory_block(struct me
 	return device_online(&mem->dev);
 }
 
-bool mhp_supports_memmap_on_memory(unsigned long size)
+static bool mhp_supports_memmap_on_memory(unsigned long size)
 {
 	unsigned long nr_vmemmap_pages = size / PAGE_SIZE;
 	unsigned long vmemmap_size = nr_vmemmap_pages * sizeof(struct page);
@@ -1339,13 +1339,12 @@ int __ref add_memory_resource(int nid, s
 	 * Self hosted memmap array
 	 */
 	if (mhp_flags & MHP_MEMMAP_ON_MEMORY) {
-		if (!mhp_supports_memmap_on_memory(size)) {
-			ret = -EINVAL;
-			goto error;
+		if (mhp_supports_memmap_on_memory(size)) {
+			mhp_altmap.free = PHYS_PFN(size);
+			mhp_altmap.base_pfn = PHYS_PFN(start);
+			params.altmap = &mhp_altmap;
 		}
-		mhp_altmap.free = PHYS_PFN(size);
-		mhp_altmap.base_pfn = PHYS_PFN(start);
-		params.altmap = &mhp_altmap;
+		/* fallback to not using altmap  */
 	}
 
 	/* call arch's memory hotadd */
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are



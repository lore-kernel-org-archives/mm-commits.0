Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8725C4338F
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 19:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD6306103B
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 19:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhHGTNw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Aug 2021 15:13:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:39902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhHGTNw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Aug 2021 15:13:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84A4961040;
        Sat,  7 Aug 2021 19:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628363614;
        bh=LMZa+u0n+c7WVU0Xdejn3oSfZ9AauGhZ4PvO1Bub5DI=;
        h=Date:From:To:Subject:From;
        b=wI+7tCbokL9Uv1ubH3CDjZ4DA478OH4PJfwg6+YErZ4gS+LvCfprvNV/I8hvTwE+A
         O+AuGcQO5b9nkd+D679TWFg2UQCi+ryLeYkGxYqD7/px22fH98isHJ7CIHz8aDPxOq
         V5r5/7TmMi+r1hafRyN7pnrmsQtfOZMLnbmVqcNM=
Date:   Sat, 07 Aug 2021 12:13:34 -0700
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
Subject:  [to-be-updated]
 dax-kmem-use-a-single-static-memory-group-for-a-single-probed-unit.patch
 removed from -mm tree
Message-ID: <20210807191334.QuBJl%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dax/kmem: use a single static memory group for a single probed unit
has been removed from the -mm tree.  Its filename was
     dax-kmem-use-a-single-static-memory-group-for-a-single-probed-unit.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: dax/kmem: use a single static memory group for a single probed unit

Although dax/kmem users often disable auto-onlining and instead online
memory manually (usually to ZONE_MOVABLE), there is still value in having
auto-onlining be aware of the relationship of memory blocks.

Let's treat one probed unit as a single static memory device, similar to a
single ACPI memory device.

Link: https://lkml.kernel.org/r/20210723125210.29987-7-david@redhat.com
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

 drivers/dax/kmem.c |   40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

--- a/drivers/dax/kmem.c~dax-kmem-use-a-single-static-memory-group-for-a-single-probed-unit
+++ a/drivers/dax/kmem.c
@@ -37,15 +37,16 @@ static int dax_kmem_range(struct dev_dax
 
 struct dax_kmem_data {
 	const char *res_name;
+	int mgid;
 	struct resource *res[];
 };
 
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
+	unsigned long total_len = 0;
 	struct dax_kmem_data *data;
-	int rc = -ENOMEM;
-	int i, mapped = 0;
+	int i, rc, mapped = 0;
 	int numa_node;
 
 	/*
@@ -61,24 +62,44 @@ static int dev_dax_kmem_probe(struct dev
 		return -EINVAL;
 	}
 
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		struct range range;
+
+		rc = dax_kmem_range(dev_dax, i, &range);
+		if (rc) {
+			dev_info(dev, "mapping%d: %#llx-%#llx too small after alignment\n",
+					i, range.start, range.end);
+			continue;
+		}
+		total_len += range_len(&range);
+	}
+
+	if (!total_len) {
+		dev_warn(dev, "rejecting DAX region without any memory after alignment\n");
+		return -EINVAL;
+	}
+
 	data = kzalloc(struct_size(data, res, dev_dax->nr_range), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
+	rc = -ENOMEM;
 	data->res_name = kstrdup(dev_name(dev), GFP_KERNEL);
 	if (!data->res_name)
 		goto err_res_name;
 
+	rc = register_static_memory_group(numa_node, total_len);
+	if (rc < 0)
+		goto err_reg_mgid;
+	data->mgid = rc;
+
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct resource *res;
 		struct range range;
 
 		rc = dax_kmem_range(dev_dax, i, &range);
-		if (rc) {
-			dev_info(dev, "mapping%d: %#llx-%#llx too small after alignment\n",
-					i, range.start, range.end);
+		if (rc)
 			continue;
-		}
 
 		/* Region is permanently reserved if hotremove fails. */
 		res = request_mem_region(range.start, range_len(&range), data->res_name);
@@ -108,8 +129,8 @@ static int dev_dax_kmem_probe(struct dev
 		 * Ensure that future kexec'd kernels will not treat
 		 * this as RAM automatically.
 		 */
-		rc = add_memory_driver_managed(numa_node, range.start,
-				range_len(&range), kmem_name, MHP_NONE);
+		rc = add_memory_driver_managed(data->mgid, range.start,
+				range_len(&range), kmem_name, MHP_NID_IS_MGID);
 
 		if (rc) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
@@ -129,6 +150,8 @@ static int dev_dax_kmem_probe(struct dev
 	return 0;
 
 err_request_mem:
+	unregister_memory_group(data->mgid);
+err_reg_mgid:
 	kfree(data->res_name);
 err_res_name:
 	kfree(data);
@@ -171,6 +194,7 @@ static void dev_dax_kmem_remove(struct d
 	}
 
 	if (success >= dev_dax->nr_range) {
+		unregister_memory_group(data->mgid);
 		kfree(data->res_name);
 		kfree(data);
 		dev_set_drvdata(dev, NULL);
_

Patches currently in -mm which might be from david@redhat.com are

mm-madvise-report-sigbus-as-efault-for-madv_populate_readwrite.patch
memory-hotplugrst-remove-locking-details-from-admin-guide.patch
memory-hotplugrst-complete-admin-guide-overhaul.patch
mm-memory_hotplug-use-unsigned-long-for-pfn-in-zone_for_pfn_range.patch
mm-memory_hotplug-remove-nid-parameter-from-arch_remove_memory.patch
mm-memory_hotplug-remove-nid-parameter-from-remove_memory-and-friends.patch
acpi-memhotplug-memory-resources-cannot-be-enabled-yet.patch
virtio-mem-use-a-single-dynamic-memory-group-for-a-single-virtio-mem-device.patch
mm-memory_hotplug-memory-group-aware-auto-movable-online-policy.patch
mm-memory_hotplug-memory-group-aware-auto-movable-online-policy-fix.patch
mm-memory_hotplug-improved-dynamic-memory-group-aware-auto-movable-online-policy.patch


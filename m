Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A51C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:55:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC76F61153
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:55:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347361AbhIHC4x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347421AbhIHC4p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:56:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0268C61102;
        Wed,  8 Sep 2021 02:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069738;
        bh=Mh7MpLfh0jg6O6/zUp112AOWnZGJ2gMDU+jZ1y3CM2o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mw0Asw+68dkXsh/VVmLBK0ETSsLYG0sk3Nlh4hgWRBcwdMkPY3oMxXTWpHd39hfw2
         9GXF5Jzvg5jQ+tn00e6T02JALYtxpTpNTZxOTVojOTSxu6aBdrZXtl82F+cOu/kh5M
         hKQ8G3aODds62EFbnyMq9N3SxWViQoc3LhLsvEtI=
Date:   Tue, 07 Sep 2021 19:55:37 -0700
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
Subject:  [patch 047/147] dax/kmem: use a single static memory
 group for a single probed unit
Message-ID: <20210908025537.KjRH70jT1%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: dax/kmem: use a single static memory group for a single probed unit

Although dax/kmem users often disable auto-onlining and instead online
memory manually (usually to ZONE_MOVABLE), there is still value in having
auto-onlining be aware of the relationship of memory blocks.

Let's treat one probed unit as a single static memory device, similar to a
single ACPI memory device.

Link: https://lkml.kernel.org/r/20210806124715.17090-7-david@redhat.com
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
 
+	rc = memory_group_register_static(numa_node, total_len);
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
+	memory_group_unregister(data->mgid);
+err_reg_mgid:
 	kfree(data->res_name);
 err_res_name:
 	kfree(data);
@@ -171,6 +194,7 @@ static void dev_dax_kmem_remove(struct d
 	}
 
 	if (success >= dev_dax->nr_range) {
+		memory_group_unregister(data->mgid);
 		kfree(data->res_name);
 		kfree(data);
 		dev_set_drvdata(dev, NULL);
_

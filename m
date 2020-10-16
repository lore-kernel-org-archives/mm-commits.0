Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED671C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 00:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97B192087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 00:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602806582;
	bh=3e+qL8HZbFIoLxExJmPSnDMIIE9p+uowcdxoAqu72Vk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=eKAOCIP/10vLtK3B9oiMtdObYVEEA5O0ZNFrsSOZ25wWKxKdW8JU/VpRZ2kkdsgT4
	 85PzbHjHT023XdhPkmQ/3/tQhYUSBnpNCcS1UuY642hZifBztEL8/aCYsztYz3MYcs
	 aTC1Ae30yZRnTQB8X6th9lpAE87Pca9ngQq40hD4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbgJPADC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 20:03:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728332AbgJPADC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 20:03:02 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DA9D20709;
        Fri, 16 Oct 2020 00:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602806580;
        bh=3e+qL8HZbFIoLxExJmPSnDMIIE9p+uowcdxoAqu72Vk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rKZ5rGTr05oNQwT9NJYt7Z2z6XzAq1AuMdRBFuttpbLJIh0o237GSQPrBm66qJkUU
         th43ClDDkVgRLvLuaTaKrtS0nRLFpJ8b7HILT7iWgyBfzuUUsT1DUL4xKCjtesOOsf
         lgDUHLN25oaUN867L8yeBLVkjiyGziN/O/mDKR7M=
Date:   Thu, 15 Oct 2020 17:02:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Brice.Goglin@inria.fr, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, dave.jiang@intel.com,
        david@redhat.com, ira.weiny@intel.com, joao.m.martins@oracle.com,
        Jonathan.Cameron@huawei.com, justin.he@arm.com,
        mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        vishal.l.verma@intel.com
Subject:  + device-dax-kmem-fix-resource-release.patch added to -mm
 tree
Message-ID: <20201016000259.pAEfWo2_f%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax/kmem: fix resource release
has been added to the -mm tree.  Its filename is
     device-dax-kmem-fix-resource-release.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-kmem-fix-resource-release.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-kmem-fix-resource-release.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: device-dax/kmem: fix resource release

The conversion to request_mem_region() is broken because it assumes that
the range is marked busy prior to release.  However, due to the way that
the kmem driver manipulates the IORESOURCE_BUSY flag (clears it to let
{add,remove}_memory() handle busy) it requires a manual release_resource()
to perform cleanup.

Given that the actual 'struct resource *' needs to be recalled, not just
the range, add that tracking to the kmem driver-data.

Link: https://lkml.kernel.org/r/160272252925.3136502.17220638073995895400.stgit@dwillia2-desk3.amr.corp.intel.com
Fixes: 0513bd5bb114 ("device-dax/kmem: replace release_resource() with release_mem_region()")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: David Hildenbrand <david@redhat.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jia He <justin.he@arm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/kmem.c |   48 ++++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 14 deletions(-)

--- a/drivers/dax/kmem.c~device-dax-kmem-fix-resource-release
+++ a/drivers/dax/kmem.c
@@ -35,11 +35,17 @@ static int dax_kmem_range(struct dev_dax
 	return 0;
 }
 
+struct dax_kmem_data {
+	const char *res_name;
+	struct resource *res[];
+};
+
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
+	struct dax_kmem_data *data;
+	int rc = -ENOMEM;
 	int i, mapped = 0;
-	char *res_name;
 	int numa_node;
 
 	/*
@@ -55,14 +61,17 @@ static int dev_dax_kmem_probe(struct dev
 		return -EINVAL;
 	}
 
-	res_name = kstrdup(dev_name(dev), GFP_KERNEL);
-	if (!res_name)
+	data = kzalloc(sizeof(*data) + sizeof(struct resource *) * dev_dax->nr_range, GFP_KERNEL);
+	if (!data)
 		return -ENOMEM;
 
+	data->res_name = kstrdup(dev_name(dev), GFP_KERNEL);
+	if (!data->res_name)
+		goto err_res_name;
+
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct resource *res;
 		struct range range;
-		int rc;
 
 		rc = dax_kmem_range(dev_dax, i, &range);
 		if (rc) {
@@ -72,7 +81,7 @@ static int dev_dax_kmem_probe(struct dev
 		}
 
 		/* Region is permanently reserved if hotremove fails. */
-		res = request_mem_region(range.start, range_len(&range), res_name);
+		res = request_mem_region(range.start, range_len(&range), data->res_name);
 		if (!res) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx could not reserve region\n",
 					i, range.start, range.end);
@@ -82,9 +91,10 @@ static int dev_dax_kmem_probe(struct dev
 			 */
 			if (mapped)
 				continue;
-			kfree(res_name);
-			return -EBUSY;
+			rc = -EBUSY;
+			goto err_request_mem;
 		}
+		data->res[i] = res;
 
 		/*
 		 * Set flags appropriate for System RAM.  Leave ..._BUSY clear
@@ -104,18 +114,25 @@ static int dev_dax_kmem_probe(struct dev
 		if (rc) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
 					i, range.start, range.end);
-			release_mem_region(range.start, range_len(&range));
+			release_resource(res);
+			kfree(res);
+			data->res[i] = NULL;
 			if (mapped)
 				continue;
-			kfree(res_name);
-			return rc;
+			goto err_request_mem;
 		}
 		mapped++;
 	}
 
-	dev_set_drvdata(dev, res_name);
+	dev_set_drvdata(dev, data);
 
 	return 0;
+
+err_request_mem:
+	kfree(data->res_name);
+err_res_name:
+	kfree(data);
+	return rc;
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
@@ -123,7 +140,7 @@ static int dev_dax_kmem_remove(struct de
 {
 	int i, success = 0;
 	struct device *dev = &dev_dax->dev;
-	const char *res_name = dev_get_drvdata(dev);
+	struct dax_kmem_data *data = dev_get_drvdata(dev);
 
 	/*
 	 * We have one shot for removing memory, if some memory blocks were not
@@ -142,7 +159,9 @@ static int dev_dax_kmem_remove(struct de
 		rc = remove_memory(dev_dax->target_node, range.start,
 				range_len(&range));
 		if (rc == 0) {
-			release_mem_region(range.start, range_len(&range));
+			release_resource(data->res[i]);
+			kfree(data->res[i]);
+			data->res[i] = NULL;
 			success++;
 			continue;
 		}
@@ -153,7 +172,8 @@ static int dev_dax_kmem_remove(struct de
 	}
 
 	if (success >= dev_dax->nr_range) {
-		kfree(res_name);
+		kfree(data->res_name);
+		kfree(data);
 		dev_set_drvdata(dev, NULL);
 	}
 
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

device-dax-kmem-fix-resource-release.patch
xen-unpopulated-alloc-consolidate-pgmap-manipulation.patch


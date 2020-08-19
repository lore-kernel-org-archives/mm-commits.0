Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E073C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 02:44:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CAA6207BB
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 02:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597805093;
	bh=mSmoFxvjpOFQ3BjF+LJF9gJ4ZExsUtOydObSByBEhTY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=0wVhxmbnTKK1yeEEz6CDeoE/gr6Xsq7Zit7LRGlH4u/ixQcL9nHJqws321vp5td3M
	 o2SqC8rb6yLXF+L+H6F71waWnGSAf0x4ZKlcrCdef0kYny5nIoXcXhtwDXIMxPCm3b
	 ODvbCO+HWlSw3UWsO9seya/VwnKWIVxwxl13l1Ls=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgHSCow (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 22:44:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbgHSCov (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 22:44:51 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F64120639;
        Wed, 19 Aug 2020 02:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597805091;
        bh=mSmoFxvjpOFQ3BjF+LJF9gJ4ZExsUtOydObSByBEhTY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NHQS2AVyVZ21ThO2OX9es8cgtNpQVJ9JBh/THi7qBlEdjP6flWFiqFuFLcDPS4e+x
         TwN45PDXglfjmYKLe+mvJVeK06XCBHe4rMIZkY7wdMqE/NZYzi3+60aYAUez1LMwWA
         RL90DJsK3sNSH/vg4ew66UwH1T8Ss/MGRgD60sSQ=
Date:   Tue, 18 Aug 2020 19:44:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        dave.jiang@intel.com, ira.weiny@intel.com,
        mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
        vishal.l.verma@intel.com
Subject:  + device-dax-fix-mismatches-of-request_mem_region.patch
 added to -mm tree
Message-ID: <20200819024450.FTaIjT3Cg%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/dax/kmem.c: fix mismatches of request_mem_region()
has been added to the -mm tree.  Its filename is
     device-dax-fix-mismatches-of-request_mem_region.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/device-dax-fix-mismatches-of-request_mem_region.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/device-dax-fix-mismatches-of-request_mem_region.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: drivers/dax/kmem.c: fix mismatches of request_mem_region()

For neatness's sake, The resources allocated by request_mem_region()
should be freed with release_mem_region().  These two functions are
paired.

Link: http://lkml.kernel.org/r/20200817065926.2239-1-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/kmem.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/dax/kmem.c~device-dax-fix-mismatches-of-request_mem_region
+++ a/drivers/dax/kmem.c
@@ -82,8 +82,7 @@ int dev_dax_kmem_probe(struct device *de
 	rc = add_memory_driver_managed(numa_node, new_res->start,
 				       resource_size(new_res), kmem_name);
 	if (rc) {
-		release_resource(new_res);
-		kfree(new_res);
+		release_mem_region(kmem_start, kmem_size);
 		kfree(new_res_name);
 		return rc;
 	}
@@ -118,8 +117,7 @@ static int dev_dax_kmem_remove(struct de
 	}
 
 	/* Release and free dax resources */
-	release_resource(res);
-	kfree(res);
+	release_mem_region(kmem_start, kmem_size);
 	kfree(res_name);
 	dev_dax->dax_kmem_res = NULL;
 
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are

device-dax-fix-mismatches-of-request_mem_region.patch


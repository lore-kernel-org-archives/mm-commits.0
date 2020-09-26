Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64899C4727D
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C8E42087D
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601087376;
	bh=OeCisnzF+5tylG/r3ailFy7fm+Azp6A5no5TjxrRQ/I=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=U/6Kt0/bFz06J+MQwX6KyQYUGaHVj6FRTqa9/jX/XbXJNuW/SxRDiMFLd6YzByTpE
	 bf5SKnS4ZlggKvF1+PwNZa985RXvJt+4PDegRLEFVicGMab0jBsunjEnpi5fIloaHL
	 q9Dh56rfp8eYu+1YXofU0K6dbZPgqRiJmRm65LMU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729974AbgIZC3f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 22:29:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729960AbgIZC3f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 22:29:35 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18A13206B8;
        Sat, 26 Sep 2020 02:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601087375;
        bh=OeCisnzF+5tylG/r3ailFy7fm+Azp6A5no5TjxrRQ/I=;
        h=Date:From:To:Subject:From;
        b=MHhliQfpz0daNch0syv3X6BVrPoD7Aldb73udiYWpNPHOci4KBAKUm3TbDABr0yB+
         77QwZdzIdTMB68RqA7zpMtZIVpeuFeREV5BlYIu7a3Jdg57W3V3PZrBhjtsN61iRl9
         /86g6nuOV1MVA0VjRvY4nDgpqLt01W2HOFcjt/ec=
Date:   Fri, 25 Sep 2020 19:29:34 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ira.weiny@intel.com, hulkci@huawei.com,
        yanaijie@huawei.com
Subject:  [merged] device-dax-make-dev_dax_kmem_probe-static.patch
 removed from -mm tree
Message-ID: <20200926022934.91HrX%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: make dev_dax_kmem_probe() static
has been removed from the -mm tree.  Its filename was
     device-dax-make-dev_dax_kmem_probe-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jason Yan <yanaijie@huawei.com>
Subject: device-dax: make dev_dax_kmem_probe() static

This eliminates the following sparse warning:

drivers/dax/kmem.c:38:5: warning: symbol 'dev_dax_kmem_probe' was not
declared. Should it be static?

Link: https://lkml.kernel.org/r/20200912033901.143382-1-yanaijie@huawei.com
Signed-off-by: Jason Yan <yanaijie@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/kmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dax/kmem.c~device-dax-make-dev_dax_kmem_probe-static
+++ a/drivers/dax/kmem.c
@@ -35,7 +35,7 @@ static int dax_kmem_range(struct dev_dax
 	return 0;
 }
 
-int dev_dax_kmem_probe(struct dev_dax *dev_dax)
+static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	int numa_node = dev_dax->target_node;
 	struct device *dev = &dev_dax->dev;
_

Patches currently in -mm which might be from yanaijie@huawei.com are

lib-include-memregionh-in-memregionc.patch


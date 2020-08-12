Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 501D5C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 212832078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266106;
	bh=GELXcNiK4KgapN6sOd2Yfhfg2N87WD3PDigxUvXzroY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ho7sYlXOEA/joO1kivrZOyXRrL/mS27SZTjc3SWC5FJzDXKYlSa02wP4veGTvWex7
	 mJ7Wshoz1x2AoJ7YuRrBSMbkXkhFz/0r25sNRCf/mWD3b16QGSXM2FEZA8xbCQugAg
	 cAOK3AZRPWIb6ce+x1animy6U3SK2d2f9ZykLEV8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgHLVBp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:01:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726611AbgHLVBp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:01:45 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7049D2078B;
        Wed, 12 Aug 2020 21:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266104;
        bh=GELXcNiK4KgapN6sOd2Yfhfg2N87WD3PDigxUvXzroY=;
        h=Date:From:To:Subject:From;
        b=Xm/b0zI5b197b4RY+KLqlCZ4h0FCOwtde2f55vjbCKW2v22AaWPIICDl9tYQhls+h
         5gCCeKWMTbIZPFrw8WoHShUVEaNG0HrsffktDwobv/pTxjpuu4cwZqoOfdgDg7fmEN
         2va4tPXldwWiwdWbkN8+gw0dGsmqrZp5tjWQ2zDs=
Date:   Wed, 12 Aug 2020 14:01:44 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, krzk@kernel.org,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-mempolicy-fix-kerneldoc-of-numa_map_to_online_node.patch removed from
 -mm tree
Message-ID: <20200812210144.15-Qc9doR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mempolicy: fix kerneldoc of numa_map_to_online_node()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-fix-kerneldoc-of-numa_map_to_online_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: mm: mempolicy: fix kerneldoc of numa_map_to_online_node()

Fix W=1 compile warnings (invalid kerneldoc):

    mm/mempolicy.c:137: warning: Function parameter or member 'node' not described in 'numa_map_to_online_node'
    mm/mempolicy.c:137: warning: Excess function parameter 'nid' description in 'numa_map_to_online_node'

Link: http://lkml.kernel.org/r/20200728171109.28687-3-krzk@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-kerneldoc-of-numa_map_to_online_node
+++ a/mm/mempolicy.c
@@ -129,7 +129,7 @@ static struct mempolicy preferred_node_p
 
 /**
  * numa_map_to_online_node - Find closest online node
- * @nid: Node id to start the search
+ * @node: Node id to start the search
  *
  * Lookup the next closest node by distance if @nid is not online.
  */
_

Patches currently in -mm which might be from krzk@kernel.org are

iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation-fix.patch
rtl818x-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
ntb-intel-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
virtio-pci-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch


Return-Path: <SRS0=nZXm=BH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 220A3C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jul 2020 20:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF506206D8
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jul 2020 20:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595969586;
	bh=VGOyzTd6dPBIY2F22Ti8zz2HEp0oDB3Q7cBqvAVAscA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=HxNZU8VI/O08BArq5nvlffpJ+ABSb/hMpPbxYKxxNayR7X0/i718Tt6PO9oOFsCa+
	 faxTJAe18B1LQkRmW7gU5o5EYyRA9jTcyPDZLaqIAY5PSVEZVQs5BjoCZQ16iL4J8a
	 m4xn7KA22QGcx6E61hDnkRzWrt8dRxEDkmtYdrSU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbgG1UxF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Jul 2020 16:53:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728202AbgG1UxF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Jul 2020 16:53:05 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ED36206D8;
        Tue, 28 Jul 2020 20:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595969584;
        bh=VGOyzTd6dPBIY2F22Ti8zz2HEp0oDB3Q7cBqvAVAscA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eWu9RAQfsgzS1477XVu9COEw6UfgKYS9gBInhXbwN+k0jhrW/kPQcWxQAAAeZ5/gX
         m4A8nIRVqsOuxlARwDhDVSNLb/ZbIYO3Xm88f2pIJYI44RA1C2v823K1+6ULYfKSZL
         wxQwNmgS/EZtLdq+zUHfszlfcckcLuhcrkGTwfB8=
Date:   Tue, 28 Jul 2020 13:53:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, krzk@kernel.org,
        mm-commits@vger.kernel.org
Subject:  +
 mm-mempolicy-fix-kerneldoc-of-numa_map_to_online_node.patch added to -mm
 tree
Message-ID: <20200728205304.FlB1rUD0d%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mempolicy: fix kerneldoc of numa_map_to_online_node()
has been added to the -mm tree.  Its filename is
     mm-mempolicy-fix-kerneldoc-of-numa_map_to_online_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-fix-kerneldoc-of-numa_map_to_online_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-fix-kerneldoc-of-numa_map_to_online_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-swap-fix-kerneldoc-of-swap_vma_readahead.patch
mm-mempolicy-fix-kerneldoc-of-numa_map_to_online_node.patch
mm-mmu_notifier-fix-and-extend-kerneldoc.patch
iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation-fix.patch
rtl818x-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
ntb-intel-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
virtio-pci-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch


Return-Path: <SRS0=nZXm=BH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15874C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jul 2020 20:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0C54206D8
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jul 2020 20:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595969657;
	bh=AZEmflOBOvyNVfaJJE1JY5l6Pze7qJpbq/FpBioySR4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=XLNRtOrnS36ireAML/b9oyWLZEmFYwo7NADiKllFZb3Cdcf1ASr6N/cFtL7Wf21xV
	 +hQrVCt346lorMNtc//hqWKVlYgSfNRc/22x5plcNhrGHn+l2QsgBhDxC4WL3qzWmQ
	 WA85K0DlGtxle43ByCY3utDcc8LwgBXT83mu9zoQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgG1UyR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Jul 2020 16:54:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728202AbgG1UyR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Jul 2020 16:54:17 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FC5B206D8;
        Tue, 28 Jul 2020 20:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595969656;
        bh=AZEmflOBOvyNVfaJJE1JY5l6Pze7qJpbq/FpBioySR4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IfMQQLkWBAeEWX3VyOxnaQ9UL9HZszjZPfnadNecVirYRaRk3UM3jwUyZ0iMp95hU
         ZD6CHg+atso6rIbFtm6XS30hHSHDGgwPYNC3ZReQd9MS679iYzw/tNWyfPHPUeMo+R
         QVgvoJ4IAmXZD2koya9xu1az9XMtwM5SV2e0hEEY=
Date:   Tue, 28 Jul 2020 13:54:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, krzk@kernel.org,
        mm-commits@vger.kernel.org
Subject:  + mm-swap-fix-kerneldoc-of-swap_vma_readahead.patch added
 to -mm tree
Message-ID: <20200728205416.Tnnn1Lai5%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: swap: fix kerneldoc of swap_vma_readahead()
has been added to the -mm tree.  Its filename is
     mm-swap-fix-kerneldoc-of-swap_vma_readahead.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-fix-kerneldoc-of-swap_vma_readahead.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-fix-kerneldoc-of-swap_vma_readahead.patch

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
Subject: mm: swap: fix kerneldoc of swap_vma_readahead()

Fix W=1 compile warnings (invalid kerneldoc):

    mm/swap_state.c:742: warning: Function parameter or member 'fentry' not described in 'swap_vma_readahead'
    mm/swap_state.c:742: warning: Excess function parameter 'entry' description in 'swap_vma_readahead'

Link: http://lkml.kernel.org/r/20200728171109.28687-2-krzk@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap_state.c~mm-swap-fix-kerneldoc-of-swap_vma_readahead
+++ a/mm/swap_state.c
@@ -725,7 +725,7 @@ static void swap_ra_info(struct vm_fault
 
 /**
  * swap_vma_readahead - swap in pages in hope we need them soon
- * @entry: swap entry of this memory
+ * @fentry: swap entry of this memory
  * @gfp_mask: memory allocation flags
  * @vmf: fault information
  *
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


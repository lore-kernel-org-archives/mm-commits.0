Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D7F5C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6E552065D
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026974;
	bh=YfZbZYCwxpdUOPcJiD2iQVTL7nzyrDQMWMdrGnytX4E=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=U9lFlTzB2gTNF+pepblaAfmbVnZf7Qy9iK+ahqYsZRpXGhD97WHvspIAej6sidv81
	 etHBLnmEgXVhwBniIt3uTQpPLPTZBoCR7j9MkqVfhkVH7dro7Cr650BTJfXVxIRrln
	 b6qiu5cEJHRcbTKce/E7BE28nHE2KA5hAVZ1zkqk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgHJCgO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:36:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCgO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:36:14 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80D932065D;
        Mon, 10 Aug 2020 02:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026973;
        bh=YfZbZYCwxpdUOPcJiD2iQVTL7nzyrDQMWMdrGnytX4E=;
        h=Date:From:To:Subject:From;
        b=I1R4YXhA3bmQ/K5dP23i4nu5FgiH7yHE2jRhbiFLzK+OvzZt8wqoZ145Q1qupppXT
         QcVuMxXb34vl6xEAFCd7X/DNmAM5O+bryt5qXu+Qrbhbk52NEEJZ8SdhYt7pfFnRQI
         +plt4uG8+QUXipeGO41PmAqUqTh7CSUBCegrsCD0=
Date:   Sun, 09 Aug 2020 19:36:13 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, krzk@kernel.org,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-swap-fix-kerneldoc-of-swap_vma_readahead.patch removed from -mm tree
Message-ID: <20200810023613.5ORr217pA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: swap: fix kerneldoc of swap_vma_readahead()
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-kerneldoc-of-swap_vma_readahead.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-mempolicy-fix-kerneldoc-of-numa_map_to_online_node.patch
mm-mmu_notifier-fix-and-extend-kerneldoc.patch
iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation-fix.patch
rtl818x-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
ntb-intel-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
virtio-pci-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch


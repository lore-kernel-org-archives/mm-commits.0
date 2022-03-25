Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A190BC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbiCYWn2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbiCYWnW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C81209A72
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA41C61502
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE29C36AE3;
        Fri, 25 Mar 2022 22:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248106;
        bh=K8w2zygBlOsk6Y93FEpMddYS5uxL93A+4IaG8Aw/+/Q=;
        h=Date:To:From:Subject:From;
        b=kwADFhflsxBpuqQcCZ//7baEluMmCoexX2fqKf6Qlv4IjnIbvSNsr5JoAH6pa9tHi
         AWzg1TEusEdNPGrJMyPQJ3BOD3U2Iho/foL8Tc7WAaIL0FZEFuCUDNP7+V4x8shS0O
         c74qmk+wEJUFmC2Vof3T2+0btJYV8bo7xAXZpVuY=
Date:   Fri, 25 Mar 2022 15:41:45 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-unexport-page_init_poison.patch removed from -mm tree
Message-Id: <20220325224146.2BE29C36AE3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: unexport page_init_poison
has been removed from the -mm tree.  Its filename was
     mm-unexport-page_init_poison.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: unexport page_init_poison

page_init_poison is only used in core MM code, so unexport it.

Link: https://lkml.kernel.org/r/20220207063446.1833404-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/debug.c~mm-unexport-page_init_poison
+++ a/mm/debug.c
@@ -261,5 +261,4 @@ void page_init_poison(struct page *page,
 	if (page_init_poisoning)
 		memset(page, PAGE_POISON_PATTERN, size);
 }
-EXPORT_SYMBOL_GPL(page_init_poison);
 #endif		/* CONFIG_DEBUG_VM */
_

Patches currently in -mm which might be from hch@lst.de are



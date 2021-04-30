Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89685C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B84161458
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhD3FgO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:36:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhD3FgN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:36:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73ED561423;
        Fri, 30 Apr 2021 05:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619760925;
        bh=QqYhcZ7GlihtX1pJ22AlpN3YnHBp5Uy0kW83851U4dA=;
        h=Date:From:To:Subject:From;
        b=FzQsO/veuJlzytAlp/asbE35sT7K3gXD3866oMVi0NiaqGU/JQXdpEBXMq2CXiGV7
         xH4+hK5FoK6x73Wj4kIju22MT3O7CXN8wzcjhM64Frxh0xVtiux2R2B9O7r6REr5zz
         HJh2QiMx5LSoCSVL63oI03Vn9IRdUI+JT6CUWNb4=
Date:   Thu, 29 Apr 2021 22:35:25 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, alexander.duyck@gmail.com,
        alobakin@pm.me, brouer@redhat.com, chuck.lever@oracle.com,
        davem@davemloft.net, hch@infradead.org,
        ilias.apalodimas@linaro.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, vbabka@suse.cz, willy@infradead.org
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-page=5Falloc-add-an-array-based-interface-to-the-bulk-?=
 =?US-ASCII?Q?page-allocator-fix.patch?= removed from -mm tree
Message-ID: <20210430053525.ZVNwJ9itD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch

This patch was dropped because it was folded into mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix

remove now unused local `allocated'

Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: David Miller <davem@davemloft.net>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix
+++ a/mm/page_alloc.c
@@ -5040,7 +5040,6 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	struct alloc_context ac;
 	gfp_t alloc_gfp;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
-	int allocated = 0;
 	int nr_populated = 0;
 
 	if (WARN_ON_ONCE(nr_pages <= 0))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator.patch
mm.patch
mm-vmscan-add-shrinker_info_protected-helper-fix.patch
mm-drop-redundant-arch_enable__migration-fix.patch
mm-drop-redundant-arch_enable__migration-fix-fix.patch
kernel-resource-allow-region_intersects-users-to-hold-resource_lock-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
cifsd-is-broken.patch
kernel-forkc-export-kernel_thread-to-modules.patch


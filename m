Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43DFBC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:30:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F74561458
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhD3Fbd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:31:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhD3Fbc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:31:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AAA661434;
        Fri, 30 Apr 2021 05:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619760645;
        bh=KGc6Jj+pT8eFP/C+7iX0wB7ZWWCJkghuUnJmXdblMDU=;
        h=Date:From:To:Subject:From;
        b=nZRsMMTMIH3xcS7sDEMmdRr5BVxwpQBgPd9At96vZfdzTLY25D4oQSCmGANopc+o9
         A3TpvcXVK0BP1Y2148Vz+nb/6Kj5sPfWSX8Gl5dzykc8WfjsQl05fgNVlBjo+X2Z5J
         oBli5M2XIZvDCsw33DSO9fB7GHxOU9Y8bRd8q3wo=
Date:   Thu, 29 Apr 2021 22:30:44 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, dan.carpenter@oracle.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        sfr@canb.auug.org.au, urezki@gmail.com, willy@infradead.org
Subject:  [folded-merged]
 mm-vmalloc-improve-allocation-failure-error-messages-fix.patch removed from
 -mm tree
Message-ID: <20210430053044.lcMlizoXV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: print correct vmalloc allocation size
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-improve-allocation-failure-error-messages-fix.patch

This patch was dropped because it was folded into mm-vmalloc-improve-allocation-failure-error-messages.patch

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: print correct vmalloc allocation size

On entry the area->nr_pages is not set yet and is zero, thus when an
allocation of the page-table array fails the vmalloc size will not be
reflected correctly in a error message.

Replace area->nr_pages by the nr_small_pages.

Link: https://lkml.kernel.org/r/20210329193214.GA28602@pc638.lan
Fixes: 014ccf9b888d ("mm/vmalloc: improve allocation failure error messages")
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reported-by: Colin King <colin.king@canonical.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-improve-allocation-failure-error-messages-fix
+++ a/mm/vmalloc.c
@@ -2793,7 +2793,7 @@ static void *__vmalloc_area_node(struct
 		warn_alloc(gfp_mask, NULL,
 			   "vmalloc size %lu allocation failure: "
 			   "page array size %lu allocation failed",
-			   area->nr_pages * PAGE_SIZE, array_size);
+			   nr_small_pages * PAGE_SIZE, array_size);
 		return NULL;
 	}
 
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-improve-allocation-failure-error-messages.patch
lib-test_vmallocc-remove-two-kvfree_rcu-tests.patch
lib-test_vmallocc-add-a-new-nr_threads-parameter.patch
lib-test_vmallocc-add-a-new-nr_threads-parameter-fix.patch
vm-test_vmallocsh-adapt-for-updated-driver-interface.patch
mm-vmalloc-refactor-the-preloading-loagic.patch
mm-vmalloc-remove-an-empty-line.patch


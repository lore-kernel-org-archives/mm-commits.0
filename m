Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35E1CC433C1
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 05:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD6EF619D3
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 05:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbhCaFKR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 01:10:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhCaFKG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 01:10:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB083619BC;
        Wed, 31 Mar 2021 05:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617167406;
        bh=y0FOufIS9LVaQPARkFTc21XqboxHnorGGLyKRX5TAw8=;
        h=Date:From:To:Subject:From;
        b=ajgp4xRezAZal5pmlyMs/woc6rf9MKmP9nUqLM35XRUorMiyJ8C5J8HBpuEUY3R61
         12bpaspg3KMSONaOYT6HhT6QrxkaAa0QcBy4LrBcHTnvOH9Yvrco6vKQI6KjVJ6/Zu
         BxGsGX567BgjT9F92GyipzpqNxi8fToNl22hVWk8=
Date:   Tue, 30 Mar 2021 22:10:05 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, dan.carpenter@oracle.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        sfr@canb.auug.org.au, urezki@gmail.com, willy@infradead.org
Subject:  +
 mm-vmalloc-improve-allocation-failure-error-messages-fix.patch added to -mm
 tree
Message-ID: <20210331051005.Q09qN03sH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: print correct vmalloc allocation size
has been added to the -mm tree.  Its filename is
     mm-vmalloc-improve-allocation-failure-error-messages-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-improve-allocation-failure-error-messages-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-improve-allocation-failure-error-messages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-vmalloc-improve-allocation-failure-error-messages-fix.patch


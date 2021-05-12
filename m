Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A6CC433ED
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 21:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 493FD61184
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 21:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346185AbhELVNw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 17:13:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:39572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1387033AbhELUbz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 16:31:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1CCD61421;
        Wed, 12 May 2021 20:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620851393;
        bh=CNdsD+jYleC22Gnt+1Z+Wp5fY/9dZ7AudYIMASmh3lo=;
        h=Date:From:To:Subject:From;
        b=Np5HvFs4Nvmd9XPxuTBlTx4d60hTpF2PoYEgW7YSZafrPq5suUB/xioawPP7HbLhQ
         nErzGZmh8abUq0M6QMwLB0FKhveMM+bkZ82Vut8dg7x3gHDjeua0mlPrm02R5T5Vud
         VbJJkYX64I4VtDoPFeFhLIRK9gl8fy2aWZgOLNfo=
Date:   Wed, 12 May 2021 13:29:52 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        sfr@canb.auug.org.au, urezki@gmail.com, willy@infradead.org
Subject:  [failures]
 mm-vmalloc-print-a-warning-message-first-on-failure.patch removed from -mm
 tree
Message-ID: <20210512202952.PRR7JClh8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: print a warning message first on failure
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-print-a-warning-message-first-on-failure.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Uladzislau Rezki <urezki@gmail.com>
Subject: mm/vmalloc: print a warning message first on failure

When a memory allocation for array of pages are not succeed emit a warning
message as a first step and then perform the further cleanup.

The reason it should be done in a right order is the clean up function
which is free_vm_area() can potentially also follow its error paths what
can lead to confusion what was broken first.

Link: https://lkml.kernel.org/r/20210510103342.GA2169@pc638.lan
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-print-a-warning-message-first-on-failure
+++ a/mm/vmalloc.c
@@ -2780,11 +2780,11 @@ static void *__vmalloc_area_node(struct
 	}
 
 	if (!area->pages) {
-		free_vm_area(area);
 		warn_alloc(gfp_mask, NULL,
 			   "vmalloc size %lu allocation failure: "
 			   "page array size %lu allocation failed",
 			   nr_small_pages * PAGE_SIZE, array_size);
+		free_vm_area(area);
 		return NULL;
 	}
 
_

Patches currently in -mm which might be from urezki@gmail.com are



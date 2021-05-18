Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C90FC43461
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 23:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81DD96135B
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 23:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbhERXlk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 May 2021 19:41:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235737AbhERXlj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 May 2021 19:41:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6FFF61353;
        Tue, 18 May 2021 23:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621381221;
        bh=8D5szr2n8xZa2oKiKPLXOemb8kHwoCMZb/vu5sMBOw0=;
        h=Date:From:To:Subject:From;
        b=qnsKFLB0H37tYkDkrNDSKV1xptLIumXwq+WRyAq1++QlP2541M7kDQHddQ6dRsnGb
         NMtI1Wi+rX7m8Q30O5uNzOwypsIM5hO8h5exviWvro/518/lwfuHgvWz+aMIZpkQRU
         Ie9RWtnuAYSi4JN1RH1yLVyLl2UHx/U5ej05mQKs=
Date:   Tue, 18 May 2021 16:40:20 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        urezki@gmail.com, willy@infradead.org
Subject:  +
 mm-vmalloc-print-a-warning-message-first-on-failure.patch added to -mm tree
Message-ID: <20210518234020.AK7ZLFhDe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: print a warning message first on failure
has been added to the -mm tree.  Its filename is
     mm-vmalloc-print-a-warning-message-first-on-failure.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-print-a-warning-message-first-on-failure.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-print-a-warning-message-first-on-failure.patch

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
Subject: mm/vmalloc: print a warning message first on failure

When a memory allocation for array of pages are not succeed emit a warning
message as a first step and then perform the further cleanup.

The reason it should be done in a right order is the clean up function
which is free_vm_area() can potentially also follow its error paths what
can lead to confusion what was broken first.

Link: https://lkml.kernel.org/r/20210516202056.2120-4-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
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

mm-page_alloc-add-an-alloc_pages_bulk_array_node-helper.patch
mm-vmalloc-switch-to-bulk-allocator-in-__vmalloc_area_node.patch
mm-vmalloc-print-a-warning-message-first-on-failure.patch


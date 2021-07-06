Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AB66C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2620E61356
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbhGFTQA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:16:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231737AbhGFTP7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:15:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99F1860C3D;
        Tue,  6 Jul 2021 19:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598799;
        bh=qNnhBEhkUduU46/8Mg64Ri4fgidtPXhUIkzQ1+du8k0=;
        h=Date:From:To:Subject:From;
        b=Loy4y6n6Wc5Qi1Xa+bNwKjCi5Zwm4NzZy6dg//fQxrpoCO4RUOhJdXsFdLMe+aSfq
         gnIywqKkRCkXfCK6iicUNwURlWzfZr1yu0CEzeuKFII62pTZYwOg2Oghaf7Oe6tmqV
         1Eiv+QSHWAdpOFjJy9weiobrEyKLWlrsl3ZhEu2E=
Date:   Tue, 06 Jul 2021 12:13:19 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        urezki@gmail.com, willy@infradead.org
Subject:  [merged]
 mm-vmalloc-print-a-warning-message-first-on-failure.patch removed from -mm
 tree
Message-ID: <20210706191319.zNsqt-rAh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: print a warning message first on failure
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-print-a-warning-message-first-on-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2783,11 +2783,11 @@ static void *__vmalloc_area_node(struct
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



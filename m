Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EEC7C47437
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4A9722510
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgLOX7K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:60868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726771AbgLOXW3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:22:29 -0500
Date:   Tue, 15 Dec 2020 15:20:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074403;
        bh=zx1KVkGDf+ivgpSRxlVu1lzFp9rBtARy0pHg39dkA/M=;
        h=From:To:Subject:From;
        b=i31UM0gRmv/6XK8SZoPBpjDX0/VqgyiYWm3v+CR8B46c9G6k7oTkbIuxw7AExMKLt
         YxruE/JrEtRGUblq7GY4JT3x44s3IGVfbdYm8hiuQTISs/ossCYrTy/YErNnfgUZFB
         WwD7Jocd82CqeAX1BO6axNYKmFDxsE9SUtoaDAX8=
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, oleksiy.avramchenko@sonymobile.com,
        rostedt@goodmis.org, urezki@gmail.com, willy@infradead.org,
        ying.huang@intel.com
Subject:  [merged]
 mm-vmalloc-use-free_vm_area-if-an-allocation-fails.patch removed from -mm
 tree
Message-ID: <20201215232002.TCG7w0xww%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: use free_vm_area() if an allocation fails
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-use-free_vm_area-if-an-allocation-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: use free_vm_area() if an allocation fails

There is a dedicated and separate function that finds and removes a
continuous kernel virtual area.  As a final step it also releases the
"area", a descriptor of corresponding vm_struct.

Use free_vmap_area() in the __vmalloc_node_range() instead of open coded
steps which are exactly the same, to perform a cleanup.

Link: https://lkml.kernel.org/r/20201116220033.1837-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-free_vm_area-if-an-allocation-fails
+++ a/mm/vmalloc.c
@@ -2479,8 +2479,7 @@ static void *__vmalloc_area_node(struct
 	}
 
 	if (!pages) {
-		remove_vm_area(area->addr);
-		kfree(area);
+		free_vm_area(area);
 		return NULL;
 	}
 
_

Patches currently in -mm which might be from urezki@gmail.com are



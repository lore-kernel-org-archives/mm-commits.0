Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA75AC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABDBC22CB1
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbgLODKv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:10:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:36620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727430AbgLODKe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:10:34 -0500
Date:   Mon, 14 Dec 2020 19:08:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001727;
        bh=lMd8cZOF4pqMHJUgtv6mbkSE8dl78uCQCs1X688BMTQ=;
        h=From:To:Subject:In-Reply-To:From;
        b=EWgyXY3uag41m8PiWNjduFAn5ze79HPRSAsrRSCV+FSHet8QQCscQBTKUWQhVpxFp
         xwrFmrTU2oPsPV/jxCjHOU8dO4TIdtUYChBjMOU5gzvyW/gxHxJshD1kEoIGVBhSfa
         rMtZ0og0jb5B2BNlg4S9otQxE1lkp4KSz6W/LH0M=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hdanton@sina.com, linux-mm@kvack.org,
        mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        torvalds@linux-foundation.org, urezki@gmail.com,
        willy@infradead.org, ying.huang@intel.com
Subject:  [patch 094/200] mm/vmalloc: use free_vm_area() if an
 allocation fails
Message-ID: <20201215030846.UAppiOID_%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E62DC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E500F223E0
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbgLODQr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:16:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:35928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728032AbgLODMg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:36 -0500
Date:   Mon, 14 Dec 2020 19:10:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001847;
        bh=UoO27HCr8bgRu7gXdJgt7KFfZZcVLLNTV0lcf9PO7ZY=;
        h=From:To:Subject:In-Reply-To:From;
        b=GFVJuvongHdmPqH171tYsrQ/pOik1Zci4WpZ5kMnETX8mies+m28mzXWZSvIa3m3m
         RB3swxjHChpZFUOWWVE5ZJAFTI3dsOYzJ4+mFoYzqSv+RX8VkmXL0XZiwRM5NGkHE1
         5k5iJytqa+JyuGA1InHOFqheWGW0MfZAC5G81cP0=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        pankaj.gupta@cloud.ionos.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 125/200] mm, page_alloc: remove setup_pageset()
Message-ID: <20201215031047.lXqJzGzOV%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: remove setup_pageset()

We initialize boot-time pagesets with setup_pageset(), which sets high and
batch values that effectively disable pcplists.

We can remove this wrapper if we just set these values for all pagesets in
pageset_init().  Non-boot pagesets then subsequently update them to the
proper values.

No functional change.

Link: https://lkml.kernel.org/r/20201111092812.11329-4-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-setup_pageset
+++ a/mm/page_alloc.c
@@ -5919,7 +5919,7 @@ static void build_zonelists(pg_data_t *p
  * not check if the processor is online before following the pageset pointer.
  * Other parts of the kernel may not check if the zone is available.
  */
-static void setup_pageset(struct per_cpu_pageset *p);
+static void pageset_init(struct per_cpu_pageset *p);
 static DEFINE_PER_CPU(struct per_cpu_pageset, boot_pageset);
 static DEFINE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
 
@@ -5987,7 +5987,7 @@ build_all_zonelists_init(void)
 	 * (a chicken-egg dilemma).
 	 */
 	for_each_possible_cpu(cpu)
-		setup_pageset(&per_cpu(boot_pageset, cpu));
+		pageset_init(&per_cpu(boot_pageset, cpu));
 
 	mminit_verify_zonelist();
 	cpuset_init_current_mems_allowed();
@@ -6306,12 +6306,15 @@ static void pageset_init(struct per_cpu_
 	pcp = &p->pcp;
 	for (migratetype = 0; migratetype < MIGRATE_PCPTYPES; migratetype++)
 		INIT_LIST_HEAD(&pcp->lists[migratetype]);
-}
 
-static void setup_pageset(struct per_cpu_pageset *p)
-{
-	pageset_init(p);
-	pageset_update(&p->pcp, 0, 1);
+	/*
+	 * Set batch and high values safe for a boot pageset. A true percpu
+	 * pageset's initialization will update them subsequently. Here we don't
+	 * need to be as careful as pageset_update() as nobody can access the
+	 * pageset yet.
+	 */
+	pcp->high = 0;
+	pcp->batch = 1;
 }
 
 /*
_

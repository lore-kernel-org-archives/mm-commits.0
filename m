Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7932DC2BB9A
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F45E22515
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgLODMp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:12:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:36838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbgLODMl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:41 -0500
Date:   Mon, 14 Dec 2020 19:10:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001854;
        bh=slsz5zJzWhka/U3BxGD1L9SnGWe2Xq+bLs00H1TAMBQ=;
        h=From:To:Subject:In-Reply-To:From;
        b=mDsz8aAZgfVDGnMNyoE0vxCMNXnGSAle+Z0bsb9H9CKkGBV1kHla1nzkLqUe0aNxw
         Myk7iE2tMlImjQNgbCGqqTJk6ju45VsGeGyJzftbq4q4mTf8AdiI0wD9TUeDoMIvTj
         ZWAPZNM55Xv2xRoF8vL1JA+O+UPfqZtoKEeFfJqM=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 127/200] mm, page_alloc: cache pageset high and
 batch in struct zone
Message-ID: <20201215031053._9Y5w6EeD%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: cache pageset high and batch in struct zone

All per-cpu pagesets for a zone use the same high and batch values, that
are duplicated there just for performance (locality) reasons.  This patch
adds the same variables also to struct zone as a shared copy.

This will be useful later for making possible to disable pcplists
temporarily by setting high value to 0, while remembering the values for
restoring them later.  But we can also immediately benefit from not
updating pagesets of all possible cpus in case the newly recalculated
values (after sysctl change or memory online/offline) are actually
unchanged from the previous ones.

Link: https://lkml.kernel.org/r/20201111092812.11329-6-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 ++++++
 mm/page_alloc.c        |   16 ++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

--- a/include/linux/mmzone.h~mm-page_alloc-cache-pageset-high-and-batch-in-struct-zone
+++ a/include/linux/mmzone.h
@@ -470,6 +470,12 @@ struct zone {
 #endif
 	struct pglist_data	*zone_pgdat;
 	struct per_cpu_pageset __percpu *pageset;
+	/*
+	 * the high and batch values are copied to individual pagesets for
+	 * faster access
+	 */
+	int pageset_high;
+	int pageset_batch;
 
 #ifndef CONFIG_SPARSEMEM
 	/*
--- a/mm/page_alloc.c~mm-page_alloc-cache-pageset-high-and-batch-in-struct-zone
+++ a/mm/page_alloc.c
@@ -5920,6 +5920,9 @@ static void build_zonelists(pg_data_t *p
  * Other parts of the kernel may not check if the zone is available.
  */
 static void pageset_init(struct per_cpu_pageset *p);
+/* These effectively disable the pcplists in the boot pageset completely */
+#define BOOT_PAGESET_HIGH	0
+#define BOOT_PAGESET_BATCH	1
 static DEFINE_PER_CPU(struct per_cpu_pageset, boot_pageset);
 static DEFINE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
 
@@ -6309,8 +6312,8 @@ static void pageset_init(struct per_cpu_
 	 * need to be as careful as pageset_update() as nobody can access the
 	 * pageset yet.
 	 */
-	pcp->high = 0;
-	pcp->batch = 1;
+	pcp->high = BOOT_PAGESET_HIGH;
+	pcp->batch = BOOT_PAGESET_BATCH;
 }
 
 /*
@@ -6334,6 +6337,13 @@ static void zone_set_pageset_high_and_ba
 		new_batch = max(1UL, 1 * new_batch);
 	}
 
+	if (zone->pageset_high == new_high &&
+	    zone->pageset_batch == new_batch)
+		return;
+
+	zone->pageset_high = new_high;
+	zone->pageset_batch = new_batch;
+
 	for_each_possible_cpu(cpu) {
 		p = per_cpu_ptr(zone->pageset, cpu);
 		pageset_update(&p->pcp, new_high, new_batch);
@@ -6394,6 +6404,8 @@ static __meminit void zone_pcp_init(stru
 	 * offset of a (static) per cpu variable into the per cpu area.
 	 */
 	zone->pageset = &boot_pageset;
+	zone->pageset_high = BOOT_PAGESET_HIGH;
+	zone->pageset_batch = BOOT_PAGESET_BATCH;
 
 	if (populated_zone(zone))
 		printk(KERN_DEBUG "  %s zone: %lu pages, LIFO batch:%u\n",
_

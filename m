Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1CDCC3526B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B239B22D6F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgLOX7X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:60886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727976AbgLOXXa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:23:30 -0500
Date:   Tue, 15 Dec 2020 15:21:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074500;
        bh=/w63bzkd67fN1j+J9OJOul4IM0zT2jOBPR34FDJptM8=;
        h=From:To:Subject:From;
        b=lPeExy9IIDN4EFNcpfqT3WMGd2VcjuNAGwNgW24js7LSRilE876SFBDzHIfCV0Wtb
         yBVgV61oIaR5Qel84jLwpDr5f2W75OtOBX1XF47kRGUCHYoc8VQODhJ5JeWp5mW/Lg
         xCGrfyXlWWWUfXGK2i45IC1le8OWuYtpkY3j18vs=
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, vbabka@suse.cz
Subject:  [merged]
 mm-page_alloc-cache-pageset-high-and-batch-in-struct-zone.patch removed
 from -mm tree
Message-ID: <20201215232140.omI_i6bDK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: cache pageset high and batch in struct zone
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-cache-pageset-high-and-batch-in-struct-zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from vbabka@suse.cz are



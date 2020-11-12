Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 358F9C5519F
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 23:57:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D78D820825
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 23:57:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="LA0wfvEI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgKLX5V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 18:57:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:36694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726229AbgKLX5V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 18:57:21 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1836421D7F;
        Thu, 12 Nov 2020 23:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605225440;
        bh=Rkgl/KJMoIzGmR2FJnsgi+i+nQu4loWrvI58657vG4s=;
        h=Date:From:To:Subject:From;
        b=LA0wfvEI5c1hRhbf5+A2hj/Kpt6yeCk24f9215GRS0rNkUQvAvzR8ZW2OVOH5dTXs
         KqFTUBt+jHrYDZnstCCLjOzb/lZDYvZUIeoHQ47TJ96J11IoTEPSEJ86NZ0xVDYCSB
         +lJeHFgrQcL/0vAFACCLjEq7BN/C/d0w1Yjb+bx8=
Date:   Thu, 12 Nov 2020 15:57:19 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, vbabka@suse.cz
Subject:  +
 mm-page_alloc-cache-pageset-high-and-batch-in-struct-zone.patch added to
 -mm tree
Message-ID: <20201112235719.HuyXQ6tTA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: cache pageset high and batch in struct zone
has been added to the -mm tree.  Its filename is
     mm-page_alloc-cache-pageset-high-and-batch-in-struct-zone.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-cache-pageset-high-and-batch-in-struct-zone.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-cache-pageset-high-and-batch-in-struct-zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -5906,6 +5906,9 @@ static void build_zonelists(pg_data_t *p
  * Other parts of the kernel may not check if the zone is available.
  */
 static void pageset_init(struct per_cpu_pageset *p);
+/* These effectively disable the pcplists in the boot pageset completely */
+#define BOOT_PAGESET_HIGH	0
+#define BOOT_PAGESET_BATCH	1
 static DEFINE_PER_CPU(struct per_cpu_pageset, boot_pageset);
 static DEFINE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
 
@@ -6295,8 +6298,8 @@ static void pageset_init(struct per_cpu_
 	 * need to be as careful as pageset_update() as nobody can access the
 	 * pageset yet.
 	 */
-	pcp->high = 0;
-	pcp->batch = 1;
+	pcp->high = BOOT_PAGESET_HIGH;
+	pcp->batch = BOOT_PAGESET_BATCH;
 }
 
 /*
@@ -6320,6 +6323,13 @@ static void zone_set_pageset_high_and_ba
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
@@ -6380,6 +6390,8 @@ static __meminit void zone_pcp_init(stru
 	 * offset of a (static) per cpu variable into the per cpu area.
 	 */
 	zone->pageset = &boot_pageset;
+	zone->pageset_high = BOOT_PAGESET_HIGH;
+	zone->pageset_batch = BOOT_PAGESET_BATCH;
 
 	if (populated_zone(zone))
 		printk(KERN_DEBUG "  %s zone: %lu pages, LIFO batch:%u\n",
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-use-kmem_cache_debug_flags-in-deactivate_slab.patch
mm-page_alloc-clean-up-pageset-high-and-batch-update.patch
mm-page_alloc-calculate-pageset-high-and-batch-once-per-zone.patch
mm-page_alloc-remove-setup_pageset.patch
mm-page_alloc-simplify-pageset_update.patch
mm-page_alloc-cache-pageset-high-and-batch-in-struct-zone.patch
mm-page_alloc-move-draining-pcplists-to-page-isolation-users.patch
mm-page_alloc-disable-pcplists-during-memory-offline.patch
mm-page_alloc-disable-pcplists-during-memory-offline-fix.patch


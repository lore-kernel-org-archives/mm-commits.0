Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98087C2D0E4
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 23:57:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FCB621D79
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 23:57:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="LNFBniOw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgKLX51 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 18:57:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:36604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbgKLX51 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 18:57:27 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07A9A21D7A;
        Thu, 12 Nov 2020 23:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605225434;
        bh=kvCNo1e9fMbIRzYw4hUWkcYWezH0bNTxlvR95wu1GlI=;
        h=Date:From:To:Subject:From;
        b=LNFBniOwBSMI21tsiCRSXSnOJL1ZOK6VRolhSNuJtuyZ0WtRtrxTLh7Y7LMehniTC
         FIvoD5K8YUhFoiDqUCS8dwzrpTu644CzxdEWWWBRZruPRt9TBf4PX4/nzuepoLnI39
         i49JL6Frqm1wtJK/ntWcZ4c3QIhg6o6IoWM42Uww=
Date:   Thu, 12 Nov 2020 15:57:13 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, pankaj.gupta@cloud.ionos.com, vbabka@suse.cz
Subject:  + mm-page_alloc-remove-setup_pageset.patch added to -mm
 tree
Message-ID: <20201112235713.GhYr51RT0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: remove setup_pageset()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-remove-setup_pageset.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-remove-setup_pageset.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-remove-setup_pageset.patch

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
@@ -5905,7 +5905,7 @@ static void build_zonelists(pg_data_t *p
  * not check if the processor is online before following the pageset pointer.
  * Other parts of the kernel may not check if the zone is available.
  */
-static void setup_pageset(struct per_cpu_pageset *p);
+static void pageset_init(struct per_cpu_pageset *p);
 static DEFINE_PER_CPU(struct per_cpu_pageset, boot_pageset);
 static DEFINE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
 
@@ -5973,7 +5973,7 @@ build_all_zonelists_init(void)
 	 * (a chicken-egg dilemma).
 	 */
 	for_each_possible_cpu(cpu)
-		setup_pageset(&per_cpu(boot_pageset, cpu));
+		pageset_init(&per_cpu(boot_pageset, cpu));
 
 	mminit_verify_zonelist();
 	cpuset_init_current_mems_allowed();
@@ -6292,12 +6292,15 @@ static void pageset_init(struct per_cpu_
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


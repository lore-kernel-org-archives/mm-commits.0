Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B01C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0763B2078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266360;
	bh=JofCPlGZTzSf2GEKLvwo1+TTbob2LalwTEyScS4O7IE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=VSuQDXDWmhZIbNFZFYj9C8rk6bcVfkuMqyEjUTT0gws+yM9dEd/YQ9KASpEY9asd3
	 fKzHT6nuN0JN+Q9WvEmZodCcbyQI/7S3cmv5Tzea+wNr32SN+RGH2u8kgRFzgEJgXs
	 eSfQUTBMJhb86Gm7Ek6SgY0/MestoPa3p/f/HcNs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgHLVF7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:05:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726564AbgHLVF7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:05:59 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E73420774;
        Wed, 12 Aug 2020 21:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266359;
        bh=JofCPlGZTzSf2GEKLvwo1+TTbob2LalwTEyScS4O7IE=;
        h=Date:From:To:Subject:From;
        b=YN0usVjKEBBPLllwHsY0bmC5LVJO1dJyBsRAhj7Rn6IpmwQY1UosFg6S7HIrPx9RE
         EhHRgs1OT8Z4XlBg27zEaj74TZGNrHbUHHtroaCz86MqopRy9k4ibPgXyHNft18n+8
         84MX4nSC2V0MJXNoBlPnqQuGai0e0sVj/GKstBtU=
Date:   Wed, 12 Aug 2020 14:05:58 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hch@infradead.org, iamjoonsoo.kim@lge.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        vbabka@suse.cz
Subject:  [merged]
 =?US-ASCII?Q?mm-migrate-clear-=5F=5Fgfp=5Freclaim-to-make-the-migratio?=
 =?US-ASCII?Q?n-callback-consistent-with-regular-thp-allocations.patch?=
 removed from -mm tree
Message-ID: <20200812210558.hZuY_UI0u%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: clear __GFP_RECLAIM to make the migration callback consistent with regular THP allocations
has been removed from the -mm tree.  Its filename was
     mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/migrate: clear __GFP_RECLAIM to make the migration callback consistent with regular THP allocations

new_page_nodemask is a migration callback and it tries to use a common gfp
flags for the target page allocation whether it is a base page or a THP. 
The later only adds GFP_TRANSHUGE to the given mask.  This results in the
allocation being slightly more aggressive than necessary because the
resulting gfp mask will contain also __GFP_RECLAIM_KSWAPD.  THP
allocations usually exclude this flag to reduce over eager background
reclaim during a high THP allocation load which has been seen during large
mmaps initialization.  There is no indication that this is a problem for
migration as well but theoretically the same might happen when migrating
large mappings to a different node.  Make the migration callback
consistent with regular THP allocations.

[akpm@linux-foundation.org: fix comment typo, per Vlastimil]
Link: http://lkml.kernel.org/r/1594622517-20681-5-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/migrate.c~mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations
+++ a/mm/migrate.c
@@ -1554,6 +1554,11 @@ struct page *new_page_nodemask(struct pa
 	}
 
 	if (PageTransHuge(page)) {
+		/*
+		 * clear __GFP_RECLAIM to make the migration callback
+		 * consistent with regular THP allocations.
+		 */
+		gfp_mask &= ~__GFP_RECLAIM;
 		gfp_mask |= GFP_TRANSHUGE;
 		order = HPAGE_PMD_ORDER;
 	}
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory_hotplug-remove-a-wrapper-for-alloc_migration_target.patch


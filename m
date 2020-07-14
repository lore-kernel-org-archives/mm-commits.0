Return-Path: <SRS0=97KN=AZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C11C433E3
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A9842193E
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594689706;
	bh=zfNj2xaC2YVQqdcbpmrkfrO+kQhw3uHw4QIvl2KZTZE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=T1pLEt2d5Qmxl2VEoGwIenkZgtTWp7vVu73gJPMYtxdwYbl5uh3EUWVAZ1h0uVxFE
	 vVV8Wv8CNa4S1KAof2yJlAUynhu0ZQUZTZIsGvjCgOJE1f9lIel7UDoXHxedg1SdFo
	 Q2OS53a2DP6olCyJwxCrrgZAPlaZyALJdjQATnwY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgGNBVq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:21:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbgGNBVq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jul 2020 21:21:46 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAB8721927;
        Tue, 14 Jul 2020 01:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594689705;
        bh=zfNj2xaC2YVQqdcbpmrkfrO+kQhw3uHw4QIvl2KZTZE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=o9MtHlItj2nXXtRXw4dB8envF/vYxz9w212QAdh9LKB1JXlUDdzz17vcStkbhtAHt
         F54BmeWuqLdHKpLWV5jQg9IJtO9N0r6iOoGLYvQVn9kLDx8h9x/idwo5ZnqHAeI+9u
         Np54r1QNTfY/Y3CAbl6ZvaK0AlgueZFPSd3fq5k8=
Date:   Mon, 13 Jul 2020 18:21:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     guro@fb.com, hch@infradead.org, iamjoonsoo.kim@lge.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        vbabka@suse.cz
Subject:  +
 =?US-ASCII?Q?mm-migrate-clear-=5F=5Fgfp=5Freclaim-to-make-the-migratio?=
 =?US-ASCII?Q?n-callback-consistent-with-regular-thp-allocations.patch?=
 added to -mm tree
Message-ID: <20200714012144.5dsHXSqE2%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
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
has been added to the -mm tree.  Its filename is
     mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1550,6 +1550,11 @@ struct page *new_page_nodemask(struct pa
 	}
 
 	if (PageTransHuge(page)) {
+		/*
+		 * clear __GFP_RECALIM to make the migration callback
+		 * consistent with regular THP allocations.
+		 */
+		gfp_mask &= ~__GFP_RECLAIM;
 		gfp_mask |= GFP_TRANSHUGE;
 		order = HPAGE_PMD_ORDER;
 	}
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-page_isolation-prefer-the-node-of-the-source-page.patch
mm-migrate-move-migration-helper-from-h-to-c.patch
mm-hugetlb-unify-migration-callbacks.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations.patch
mm-migrate-make-a-standard-migration-target-allocation-function.patch
mm-mempolicy-use-a-standard-migration-target-allocation-callback.patch
mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory_hotplug-remove-a-wrapper-for-alloc_migration_target.patch


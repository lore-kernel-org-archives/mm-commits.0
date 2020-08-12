Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD27C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFC4320658
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196243;
	bh=6pUawQYFMnWwmm63Bgul/mcFhjmYAQKelEnj60+iEKo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=VLInGXYF0VtpZZn/dPgadgLXejdCxxkELIRPzJ0FbadQaFEV7KFeMyiWk5zE0NjR5
	 A8P44FxoSb8nxF8CJrjb1Hd+8jk9VRLP2oo/8vCy8qSy9SxiR+2L3LorFednNXHVXG
	 IIew9SnXJPqE0SLoTjo1M0eZaBH2Ec75lvrAT4vU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgHLBhX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:37:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBhX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:37:23 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F3362054F;
        Wed, 12 Aug 2020 01:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196242;
        bh=6pUawQYFMnWwmm63Bgul/mcFhjmYAQKelEnj60+iEKo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=uzVs2i6b6W02rc8wQvqG3BCwRBQox6qwmZMLz27B0FQLshReSsSNFdPCxkEbk0C01
         KiYcndYF0hV5T8UC6HpV4QyQroxhskW9qPt2fmJxqwIhMneGDabaFZabW0zEa/Rw0n
         JIHpuSGFONSoP2aIdvgOtThxTMGfTY83E6PvM0QA=
Date:   Tue, 11 Aug 2020 18:37:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hch@infradead.org,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 134/165] mm/migrate: clear __GFP_RECLAIM to make
 the migration callback consistent with regular THP allocations
Message-ID: <20200812013720.9eNe_libe%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

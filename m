Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 705F4C6377A
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jul 2021 20:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B36561246
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jul 2021 20:50:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbhGUUKI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jul 2021 16:10:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229976AbhGUUKI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 21 Jul 2021 16:10:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A58C461009;
        Wed, 21 Jul 2021 20:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626900644;
        bh=9ePl7FvPHHSI1jvig7UeIBDj1IAHp2A4AblCG1a5EAA=;
        h=Date:From:To:Subject:From;
        b=BVd4p6GSlF37TGXCrBqDEPx+VQ1h13Q33ZaiPGXHvOrD0Z/v5IlsN42ZC0GyUNt8Y
         4YKjnQpcXBoeWti0HEn03yCtFRlpSh/6DsPfiMisykDj0StOQ3s6qMFRyKphekHv1w
         tT1YocbcupnU9VMMjJqNtDuolkxl1y7fPgrvFb0g=
Date:   Wed, 21 Jul 2021 13:50:42 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        weixugc@google.com, shy828301@gmail.com, rientjes@google.com,
        osalvador@suse.de, mhocko@suse.com, kbusch@kernel.org,
        gthelen@google.com, david@redhat.com, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com
Subject:  + mm-migrate-demote-pages-during-reclaim-v11.patch added to
 -mm tree
Message-ID: <20210721205042.3JlVN%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-migrate-demote-pages-during-reclaim-v11
has been added to the -mm tree.  Its filename is
     mm-migrate-demote-pages-during-reclaim-v11.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-demote-pages-during-reclaim-v11.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-demote-pages-during-reclaim-v11.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm-migrate-demote-pages-during-reclaim-v11

Rename can_demote_anon_pages() to can_demote() to reflect the fact that
the function is for anon and file pages.

Link: https://lkml.kernel.org/r/20210715055145.195411-5-ying.huang@intel.com
Link: https://lkml.kernel.org/r/20210721063926.3024591-4-ying.huang@intel.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Wei Xu <weixugc@google.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-migrate-demote-pages-during-reclaim-v11
+++ a/mm/vmscan.c
@@ -519,7 +519,7 @@ static long add_nr_deferred(long nr, str
 	return atomic_long_add_return(nr, &shrinker->nr_deferred[nid]);
 }
 
-static bool can_demote_anon_pages(int nid, struct scan_control *sc)
+static bool can_demote(int nid, struct scan_control *sc)
 {
 	if (sc->no_demotion)
 		return false;
@@ -1343,7 +1343,7 @@ static unsigned int shrink_page_list(str
 
 	memset(stat, 0, sizeof(*stat));
 	cond_resched();
-	do_demote_pass = can_demote_anon_pages(pgdat->node_id, sc);
+	do_demote_pass = can_demote(pgdat->node_id, sc);
 
 retry:
 	while (!list_empty(page_list)) {
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

mm-numa-automatically-generate-node-migration-order.patch
mm-migrate-update-node-demotion-order-on-hotplug-events.patch
mm-migrate-demote-pages-during-reclaim.patch
mm-migrate-demote-pages-during-reclaim-v11.patch
mm-vmscan-add-helper-for-querying-ability-to-age-anonymous-pages.patch
mm-vmscan-add-helper-for-querying-ability-to-age-anonymous-pages-v11.patch
mm-vmscan-never-demote-for-memcg-reclaim.patch
mm-mempolicy-add-mpol_preferred_many-for-multiple-preferred-nodes.patch


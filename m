Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 610CEC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4075061059
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346621AbhIBVUh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:20:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346353AbhIBVUc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:20:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBCC06102A;
        Thu,  2 Sep 2021 21:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630617573;
        bh=cF/TJrS35aQg305oDsvmfH15xK7r+GjOgFIjG6cm7g0=;
        h=Date:From:To:Subject:From;
        b=cx1w+8JyTW4gEdmwTWzS4+EKA3cJjIWo0oUxvdSoe9N7A/z2TFQd9NRwM2J94Wo/z
         QfTCqTXkzidl5X6F1BGtIDzvwBGA5h0IIKMVw2FKQlmc337DP/yFMf4xiWgqIHWXmr
         9XbXuY3ddMJB/cWhCAv/XMl45p7zRC7oHqqtlj2M=
Date:   Thu, 02 Sep 2021 14:19:32 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, gthelen@google.com, kbusch@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        rientjes@google.com, shy828301@gmail.com, weixugc@google.com,
        ying.huang@intel.com, ziy@nvidia.com
Subject:  [folded-merged]
 mm-migrate-demote-pages-during-reclaim-v11.patch removed from -mm tree
Message-ID: <20210902211932.H7MI_MThS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-migrate-demote-pages-during-reclaim-v11
has been removed from the -mm tree.  Its filename was
     mm-migrate-demote-pages-during-reclaim-v11.patch

This patch was dropped because it was folded into mm-migrate-demote-pages-during-reclaim.patch

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
@@ -522,7 +522,7 @@ static long add_nr_deferred(long nr, str
 	return atomic_long_add_return(nr, &shrinker->nr_deferred[nid]);
 }
 
-static bool can_demote_anon_pages(int nid, struct scan_control *sc)
+static bool can_demote(int nid, struct scan_control *sc)
 {
 	if (sc->no_demotion)
 		return false;
@@ -1346,7 +1346,7 @@ static unsigned int shrink_page_list(str
 
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
mm-vmscan-add-helper-for-querying-ability-to-age-anonymous-pages.patch
mm-vmscan-add-helper-for-querying-ability-to-age-anonymous-pages-v11.patch
mm-vmscan-never-demote-for-memcg-reclaim.patch
mm-mempolicy-add-mpol_preferred_many-for-multiple-preferred-nodes.patch


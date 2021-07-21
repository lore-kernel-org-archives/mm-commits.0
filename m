Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61A96C6377B
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jul 2021 20:50:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BF2561244
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jul 2021 20:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhGUUKE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jul 2021 16:10:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229909AbhGUUKD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 21 Jul 2021 16:10:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D88861222;
        Wed, 21 Jul 2021 20:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626900640;
        bh=fCVtVXPui5iVolzePMQxMTpWo9WPgyc9nS99tViKC+A=;
        h=Date:From:To:Subject:From;
        b=KbGE5qnCnMfEgGU7B7IpC+Ye4JMzaJAPLu3sK4Ve2NXeQAgwhxGhkaPseWwXrp1GV
         ZglPcvT3RWf5t8PWWty7Kx8FbYAf1sIp59nZtukyxkI2vDhOds7nK6YsSMErKh1uzf
         4XlrFRZ1Odo1Ewtlhul+ZmUEXmPclLWN7b4Jnj1k=
Date:   Wed, 21 Jul 2021 13:50:38 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        yang.shi@linux.alibaba.com, weixugc@google.com,
        shy828301@gmail.com, rientjes@google.com, osalvador@suse.de,
        mhocko@suse.com, kbusch@kernel.org, gthelen@google.com,
        david@redhat.com, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com
Subject:  + mm-vmscan-never-demote-for-memcg-reclaim.patch added to
 -mm tree
Message-ID: <20210721205038.8DXBB%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: never demote for memcg reclaim
has been added to the -mm tree.  Its filename is
     mm-vmscan-never-demote-for-memcg-reclaim.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-never-demote-for-memcg-reclaim.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-never-demote-for-memcg-reclaim.patch

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
Subject: mm/vmscan: never demote for memcg reclaim

Global reclaim aims to reduce the amount of memory used on a given node or
set of nodes.  Migrating pages to another node serves this purpose.

memcg reclaim is different.  Its goal is to reduce the total memory
consumption of the entire memcg, across all nodes.  Migration does not
assist memcg reclaim because it just moves page contents between nodes
rather than actually reducing memory consumption.

Link: https://lkml.kernel.org/r/20210715055145.195411-9-ying.huang@intel.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Suggested-by: Yang Shi <yang.shi@linux.alibaba.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-never-demote-for-memcg-reclaim
+++ a/mm/vmscan.c
@@ -521,8 +521,13 @@ static long add_nr_deferred(long nr, str
 
 static bool can_demote(int nid, struct scan_control *sc)
 {
-	if (sc && sc->no_demotion)
-		return false;
+	if (sc) {
+		if (sc->no_demotion)
+			return false;
+		/* It is pointless to do demotion in memcg reclaim */
+		if (cgroup_reclaim(sc))
+			return false;
+	}
 	if (next_demotion_node(nid) == NUMA_NO_NODE)
 		return false;
 
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


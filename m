Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F1DC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6194461131
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350231AbhICVBs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:01:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350431AbhICVBl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:01:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAE49610FD;
        Fri,  3 Sep 2021 21:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702841;
        bh=8i7RhWNvCPbVo5OAfSo6qCuZtodPUztmX0mN5oZHeHE=;
        h=Date:From:To:Subject:From;
        b=sNmXZughPGaCw5AZ6pJ00ybecgecomNyPWK4+C9XJGKqq7S3ipNWaFILBUioOsGa2
         t6Rw+eWIIAl4KS/7Kk3I0kKcyv/D5k2pXM5265o3WJupkNDJBg9dTYzrCj/7w17l6j
         uP2US3j57Qhinqz9rZm10dWD6dLQ9XWGf++tzpcU=
Date:   Fri, 03 Sep 2021 14:00:40 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, gthelen@google.com, kbusch@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        rientjes@google.com, shy828301@gmail.com, weixugc@google.com,
        yang.shi@linux.alibaba.com, ying.huang@intel.com, ziy@nvidia.com
Subject:  [merged] mm-vmscan-never-demote-for-memcg-reclaim.patch
 removed from -mm tree
Message-ID: <20210903210040.iWf9-kh7s%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: never demote for memcg reclaim
has been removed from the -mm tree.  Its filename was
     mm-vmscan-never-demote-for-memcg-reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
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
@@ -524,8 +524,13 @@ static long add_nr_deferred(long nr, str
 
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



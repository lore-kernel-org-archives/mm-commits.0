Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4487C07E9D
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 20:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbiIZU7e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 16:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbiIZU73 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 16:59:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E21A061C
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 13:59:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B0CD61416
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 20:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BFAC433D6;
        Mon, 26 Sep 2022 20:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664225967;
        bh=eK6mR4B8nfFTYD3nVBVvbcRxzQ3zRPndg+lXslJ1XPk=;
        h=Date:To:From:Subject:From;
        b=qW6GeSf+ElnCrpkRpkES0e/4fOu1Be/J7+sQG3DpNiTHZ9SLvV1vWCxGnHftycgtQ
         HdDZuQi3zr/afC0AD2yfI7yUp64eejiJs6oFS1puC2Oux8kgMmWGpMYJLFqPZ4u0Wi
         C34AylbsyvODKh2zJ4A6whyAcA+u0TMt4tzpCrdQ=
Date:   Mon, 26 Sep 2022 13:59:26 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, tim.c.chen@intel.com, sj@kernel.org,
        shy828301@gmail.com, mhocko@kernel.org, jvgediya.oss@gmail.com,
        Jonathan.Cameron@huawei.com, hesham.almatary@huawei.com,
        hannes@cmpxchg.org, dave@stgolabs.net, dave.hansen@intel.com,
        dan.j.williams@intel.com, bharata@amd.com, apopple@nvidia.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-3.patch removed from -mm tree
Message-Id: <20220926205927.71BFAC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/demotion: make toptier_distance inclusive upper bound of toptiers
has been removed from the -mm tree.  Its filename was
     mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-3.patch

This patch was dropped because it was folded into mm-demotion-update-node_is_toptier-to-work-with-memory-tiers.patch

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/demotion: make toptier_distance inclusive upper bound of toptiers
Date: Tue, 30 Aug 2022 13:44:57 +0530

Based on suggestion from Wei Xu, having an inclusive upper bound is
simpler.

Link: https://lkml.kernel.org/r/20220830081457.118960-1-aneesh.kumar@linux.ibm.com
Fixes: mm/demotion: Update node_is_toptier to work with memory tiers
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hesham Almatary <hesham.almatary@huawei.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jagdish Gediya <jvgediya.oss@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-tiers.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memory-tiers.c~mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-3
+++ a/mm/memory-tiers.c
@@ -179,7 +179,7 @@ bool node_is_toptier(int node)
 		toptier = true;
 		goto out;
 	}
-	if (memtier->adistance_start < top_tier_adistance)
+	if (memtier->adistance_start <= top_tier_adistance)
 		toptier = true;
 	else
 		toptier = false;
@@ -361,7 +361,8 @@ static void establish_demotion_targets(v
 			 * abstract distance below the max value of this memtier
 			 * is considered toptier.
 			 */
-			top_tier_adistance = memtier->adistance_start + MEMTIER_CHUNK_SIZE;
+			top_tier_adistance = memtier->adistance_start +
+						MEMTIER_CHUNK_SIZE - 1;
 			break;
 		}
 	}
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-demotion-add-support-for-explicit-memory-tiers.patch
mm-demotion-move-memory-demotion-related-code.patch
mm-demotion-add-hotplug-callbacks-to-handle-new-numa-node-onlined.patch
mm-demotion-dax-kmem-set-nodes-abstract-distance-to-memtier_default_dax_adistance.patch
mm-demotion-build-demotion-targets-based-on-explicit-memory-tiers.patch
mm-demotion-add-pg_data_t-member-to-track-node-memory-tier-details.patch
mm-demotion-drop-memtier-from-memtype.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers.patch
lib-nodemask-optimize-node_random-for-nodemask-with-single-numa-node.patch
mm-demotion-expose-memory-tier-details-via-sysfs.patch
mm-demotion-expose-memory-tier-details-via-sysfs-v4.patch


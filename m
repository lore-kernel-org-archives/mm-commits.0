Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E0DFECAAA1
	for <mm-commits@archiver.kernel.org>; Wed, 31 Aug 2022 01:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiHaBcr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 Aug 2022 21:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiHaBcp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Aug 2022 21:32:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FFF9E886
        for <mm-commits@vger.kernel.org>; Tue, 30 Aug 2022 18:32:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47B3FB81E3B
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 01:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E58C433C1;
        Wed, 31 Aug 2022 01:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661909562;
        bh=oJLDJj4DidcAT/nujWIeM/4u1fvPOlgV2AH5mhgUfoU=;
        h=Date:To:From:Subject:From;
        b=II8ZQX9bK8yUcb7lqIsB0wpkkTvS1prRH/g9F4JhF5LPUpL/tSARtqKjDqSnBNuvU
         gLC95tXjdL1kgZ4OzSibefBX4118UJLFrcVN8A6aY6Vr0KPk4oJn7H1HwnSloAz9Zq
         QEflwn09m7Klb45S21ccBADOUknoy4U5phLDFck8=
Date:   Tue, 30 Aug 2022 18:32:41 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, tim.c.chen@intel.com, sj@kernel.org,
        shy828301@gmail.com, mhocko@kernel.org, jvgediya.oss@gmail.com,
        Jonathan.Cameron@huawei.com, hesham.almatary@huawei.com,
        hannes@cmpxchg.org, dave@stgolabs.net, dave.hansen@intel.com,
        dan.j.williams@intel.com, bharata@amd.com, apopple@nvidia.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-3.patch added to mm-unstable branch
Message-Id: <20220831013241.E9E58C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/demotion: make toptier_distance inclusive upper bound of toptiers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-3.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
mm-demotion-add-hotplug-callbacks-to-handle-new-numa-node-onlined-fix.patch
mm-demotion-dax-kmem-set-nodes-abstract-distance-to-memtier_default_dax_adistance.patch
mm-demotion-dax-kmem-set-nodes-abstract-distance-to-memtier_default_dax_adistance-fix.patch
mm-demotion-build-demotion-targets-based-on-explicit-memory-tiers.patch
mm-demotion-add-pg_data_t-member-to-track-node-memory-tier-details.patch
mm-demotion-drop-memtier-from-memtype.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-3.patch
lib-nodemask-optimize-node_random-for-nodemask-with-single-numa-node.patch
mm-demotion-expose-memory-tier-details-via-sysfs.patch


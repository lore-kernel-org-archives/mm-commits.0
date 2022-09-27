Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D71C6FA82
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiI0CvA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbiI0Cs5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:48:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5B9A98CD
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:48:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16C97B81910
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31F7C433C1;
        Tue, 27 Sep 2022 02:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246905;
        bh=GGwuAowMb6ZfMFYL6lboGaV9uOvqs1oTj2H3MF9d+R4=;
        h=Date:To:From:Subject:From;
        b=FaDwSqfCCkJlJRJrguoXBJTYbTnWTTPuxLEV/4NWM4vcF+Do/1MjBobB0H4tNsbXk
         101e+IJ57s8KiZqxOP+GicsFuoWFRUXlHi50urIfXRs9NpsMx3r6SBNvbvvk5pwJrd
         MfMmAkNlobOww1jAlyvNLkIq7xPBQOTzWcAw4bGU=
Date:   Mon, 26 Sep 2022 19:48:25 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, tim.c.chen@intel.com, sj@kernel.org,
        shy828301@gmail.com, mhocko@kernel.org, jvgediya.oss@gmail.com,
        Jonathan.Cameron@huawei.com, hesham.almatary@huawei.com,
        hannes@cmpxchg.org, dave@stgolabs.net, dave.hansen@intel.com,
        dan.j.williams@intel.com, bharata@amd.com, apopple@nvidia.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-nodemask-optimize-node_random-for-nodemask-with-single-numa-node.patch removed from -mm tree
Message-Id: <20220927024825.C31F7C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/nodemask: optimize node_random for nodemask with single NUMA node
has been removed from the -mm tree.  Its filename was
     lib-nodemask-optimize-node_random-for-nodemask-with-single-numa-node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: lib/nodemask: optimize node_random for nodemask with single NUMA node
Date: Thu, 18 Aug 2022 18:40:42 +0530

The most common case for certain node_random usage (demotion nodemask) is
with nodemask weight 1.  We can avoid calling get_random_init() in that
case and always return the only node set in the nodemask.

A simple test as below
  before = rdtsc_ordered();
  for (i= 0; i < 100; i++) {
      rand = node_random(&nmask);
  }
  after = rdtsc_ordered();

Without fix after - before : 16438
With fix after - before : 816

Link: https://lkml.kernel.org/r/20220818131042.113280-11-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Wei Xu <weixugc@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hesham Almatary <hesham.almatary@huawei.com>
Cc: Jagdish Gediya <jvgediya.oss@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/include/linux/nodemask.h~lib-nodemask-optimize-node_random-for-nodemask-with-single-numa-node
+++ a/include/linux/nodemask.h
@@ -505,12 +505,21 @@ static inline int num_node_state(enum no
 static inline int node_random(const nodemask_t *maskp)
 {
 #if defined(CONFIG_NUMA) && (MAX_NUMNODES > 1)
-	int w, bit = NUMA_NO_NODE;
+	int w, bit;
 
 	w = nodes_weight(*maskp);
-	if (w)
+	switch (w) {
+	case 0:
+		bit = NUMA_NO_NODE;
+		break;
+	case 1:
+		bit = first_node(*maskp);
+		break;
+	default:
 		bit = bitmap_ord_to_pos(maskp->bits,
-			get_random_int() % w, MAX_NUMNODES);
+					get_random_int() % w, MAX_NUMNODES);
+		break;
+	}
 	return bit;
 #else
 	return 0;
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are



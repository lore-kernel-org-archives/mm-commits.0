Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F62CC00140
	for <mm-commits@archiver.kernel.org>; Thu, 18 Aug 2022 23:52:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346039AbiHRXwB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Aug 2022 19:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245586AbiHRXvn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Aug 2022 19:51:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59395DD742
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 16:51:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BEDBB824EA
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 23:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A357EC433D7;
        Thu, 18 Aug 2022 23:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660866689;
        bh=+IeqbVLHGS29aFjMaCnXW967PO4m3x2PMFlMcBCrp80=;
        h=Date:To:From:Subject:From;
        b=Ypn85z6wQmHeetVF/AIrRKTheWoCv/RZ8Rk0JLan38TusxLDQ5CrL5TrR63L9Qo7Q
         R+0ZAjx9+3U9bkp6sYwum1QcKxmLk84P88Vk7F1iOSwJXMFoTfSX7mHJXLW6h+kXuh
         SDC7qw/OypN0rvZvsOQ9f/BQvYYdemhQ72tX6Q2w=
Date:   Thu, 18 Aug 2022 16:51:28 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, tim.c.chen@intel.com, shy828301@gmail.com,
        mhocko@kernel.org, jvgediya.oss@gmail.com,
        Jonathan.Cameron@huawei.com, hesham.almatary@huawei.com,
        hannes@cmpxchg.org, dave@stgolabs.net, dave.hansen@intel.com,
        dan.j.williams@intel.com, bharata@amd.com, apopple@nvidia.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-nodemask-optimize-node_random-for-nodemask-with-single-numa-node.patch added to mm-unstable branch
Message-Id: <20220818235129.A357EC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/nodemask: optimize node_random for nodemask with single NUMA node
has been added to the -mm mm-unstable branch.  Its filename is
     lib-nodemask-optimize-node_random-for-nodemask-with-single-numa-node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-nodemask-optimize-node_random-for-nodemask-with-single-numa-node.patch

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
Cc: Wei Xu <weixugc@google.com>
Cc: Yang Shi <shy828301@gmail.com>
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

mm-demotion-add-support-for-explicit-memory-tiers.patch
mm-demotion-move-memory-demotion-related-code.patch
mm-demotion-add-hotplug-callbacks-to-handle-new-numa-node-onlined.patch
mm-demotion-dax-kmem-set-nodes-abstract-distance-to-memtier_default_dax_adistance.patch
mm-demotion-build-demotion-targets-based-on-explicit-memory-tiers.patch
mm-demotion-add-pg_data_t-member-to-track-node-memory-tier-details.patch
mm-demotion-drop-memtier-from-memtype.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers.patch
lib-nodemask-optimize-node_random-for-nodemask-with-single-numa-node.patch


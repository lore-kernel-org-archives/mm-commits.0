Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26455C11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1196061D20
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbhF2Cpj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:45:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231332AbhF2Cpi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:45:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4A6261D1D;
        Tue, 29 Jun 2021 02:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934592;
        bh=rHvJcpbuQR7xtLpBz6JlEOqWljVAT9Qt0WEFgBr+qBI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LGCzfeIKekRYfpM4j7DyB86Hk+LHJhYjC1UciCpn58ZpcyLF2KqCfmFN2khXP7dUw
         TjoPXlyW3FaoG1wxe5t0J1pEUvkQGzEQgcrw8xM6f47wwG0XZ/5w/9pVxL4Dl563rM
         F5Ezm+HX18tiFdX/FtDX+gQO3heqPW0R1vXY6qp4=
Date:   Mon, 28 Jun 2021 19:43:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dave.hansen@intel.com,
        feng.tang@intel.com, hdanton@sina.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 190/192] mm/page_alloc: split pcp->high across all
 online CPUs for cpuless nodes
Message-ID: <20210629024311.e8wr0CToB%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: split pcp->high across all online CPUs for cpuless nodes

Dave Hansen reported the following about Feng Tang's tests on a machine
with persistent memory onlined as a DRAM-like device.

  Feng Tang tossed these on a "Cascade Lake" system with 96 threads and
  ~512G of persistent memory and 128G of DRAM.  The PMEM is in "volatile
  use" mode and being managed via the buddy just like the normal RAM.

  The PMEM zones are big ones:

        present  65011712 = 248 G
        high       134595 = 525 M

  The PMEM nodes, of course, don't have any CPUs in them.

  With your series, the pcp->high value per-cpu is 69584 pages or about
  270MB per CPU.  Scaled up by the 96 CPU threads, that's ~26GB of
  worst-case memory in the pcps per zone, or roughly 10% of the size of
  the zone.

This should not cause a problem as such although it could trigger reclaim
due to pages being stored on per-cpu lists for CPUs remote to a node.  It
is not possible to treat cpuless nodes exactly the same as normal nodes
but the worst-case scenario can be mitigated by splitting pcp->high across
all online CPUs for cpuless memory nodes.

Link: https://lkml.kernel.org/r/20210616110743.GK30378@techsingularity.net
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Tang, Feng" <feng.tang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-split-pcp-high-across-all-online-cpus-for-cpuless-nodes
+++ a/mm/page_alloc.c
@@ -6790,7 +6790,7 @@ static int zone_highsize(struct zone *zo
 {
 #ifdef CONFIG_MMU
 	int high;
-	int nr_local_cpus;
+	int nr_split_cpus;
 	unsigned long total_pages;
 
 	if (!percpu_pagelist_high_fraction) {
@@ -6813,10 +6813,14 @@ static int zone_highsize(struct zone *zo
 	 * Split the high value across all online CPUs local to the zone. Note
 	 * that early in boot that CPUs may not be online yet and that during
 	 * CPU hotplug that the cpumask is not yet updated when a CPU is being
-	 * onlined.
+	 * onlined. For memory nodes that have no CPUs, split pcp->high across
+	 * all online CPUs to mitigate the risk that reclaim is triggered
+	 * prematurely due to pages stored on pcp lists.
 	 */
-	nr_local_cpus = max(1U, cpumask_weight(cpumask_of_node(zone_to_nid(zone)))) + cpu_online;
-	high = total_pages / nr_local_cpus;
+	nr_split_cpus = cpumask_weight(cpumask_of_node(zone_to_nid(zone))) + cpu_online;
+	if (!nr_split_cpus)
+		nr_split_cpus = num_online_cpus();
+	high = total_pages / nr_split_cpus;
 
 	/*
 	 * Ensure high is at least batch*4. The multiple is based on the
_

Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3FCCC25B6E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjJYXrn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjJYXrm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:47:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB73992
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:47:40 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F6DC433C8;
        Wed, 25 Oct 2023 23:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277660;
        bh=nbKPfsfER4EnkCEbBP7ygBLSYScyUFOKfZQ1gYM0gik=;
        h=Date:To:From:Subject:From;
        b=NS27G217BqVO1MAtbguVdLdi+RewSrzFLZDDPBtHB5tBtd/DzXQZsxK4RbY6OZrjg
         KPrSSY02mB8M/ucry9Noa1Yr2zYEwpQIYeBIpvv9iPFCMftGWGyTV4EPBWj14k9K5c
         5JCPPthTIWw5HJCDAtTpxEAzlx0x4w5wHziNb1z4=
Date:   Wed, 25 Oct 2023 16:47:39 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@kernel.org,
        mgorman@techsingularity.net, cl@linux.com, ying.huang@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-draining-remote-pageset.patch removed from -mm tree
Message-Id: <20231025234740.70F6DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix draining remote pageset
has been removed from the -mm tree.  Its filename was
     mm-fix-draining-remote-pageset.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm: fix draining remote pageset
Date: Fri, 11 Aug 2023 17:08:19 +0800

If there is no memory allocation/freeing in the PCP (Per-CPU Pageset) of a
remote zone (zone in remote NUMA node) after some time (3 seconds for
now), the pages of the PCP of the remote zone will be drained to avoid
memory wastage.

This behavior was introduced in the commit 4ae7c03943fc ("[PATCH]
Periodically drain non local pagesets") and the commit 4037d452202e ("Move
remote node draining out of slab allocators")

But, after the commit 7cc36bbddde5 ("vmstat: on-demand vmstat workers
V8"), the vmstat updater worker which is used to drain the PCP of remote
zones may not be re-queued when we are waiting for the timeout
(pcp->expire != 0) if there are no vmstat changes on this CPU, for
example, when the CPU goes idle or runs user space only workloads.  This
may cause the pages of a remote zone be kept in PCP of this CPU for long
time.  So that, the page reclaiming of the remote zone may be triggered
prematurely.  This isn't a severe problem in practice, because the PCP of
the remote zone will be drained if some memory are allocated/freed again
on this CPU.  And, the PCP will eventually be drained during the direct
reclaiming if necessary.

Anyway, the problem still deserves a fix via guaranteeing that the vmstat
updater worker will always be re-queued when we are waiting for the
timeout.  In effect, this restores the original behavior before the commit
7cc36bbddde5.

We can reproduce the bug via allocating/freeing pages from a remote zone
then go idle as follows.  And the patch can fix it.

- Run some workloads, use `numactl` to bind CPU to node 0 and memory to
  node 1.  So the PCP of the CPU on node 0 for zone on node 1 will be
  filled.

- After workloads finish, idle for 60s

- Check /proc/zoneinfo

With the original kernel, the number of pages in the PCP of the CPU on
node 0 for zone on node 1 is non-zero after idle.  With the patched
kernel, it becomes 0 after idle.  That is, we avoid to keep pages in the
remote PCP during idle.

Link: https://lkml.kernel.org/r/20231007062356.187621-1-ying.huang@intel.com
Link: https://lkml.kernel.org/r/20230811090819.60845-1-ying.huang@intel.com
Fixes: 7cc36bbddde5 ("vmstat: on-demand vmstat workers V8")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/vmstat.c~mm-fix-draining-remote-pageset
+++ a/mm/vmstat.c
@@ -857,8 +857,10 @@ static int refresh_cpu_vm_stats(bool do_
 				continue;
 			}
 
-			if (__this_cpu_dec_return(pcp->expire))
+			if (__this_cpu_dec_return(pcp->expire)) {
+				changes++;
 				continue;
+			}
 
 			if (__this_cpu_read(pcp->count)) {
 				drain_zone_pages(zone, this_cpu_ptr(pcp));
_

Patches currently in -mm which might be from ying.huang@intel.com are



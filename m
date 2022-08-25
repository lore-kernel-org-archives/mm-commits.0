Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C8EC3F6B0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Aug 2022 00:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiHYAeC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 20:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiHYAeB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 20:34:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DBA8D3F6
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 17:33:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DFB461A78
        for <mm-commits@vger.kernel.org>; Thu, 25 Aug 2022 00:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6148DC433C1;
        Thu, 25 Aug 2022 00:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661387638;
        bh=YESJk26G/WYj278eMVGAaq27yBNdJN+F9gERXJfmuUI=;
        h=Date:To:From:Subject:From;
        b=poJYQEzBSoEzKMRQzv/gsZiCkrrLZIeCUIrGomo0fQAvbc0NaO61qpHIdGqBj7vPp
         hzP9qQ+E50fCt1HX4JrTMZoMj1TVAJ4ZD7tFRN2tFfgDKvM6ydg4eYUtX6/tb6Nfaq
         XlitsSQw18OHzhtQ93p6vX9PcC6LQ+nrBow8BKXY=
Date:   Wed, 24 Aug 2022 17:33:57 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        soheil@google.com, roman.gushchin@linux.dev, oliver.sang@intel.com,
        mkoutny@suse.com, mhocko@kernel.org, hannes@cmpxchg.org,
        feng.tang@intel.com, edumazet@google.com, shakeelb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_counter-remove-unneeded-atomic-ops-for-low-min.patch added to mm-unstable branch
Message-Id: <20220825003358.6148DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_counter: remove unneeded atomic ops for low/min
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_counter-remove-unneeded-atomic-ops-for-low-min.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_counter-remove-unneeded-atomic-ops-for-low-min.patch

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
From: Shakeel Butt <shakeelb@google.com>
Subject: mm: page_counter: remove unneeded atomic ops for low/min
Date: Thu, 25 Aug 2022 00:05:04 +0000

Patch series "memcg: optimize charge codepath", v2.

Recently Linux networking stack has moved from a very old per socket
pre-charge caching to per-cpu caching to avoid pre-charge fragmentation
and unwarranted OOMs.  One impact of this change is that for network
traffic workloads, memcg charging codepath can become a bottleneck.  The
kernel test robot has also reported this regression[1].  This patch series
tries to improve the memcg charging for such workloads.

This patch series implement three optimizations:
(A) Reduce atomic ops in page counter update path.
(B) Change layout of struct page_counter to eliminate false sharing
    between usage and high.
(C) Increase the memcg charge batch to 64.

To evaluate the impact of these optimizations, on a 72 CPUs machine, we
ran the following workload in root memcg and then compared with scenario
where the workload is run in a three level of cgroup hierarchy with top
level having min and low setup appropriately.

 $ netserver -6
 # 36 instances of netperf with following params
 $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K

Results (average throughput of netperf):
1. root memcg		21694.8 Mbps
2. 6.0-rc1		10482.7 Mbps (-51.6%)
3. 6.0-rc1 + (A)	14542.5 Mbps (-32.9%)
4. 6.0-rc1 + (B)	12413.7 Mbps (-42.7%)
5. 6.0-rc1 + (C)	17063.7 Mbps (-21.3%)
6. 6.0-rc1 + (A+B+C)	20120.3 Mbps (-7.2%)

With all three optimizations, the memcg overhead of this workload has
been reduced from 51.6% to just 7.2%.

[1] https://lore.kernel.org/linux-mm/20220619150456.GB34471@xsang-OptiPlex-9020/


This patch (of 3):

For cgroups using low or min protections, the function
propagate_protected_usage() was doing an atomic xchg() operation
irrespectively.  We can optimize out this atomic operation for one
specific scenario where the workload is using the protection (i.e.  min >
0) and the usage is above the protection (i.e.  usage > min).

This scenario is actually very common where the users want a part of their
workload to be protected against the external reclaim.  Though this
optimization does introduce a race when the usage is around the protection
and concurrent charges and uncharged trip it over or under the protection.
In such cases, we might see lower effective protection but the subsequent
charge/uncharge will correct it.

To evaluate the impact of this optimization, on a 72 CPUs machine, we ran
the following workload in a three level of cgroup hierarchy with top level
having min and low setup appropriately to see if this optimization is
effective for the mentioned case.

 $ netserver -6
 # 36 instances of netperf with following params
 $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K

Results (average throughput of netperf):
Without (6.0-rc1)	10482.7 Mbps
With patch		14542.5 Mbps (38.7% improvement)

With the patch, the throughput improved by 38.7%

Link: https://lkml.kernel.org/r/20220825000506.239406-1-shakeelb@google.com
Link: https://lkml.kernel.org/r/20220825000506.239406-2-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Reviewed-by: Feng Tang <feng.tang@intel.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Michal Koutný" <mkoutny@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oliver Sang <oliver.sang@intel.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_counter.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/page_counter.c~mm-page_counter-remove-unneeded-atomic-ops-for-low-min
+++ a/mm/page_counter.c
@@ -17,24 +17,23 @@ static void propagate_protected_usage(st
 				      unsigned long usage)
 {
 	unsigned long protected, old_protected;
-	unsigned long low, min;
 	long delta;
 
 	if (!c->parent)
 		return;
 
-	min = READ_ONCE(c->min);
-	if (min || atomic_long_read(&c->min_usage)) {
-		protected = min(usage, min);
+	protected = min(usage, READ_ONCE(c->min));
+	old_protected = atomic_long_read(&c->min_usage);
+	if (protected != old_protected) {
 		old_protected = atomic_long_xchg(&c->min_usage, protected);
 		delta = protected - old_protected;
 		if (delta)
 			atomic_long_add(delta, &c->parent->children_min_usage);
 	}
 
-	low = READ_ONCE(c->low);
-	if (low || atomic_long_read(&c->low_usage)) {
-		protected = min(usage, low);
+	protected = min(usage, READ_ONCE(c->low));
+	old_protected = atomic_long_read(&c->low_usage);
+	if (protected != old_protected) {
 		old_protected = atomic_long_xchg(&c->low_usage, protected);
 		delta = protected - old_protected;
 		if (delta)
_

Patches currently in -mm which might be from shakeelb@google.com are

revert-memcg-cleanup-racy-sum-avoidance-code.patch
mm-page_counter-remove-unneeded-atomic-ops-for-low-min.patch
mm-page_counter-rearrange-struct-page_counter-fields.patch
memcg-increase-memcg_charge_batch-to-64.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D498322B
	for <mm-commits@vger.kernel.org>; Wed, 28 May 2025 02:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748399962; cv=none; b=AlbUj+zMjxJQ0osP2OKpBuof8osPcIUrWcDuLbXm1bWyp1oFrZ00UMXq2OMvJMswMqF+zgvj2pSFEgJzeBkJdC2A1OmmZqlxGgVJ7rVax+bzizOHXMaO/c9L1o7cmSi8gBQf1wublj+CLGyuvDecBL/DOOHwiKuhUhLRWWMZELk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748399962; c=relaxed/simple;
	bh=8mLZzmB6k8IcfMtED93z7E+sQUv+uQIaIi3r+C1vzoI=;
	h=Date:To:From:Subject:Message-Id; b=glk7/Q5JsYrGUK29TtI8KX1obdMqJzGHpMbbjiO/Lt0DpR8p/7pjWSjpJblEo9qNukT5gEHNFqlW2j0gCRd4QZRPK3cgNd0Bb8q7N+rTn6Ascg1wTg9a2PCH4C9Xnl2oX3z7z+cBJu/Sdak4q5ti+H+T5k8LC3PBfVki914O7/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CIL+p8V3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CIL+p8V3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A940C4CEE9;
	Wed, 28 May 2025 02:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748399961;
	bh=8mLZzmB6k8IcfMtED93z7E+sQUv+uQIaIi3r+C1vzoI=;
	h=Date:To:From:Subject:From;
	b=CIL+p8V3JBvx6wKAzKXvEXhRMaI2ubw6aYPl2xy3qwpZw2pTMS0NmCcd8j/Ctw+QD
	 Sr4s9actCdbpW3J38HHZBAzdfdXjwJQbh7jfxEs3cgpOHhKuuUrf8yzV+XgKdnc4VL
	 rnVaayXW9Ojkixoj2C2RwVRQWcXVlz4TP4hlXtdE=
Date: Tue, 27 May 2025 19:39:20 -0700
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,raghavendra.kt@amd.com,mgorman@techsingularity.net,bharata@amd.com,nikhil.dhama@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pcp-increase-pcp-free_count-threshold-to-trigger-free_high.patch removed from -mm tree
Message-Id: <20250528023921.7A940C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pcp: increase pcp->free_count threshold to trigger free_high
has been removed from the -mm tree.  Its filename was
     mm-pcp-increase-pcp-free_count-threshold-to-trigger-free_high.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nikhil Dhama <nikhil.dhama@amd.com>
Subject: mm: pcp: increase pcp->free_count threshold to trigger free_high
Date: Mon, 7 Apr 2025 16:22:19 +0530

In old pcp design, pcp->free_factor gets incremented in nr_pcp_free()
which is invoked by free_pcppages_bulk().  So, it used to increase
free_factor by 1 only when we try to reduce the size of pcp list and
free_high used to trigger only for order > 0 and order < costly_order
and pcp->free_factor > 0.

For iperf3 I noticed that with older design in kernel v6.6, pcp list
was drained mostly when pcp->count > high (more often when count goes
above 530).  and most of the time pcp->free_factor was 0, triggering
very few high order flushes.

But this is changed in the current design, introduced in commit
6ccdcb6d3a74 ("mm, pcp: reduce detecting time of consecutive high order
page freeing"), where pcp->free_factor is changed to pcp->free_count to
keep track of the number of pages freed contiguously.  In this design,
pcp->free_count is incremented on every deallocation, irrespective of
whether pcp list was reduced or not.  And logic to trigger free_high is
if pcp->free_count goes above batch (which is 63) and there are two
contiguous page free without any allocation.

With this design, for iperf3, pcp list is getting flushed more
frequently because free_high heuristics is triggered more often now.  I
observed that high order pcp list is drained as soon as both count and
free_count goes above 63.

Due to this more aggressive high order flushing, applications doing
contiguous high order allocation will require to go to global list more
frequently.

On a 2-node AMD machine with 384 vCPUs on each node, connected via
Mellonox connectX-7, I am seeing a ~30% performance reduction if we
scale number of iperf3 client/server pairs from 32 to 64.

Though this new design reduced the time to detect high order flushes,
but for application which are allocating high order pages more
frequently it may be flushing the high order list pre-maturely.  This
motivates towards tuning on how late or early we should flush high
order lists.  

So, in this patch, we increased the pcp->free_count threshold to
trigger free_high from "batch" to "batch + pcp->high_min / 2" as
suggested by Ying [1], In the original pcp->free_factor solution,
free_high is triggered for contiguous freeing with size ranging from
"batch" to "pcp->high + batch".  So, the average value is "batch +
pcp->high / 2".  While in the pcp->free_count solution, free_high will
be triggered for contiguous freeing with size "batch".  So, to restore
the original behavior, we can use the threshold "batch + pcp->high_min
/ 2"

This new threshold keeps high order pages in pcp list for a longer
duration which can help the application doing high order allocations
frequently.

With this patch performace to Iperf3 is restored and score for other
benchmarks on the same machine are as follows:

		      iperf3    lmbench3        netperf         kbuild
                               (AF_UNIX)   (SCTP_STREAM_MANY)
                     -------   ---------   -----------------    ------
v6.6  vanilla (base)    100          100              100          100
v6.12 vanilla            69          113             98.5         98.8
v6.12 + this patch      100        110.3            100.2         99.3


netperf-tcp:

                                  6.12                      6.12
                               vanilla    	      this_patch
Hmean     64         732.14 (   0.00%)         730.45 (  -0.23%)
Hmean     128       1417.46 (   0.00%)        1419.44 (   0.14%)
Hmean     256       2679.67 (   0.00%)        2676.45 (  -0.12%)
Hmean     1024      8328.52 (   0.00%)        8339.34 (   0.13%)
Hmean     2048     12716.98 (   0.00%)       12743.68 (   0.21%)
Hmean     3312     15787.79 (   0.00%)       15887.25 (   0.63%)
Hmean     4096     17311.91 (   0.00%)       17332.68 (   0.12%)
Hmean     8192     20310.73 (   0.00%)       20465.09 (   0.76%)

Link: https://lore.kernel.org/all/875xjmuiup.fsf@DESKTOP-5N7EMDA/ [1]
Link: https://lkml.kernel.org/r/20250407105219.55351-1-nikhil.dhama@amd.com
Fixes: 6ccdcb6d3a74 ("mm, pcp: reduce detecting time of consecutive high order page freeing")
Signed-off-by: Nikhil Dhama <nikhil.dhama@amd.com>
Suggested-by: Huang Ying <ying.huang@linux.alibaba.com>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Cc: Raghavendra K T <raghavendra.kt@amd.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Bharata B Rao <bharata@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-pcp-increase-pcp-free_count-threshold-to-trigger-free_high
+++ a/mm/page_alloc.c
@@ -2661,7 +2661,7 @@ static void free_frozen_page_commit(stru
 	 * stops will be drained from vmstat refresh context.
 	 */
 	if (order && order <= PAGE_ALLOC_COSTLY_ORDER) {
-		free_high = (pcp->free_count >= batch &&
+		free_high = (pcp->free_count >= (batch + pcp->high_min / 2) &&
 			     (pcp->flags & PCPF_PREV_FREE_HIGH_ORDER) &&
 			     (!(pcp->flags & PCPF_FREE_HIGH_BATCH) ||
 			      pcp->count >= batch));
_

Patches currently in -mm which might be from nikhil.dhama@amd.com are



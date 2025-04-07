Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C372185BE
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 19:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744052688; cv=none; b=nxJV9GuebtUYFaFNdA6nN5MEc4IaitINKNbT/phkhtIwDoDyj86bVUguoJODVLbAaee9TiTfRfNgy+FZrdqUEUD026H//QJ5zsmegqbdFdyXDu48w7gUPNzrk7fgv1g4f4MMRnoJYspRyWF6+69PHq3pT9aQBlDlN50zWUNRrSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744052688; c=relaxed/simple;
	bh=olgYtSXWJ60ORY12xRharteCZJK943SUK4aDOeYhU6I=;
	h=Date:To:From:Subject:Message-Id; b=hP4LSLcR0FZ9rK47uAlaWWeczrRKPQuTZHPJApxq78uOseRcEZzJCV3IJXd+joq8AuUUG6vGsG0epfGyjyifWEjuJHa1UVBQuNGtNy1XX+9XfC+AsIatoAbOcyenJgnsN/RF5FFw3Ec1OCCYCECXiBJeDqJE8sTHjlpUDfDAXRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VXX+DFmS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VXX+DFmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D322DC4CEDD;
	Mon,  7 Apr 2025 19:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744052687;
	bh=olgYtSXWJ60ORY12xRharteCZJK943SUK4aDOeYhU6I=;
	h=Date:To:From:Subject:From;
	b=VXX+DFmSsVyMBd6b9Qze7iAARHU3xer2rabX5cSlRW3wKThGnt2n8L/u1W5ZU23BJ
	 tpjQ4Ys1K4Qj+2+b/yFsgXGpo8olASNBiyEduISFGcJcw6mb91h6ZoHz3UtQu4OSWj
	 75aR66VHrY7RpWQBZgT6cseHQDyV5tEYHG9kAXwE=
Date: Mon, 07 Apr 2025 12:04:47 -0700
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,mgorman@techsingularity.net,huang.ying.caritas@gmail.com,bharata@amd.com,nikhil.dhama@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pcp-increase-pcp-free_count-threshold-to-trigger-free_high.patch added to mm-new branch
Message-Id: <20250407190447.D322DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: pcp: increase pcp->free_count threshold to trigger free_high
has been added to the -mm mm-new branch.  Its filename is
     mm-pcp-increase-pcp-free_count-threshold-to-trigger-free_high.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pcp-increase-pcp-free_count-threshold-to-trigger-free_high.patch

This patch will later appear in the mm-new branch at
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
From: Nikhil Dhama <nikhil.dhama@amd.com>
Subject: mm: pcp: increase pcp->free_count threshold to trigger free_high
Date: Mon, 7 Apr 2025 16:22:19 +0530

In old pcp design, pcp->free_factor gets incremented in nr_pcp_free()
which is invoked by free_pcppages_bulk().  So, it used to increase
free_factor by 1 only when we try to reduce the size of pcp list or flush
for high order, and free_high used to trigger only for order > 0 and order
< costly_order and pcp->free_factor > 0.

For iperf3 I noticed that with older design in kernel v6.6, pcp list was
drained mostly when pcp->count > high (more often when count goes above
530).  and most of the time pcp->free_factor was 0, triggering very few
high order flushes.

But this is changed in the current design, introduced in commit
6ccdcb6d3a74 ("mm, pcp: reduce detecting time of consecutive high order
page freeing"), where pcp->free_factor is changed to pcp->free_count to
keep track of the number of pages freed contiguously.  In this design,
pcp->free_count is incremented on every deallocation, irrespective of
whether pcp list was reduced or not.  And logic to trigger free_high is if
pcp->free_count goes above batch (which is 63) and there are two
contiguous page free without any allocation.

With this design, for iperf3, pcp list is getting flushed more frequently
because free_high heuristics is triggered more often now.  I observed that
high order pcp list is drained as soon as both count and free_count goes
above 63.

Due to this more aggressive high order flushing, applications doing
contiguous high order allocation will require to go to global list more
frequently.

On a 2-node AMD machine with 384 vCPUs on each node, connected via
Mellonox connectX-7, I am seeing a ~30% performance reduction if we scale
number of iperf3 client/server pairs from 32 to 64.

Though this new design reduced the time to detect high order flushes, but
for application which are allocating high order pages more frequently it
may be flushing the high order list pre-maturely.  This motivates towards
tuning on how late or early we should flush high order lists.

So, in this patch, we increased the pcp->free_count threshold to trigger
free_high from "batch" to "batch + pcp->high_min / 2".  This new threshold
keeps high order pages in pcp list for a longer duration which can help
the application doing high order allocations frequently.

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

Link: https://lkml.kernel.org/r/20250407105219.55351-1-nikhil.dhama@amd.com
Fixes: 6ccdcb6d3a74 ("mm, pcp: reduce detecting time of consecutive high order page freeing")
Signed-off-by: Nikhil Dhama <nikhil.dhama@amd.com>
Suggested-by: Huang Ying <ying.huang@linux.alibaba.com>
Cc: Huang Ying <huang.ying.caritas@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Bharata B Rao <bharata@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-pcp-increase-pcp-free_count-threshold-to-trigger-free_high
+++ a/mm/page_alloc.c
@@ -2669,7 +2669,7 @@ static void free_frozen_page_commit(stru
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

mm-pcp-increase-pcp-free_count-threshold-to-trigger-free_high.patch


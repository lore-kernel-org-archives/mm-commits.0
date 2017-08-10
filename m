From: akpm@linux-foundation.org
Subject: [patch 02/21] mm: ratelimit PFNs busy info message
Date: Thu, 10 Aug 2017 15:23:35 -0700
Message-ID: <598cdce7.LHSXG+5xTnmA5BYJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48178 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753089AbdHJWXg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2017 18:23:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jtoppins@redhat.com, dledford@redhat.com, hillf.zj@alibaba-inc.com, mgorman@techsingularity.net, mhocko@suse.com, stable@vger.kernel.org, vbabka@suse.cz

From: Jonathan Toppins <jtoppins@redhat.com>
Subject: mm: ratelimit PFNs busy info message

The RDMA subsystem can generate several thousand of these messages per
second eventually leading to a kernel crash.  Ratelimit these messages to
prevent this crash.

Doug said:

: I've been carrying a version of this for several kernel versions.  I don't
: remember when they started, but we have one (and only one) class of
: machines: Dell PE R730xd, that generate these errors.  When it happens,
: without a rate limit, we get rcu timeouts and kernel oopses.  With the
: rate limit, we just get a lot of annoying kernel messages but the machine
: continues on, recovers, and eventually the memory operations all succeed.

And:

: > Well...  why are all these EBUSY's occurring?  It sounds inefficient
: > (at least) but if it is expected, normal and unavoidable then perhaps we
: > should just remove that message altogether?
: 
: I don't have an answer to that question.  To be honest, I haven't
: looked real hard.  We never had this at all, then it started out of the
: blue, but only on our Dell 730xd machines (and it hits all of them),
: but no other classes or brands of machines.  And we have our 730xd
: machines loaded up with different brands and models of cards (for
: instance one dedicated to mlx4 hardware, one for qib, one for mlx5, an
: ocrdma/cxgb4 combo, etc), so the fact that it hit all of the machines
: meant it wasn't tied to any particular brand/model of RDMA hardware. 
: To me, it always smelled of a hardware oddity specific to maybe the
: CPUs or mainboard chipsets in these machines, so given that I'm not an
: mm expert anyway, I never chased it down.
: 
: A few other relevant details: it showed up somewhere around 4.8/4.9 or
: thereabouts.  It never happened before, but the prinkt has been there
: since the 3.18 days, so possibly the test to trigger this message was
: changed, or something else in the allocator changed such that the
: situation started happening on these machines?
: 
: And, like I said, it is specific to our 730xd machines (but they are
: all identical, so that could mean it's something like their specific
: ram configuration is causing the allocator to hit this on these machine
: but not on other machines in the cluster, I don't want to say it's
: necessarily the model of chipset or CPU, there are other bits of
: identicalness between these machines).

Link: http://lkml.kernel.org/r/499c0f6cc10d6eb829a67f2a4d75b4228a9b356e.1501695897.git.jtoppins@redhat.com
Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
Reviewed-by: Doug Ledford <dledford@redhat.com>
Tested-by: Doug Ledford <dledford@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-ratelimit-pfns-busy-info-message mm/page_alloc.c
--- a/mm/page_alloc.c~mm-ratelimit-pfns-busy-info-message
+++ a/mm/page_alloc.c
@@ -7669,7 +7669,7 @@ int alloc_contig_range(unsigned long sta
 
 	/* Make sure the range is really isolated. */
 	if (test_pages_isolated(outer_start, end, false)) {
-		pr_info("%s: [%lx, %lx) PFNs busy\n",
+		pr_info_ratelimited("%s: [%lx, %lx) PFNs busy\n",
 			__func__, outer_start, end);
 		ret = -EBUSY;
 		goto done;
_

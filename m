From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: +
 mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-only-in-direct-reclaim.patch
 added to -mm tree
Date: Mon, 29 Oct 2012 16:12:36 -0700
Message-ID: <20121029161236.a9c1210f.akpm@linux-foundation.org>
References: <20121015222313.B3DD6100047@wpzn3.hot.corp.google.com>
	<14005.1350400638@turing-police.cc.vt.edu>
	<31622.1350421487@turing-police.cc.vt.edu>
	<20121017104528.GH29125@suse.de>
	<508BCB5C.6010401@suse.cz>
	<20121028212215.GA3888@suse.de>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab2J2XMh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 19:12:37 -0400
In-Reply-To: <20121028212215.GA3888@suse.de>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Mel Gorman <mgorman@suse.de>
Cc: Jiri Slaby <jslaby@suse.cz>, Valdis.Kletnieks@vt.edu, mm-commits@vger.kernel.org, minchan@kernel.org, riel@redhat.com, "jirisl >> Jiri Slaby" <jirislaby@gmail.com>

On Sun, 28 Oct 2012 21:22:15 +0000
Mel Gorman <mgorman@suse.de> wrote:

> > Hi, this one breaks UML build:
> > In function ???is_thp_alloc???,
> >     inlined from ???__alloc_pages_slowpath??? at mm/page_alloc.c:2427:20,
> >     inlined from ???__alloc_pages_nodemask??? at mm/page_alloc.c:2645:8:
> > mm/page_alloc.c:2383:15: error: call to ???__build_bug_failed??? declared
> > with attribute error: BUILD_BUG failed
> > 
> > That arch does not support THP.
> > 
> 
> ---8<---
> mm: page_alloc: Do not wake kswapd if the request is for THP but deferred
>
> Since commit c6543459 (mm: remove __GFP_NO_KSWAPD), kswapd gets woken
> for every THP request in the slow path. If compaction has been deferred
> the waker will not compact or enter direct reclaim on its own behalf
> but kswapd is still woken to reclaim free pages that no one may consume.
> If compaction was deferred because pages and slab was not reclaimable
> then kswapd is just consuming cycles for no gain.
> 
> This patch avoids waking kswapd if the compaction has been deferred.
> It'll still wake when compaction is running to reduce the latency of
> THP allocations.

umwhat?  I'd struggling to see how this patch will fix the UML build.

> index bb90971..e72674c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2378,6 +2378,15 @@ bool gfp_pfmemalloc_allowed(gfp_t gfp_mask)
>  	return !!(gfp_to_alloc_flags(gfp_mask) & ALLOC_NO_WATERMARKS);
>  }
>  
> +/* Returns true if the allocation is likely for THP */

Comment is a bit awkward/ambiguous.  Perhaps "if this allocation is
probably asking for a THP hugepage".

And why the "likely"/"probably"?  Is it so hard to know for certain?


Anyway, I think I'll duck this patch under the assumption you pasted the
wrong thing into that email.


I currently have
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-only-in-direct-reclaim.patch
queued for 3.7, but on hold due to Valdis's bug report.

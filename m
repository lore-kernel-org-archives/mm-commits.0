Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9101494BF
	for <mm-commits@vger.kernel.org>; Sat, 12 Oct 2024 22:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728772506; cv=none; b=AMpHloCOFM+aRXR+mRiqU3iWEz3l7nWe4mTSx3TIgl7MwPou4xSAdD5adOk3IoBvhQ7lhsN7SS9ZhJDaIeHjctAmEmIeep0vfuJaL+AhHdbovHPjiUiAlUczjDP9KtBpctMmt1jpK93DJyktFL5CDddgr7Q/CaPhxa8cNXG5FXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728772506; c=relaxed/simple;
	bh=ZsB7uTr/gUjJfCxDI/BHtW48VS7xy31aME5n040Nhno=;
	h=Date:To:From:Subject:Message-Id; b=W5g+8+RCetAziu/8HNaHgYxbcbuOFWUoQiIWLHuOVwZhDpyE1KrX4Y8XT4SxFqn/pLz22tlX+KTd8IacDS17hpOt3he4mhNG5fPp/PWHf4npX1A8z5bz2qMFxwK/WGBoE/dsIz0c8IzWoPI/mbta+CnTOqDi7+7U7wEn2rBu5LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OwQD9ykS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OwQD9ykS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80446C4CEC6;
	Sat, 12 Oct 2024 22:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728772505;
	bh=ZsB7uTr/gUjJfCxDI/BHtW48VS7xy31aME5n040Nhno=;
	h=Date:To:From:Subject:From;
	b=OwQD9ykSOfLmU/C6PDXBLCMpSiF3pMHQ8ddg1jtbT2y6cbJL6/T4WQ3SaM0C4s9fG
	 +kuGMhcXHDPNPrca6L6Bd3EbLv6szr0NZ6r4H/PhaRaWq3OiwgNFKa4ooWlPX0MAyd
	 st24x4hIzSRdGMYe1V1oGnK+g0D9b4TIJolKonUA=
Date: Sat, 12 Oct 2024 15:35:04 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@kernel.org,mgorman@techsingularity.net,mfleming@cloudflare.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-let-gfp_atomic-order-0-allocs-access-highatomic-reserves.patch added to mm-unstable branch
Message-Id: <20241012223505.80446C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: let GFP_ATOMIC order-0 allocs access highatomic reserves
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-let-gfp_atomic-order-0-allocs-access-highatomic-reserves.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-let-gfp_atomic-order-0-allocs-access-highatomic-reserves.patch

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
From: Matt Fleming <mfleming@cloudflare.com>
Subject: mm/page_alloc: let GFP_ATOMIC order-0 allocs access highatomic reserves
Date: Fri, 11 Oct 2024 13:07:37 +0100

Under memory pressure it's possible for GFP_ATOMIC order-0 allocations to
fail even though free pages are available in the highatomic reserves. 
GFP_ATOMIC allocations cannot trigger unreserve_highatomic_pageblock()
since it's only run from reclaim.

Given that such allocations will pass the watermarks in
__zone_watermark_unusable_free(), it makes sense to fallback to highatomic
reserves the same way that ALLOC_OOM can.

This fixes order-0 page allocation failures observed on Cloudflare's
fleet when handling network packets:

  kswapd1: page allocation failure: order:0, mode:0x820(GFP_ATOMIC),
  nodemask=(null),cpuset=/,mems_allowed=0-7
  CPU: 10 PID: 696 Comm: kswapd1 Kdump: loaded Tainted: G           O 6.6.43-CUSTOM #1
  Hardware name: MACHINE
  Call Trace:
   <IRQ>
   dump_stack_lvl+0x3c/0x50
   warn_alloc+0x13a/0x1c0
   __alloc_pages_slowpath.constprop.0+0xc9d/0xd10
   __alloc_pages+0x327/0x340
   __napi_alloc_skb+0x16d/0x1f0
   bnxt_rx_page_skb+0x96/0x1b0 [bnxt_en]
   bnxt_rx_pkt+0x201/0x15e0 [bnxt_en]
   __bnxt_poll_work+0x156/0x2b0 [bnxt_en]
   bnxt_poll+0xd9/0x1c0 [bnxt_en]
   __napi_poll+0x2b/0x1b0
   bpf_trampoline_6442524138+0x7d/0x1000
   __napi_poll+0x5/0x1b0
   net_rx_action+0x342/0x740
   handle_softirqs+0xcf/0x2b0
   irq_exit_rcu+0x6c/0x90
   sysvec_apic_timer_interrupt+0x72/0x90
   </IRQ>

Link: https://lkml.kernel.org/r/20241011120737.3300370-1-matt@readmodwrite.com
Link: https://lore.kernel.org/all/CAGis_TWzSu=P7QJmjD58WWiu3zjMTVKSzdOwWE8ORaGytzWJwQ@mail.gmail.com/
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-let-gfp_atomic-order-0-allocs-access-highatomic-reserves
+++ a/mm/page_alloc.c
@@ -2898,7 +2898,7 @@ struct page *rmqueue_buddy(struct zone *
 			 * failing a high-order atomic allocation in the
 			 * future.
 			 */
-			if (!page && (alloc_flags & ALLOC_OOM))
+			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
 				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
 
 			if (!page) {
_

Patches currently in -mm which might be from mfleming@cloudflare.com are

mm-page_alloc-let-gfp_atomic-order-0-allocs-access-highatomic-reserves.patch


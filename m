Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3EC171E76;
	Thu, 24 Oct 2024 06:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729750520; cv=none; b=HU5U2NUElZ5KOKasuhusveMDYm3gN3ZdKHfseefCuO7eiAx1t3SQIYEqoeClI0iOKpV7L1XHA0FuX9qk9oC9J18EiV1csbt0F+2QnbxSm7A57Rnbuyescn6G9FV+lEyBhtpM11S0EBLh4lZeHiqcpfiDSwblS1b6b3IjQ7mcA5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729750520; c=relaxed/simple;
	bh=BwIMeHTaLRPxmdrQsFKwxeMiG0aGLP8hrg5vmWV1fcA=;
	h=Date:To:From:Subject:Message-Id; b=STVbXhsfJtC6hQlpOv7qfCVepGAFGOs+ZR4iiB2LsqhrCgV3q8iRCLSj2GqK+PNJo2aa9SjQq5bnhcqsfnI+a9rzemXNBc7f+MOZhPh7U9zJlF1nQPu9X6FgHwpi6xV+OiM8ZqmW5/ZT8r6Xz/kapsYuWF5jzL2Tr/KZk5rnIHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aaQ7VSAW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aaQ7VSAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57382C4CEC7;
	Thu, 24 Oct 2024 06:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729750520;
	bh=BwIMeHTaLRPxmdrQsFKwxeMiG0aGLP8hrg5vmWV1fcA=;
	h=Date:To:From:Subject:From;
	b=aaQ7VSAWE81OBZlmtaUAeOcw3gnqwHoygPn0nvo+LZk5i97SlxzNmcMd8S0zVFSLW
	 DDbR9zk1m25FzUA0WiftCnFpLjet/atLpydBCE5EugfwQvi66Nwebh6uozSKqirAIq
	 IBwu2TWJC62y2WG0wv5iuypUcCkTFlyj95lwGzsQ=
Date: Wed, 23 Oct 2024 23:15:19 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,mhocko@kernel.org,mgorman@techsingularity.net,mfleming@cloudflare.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_alloc-let-gfp_atomic-order-0-allocs-access-highatomic-reserves.patch removed from -mm tree
Message-Id: <20241024061520.57382C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: let GFP_ATOMIC order-0 allocs access highatomic reserves
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-let-gfp_atomic-order-0-allocs-access-highatomic-reserves.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

This fixes order-0 page allocation failures observed on Cloudflare's fleet
when handling network packets:

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

[mfleming@cloudflare.com: update comment]
  Link: https://lkml.kernel.org/r/20241015125158.3597702-1-matt@readmodwrite.com
Link: https://lkml.kernel.org/r/20241011120737.3300370-1-matt@readmodwrite.com
Link: https://lore.kernel.org/all/CAGis_TWzSu=P7QJmjD58WWiu3zjMTVKSzdOwWE8ORaGytzWJwQ@mail.gmail.com/
Fixes: 1d91df85f399 ("mm/page_alloc: handle a missing case for memalloc_nocma_{save/restore} APIs")
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-let-gfp_atomic-order-0-allocs-access-highatomic-reserves
+++ a/mm/page_alloc.c
@@ -2893,12 +2893,12 @@ struct page *rmqueue_buddy(struct zone *
 			page = __rmqueue(zone, order, migratetype, alloc_flags);
 
 			/*
-			 * If the allocation fails, allow OOM handling access
-			 * to HIGHATOMIC reserves as failing now is worse than
-			 * failing a high-order atomic allocation in the
-			 * future.
+			 * If the allocation fails, allow OOM handling and
+			 * order-0 (atomic) allocs access to HIGHATOMIC
+			 * reserves as failing now is worse than failing a
+			 * high-order atomic allocation in the future.
 			 */
-			if (!page && (alloc_flags & ALLOC_OOM))
+			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
 				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
 
 			if (!page) {
_

Patches currently in -mm which might be from mfleming@cloudflare.com are



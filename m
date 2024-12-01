Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7BB79FD;
	Sun,  1 Dec 2024 02:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733020878; cv=none; b=RbERQ4QaOEzhZEZB7PCo76Uy9B0+rPl1bKFxb9w5EMMq5Vwax9UF3dvOSCygzkzSS/imOr0HVQGxzxnhXek8S9yg1lzD5Dsxpr96ZB5XIUuEia7v+n3rxyRfwhXWjurb4k6AZJ6PFLSneXc3A6WexoER3H+wZJjqoc5+oR9ZlMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733020878; c=relaxed/simple;
	bh=9CY0YeXAbxlBIOer1kt14LCTkQ8Jq8XZyOUOp4GoUDU=;
	h=Date:To:From:Subject:Message-Id; b=ikpwuwtQtm9EiG4KKQzMP379FSsJxW36n8Id00P/Tvcjkkw1gTyyctuxSHu8Ujbp2rxMPkmVNpj+mJUcKq2RH/WaUxQYkzY/w1ZE/EFPt+CL/KSF4RBXUAJ/nYkvUFJaJDMAU2b/dUR54Dmmd+0OYldjM5hYnC5xkABK1O+oAfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c8dA1LhS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c8dA1LhS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79E8C4CECC;
	Sun,  1 Dec 2024 02:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733020877;
	bh=9CY0YeXAbxlBIOer1kt14LCTkQ8Jq8XZyOUOp4GoUDU=;
	h=Date:To:From:Subject:From;
	b=c8dA1LhS6FLbo1GQ8vOnSVENFKhgbZpY6w5wyPPfWlKirW6kiKBTH4fwjoB5AQsFW
	 yT5aIu5lxaKXj+wk7vxXH08kGrWZbhIbRxRErK8NoJAMjM0uLVObZr5Ggir9jN+FqO
	 CNw81h5a5Qs9dl8x1bh4mWAqnltQW5UNmvM82e+Q=
Date: Sat, 30 Nov 2024 18:41:17 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mgorman@techsingularity.net,snishika@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim.patch added to mm-hotfixes-unstable branch
Message-Id: <20241201024117.A79E8C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: account for free pages to prevent infinite Loop in throttle_direct_reclaim()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Seiji Nishikawa <snishika@redhat.com>
Subject: mm: vmscan: account for free pages to prevent infinite Loop in throttle_direct_reclaim()
Date: Sun, 1 Dec 2024 01:12:34 +0900

The kernel hangs due to a task stuck in throttle_direct_reclaim(), caused
by a node being incorrectly deemed balanced despite pressure in certain
zones, such as ZONE_NORMAL.  This issue arises from
zone_reclaimable_pages() returning 0 for zones without reclaimable file-
backed or anonymous pages, causing zones like ZONE_DMA32 with sufficient
free pages to be skipped.

The lack of swap or reclaimable pages results in ZONE_DMA32 being ignored
during reclaim, masking pressure in other zones.  Consequently,
pgdat->kswapd_failures remains 0 in balance_pgdat(), preventing fallback
mechanisms in allow_direct_reclaim() from being triggered, leading to an
infinite loop in throttle_direct_reclaim().

This patch modifies zone_reclaimable_pages() to account for free pages
(NR_FREE_PAGES) when no other reclaimable pages exist.  This ensures zones
with sufficient free pages are not skipped, enabling proper balancing and
reclaim behavior.

Link: https://lkml.kernel.org/r/20241130161236.433747-2-snishika@redhat.com
Signed-off-by: Seiji Nishikawa <snishika@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim
+++ a/mm/vmscan.c
@@ -374,7 +374,14 @@ unsigned long zone_reclaimable_pages(str
 	if (can_reclaim_anon_pages(NULL, zone_to_nid(zone), NULL))
 		nr += zone_page_state_snapshot(zone, NR_ZONE_INACTIVE_ANON) +
 			zone_page_state_snapshot(zone, NR_ZONE_ACTIVE_ANON);
-
+	/*
+	 * If there are no reclaimable file-backed or anonymous pages, 
+	 * ensure zones with sufficient free pages are not skipped. 
+	 * This prevents zones like DMA32 from being ignored in reclaim 
+	 * scenarios where they can still help alleviate memory pressure.
+	 */
+	if (nr == 0)
+	    nr = zone_page_state_snapshot(zone, NR_FREE_PAGES);
 	return nr;
 }
 
_

Patches currently in -mm which might be from snishika@redhat.com are

mm-vmscan-ensure-kswapd-is-woken-up-if-the-wait-queue-is-active.patch
mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim.patch


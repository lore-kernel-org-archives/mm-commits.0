Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F7119E98B;
	Thu,  6 Mar 2025 05:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239476; cv=none; b=eFSrLCW2iKSxYMaKgj8zwQPXF2RDjX3qk+Wc+f5qrJ7CVtD6mRkzDN/zFujpvxFIzckkl3jwUjO9wvJ2MnboLRskCNjk8BLe3F4qN2iIA5666sXPWsIdoGggqVp4Swp+/YDBtPHXSyW6Z+7CMxz7AUwPG+lzlto/gK4oFVSVjkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239476; c=relaxed/simple;
	bh=iBr+rfjfy6v6aHM+Xx+3YvVaBH/E0MbgeQihU6Zo7fY=;
	h=Date:To:From:Subject:Message-Id; b=nLD8r+R3R1Tj/71RED+wM12GcN4NBpuE6WebyqrDzgZXa36Fgo3dfoQpIll6kwqb9u7RT4tRpGGUsKeE2/tyUfrJwhepDrZBadGiwi8voUWrUmn8B94iJXxjWcKwyH4c9vjOCLXjX1ihM3WysXcmgnqrU0Zco5OK53nJAuk9RYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0DIpZBke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0DIpZBke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280FDC4CEE8;
	Thu,  6 Mar 2025 05:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239476;
	bh=iBr+rfjfy6v6aHM+Xx+3YvVaBH/E0MbgeQihU6Zo7fY=;
	h=Date:To:From:Subject:From;
	b=0DIpZBkens+fIoRkrcLUtMwWx57jvAIRZ9tg8PpAVvCzJ9aAMgyaLt7tg3YPZZKww
	 zXVI6Jajmf7G1jUbKPF99HiXBAd8IKIWvq0CndTRGftucNIFOeSYC0z6SWx0IjmHvU
	 J5tCNpC86HK2t4L2X1zI7RoVpejn3EUVMG8bxsYg=
Date: Wed, 05 Mar 2025 21:37:55 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,mhocko@suse.com,mgorman@suse.de,bhe@redhat.com,krisman@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-mm-page_allocc-dont-show-protection-in-zones-lowmem_reserve-for-empty-zone.patch removed from -mm tree
Message-Id: <20250306053756.280FDC4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "mm/page_alloc.c: don't show protection in zone's ->lowmem_reserve[] for empty zone"
has been removed from the -mm tree.  Its filename was
     revert-mm-page_allocc-dont-show-protection-in-zones-lowmem_reserve-for-empty-zone.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gabriel Krisman Bertazi <krisman@suse.de>
Subject: Revert "mm/page_alloc.c: don't show protection in zone's ->lowmem_reserve[] for empty zone"
Date: Tue, 25 Feb 2025 22:22:58 -0500

Commit 96a5c186efff ("mm/page_alloc.c: don't show protection in zone's
->lowmem_reserve[] for empty zone") removes the protection of lower zones
from allocations targeting memory-less high zones.  This had an unintended
impact on the pattern of reclaims because it makes the high-zone-targeted
allocation more likely to succeed in lower zones, which adds pressure to
said zones.  I.e, the following corresponding checks in
zone_watermark_ok/zone_watermark_fast are less likely to trigger:

        if (free_pages <= min + z->lowmem_reserve[highest_zoneidx])
                return false;

As a result, we are observing an increase in reclaim and kswapd scans, due
to the increased pressure.  This was initially observed as increased
latency in filesystem operations when benchmarking with fio on a machine
with some memory-less zones, but it has since been associated with
increased contention in locks related to memory reclaim.  By reverting
this patch, the original performance was recovered on that machine.

The original commit was introduced as a clarification of the
/proc/zoneinfo output, so it doesn't seem there are usecases depending on
it, making the revert a simple solution.

For reference, I collected vmstat with and without this patch on a freshly
booted system running intensive randread io from an nvme for 5 minutes.  I
got:

rpm-6.12.0-slfo.1.2 ->  pgscan_kswapd 5629543865
Patched             ->  pgscan_kswapd 33580844

33M scans is similar to what we had in kernels predating this patch. 
These numbers is fairly representative of the workload on this machine, as
measured in several runs.  So we are talking about a 2-order of magnitude
increase.

Link: https://lkml.kernel.org/r/20250226032258.234099-1-krisman@suse.de
Fixes: 96a5c186efff ("mm/page_alloc.c: don't show protection in zone's ->lowmem_reserve[] for empty zone")
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/page_alloc.c~revert-mm-page_allocc-dont-show-protection-in-zones-lowmem_reserve-for-empty-zone
+++ a/mm/page_alloc.c
@@ -5849,11 +5849,10 @@ static void setup_per_zone_lowmem_reserv
 
 			for (j = i + 1; j < MAX_NR_ZONES; j++) {
 				struct zone *upper_zone = &pgdat->node_zones[j];
-				bool empty = !zone_managed_pages(upper_zone);
 
 				managed_pages += zone_managed_pages(upper_zone);
 
-				if (clear || empty)
+				if (clear)
 					zone->lowmem_reserve[j] = 0;
 				else
 					zone->lowmem_reserve[j] = managed_pages / ratio;
_

Patches currently in -mm which might be from krisman@suse.de are



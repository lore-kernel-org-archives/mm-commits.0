Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2987279DCC
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 19:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766517864; cv=none; b=rX1dwzne+W28DCZ/joScoKjibXBrKb0BffxM4yZKE18XCAU1Hkpxkuxvj8BT7D4/vZWbjwy5tB4T3/RRF7U1OyMztfwyVog4y9SN/A0ELiYS9pxPOwmnEKQz0RVUHuvR6HWah6MasTuQ3/WibrW+kyi34vV/ZWf6DIWEcJvMIVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766517864; c=relaxed/simple;
	bh=nalSYlfr/fJz8/RlW4OTziW48R24tD7iMGLCxsHR/K4=;
	h=Date:To:From:Subject:Message-Id; b=Fs+I0gGlgSUSI6UVqxzsf13F3g4mv40BID34RkrJ3gRNMC1F4m66Kpc/gEHy90GQ6ggI4mbiSLcSJMVyB2oHCxagNrb71b/ZOjSR135ej/yIUQQlsH5t2Thg4tsW17dYziyULJDCBg6rQJT8ufGQcWyEzuB3ALmqvd9LEBipkcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TShS9enV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TShS9enV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879CAC113D0;
	Tue, 23 Dec 2025 19:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766517864;
	bh=nalSYlfr/fJz8/RlW4OTziW48R24tD7iMGLCxsHR/K4=;
	h=Date:To:From:Subject:From;
	b=TShS9enVwtBfr/VSEAONcdyTpWaW1hNT41TbGv595quq8s0FDveFVbSzlO2U75K11
	 4sjicgkdZrajPwk+4EFZJW+37tsSVH0UhhDjKMR1jzujSadHdqNOmeUv0l2ENbFoPu
	 /AgvEEFKIG9xWOs1xRpstGTiR0Puy7o9dD9g9Lsk=
Date: Tue, 23 Dec 2025 11:24:24 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,thehajime@gmail.com,surenb@google.com,sj@kernel.org,mhocko@suse.com,linux@roeck-us.net,jackmanb@google.com,hannes@cmpxchg.org,daniel@thingy.jp,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_alloc-report-1-as-zone_batchsize-for-config_mmu.patch removed from -mm tree
Message-Id: <20251223192424.879CAC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: report 1 as zone_batchsize for !CONFIG_MMU
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-report-1-as-zone_batchsize-for-config_mmu.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm/page_alloc: report 1 as zone_batchsize for !CONFIG_MMU
Date: Thu, 18 Dec 2025 00:31:59 -0800

Commit 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
moved the error handling (0-handling) of zone_batchsize from its callers
to inside the function.  However, the commit left out the error handling
for the NOMMU case, leading to deadlocks on NOMMU systems.

For NOMMU systems, return 1 instead of 0 for zone_batchsize, which
restores the previous deadlock-free behavior.

There is no functional difference expected with this patch before commit
2783088ef24e, other than the pr_debug in zone_pcp_init now printing out 1
instead of 0 for zones in NOMMU systems.  Not only is this a pr_debug, the
difference is purely semantic anyways.

Link: https://lkml.kernel.org/r/20251218083200.2435789-1-joshua.hahnjy@gmail.com
Fixes: 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reported-by: Daniel Palmer <daniel@thingy.jp>
Closes: https://lore.kernel.org/linux-mm/CAFr9PX=_HaM3_xPtTiBn5Gw5-0xcRpawpJ02NStfdr0khF2k7g@mail.gmail.com/
Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/all/42143500-c380-41fe-815c-696c17241506@roeck-us.net/
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Daniel Palmer <daniel@thingy.jp>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: SeongJae Park <sj@kernel.org>
Tested-by: Hajime Tazaki <thehajime@gmail.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-report-1-as-zone_batchsize-for-config_mmu
+++ a/mm/page_alloc.c
@@ -5924,7 +5924,7 @@ static int zone_batchsize(struct zone *z
 	 * recycled, this leads to the once large chunks of space being
 	 * fragmented and becoming unavailable for high-order allocations.
 	 */
-	return 0;
+	return 1;
 #endif
 }
 
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are



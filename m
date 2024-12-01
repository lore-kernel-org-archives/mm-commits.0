Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030FD23AB
	for <mm-commits@vger.kernel.org>; Sun,  1 Dec 2024 02:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733021135; cv=none; b=WPx5B60MjEO23SizZ4+5jTZPT7CU3rm+gtcT7C+ps0MRiC9CxYiiHTpFuqDYhiCiK84KRocAR+U1SHN6gDxD01hbz8Ur8IDvOpZELN5UfWZooa0VuQY+AUValon97V6Z8zYWv7cPMfUaLAxzuazC/Vzf7u8wECEgMbmR1npTuTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733021135; c=relaxed/simple;
	bh=vsrBcrwLXgnOkyl8LyfrHMvhun4IrIWx8Iln5tFRuPM=;
	h=Date:To:From:Subject:Message-Id; b=WbqB8jX9TFypt/9T3OhSM7cRB4QPgCjurUo04VB6D31BhdlweV4kjbmg0iHikhTxMqwNqLvNOdgCHcht5iOH1ZLZhXV3Vtc33jR9N0/ip+m1+eE1BuJDxM0MzWI9U3WTi2LfJWeuqiYYqekqDU9qncAAVfqYlfhRecMHNlWpMKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nyOmKSLl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nyOmKSLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A384C4CECC;
	Sun,  1 Dec 2024 02:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733021134;
	bh=vsrBcrwLXgnOkyl8LyfrHMvhun4IrIWx8Iln5tFRuPM=;
	h=Date:To:From:Subject:From;
	b=nyOmKSLlyCFYa/F8/QU49TCdkjdv/nBsJh7DBt7rURLW3/zGmc5c75wdgYxuCTsbf
	 UunPK/IU5978ntdbDxzryAZxMZ+Ceg6dKJmMVlGXHM4qMLHbsB1XYRDRixrWRuoNF2
	 jqOxm1sINjWKNuSyA38RNpDn91lyXcBISX/J5JGQ=
Date: Sat, 30 Nov 2024 18:45:33 -0800
To: mm-commits@vger.kernel.org,snishika@redhat.com,mgorman@techsingularity.net,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes.patch added to mm-hotfixes-unstable branch
Message-Id: <20241201024534.9A384C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes
Date: Sat Nov 30 06:44:24 PM PST 2024

ERROR: trailing whitespace
#40: FILE: mm/vmscan.c:378:
+^I * If there are no reclaimable file-backed or anonymous pages, $

ERROR: trailing whitespace
#41: FILE: mm/vmscan.c:379:
+^I * ensure zones with sufficient free pages are not skipped. $

ERROR: trailing whitespace
#42: FILE: mm/vmscan.c:380:
+^I * This prevents zones like DMA32 from being ignored in reclaim $

WARNING: suspect code indent for conditional statements (8, 12)
#45: FILE: mm/vmscan.c:383:
+	if (nr == 0)
+	    nr = zone_page_state_snapshot(zone, NR_FREE_PAGES);

total: 3 errors, 1 warnings, 15 lines checked

Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Seiji Nishikawa <snishika@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes
+++ a/mm/vmscan.c
@@ -375,13 +375,13 @@ unsigned long zone_reclaimable_pages(str
 		nr += zone_page_state_snapshot(zone, NR_ZONE_INACTIVE_ANON) +
 			zone_page_state_snapshot(zone, NR_ZONE_ACTIVE_ANON);
 	/*
-	 * If there are no reclaimable file-backed or anonymous pages, 
-	 * ensure zones with sufficient free pages are not skipped. 
-	 * This prevents zones like DMA32 from being ignored in reclaim 
+	 * If there are no reclaimable file-backed or anonymous pages,
+	 * ensure zones with sufficient free pages are not skipped.
+	 * This prevents zones like DMA32 from being ignored in reclaim
 	 * scenarios where they can still help alleviate memory pressure.
 	 */
 	if (nr == 0)
-	    nr = zone_page_state_snapshot(zone, NR_FREE_PAGES);
+		nr = zone_page_state_snapshot(zone, NR_FREE_PAGES);
 	return nr;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-proc-vmcorec-fix-warning-when-config_mmu=n.patch
mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm-fix.patch
mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes.patch
mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch


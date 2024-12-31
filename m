Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425DDFC0B
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 01:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735610104; cv=none; b=IwmValiSb9WN8ZhlXsZL3fyfnIbzo83zerIbBDfrmNt96nlQB2+8qNVBwIeWGSgJTnXnkUpA/FKJoafHCsqRM1f4UM6bDqqxoH94VUyODa+zbstWd5z+OqkwsdNTUNQiialIsAruRKw0SqBub+V3I8wyY6RR8Keu9gbnxNm5eeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735610104; c=relaxed/simple;
	bh=hPMvwy2E6A6JAZktsTZb8KD0yzsFhjHbSaSqawMtXws=;
	h=Date:To:From:Subject:Message-Id; b=RPisTFKgNhWjV8dJ/h8frpJz33qUPGd73/t+BqGnPDJH6uPI/C4KgiT/AqikY4n947bSGlaYlO+x/u/8tRqpXdgVRNeewlDAxa29GIJK8g0y+nbHKeLNQz4hYzXV6qYrF7h4kGOWmqOnqSxZ1Ugt2pqAyv+d2dt8lkvNpHKlrIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0WXPINo8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0WXPINo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16CCC4CED2;
	Tue, 31 Dec 2024 01:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735610103;
	bh=hPMvwy2E6A6JAZktsTZb8KD0yzsFhjHbSaSqawMtXws=;
	h=Date:To:From:Subject:From;
	b=0WXPINo848styb07JFietDquCsYOzOXL/K1do2va19fUmvvXa9ZMwiGqQ3qiNsmCA
	 vNCwiev9arNgeR7RwMigCoYRMfhiEUlj1BStlwtk/TUs6NFAUry+q+jienU6w12H1/
	 aqOW4vde58fHS1frSCubJ4BmVGmBSKGcZXavho0E=
Date: Mon, 30 Dec 2024 17:55:02 -0800
To: mm-commits@vger.kernel.org,snishika@redhat.com,mgorman@techsingularity.net,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20241231015503.A16CCC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim.patch

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

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes
+++ a/mm/vmscan.c
@@ -381,7 +381,7 @@ unsigned long zone_reclaimable_pages(str
 	 * scenarios where they can still help alleviate memory pressure.
 	 */
 	if (nr == 0)
-	    nr = zone_page_state_snapshot(zone, NR_FREE_PAGES);
+		nr = zone_page_state_snapshot(zone, NR_FREE_PAGES);
 	return nr;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim.patch
ocfs2-fix-slab-use-after-free-due-to-dangling-pointer-dqi_priv-checkpatch-fixes.patch
percpu-remove-intermediate-variable-in-percpu_ptr-fix.patch
mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
mm-huge_memoryc-rename-shadowed-local.patch
replace-free-hugepage-folios-after-migration-fix.patch
xarray-port-tests-to-kunit-fix.patch
fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch


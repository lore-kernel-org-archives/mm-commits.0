Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1057436E496
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 21:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769896675; cv=none; b=aoATKi7lbGFY/g7r2T39nHJZ7eJhTFXCsvHuUJ15Uq6pWkLVSM8c6ma9wnug8Iyj1uxccr7hVZnnel/udZgtozpn+uH03JK6NsrS7D0dmHB4k/1GUURikvHw4iL7ulHojpJFTbagCoI/6FLylk16c8IJ9kImuSUK2GPYinkJ0KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769896675; c=relaxed/simple;
	bh=2/mmmzdaBqQeJgohSBFLaNyUkOnOLt4tE+4tzbBI2J0=;
	h=Date:To:From:Subject:Message-Id; b=drmQ0STtPesuufQBmZoFVyWEfj+oCIN0YtsI8JcjlLjGYqxdf3+hProd/j6D/w93g2xoX2U9xHaagDGPiCE8Scx+NQDsECUc/UQCa/bTGURd2ea2mGg2tho8iT33wbXpbLPrv4S5eajUcWWipY+yokF7kcbEWYCFyHH/GGXeq/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IhQr9ixT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IhQr9ixT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EA0C4CEF1;
	Sat, 31 Jan 2026 21:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769896674;
	bh=2/mmmzdaBqQeJgohSBFLaNyUkOnOLt4tE+4tzbBI2J0=;
	h=Date:To:From:Subject:From;
	b=IhQr9ixTIbBdSP759bSNpd5IM5SPoAAAsblsdcykFW1x/FCudLREk+SRH75jBlO4u
	 YRFWqfe2U5r1rcWGZIUM6OHbL+dP++XGI26k5z8LE7op7aClhGw611+k81gCB2D5Vv
	 1zlnpMMgel/DOeLRobBPOGc9FoxBuoz0oH2mGbtg=
Date: Sat, 31 Jan 2026 13:57:53 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,rafael@kernel.org,nphamcs@gmail.com,kartikey406@gmail.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer-fix.patch removed from -mm tree
Message-Id: <20260131215754.87EA0C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer-fix
has been removed from the -mm tree.  Its filename was
     mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer-fix.patch

This patch was dropped because it was folded into mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer.patch

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer-fix
Date: Tue, 13 Jan 2026 02:33:36 +0800

fix cgroup v1 accounting issue

Syzbot, Deepanshu and Johannes helped found there is a problem with
Cgroup V1 accounting here:
https://lore.kernel.org/linux-mm/CAMgjq7CMsAMZZJL1=a=EtfWCOuDFE62RKR_0hUdPC4H+QF5GfQ@mail.gmail.com/

Syzbot have verified this fix:
https://lore.kernel.org/all/69653d31.050a0220.eaf7.00ca.GAE@google.com/

Link: https://lkml.kernel.org/r/CAMgjq7CGUnzOVG7uSaYjzw9wD7w2dSKOHprJfaEp4CcGLgE3iw@mail.gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer-fix
+++ a/mm/vmscan.c
@@ -757,8 +757,8 @@ static int __remove_mapping(struct addre
 
 		if (reclaimed && !mapping_exiting(mapping))
 			shadow = workingset_eviction(folio, target_memcg);
-		__swap_cache_del_folio(ci, folio, swap, shadow);
 		memcg1_swapout(folio, swap);
+		__swap_cache_del_folio(ci, folio, swap, shadow);
 		swap_cluster_unlock_irq(ci);
 	} else {
 		void (*free_folio)(struct folio *);
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-shmem-swap-fix-race-of-truncate-and-swap-entry-split.patch
mm-swap-rename-__read_swap_cache_async-to-swap_cache_alloc_folio.patch
mm-swap-split-swap-cache-preparation-loop-into-a-standalone-helper.patch
mm-swap-never-bypass-the-swap-cache-even-for-swp_synchronous_io.patch
mm-swap-always-try-to-free-swap-cache-for-swp_synchronous_io-devices.patch
mm-swap-simplify-the-code-and-reduce-indention.patch
mm-swap-free-the-swap-cache-after-folio-is-mapped.patch
mm-shmem-never-bypass-the-swap-cache-for-swp_synchronous_io.patch
mm-swap-swap-entry-of-a-bad-slot-should-not-be-considered-as-swapped-out.patch
mm-swap-consolidate-cluster-reclaim-and-usability-check.patch
mm-swap-split-locked-entry-duplicating-into-a-standalone-helper.patch
mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer.patch
mm-swap-remove-workaround-for-unsynchronized-swap-map-cache-state.patch
mm-swap-cleanup-swap-entry-management-workflow.patch
mm-swap-cleanup-swap-entry-management-workflow-fix.patch
mm-swap-add-folio-to-swap-cache-directly-on-allocation.patch
mm-swap-check-swap-table-directly-for-checking-cache.patch
mm-swap-clean-up-and-improve-swap-entries-freeing.patch
mm-swap-drop-the-swap_has_cache-flag.patch
mm-swap-remove-no-longer-needed-_swap_info_get.patch


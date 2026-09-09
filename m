Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A216635E1CE
	for <mm-commits@vger.kernel.org>; Wed,  9 Sep 2026 17:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788976214; cv=none; b=O6Bcm8X1IuUjHkI7/bpKN9k+lPUjxi/96vJvT1EyyUgLDtROs3rXaYHu7QkJoZtlJTS9ELdg9wKTBnTrGAnuEGO3O2ZR0sOY4gJ0GWZyvIyjqfHoVLRidcVEIz7Nq6yULXvZa/43YLugvDjzKCwfmKguR3GNjcGFmV2EVw7hMhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788976214; c=relaxed/simple;
	bh=kWItCEUrNJ9DPbugfl9UsDDoduT7HDaJblDcIbb7sxo=;
	h=Date:To:From:Subject:Message-Id; b=M4X+l5Ip2Z6RWY0UX/C2HRJSu49qbE0ew5D3y/0Jj4gu2x576fip7NAIUyJgSmYFT8mytFe74Kl/2p09XKBVtMz2WEloAtRWeXMr7H4oV/i4W72a5T2tz83RNRrON46f5zi7tgEPP7nvZN6Nz8bNuQQdnC65+PJFUM9gqIHqauo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ULdFipzW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ULdFipzW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DE51F000FF;
	Wed,  9 Sep 2026 17:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788976212;
	bh=D3Nv5UzPim7SCOs79ec0LG+btM1mEX3zIY54tbLcw20=;
	h=Date:To:From:Subject;
	b=ULdFipzWOBgw5ZwgJRVbvpYOUctJK2mZQxmB5FNs9jS58n1XSqOCQeDJNjvHc2VUl
	 U4IKgbluyQh8M8gfu+FQej0UCw8FO1stlsW52APtklnriAMqqs5qCjdtIl/KsgGZ1M
	 tIES8oHlaL3chW54AWp0WWLufui1Tf86uMutg0pQ=
Date: Wed, 09 Sep 2026 10:50:11 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-scan-by-cluster-in-find_next_to_unuse.patch added to mm-new branch
Message-Id: <20260909175012.20DE51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: scan by cluster in find_next_to_unuse()
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-scan-by-cluster-in-find_next_to_unuse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-scan-by-cluster-in-find_next_to_unuse.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Youngjun Park <youngjun.park@lge.com>
Subject: mm/swap: scan by cluster in find_next_to_unuse()
Date: Thu, 10 Sep 2026 01:15:52 +0900

find_next_to_unuse() walks every offset from 0 to si->max, and swapoff
restarts that walk on each retry, so the cost scales with the size of the
device rather than with the few slots the shmem and mmlist passes could
not free.  It has caused stalls before.

The flat walk predates the swap table.  Slot state now lives in a per
cluster table, and wait_for_allocation() stops all allocation before
try_to_unuse() runs, so a cluster that holds no slot in use stays that
way.  Skip such a cluster instead of reading all of its entries.

Fill a 1 TiB swap up to some amount, then swapoff.  What is left sits at
the top of what was filled, so every slot below it is free.  Medians over
11 pairs at 32 and 128 GiB, 3 pairs at 256 and 512.

	filled		swapoff
			old	new
	 32 GiB		 92.4ms	 66.3ms
	128 GiB		157.6ms	 94.4ms
	256 GiB		209.7ms	 63.8ms
	512 GiB		391.8ms	 73.4ms

old grows with how much was filled, new does not.

In the ordinary case swap still holds real data and swapoff spends its
time reading it back.  it is tested 4 GiB on an 8 GiB device, where the
scan is 1.4% of try_to_unuse(), and there is no difference either way.

Commit dc644a073769 ("mm: add three more cond_resched() in swapoff")
answered those stalls with a cond_resched() every 256 offsets.  A walk
bounded by one cluster no longer needs that counter.  The loop now runs at
most SWAPFILE_CLUSTER times before it returns or reschedules, the same
bound swap_reclaim_full_clusters() already scans between cond_resched()
calls.

The scan end is clamped to si->max, so the walk stops there rather than
running into the masked tail of the last cluster.

ci->count is read without ci->lock, so READ_ONCE() marks the read for
KCSAN.  Allocation is already stopped, so the count can only drop, and a
slot stops being counted only after its folio has left the swap cache.  An
empty cluster therefore holds nothing for try_to_unuse() to act on.

Link: https://lore.kernel.org/20260909161552.2335971-3-youngjun.park@lge.com
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)

--- a/mm/swapfile.c~mm-swap-scan-by-cluster-in-find_next_to_unuse
+++ a/mm/swapfile.c
@@ -370,8 +370,6 @@ static void discard_swap_cluster(struct
 	}
 }
 
-#define LATENCY_LIMIT		256
-
 static inline bool cluster_is_empty(struct swap_cluster_info *info)
 {
 	return info->count == 0;
@@ -2726,7 +2724,9 @@ unlock:
 static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 					unsigned int prev)
 {
-	unsigned int i;
+	struct swap_cluster_info *ci;
+	unsigned long i, end;
+	unsigned int ci_off;
 	unsigned long swp_tb;
 
 	/*
@@ -2735,19 +2735,36 @@ static unsigned int find_next_to_unuse(s
 	 * hits are okay, and sys_swapoff() has already prevented new
 	 * allocations from this area (while holding swap_lock).
 	 */
-	for (i = prev + 1; i < si->max; i++) {
-		swp_tb = swap_table_get(__swap_offset_to_cluster(si, i),
-					i % SWAPFILE_CLUSTER);
-		if (!swp_tb_is_null(swp_tb) && !swp_tb_is_bad(swp_tb))
-			break;
-		if ((i % LATENCY_LIMIT) == 0)
+	i = prev + 1;
+	while (i < si->max) {
+		ci = __swap_offset_to_cluster(si, i);
+		end = min_t(unsigned long,
+			    ALIGN_DOWN(i, SWAPFILE_CLUSTER) + SWAPFILE_CLUSTER,
+			    si->max);
+
+		/*
+		 * An empty cluster has no slot in use, so skip it whole.
+		 * A slot is uncounted only after its folio left the swap
+		 * cache, so there is nothing here for try_to_unuse() to act on.
+		 * Count only drops here, so a READ_ONCE() without ci->lock is
+		 * enough, unlike in every other cluster_is_empty() caller.
+		 */
+		if (!READ_ONCE(ci->count)) {
+			i = end;
 			cond_resched();
-	}
+			continue;
+		}
 
-	if (i == si->max)
-		i = 0;
+		ci_off = i % SWAPFILE_CLUSTER;
+		for (; i < end; ci_off++, i++) {
+			swp_tb = swap_table_get(ci, ci_off);
+			if (!swp_tb_is_null(swp_tb) && !swp_tb_is_bad(swp_tb))
+				return i;
+		}
+		cond_resched();
+	}
 
-	return i;
+	return 0;
 }
 
 static int try_to_unuse(unsigned int type)
_

Patches currently in -mm which might be from youngjun.park@lge.com are

mm-swap-fix-stale-comment-on-swap_info_struct-cluster_info.patch
mm-swap-scan-by-cluster-in-find_next_to_unuse.patch


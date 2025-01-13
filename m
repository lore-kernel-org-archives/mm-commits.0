Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E230D4315A;
	Mon, 13 Jan 2025 03:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736737466; cv=none; b=cUgj2wsYM/qu7U+MuKQ/ql5tIXjY8y6lQVf7bqIL9f8JMcBsXIKls5dFa8z8kSv3wMFpYm3glf/iSiYE23f9/Erate3GQ7lJrUXn3t6R+7rRkGSK2go0DGQ0c+OHYKHu17NBbOr5KWkIDXkGX3ZhLJE8WpOZgBs/YDuasMIP2PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736737466; c=relaxed/simple;
	bh=bMuMCBt4X0fu92Lq8l+OIrlFdC7Hsh92apBRQzATdk4=;
	h=Date:To:From:Subject:Message-Id; b=m2n5+FNZ2StUP98mkckXJ0T5qvYTZyyGKsAhbuamWbyBOaVCWzj9g6x8tdnxlHbl6LwewZSQw/PnYXgEYl2O9fjyDCX9idHXH45Wr4Ral66ka0yeFL/3td6iL6klir3xh9WFFg7jdzWvpLJtsTYS67tbS8kNbIRcI+ICFrAa/3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NwOr+knO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NwOr+knO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7576C4CEDF;
	Mon, 13 Jan 2025 03:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736737465;
	bh=bMuMCBt4X0fu92Lq8l+OIrlFdC7Hsh92apBRQzATdk4=;
	h=Date:To:From:Subject:From;
	b=NwOr+knOkVXxAimFA+STTzMu2sgEK+Cmh3Mi7D3bMe/9Q6O0CgiLYH5ANQpwmYxPx
	 CWyIBNSDbrLNQ1wbf9E0weY63LnuHlWCg1WkO2vbL5whqD1uHjsk6eno6wi4MA3Y1B
	 gFOvH7h6R0aXAKdZubblUxNlrnu/iUXLJl8ka/7Q=
Date: Sun, 12 Jan 2025 19:04:25 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,weixugc@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,ritesh.list@gmail.com,rientjes@google.com,muchun.song@linux.dev,mhocko@kernel.org,lizhijian@fujitsu.com,kaiyang2@cs.cmu.edu,hannes@cmpxchg.org,aneesh.kumar@kernel.org,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmscan-pgdemote-vmstat-is-not-getting-updated-when-mglru-is-enabled.patch removed from -mm tree
Message-Id: <20250113030425.B7576C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan : pgdemote vmstat is not getting updated when MGLRU is enabled.
has been removed from the -mm tree.  Its filename was
     mm-vmscan-pgdemote-vmstat-is-not-getting-updated-when-mglru-is-enabled.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Donet Tom <donettom@linux.ibm.com>
Subject: mm: vmscan : pgdemote vmstat is not getting updated when MGLRU is enabled.
Date: Thu, 9 Jan 2025 00:05:39 -0600

When MGLRU is enabled, the pgdemote_kswapd, pgdemote_direct, and
pgdemote_khugepaged stats in vmstat are not being updated.

Commit f77f0c751478 ("mm,memcg: provide per-cgroup counters for NUMA
balancing operations") moved the pgdemote vmstat update from
demote_folio_list() to shrink_inactive_list(), which is in the normal LRU
path.  As a result, the pgdemote stats are updated correctly for the
normal LRU but not for MGLRU.

To address this, we have added the pgdemote stat update in the
evict_folios() function, which is in the MGLRU path.  With this patch, the
pgdemote stats will now be updated correctly when MGLRU is enabled.

Without this patch vmstat output when MGLRU is enabled
======================================================
pgdemote_kswapd 0
pgdemote_direct 0
pgdemote_khugepaged 0

With this patch vmstat output when MGLRU is enabled
===================================================
pgdemote_kswapd 43234
pgdemote_direct 4691
pgdemote_khugepaged 0

Link: https://lkml.kernel.org/r/20250109060540.451261-1-donettom@linux.ibm.com
Fixes: f77f0c751478 ("mm,memcg: provide per-cgroup counters for NUMA balancing operations")
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Acked-by: Yu Zhao <yuzhao@google.com>
Tested-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Li Zhijian <lizhijian@fujitsu.com>
Cc: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/vmscan.c~mm-vmscan-pgdemote-vmstat-is-not-getting-updated-when-mglru-is-enabled
+++ a/mm/vmscan.c
@@ -4642,6 +4642,9 @@ retry:
 		reset_batch_size(walk);
 	}
 
+	__mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(),
+					stat.nr_demoted);
+
 	item = PGSTEAL_KSWAPD + reclaimer_offset();
 	if (!cgroup_reclaim(sc))
 		__count_vm_events(item, reclaimed);
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

mm-migrate-removed-unused-argument-vma-from-migrate_misplaced_folio.patch
selftests-mm-added-new-test-cases-to-the-migration-test.patch


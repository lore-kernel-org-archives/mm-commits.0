Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F273161BE
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498764; cv=none; b=qtxoqOqoL+uF/fKAhpdPHpsNknsxnV5VYLiW4gPsGih2KtM9rKa6HI5lTRysKJf58SLhCwaIkn1IaIEYEP3lr2pKZROqymoFjFRfFub2R8OfcMwpF506xhksT8VJNwG/QTmPE53fH7zZM9Z9rAeHln4ExYotfflWC/MMuA4ejhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498764; c=relaxed/simple;
	bh=iMWmYGowS4I+ySEpGkJQ27H+kuIPvl3D0KWnMyhN64U=;
	h=Date:To:From:Subject:Message-Id; b=HefVG+e4c1X+s2b10hb9iEpVbrSf233Fq5H1nwGr9nENgewW7uLQl10hsqSUMGXYbJaPuNAmlhbL7SMhA+Rtnrqu5rdUgBtbMJtUJe1OfBraX3l8m3/Ckj4mffNFrh/mfTi5jA2nAHqbKPp7MdwMHQ/gfcRRzHn8mSWzuLZ9NNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tSC1yns1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tSC1yns1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4506C19424;
	Sat, 18 Apr 2026 07:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498763;
	bh=iMWmYGowS4I+ySEpGkJQ27H+kuIPvl3D0KWnMyhN64U=;
	h=Date:To:From:Subject:From;
	b=tSC1yns1/t0Y4A59nyOJFXFnnxKUueFi5mJX7OwWVMrPxqueLY50Um3bUxRp5GLJE
	 QpedsfyOS9C3V5b1v78QqBCkM8OLFp1jPU2s+NQLXKqc6vGaiXAxRChTEwfkxyNYx7
	 l+dwSIyr9zCyZYjGhNvP/geGx/2qBY8iAZVTyA04=
Date: Sat, 18 Apr 2026 00:52:37 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-fix-dirty-folios-throttling-on-cgroup-v1-for-mglru.patch removed from -mm tree
Message-Id: <20260418075242.C4506C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: fix dirty folios throttling on cgroup v1 for MGLRU
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-dirty-folios-throttling-on-cgroup-v1-for-mglru.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: vmscan: fix dirty folios throttling on cgroup v1 for MGLRU
Date: Fri, 27 Mar 2026 18:21:08 +0800

The balance_dirty_pages() won't do the dirty folios throttling on
cgroupv1.  See commit 9badce000e2c ("cgroup, writeback: don't enable
cgroup writeback on traditional hierarchies").

Moreover, after commit 6b0dfabb3555 ("fs: Remove aops->writepage"), we no
longer attempt to write back filesystem folios through reclaim.

On large memory systems, the flusher may not be able to write back quickly
enough.  Consequently, MGLRU will encounter many folios that are already
under writeback.  Since we cannot reclaim these dirty folios, the system
may run out of memory and trigger the OOM killer.

Hence, for cgroup v1, let's throttle reclaim after waking up the flusher,
which is similar to commit 81a70c21d917 ("mm/cgroup/reclaim: fix dirty
pages throttling on cgroup v1"), to avoid unnecessary OOM.

The following test program can easily reproduce the OOM issue.  With this
patch applied, the test passes successfully.

$mkdir /sys/fs/cgroup/memory/test
$echo 256M > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
$echo $$ > /sys/fs/cgroup/memory/test/cgroup.procs
$dd if=/dev/zero of=/mnt/data.bin bs=1M count=800

Link: https://lore.kernel.org/3445af0f09e8ca945492e052e82594f8c4f2e2f6.1774606060.git.baolin.wang@linux.alibaba.com
Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-fix-dirty-folios-throttling-on-cgroup-v1-for-mglru
+++ a/mm/vmscan.c
@@ -5027,9 +5027,24 @@ static bool try_to_shrink_lruvec(struct
 	 * If too many file cache in the coldest generation can't be evicted
 	 * due to being dirty, wake up the flusher.
 	 */
-	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken)
+	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken) {
+		struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+
 		wakeup_flusher_threads(WB_REASON_VMSCAN);
 
+		/*
+		 * For cgroupv1 dirty throttling is achieved by waking up
+		 * the kernel flusher here and later waiting on folios
+		 * which are in writeback to finish (see shrink_folio_list()).
+		 *
+		 * Flusher may not be able to issue writeback quickly
+		 * enough for cgroupv1 writeback throttling to work
+		 * on a large system.
+		 */
+		if (!writeback_throttling_sane(sc))
+			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
+	}
+
 	/* whether this lruvec should be rotated */
 	return nr_to_scan < 0;
 }
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are



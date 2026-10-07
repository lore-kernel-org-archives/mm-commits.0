Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303C72D0629
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334143; cv=none; b=O22EbAPQYpNg8kWYZu8wgkz9pBsOOslOSNreGbCIqgw/SFHgFUFEnXc0BTJyntsCHtLY+1t0D3BYtk2kkQAgC3gjuTy1QrEmdKx8iCW5IRzmPH26A0xyBymyHznDiJRT3QHFwVIHIfJ7jlqHqcdALQu4SSLfmFUx1JQ7GTxB5fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334143; c=relaxed/simple;
	bh=Eyte1+S3Etj6NQFqvDZkyYRZTn6HY0E8Qx/IhrUcvLc=;
	h=Date:To:From:Subject:Message-Id; b=Esm+LMnqqe08ezHct7N+FJcw7Q1G+bq35B343QWL5MI6pvGxIAaQap7zyzSO+DDw7eduofjhZkZZRnCUxdIhjmSzcMq8T5JKFOVgPst3EbxstS0vxSiE8+4u27Wm92v+dzTgV4uHm6usT9WoxUkv6kLSdr1TufjIdce7r/25wvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TdellIVX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TdellIVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3E51F0089C;
	Wed,  7 Oct 2026 00:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334142;
	bh=D4LlSP+Ok5F7280E+aix/VRUJ7lBFs90eHmX2ubcJU0=;
	h=Date:To:From:Subject;
	b=TdellIVX5myot55ZuPjXHWvGGRN5ae9FW5Bjnd0+gMocZJMwuXP7j63xBdJZkXvu5
	 VVfWWNJiedECOJOtsSoH9WBvrwIMOKMr6LGYlh/J+Fxi/2hS0S4oBHn1fnVvBtSWLl
	 31hC4cRWoqI9ZeB+nkPE7W+WLMyYlP95jyNiHzQA=
Date: Tue, 06 Oct 2026 17:49:01 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,mhocko@suse.com,gourry@gourry.net,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-remove-unused-memcg-parameter-in-calculate_high_delay.patch removed from -mm tree
Message-Id: <20261007004902.0C3E51F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memcontrol: remove unused memcg parameter in calculate_high_delay()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-remove-unused-memcg-parameter-in-calculate_high_delay.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: mm/memcontrol: remove unused memcg parameter in calculate_high_delay()
Date: Tue, 25 Aug 2026 20:01:53 +0800

The memcg argument of calculate_high_delay() is never referenced in its
function body.  The delay calculation only depends on nr_pages and
max_overage, and both callers have already obtained max_overage from the
same memcg.

Drop this unused parameter and update the two call sites inside
__mem_cgroup_handle_over_high().

Link: https://lore.kernel.org/20260825120153.1405-1-hongfu.li@linux.dev
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---

 mm/memcontrol.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-remove-unused-memcg-parameter-in-calculate_high_delay
+++ a/mm/memcontrol.c
@@ -2515,8 +2515,7 @@ static u64 swap_find_max_overage(struct
  * Get the number of jiffies that we should penalise a mischievous cgroup which
  * is exceeding its memory.high by checking both it and its ancestors.
  */
-static unsigned long calculate_high_delay(struct mem_cgroup *memcg,
-					  unsigned int nr_pages,
+static unsigned long calculate_high_delay(unsigned int nr_pages,
 					  u64 max_overage)
 {
 	unsigned long penalty_jiffies;
@@ -2594,10 +2593,10 @@ retry_reclaim:
 	 * memory.high is breached and reclaim is unable to keep up. Throttle
 	 * allocators proactively to slow down excessive growth.
 	 */
-	penalty_jiffies = calculate_high_delay(memcg, nr_pages,
+	penalty_jiffies = calculate_high_delay(nr_pages,
 					       mem_find_max_overage(memcg));
 
-	penalty_jiffies += calculate_high_delay(memcg, nr_pages,
+	penalty_jiffies += calculate_high_delay(nr_pages,
 						swap_find_max_overage(memcg));
 
 	/*
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-page_owner-preserve-original-free_pid-free_tgid-during-folio-migration.patch
mm-memfd-fix-hugetlb-reservation-accounting-in-error-paths.patch
selftests-mm-fix-ptrace-peekdata-check-in-memfd_secret-test.patch
mm-hugetlb_cgroup-move-per-node-usage-on-cross-node-migration.patch
mm-hugetlb_cgroup-move-per-node-usage-on-cgroup-reparenting.patch
mm-hugetlb-account-migration-target-folio-in-per-node-nr_hugetlb-vmstat.patch
mm-memcg-migrate-per-node-hugetlb-lruvec-stat-together-with-hugetlb-folio.patch


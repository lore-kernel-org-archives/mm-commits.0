Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A324E50A9;
	Thu, 17 Sep 2026 06:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789625038; cv=none; b=jpuChfTv6JdifCBo9YiTRZ367lii+1usjCwa+uG+k3EYNLGczSaKCrQBg3/ihH2q6ObNvuy+Su+H4OwJYLwnEAwei0ZOvx3j/ZdrJaFYvBzoKap0rN0Z/FIZXqdTU313/yJnBYa/n5ftAXNU/7AbeNwIggWZvPVVXienrw4lqzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789625038; c=relaxed/simple;
	bh=cnosAD03e47jeYbppoNb2dNXP0R5nCJWNP/PMfptQHQ=;
	h=Date:To:From:Subject:Message-Id; b=m3WiiflwifVxdjCEZuZ4nJoxlBN0r+fEz+OuHGAecBx9ySEepXclI57cKtum5rAvOGAdlV8ga11wUV8qCEPQRqK9iw5Kr+kxs14v5jvVYGkRJu40xCX8nXJ0///VlRioLNtH7+qCprcPzDwN3KJm/DwHR5aDLDAoGD0Hluj9qME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p2ERiXeM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p2ERiXeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B02F1F000FF;
	Thu, 17 Sep 2026 06:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789625037;
	bh=9vUq67gPflbhCG+gc8TuhSf79dGgLmsq+B5uMM0m6EY=;
	h=Date:To:From:Subject;
	b=p2ERiXeM5m0XlZCuLb3SLpLDz3I2Dwp1LCrE8dUiVgVYnLCayfyvwadEhJIHuULJS
	 BFm0uTgWvGs/5GRm6kdHjI+h3rq/OpsNY7WfZ7FrnbqkTVt+WTlah1nsaeAKQjdJ47
	 YbIJYHJk+caNxvHgwBwc16xKIKABEisikmk5OQpo=
Date: Wed, 16 Sep 2026 23:03:56 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,arnd@arndb.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-vmscanc-fix-min-signedness-mismatch.patch removed from -mm tree
Message-Id: <20260917060357.1B02F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan.c: fix min() signedness mismatch
has been removed from the -mm tree.  Its filename was
     mm-vmscanc-fix-min-signedness-mismatch.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/vmscan.c: fix min() signedness mismatch
Date: Wed Sep 16 04:21:22 PM PDT 2026

A __noipa conversion from Arnd [1] somehow revealed a longstanding min()
error in read_ctrl_pos().  Plug it with min_t().

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscanc-fix-min-signedness-mismatch
+++ a/mm/vmscan.c
@@ -3205,7 +3205,7 @@ static void read_ctrl_pos(struct lruvec
 	pos->gain = gain;
 	pos->refaulted = pos->total = 0;
 
-	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
+	for (i = tier % MAX_NR_TIERS; i <= min_t(unsigned int, tier, MAX_NR_TIERS - 1); i++) {
 		pos->refaulted += lrugen->avg_refaulted[type][i] +
 				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
 		pos->total += lrugen->avg_total[type][i] +
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplug-factor-out-node_is_memoryless-fix.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch


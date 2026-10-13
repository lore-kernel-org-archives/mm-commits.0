Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC6D483818
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865970; cv=none; b=vE3dX6zgkb0CLb1OFhNU5n+Wmps5xx53cjLvv+UXNz47X2oYoQWytYFmDCkrabw23wwwuDc/+EzlrBWqvKeduFJtmge56l3ZSzrpIAgQ8La7+8WXmDQvyB4PmqB7BKFrrdTtiDVPLJW12b8zWcoyJ4BYZ8DFlh9mWLQR09k5Llo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865970; c=relaxed/simple;
	bh=O+c86KBCIpcmHoOPuui80ObKYgipmB+kF2grc15B61o=;
	h=Date:To:From:Subject:Message-Id; b=YE3XdFs2UIUFKEldPNMzSjZ9qIKipf1JyOI4IZXl4YkpCmZ36zbUa7QgH5987gbiZScnHq24Jg2SX8aeMbEYe2reDRsA3tVE9b9aO5l0gI/Ft4rnJ3twfMI1HUbh4ztPNdCWjEvbvQzEmQFShVfZk7r2Sm/tD925KTJhfS/FCgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TljrCjNj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TljrCjNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4A41F000FF;
	Tue, 13 Oct 2026 04:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865969;
	bh=e4sBhHjPU8T1W4knilv5ok5r/50bQgceq/m6TmqqGKk=;
	h=Date:To:From:Subject;
	b=TljrCjNjs9zR2iAvl0HeauuodBoJ8/+p7aYhmSPe5EsThmsW3XdMz0tXwIyz0b6vi
	 Ugta4JyA9o6crhSmdimGsa8AlamaLq/PQCVnmb1SRvbBzQ27GX7Wv2cAIhqrO/374w
	 Y6RhWtxRLen4ws9CynaPCb/26d8Mc5NSu1qzRQ2c=
Date: Mon, 12 Oct 2026 21:32:48 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gutierrez.asier@huawei-partners.com,david@kernel.org,davidgow@davidgow.net,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-use-mult_frac-in-damon_feed_loop_next_input.patch removed from -mm tree
Message-Id: <20261013043249.2F4A41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: use mult_frac() in damon_feed_loop_next_input()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-use-mult_frac-in-damon_feed_loop_next_input.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: use mult_frac() in damon_feed_loop_next_input()
Date: Thu, 17 Sep 2026 07:22:01 -0700

damon_feed_loop_next_input() does its best effort overflow protection.
score_goal_diff is always smaller than goal (10,000).  Hence the
calculation can be replaced to use mult_frac() without concerning the
overflow.  Use mult_frac().

Link: https://lore.kernel.org/20260917142210.90829-4-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/damon/core.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-use-mult_frac-in-damon_feed_loop_next_input
+++ a/mm/damon/core.c
@@ -2927,11 +2927,7 @@ static unsigned long damon_feed_loop_nex
 		return min_input;
 
 	score_goal_diff = abs_diff(score, goal);
-
-	if (last_input < ULONG_MAX / score_goal_diff)
-		compensation = last_input * score_goal_diff / goal;
-	else
-		compensation = last_input / goal * score_goal_diff;
+	compensation = mult_frac(last_input, score_goal_diff, goal);
 
 	if (over_achieving)
 		return max(last_input - compensation, min_input);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch


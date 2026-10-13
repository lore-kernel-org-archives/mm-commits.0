Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C50391838
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865970; cv=none; b=kSphTmzjpxIRzMnkzoPTenI4EpayBN8gMCtXkyalj6lzj7g/zEE4MNYEA2QSnD8by/RR9g5nJcAp9Js3b1Zvs2cATxRUp2Xgcxf9vqDcpZZJwSP2YHUA7mA+QhAEiew0v2PxZBEkrV64zo8VdmLiQnfWrVe2L2iVlB8LUwxWj+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865970; c=relaxed/simple;
	bh=gOg8ME7zrlis8ms2navzdUCxbG6gnjAN7DOzWA/+ukI=;
	h=Date:To:From:Subject:Message-Id; b=YNkQP4jMouZQT5FcJjDourSK6hR76DrJdZbxKNVop9HI9xKP9zdidjw3c/nkGNtSxhMyI1tmSc4UIqr/kUou182dLDPE00+u6r5mshb4M6O6PBweRYNKc1EYReWLVRlLyS5NLAXnfuGX3bTjIF35I8oNYj55eSE5rKyA2e4d5Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xnEfL53W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xnEfL53W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228061F00893;
	Tue, 13 Oct 2026 04:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865968;
	bh=X6/mhIJ68EGOACHNzsXNX1ARNOFL26IHGrTeeiOg/sE=;
	h=Date:To:From:Subject;
	b=xnEfL53WjJBeco7QJjTa4TbJzIFyXQSzDhnOgXXb3LSREZTbXirwSmfTe9xNd1hfl
	 y92DZXIQKRXDliL4oHWrFh8GTYpELXyitVMTkNXUJ4vZflO9kYffvPnlHYq8uEKFv/
	 AJPA3IbTve8/Cz2qIvBatDo0AdmrLNWsLa38bbHw=
Date: Mon, 12 Oct 2026 21:32:47 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gutierrez.asier@huawei-partners.com,david@kernel.org,davidgow@davidgow.net,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-use-abs_diff-in-damon_feed_loop_next_input.patch removed from -mm tree
Message-Id: <20261013043248.228061F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: use abs_diff() in damon_feed_loop_next_input()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-use-abs_diff-in-damon_feed_loop_next_input.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: use abs_diff() in damon_feed_loop_next_input()
Date: Thu, 17 Sep 2026 07:22:00 -0700

damon_feed_loop_next_input() is open-coding absolute diff calculation
instead of the dedicated helper, abs_diff(), for no good reason.  Use
the dedicated helper.

Link: https://lore.kernel.org/20260917142210.90829-3-sj@kernel.org
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

 mm/damon/core.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-use-abs_diff-in-damon_feed_loop_next_input
+++ a/mm/damon/core.c
@@ -2926,10 +2926,7 @@ static unsigned long damon_feed_loop_nex
 	if (score >= goal * 2)
 		return min_input;
 
-	if (over_achieving)
-		score_goal_diff = score - goal;
-	else
-		score_goal_diff = goal - score;
+	score_goal_diff = abs_diff(score, goal);
 
 	if (last_input < ULONG_MAX / score_goal_diff)
 		compensation = last_input * score_goal_diff / goal;
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


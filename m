Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A3E3AF665
	for <mm-commits@vger.kernel.org>; Tue, 29 Sep 2026 20:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790714970; cv=none; b=M6Q3Tkh9V/i8hvO1L49xiJd6r0Tvi6Q9/JEVr5hNIr/y7yuxY+ipJTXUTiXSaYKf/sdaQxlmRhtXsLi/XVQyFJNVLyEbUhq1OkXQNQWSPDy+B5egNM8c0qdXY7ntCt84mn0jKzICqU6ZNQ/37xq5XelVhS4CI8VGK50OFHF4N3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790714970; c=relaxed/simple;
	bh=s791JDwCoNVbF6JLfjTncfeeMGCzB/FtV9vuESzrmE8=;
	h=Date:To:From:Subject:Message-Id; b=PQ41+mkd01aBPJhcEYX6xIcpg2H/oes2fuwd712Ihot3RSB4fWvFU1v0W3ZrAjwcgyYhPobJUWj4bYZra4uOvCWsG6+AVq7q4YaEaIq8oJ4FA5ns/cu/IKoE1TqvkXfkxG5iWYFMRmZng9dkYj/lICNpt90Ofs2CokEUjKMjloM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BKPfMqrW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BKPfMqrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFEC1F000FF;
	Tue, 29 Sep 2026 20:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790714969;
	bh=ZzPPij5oABiNyQBc09+UyhrqP9HQwbaseX8/MM2bcBw=;
	h=Date:To:From:Subject;
	b=BKPfMqrWydkRfjNkZWASp5tsjR6dFGhIFTBek9lyRzKdzsaDyp1J2DT3+o6qrevr2
	 JUEvFa0EuX/V/Vwj/gH7Nuhxw1ZZ6nML9ptUXQ7tyn+pSGitgtvZnQwuTe00CHSzfo
	 0KxF3Kzqj317i/NEt3KlWKuaJdezLUxWv9CJwquE=
Date: Tue, 29 Sep 2026 13:49:28 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,gutierrez.asier@huawei-partners.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-introduce-damos_quota_goal-complement-fix.patch added to mm-new branch
Message-Id: <20260929204929.0BFEC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-damon-core-introduce-damos_quota_goal-complement-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-introduce-damos_quota_goal-complement-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-introduce-damos_quota_goal-complement-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-damon-core-introduce-damos_quota_goal-complement-fix
Date: Tue Sep 29 01:47:25 PM PDT 2026

fix comment tpyo, per Gutierrez

Cc: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-introduce-damos_quota_goal-complement-fix
+++ a/mm/damon/core.c
@@ -3267,7 +3267,7 @@ static void damos_set_quota_goal_current
 	if (!goal->complement)
 		return;
 
-	/* updte current_value to complemented value */
+	/* update current_value to complemented value */
 
 	/* for user_input, users set complemented value on their own */
 	if (goal->metric == DAMOS_QUOTA_USER_INPUT)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplug-factor-out-node_is_memoryless-fix.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix-fix.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma-fix.patch
mm-selftests-add-shmem-into-memory-failure-test-fix.patch
proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch
mm-damon-core-introduce-damos_quota_goal-complement-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch


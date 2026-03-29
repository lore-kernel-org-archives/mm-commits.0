Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F6C25B2FA
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744872; cv=none; b=jQs7+q+yPsHUv0LkJjNpIzF3Mkw+KDeYLigFPEu2SnxGlyY+uSKyD0PB20nNmbNQET31UVlNf90LyzACffLB0oUdXwuL5s9Hfc4Hcyzk1JrIteW+5i//lgc+sWYl9hPvONvlyQNx9MGLVvZM+LHgyMwY+SEICGrcQaway78XNHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744872; c=relaxed/simple;
	bh=YKijP8weDFAdTs5+5VThSXsHc39KF291LYcyYnf1Bow=;
	h=Date:To:From:Subject:Message-Id; b=JjZQakPLmuPF/cMz4D8rYgDV7DdteVH7cBveYUycMknUY2hdLEUz5w9yQacUifqhPMrWolXDlkcd/inph/1Zyhq2mP1PwpsTj1PDlkAiMzxkPThSknbJDxnG9+uc6pqrM/mIr4MTYzxbnMZIss+bTuG4g2DmYp8++qLEUeaRf7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nKeSzjrM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nKeSzjrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70EBC4CEF7;
	Sun, 29 Mar 2026 00:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744872;
	bh=YKijP8weDFAdTs5+5VThSXsHc39KF291LYcyYnf1Bow=;
	h=Date:To:From:Subject:From;
	b=nKeSzjrMmtdq38iCkfZijD6S5cfcgmncTJTgAy9exLI2jsAp1NclyD3XagnJHpZKk
	 OhJRWWqSDMD+YRuTEV0TuedtisDQcfB8lg/SjhQu0J7Tzyj0Qxmj1mf3tuv+vqsu6X
	 73Jx5Ox4W0k7nq0g0yovkrPK2pTPFGMOGuOHB80g=
Date: Sat, 28 Mar 2026 17:41:12 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-update-for-goal_tuner.patch removed from -mm tree
Message-Id: <20260329004112.A70EBC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/ABI/damon: update for goal_tuner
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-update-for-goal_tuner.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: update for goal_tuner
Date: Mon, 9 Mar 2026 18:05:23 -0700

Update the ABI document for the newly added goal_tuner sysfs file.

Link: https://lkml.kernel.org/r/20260310010529.91162-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-update-for-goal_tuner
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -316,6 +316,12 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the path
 		parameter of the goal.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goal_tuner
+Date:		Mar 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		goal-based effective quota auto-tuning algorithm to use.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/weights/sz_permil
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch


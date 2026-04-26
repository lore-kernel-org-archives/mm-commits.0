Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0A2257ACF;
	Sun, 26 Apr 2026 18:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777227019; cv=none; b=FRL2ldQ6eTysUeL97rEtkkVcGeBu6MKlBrxU8qvarQasA41ucGmLza3UgDxtBCm1DjZUzgugmo+q28/jPESiUDtv0cOnJZErcssmYctGCIGgTdYpczIkhsCF9UweddqToi+yqDu2Op23B7X1X/UifrlxmhcydR3ePhwvrPiZXYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777227019; c=relaxed/simple;
	bh=MFfB5lAxYmqbSowORzHQ3YeRtMHgWMFcHW8osSTHS2c=;
	h=Date:To:From:Subject:Message-Id; b=e7kY3BSEmnwoXmthLW+VQH58kcpmFoNJnqABcxixIy79VDY9VlR8iGq9A3+IVZc8lBT1XYqltSor7bGjD2/tEsflrjeVHGYp3mW5VbN1bxtNfcyt3vUGYTSdz57gt6q54wxWm8TaJw0N7F7nsAm2eS+Q9CEKT3EYka4WrEGBY14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rQ1mMg/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rQ1mMg/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67112C2BCAF;
	Sun, 26 Apr 2026 18:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777227019;
	bh=MFfB5lAxYmqbSowORzHQ3YeRtMHgWMFcHW8osSTHS2c=;
	h=Date:To:From:Subject:From;
	b=rQ1mMg/UzC28ninoBBz1cHfhsk9KxZidzRjQxbtYMHXnSpAir6V0ZRnYOZN09AfHr
	 PywzNUZ+3silnAM/AkPlpX4oHca0kk6ysq1u8MGBmlR+K6zi38qWHxN2f/7iwLGkUc
	 LeMPm3KANzkRBP8swYfFnQ9YrKx5kpm0F+AN1af8=
Date: Sun, 26 Apr 2026 11:10:18 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-call-missing-mem_cgroup_iter_break.patch added to mm-hotfixes-unstable branch
Message-Id: <20260426181019.67112C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: call missing mem_cgroup_iter_break()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-call-missing-mem_cgroup_iter_break.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-call-missing-mem_cgroup_iter_break.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: call missing mem_cgroup_iter_break()
Date: Sun, 26 Apr 2026 10:36:12 -0700

damon_sysfs_memcg_path_to_id() breaks mem_cgroup_iter() loop without
calling mem_cgroup_iter_break().  This leaks the cgroup reference.  Fix
the issue by calling mem_cgroup_iter_break() before the break.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260426173625.86521-1-sj@kernel.org
Link: https://lore.kernel.org/20260423004148.74722-1-sj@kernel.org [1]
Fixes: 29cbb9a13f05 ("mm/damon/sysfs-schemes: implement scheme filters")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.3.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-call-missing-mem_cgroup_iter_break
+++ a/mm/damon/sysfs-schemes.c
@@ -2594,6 +2594,7 @@ static int damon_sysfs_memcg_path_to_id(
 		if (damon_sysfs_memcg_path_eq(memcg, path, memcg_path)) {
 			*id = mem_cgroup_id(memcg);
 			found = true;
+			mem_cgroup_iter_break(NULL, memcg);
 			break;
 		}
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-protect-memcg_path-kfree-with-damon_sysfs_lock.patch
mm-damon-sysfs-schemes-protect-path-kfree-with-damon_sysfs_lock.patch
mm-damon-reclaim-detect-and-use-fresh-enabled-and-kdamond_pid-values.patch
mm-damon-lru_sort-detect-and-use-fresh-enabled-and-kdamond_pid-values.patch
mm-damon-stat-detect-and-use-fresh-enabled-value.patch
mm-damon-sysfs-schemes-call-missing-mem_cgroup_iter_break.patch
docs-mm-damon-maintainer-profile-add-ai-review-usage-guideline.patch


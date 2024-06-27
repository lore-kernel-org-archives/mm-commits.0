Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CFC45BE4
	for <mm-commits@vger.kernel.org>; Thu, 27 Jun 2024 20:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719518881; cv=none; b=kqd89YlO9xeAB02EBFsGA6WW50nTYN2Y9MVlb+H56QaEf3QLriYz6Jpljr4eyCcX337Cn+dJfaPMsYTzdQugMp94Gk+EUdtjXXI4ipf00heGCy3eXEs668MzySmqPpGEqzhW5ak96b7iez+WkzGpKONKekV0lPIy2N8m1F3pz0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719518881; c=relaxed/simple;
	bh=WvLGOzLVR8CTWcwMUA795rO9+wBD5qjMsM/X9uUzmsY=;
	h=Date:To:From:Subject:Message-Id; b=NhH5nwzcZMVq+LpRWdQS2Z/laeFdQLnRCRznop9TXXT5qZDl99A7dxOjfVUzdSZiFb+9hhnVzJDiwzLyRzPOPjhLyR1eDy0v3YCen7Nh6bBQnek/tqkJiDbljvZdB1IrROx9DIxKds6ZRtUR+AyGAAR9vZciAhXl1QEipvKKFHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KB21Z31F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KB21Z31F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3A8C2BBFC;
	Thu, 27 Jun 2024 20:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719518881;
	bh=WvLGOzLVR8CTWcwMUA795rO9+wBD5qjMsM/X9uUzmsY=;
	h=Date:To:From:Subject:From;
	b=KB21Z31F3RupFcC5DtaF+ZqDB2+5HdCAksn6uueVInT4EMd2mX2X8LfXwL5Daja48
	 zqqlmKJrkiTWpsnsb2Bcy1uWIfrjOeO5s1s1NLNcq46EmSPT1JTmRDQEVI4RH/7I/S
	 M/QIUVR6enjetSsNNCA9VzzQI1/KJosP4Q/xrQxM=
Date: Thu, 27 Jun 2024 13:08:00 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix-2.patch added to mm-hotfixes-unstable branch
Message-Id: <20240627200801.1A3A8C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: ensure max threshold attempt for max_nr_regions violation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix-2.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: ensure max threshold attempt for max_nr_regions violation
Date: Thu, 27 Jun 2024 09:31:52 -0700

Since commit ed6cb9d022c8 ("mm/damon/core: increase regions merge
aggressiveness while respecting min_nr_regions") of mm-unstable,
kdamond_merge_regions() stops the repeated merge attempts for meeting
max_nr_regions if the merge threshold that increased for next iteration is
higher than the possible maximum threshold.  Hence, it can skip a merge
attempt with the maximum threshold depending on the amount of the
threshold increase, the maximum threshold, and the last-used threshold
value.  In extreme situations (e.g., region 1 has 100% access frequency,
region 2 has 0% access frequency, so on), this can degrade the
max_nr_regions violation recovery.

Fix this by stopping the loop by comparing the last-used threshold instead
of the to-be-used threshold, and if the last-used threshold is same to or
higher than the maximum possible threshold.

Link: https://lkml.kernel.org/r/20240627163153.75969-1-sj@kernel.org
Fixes: ed6cb9d022c8 ("mm/damon/core: increase regions merge aggressiveness while respecting min_nr_regions") # mm-unstable
Signed-off-by: SeongJae Park <sj@kernel.org>
Closes: https://lore.kernel.org/20240626214954.46143-1-sj@kernel.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix-2
+++ a/mm/damon/core.c
@@ -1382,7 +1382,7 @@ static void kdamond_merge_regions(struct
 		}
 		threshold = max(1, threshold * 2);
 	} while (nr_regions > c->attrs.max_nr_regions &&
-			threshold <= max_thres);
+			threshold / 2 < max_thres);
 }
 
 /*
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix-2.patch
docs-mm-damon-maintainer-profile-introduce-hackermail.patch
docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch
selftests-damon-access_memory-use-user-defined-region-size.patch
selftests-damon-_damon_sysfs-support-schemes_update_tried_regions.patch
selftests-damon-implement-a-program-for-even-numbered-memory-regions-access.patch
selftests-damon-implement-damos-tried-regions-test.patch
selftests-damon-_damon_sysfs-implement-kdamonds-stop-function.patch
selftests-damon-implement-test-for-min-max_nr_regions.patch
_damon_sysfs-implement-commit-for-online-parameters-update.patch
selftests-damon-damon_nr_regions-test-online-tuned-max_nr_regions.patch


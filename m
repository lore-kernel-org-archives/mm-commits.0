Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A836AFAE
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423601; cv=none; b=PXptHD2lAYrfkkcgtfg5NTzZAP1lTvh8auCOhgn6WzSQJUkZZ+AwOhm0I0YowsIpp3Az+2hrzY03Rs/nmMUAaYNAPt0nkyZV8Bx097Xqj2vUbLk1vGU6ZfAqTylpRkKCg9i7A7363K53mlMtd5KHGD8JvUUrj9ULPNRUmc5Qh2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423601; c=relaxed/simple;
	bh=bP/aRXkBltsNzgsFY+LNmEpk4m8Oyr/LTTU7TY2FMuE=;
	h=Date:To:From:Subject:Message-Id; b=GCrvdsGIiYFo91bv4uxVCDoCalzeT9RbfTB+usLyOK1Q3PKv0VnUk0+I+m23rCgNeNI0JpxO+6+vOqtrsN5UMXVkxYozspcz9QZhHs0dthh6lEWbv+l9RmRelcRo9+5kI/jSNpkKw9wK4rbvYW7FkWWGOZam9EvwaY8fZ4fKixc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PWUrJ+7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PWUrJ+7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A953EC4CEC2;
	Wed,  4 Sep 2024 04:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423601;
	bh=bP/aRXkBltsNzgsFY+LNmEpk4m8Oyr/LTTU7TY2FMuE=;
	h=Date:To:From:Subject:From;
	b=PWUrJ+7tZtJ2iTZfh6E+NKNuFdfhwBPOfEK1B8lGgCgqlCb5DycNR6P4ZmCMsMTu/
	 d62uUFa7RxIuaAlgh9RytTI8jdxaGD8hlTGGISPoXZCcu06ORekSxCeWqn6K27xcYx
	 4E76+Za2vEq2/GXO1yrBYVu8exsAw31j0J5/QSW4=
Date: Tue, 03 Sep 2024 21:20:01 -0700
To: mm-commits@vger.kernel.org,davidgow@google.com,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-add-execute-permissions-to-test-scripts.patch removed from -mm tree
Message-Id: <20240904042001.A953EC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: add execute permissions to test scripts
has been removed from the -mm tree.  Its filename was
     selftests-damon-add-execute-permissions-to-test-scripts.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: add execute permissions to test scripts
Date: Mon, 26 Aug 2024 20:03:30 -0700

Some test scripts are missing executable permissions.  It causes warnings
that make the test output unnecessarily verbose.  Add executable
permissions.

Link: https://lkml.kernel.org/r/20240827030336.7930-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 0 files changed

diff --git a/tools/testing/selftests/damon/damon_nr_regions.py a/tools/testing/selftests/damon/damon_nr_regions.py
old mode 100664
new mode 100755
diff --git a/tools/testing/selftests/damon/damos_apply_interval.py a/tools/testing/selftests/damon/damos_apply_interval.py
old mode 100664
new mode 100755
diff --git a/tools/testing/selftests/damon/damos_quota_goal.py a/tools/testing/selftests/damon/damos_quota_goal.py
old mode 100664
new mode 100755
diff --git a/tools/testing/selftests/damon/damos_quota.py a/tools/testing/selftests/damon/damos_quota.py
old mode 100664
new mode 100755
diff --git a/tools/testing/selftests/damon/damos_tried_regions.py a/tools/testing/selftests/damon/damos_tried_regions.py
old mode 100664
new mode 100755
diff --git a/tools/testing/selftests/damon/debugfs_target_ids_pid_leak.sh a/tools/testing/selftests/damon/debugfs_target_ids_pid_leak.sh
old mode 100664
new mode 100755
diff --git a/tools/testing/selftests/damon/debugfs_target_ids_read_before_terminate_race.sh a/tools/testing/selftests/damon/debugfs_target_ids_read_before_terminate_race.sh
old mode 100664
new mode 100755
diff --git a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py
old mode 100664
new mode 100755
diff --git a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
old mode 100664
new mode 100755
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-intorduce-per-context-region-priorities-histogram-buffer.patch
mm-damon-core-replace-per-quota-regions-priority-histogram-buffer-usage-with-per-context-one.patch
mm-damon-core-remove-per-scheme-region-priority-histogram-buffer.patch
revert-mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch
docs-damon-use-damonitor-github-organization-instead-of-awslabs.patch
docs-damon-maintainer-profile-add-links-in-place.patch
docs-damon-maintainer-profile-document-google-calendar-for-bi-weekly-meetups.patch


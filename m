Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B28D156F28
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756862; cv=none; b=epJqQW6ImmG+XUBk30cDf4j29qhwlfJnwCgfC+f2Fo4agwuash20h6RVNtf993fBQ08gmNFPkx1xx0S0JfkAdAMW67VtVhPeFUUSPWEwvs+EnNaizurjCCdfmu10m9pGMT3EJBd/zHK7efkeCPwKZZR+pTNRqndm8Jm+iq8ewCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756862; c=relaxed/simple;
	bh=rYajGG5YmLnFNUUGG5REwa4I0OwpDv0gjCDH24aqi9k=;
	h=Date:To:From:Subject:Message-Id; b=oYsSK2QabXNWQUIWp0ijobx+aphDMorZSyuwwQ9Npt4CXm5hDSyYtHGaLct6YuHXlIUbR49yN8pibgSXsSGJwnUtneZ7Kxg5JjnbNQ8mOvK33fnP2akPKFRwAXPcpS+wLU79hGTjiMhsjPZhbkq5UUADH3KjR2yHBaj9YC1UYJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rq3XME2Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rq3XME2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE4FC4CEED;
	Sun,  1 Jun 2025 05:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756862;
	bh=rYajGG5YmLnFNUUGG5REwa4I0OwpDv0gjCDH24aqi9k=;
	h=Date:To:From:Subject:From;
	b=rq3XME2Qnl7VbWztAHbKTuQcZrDB8tfWRFBv4nmwLAa73G+ztLVRNT27xcewJoxD3
	 b+QUCzDxnLdRjgzqgBFave7bbkBSwEnU9p56yWNxVuNFl19ktG0h0K7zSIsp2b0XIO
	 JS8qbPw16ATi3+hzlapSnXA/TUcVGGscZE/EMWKQ=
Date: Sat, 31 May 2025 22:47:41 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_damon_sysfs-skip-testcases-if-config_damon_sysfs-is-disabled.patch removed from -mm tree
Message-Id: <20250601054742.3EE4FC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_damon_sysfs: skip testcases if CONFIG_DAMON_SYSFS is disabled
has been removed from the -mm tree.  Its filename was
     selftests-damon-_damon_sysfs-skip-testcases-if-config_damon_sysfs-is-disabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Enze Li <lienze@kylinos.cn>
Subject: selftests/damon/_damon_sysfs: skip testcases if CONFIG_DAMON_SYSFS is disabled
Date: Sat, 31 May 2025 17:39:37 +0800

When CONFIG_DAMON_SYSFS is disabled, the selftests fail with the following
outputs,

not ok 2 selftests: damon: sysfs_update_schemes_tried_regions_wss_estimation.py # exit=1
not ok 3 selftests: damon: damos_quota.py # exit=1
not ok 4 selftests: damon: damos_quota_goal.py # exit=1
not ok 5 selftests: damon: damos_apply_interval.py # exit=1
not ok 6 selftests: damon: damos_tried_regions.py # exit=1
not ok 7 selftests: damon: damon_nr_regions.py # exit=1
not ok 11 selftests: damon: sysfs_update_schemes_tried_regions_hang.py # exit=1

The root cause of this issue is that all the testcases above do not check
the sysfs interface of DAMON whether it exists or not.  With this patch
applied, all the testcases above now pass successfully.

Link: https://lkml.kernel.org/r/20250531093937.1555159-1-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-skip-testcases-if-config_damon_sysfs-is-disabled
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -15,6 +15,10 @@ if sysfs_root is None:
     print('Seems sysfs not mounted?')
     exit(ksft_skip)
 
+if not os.path.exists(sysfs_root):
+    print('Seems DAMON disabled?')
+    exit(ksft_skip)
+
 def write_file(path, string):
     "Returns error string if failed, or None otherwise"
     string = '%s' % string
_

Patches currently in -mm which might be from lienze@kylinos.cn are



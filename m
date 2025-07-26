Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45130260587
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567826; cv=none; b=RH/YVmpJtoJHt8lBPaOS6i6Ho9JGeyE7mrL/nMYKwO7NLx5TkMxMlyuCZarxIH9TMFLtO+zX8NrZ/R3y209cW4M/7FPjlTrZm4Xf1xzCeXczjhpSZss6JKb7duH9U/fe3LC6IZa7OIUE/28ZQY+BDwvoj81zM3aw3GTiA3yGk68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567826; c=relaxed/simple;
	bh=RwRc35rMcRPYYlDQvDOOlRkANGpkpvOdNOBZEjooEIY=;
	h=Date:To:From:Subject:Message-Id; b=WmiS3UaB8AG64SM0ESQroRJgZssXvWgMpJqQkjpRJk2sayyjLggHyfWWC1zleUeZLYHgvidn6l7+4tRxBz6I/05e97VmzhnMlFSCB9vt2hq74bxPnk74AZoutFqDRjRCjYKnO7wvUDR84tb7yT9vxtSvPWBnvV93fGlQPo1hpNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MJMstd82; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MJMstd82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6882C4CEED;
	Sat, 26 Jul 2025 22:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567825;
	bh=RwRc35rMcRPYYlDQvDOOlRkANGpkpvOdNOBZEjooEIY=;
	h=Date:To:From:Subject:From;
	b=MJMstd82Vp1tJJCWph2LpCiNOfejA91xBrGNS5FMwfsuNS7Q3be6vsC8B72BotYNa
	 E/SOxU5gp65X8BgkF1p6rz+F5BkceCrIwQ6GqoZB0/yqJE/NfoDtdvcq8VcqlFrUeD
	 lXhpu7ooN6zm/EayrifDHT3p+k4e3Izug9Ei57d0=
Date: Sat, 26 Jul 2025 15:10:25 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfspy-generalize-damos-schemes-commit-assertion.patch removed from -mm tree
Message-Id: <20250726221025.D6882C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.py: generalize DAMOS schemes commit assertion
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfspy-generalize-damos-schemes-commit-assertion.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs.py: generalize DAMOS schemes commit assertion
Date: Sun, 20 Jul 2025 10:16:48 -0700

DAMOS schemes commitment assertion is hard-coded for a specific test case.
Split it out into a general version that can be reused for different test
cases.

Link: https://lkml.kernel.org/r/20250720171652.92309-19-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-generalize-damos-schemes-commit-assertion
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -136,6 +136,11 @@ def assert_scheme_committed(scheme, dump
     for idx, f in enumerate(scheme.ops_filters.filters):
         assert_filter_committed(f, dump['ops_filters'][idx])
 
+def assert_schemes_committed(schemes, dump):
+    assert_true(len(schemes) == len(dump), 'len_schemes', dump)
+    for idx, scheme in enumerate(schemes):
+        assert_scheme_committed(scheme, dump[idx])
+
 def main():
     kdamonds = _damon_sysfs.Kdamonds(
             [_damon_sysfs.Kdamond(
@@ -180,10 +185,7 @@ def main():
             { 'pid': 0, 'nr_regions': 0, 'regions_list': []}]:
         fail('adaptive targets', status)
 
-    if len(ctx['schemes']) != 1:
-        fail('number of schemes', status)
-
-    assert_scheme_committed(_damon_sysfs.Damos(), ctx['schemes'][0])
+    assert_schemes_committed([_damon_sysfs.Damos()], ctx['schemes'])
 
     kdamonds.stop()
 
_

Patches currently in -mm which might be from sj@kernel.org are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D9837187F
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439158; cv=none; b=ASSgfy7XMyLI1Z75cH0BMC6w45pDwNE9yJ6w3EFS96BQ+OoLxjLQlJhGTPx1wnJF7ke5MieYFHEXfxFsVJ0Qxow7kAKRZcmWZxo0dNlBvvXyru79c+qCLae7twnjJgw068RU+eSfxwXjah1mnbAXZuYuFFuvSQO1a3ONOzZMiUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439158; c=relaxed/simple;
	bh=EH3U2kwJDFHTEKopvprEcTDk1/7JB4sHrHfK7QzqGlo=;
	h=Date:To:From:Subject:Message-Id; b=CXd9Wl7BEe2BAht+vWiUba4PMLvTUO+lkPPgeuKV+ifVx5JY0pOLDwmLpewM7wWIDM1XVXl2HIkRopyfgSnl+4ZfdDsdqmZlYuNAvDsxvZ6aJtk+dFy8sFKAdR3W3jIAa/m2+Wz27RmwdrF/Ygx01t4KbfAFDNqrM8I+BjWZ3JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z9hS4vTU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z9hS4vTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B30B1F00898;
	Tue,  2 Jun 2026 22:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439157;
	bh=TJ6irJJOYYuWQyh3ux1kphLxoSHcc3GkZIM66z84sTY=;
	h=Date:To:From:Subject;
	b=Z9hS4vTUWsdxlw6dhYAIGYE7R3wXtPkz5EjFiZ/Ga++kiBpvFSbNHnnzkivaxIMH7
	 7jQH3Mp/pnBgrCB0KJhw5kRFWAyNjU9RuzgzDJ6AmuSldLFRO+fVkROuH4ZOYJOf+Q
	 tnUaRaVPEYcUfzCQVw/mwOaMbElFgK0JLrcSvP80=
Date: Tue, 02 Jun 2026 15:25:57 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfspy-stop-kdamonds-before-failing.patch removed from -mm tree
Message-Id: <20260602222557.9B30B1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.py: stop kdamonds before failing
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfspy-stop-kdamonds-before-failing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs.py: stop kdamonds before failing
Date: Fri, 22 May 2026 08:40:22 -0700

When an assertion is failed, sysfs.py DAMON selftest immediately exits the
test program leaving the DAMON running behind.  Many of the following
tests need to start DAMON on their own.  But because DAMON that was
started by sysfs.py is still running, those start attempts fail, and the
tests are failed or skipped.  Update sysfs.py to stop DAMON before exiting
the test program due to the assertion failure.

Link: https://lore.kernel.org/20260522154026.80546-12-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-stop-kdamonds-before-failing
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -24,9 +24,12 @@ def dump_damon_status_dict(pid):
     except Exception as e:
         return None, 'json.load fail (%s)' % e
 
+kdamonds = None
 def fail(expectation, status):
     print('unexpected %s' % expectation)
     print(json.dumps(status, indent=4))
+    if kdamonds is not None:
+        kdamonds.stop()
     exit(1)
 
 def assert_true(condition, expectation, status):
@@ -248,6 +251,7 @@ def assert_ctxs_committed(kdamonds):
                 ctx.pause = False
 
 def main():
+    global kdamonds
     kdamonds = _damon_sysfs.Kdamonds(
             [_damon_sysfs.Kdamond(
                 contexts=[_damon_sysfs.DamonCtx(
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch


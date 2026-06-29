Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A399A356748
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 17:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782755729; cv=none; b=jh8jwmpStoXEW0ignnnUHBSHcrw8l/YqalugG0mWg8CFjuIGSjDvIvnUgCNUU0mvl1h5jC6TJImT8lGAVBXoUdoczvHP+4wNizn76hwYdl3p0VKBCLjhMsOT29XwFPqFigmgUZL35XM/U1KqF5L4pF8XHCffLBb82vPEP0bJzTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782755729; c=relaxed/simple;
	bh=1b3SbgA9v/bhv0/DifAco+hRHZJw27EWDulwBLHrnoM=;
	h=Date:To:From:Subject:Message-Id; b=kzAYIdTcA1lKMTj0+LDXOCqDXYARBTjs6ptnyDOQHhzvVfDlL0HX50ViwvNlsYWIGTXe09oA6cP7jn6E9+EErBiAT7WS8j04FiltSKuCIl8wlhm3nP1oSpwqyza0R3zD0bsllBcWrylI8RUDSyJkc5t0T/XyIhvX+EG1kW53vqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mKRL6Abf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mKRL6Abf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8CD1F00A3A;
	Mon, 29 Jun 2026 17:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782755728;
	bh=aHbNrzbQUUINwnE5kk0hWN7qGudhYr4GPSCXxFrCepU=;
	h=Date:To:From:Subject;
	b=mKRL6AbfXlSYMOPoE/uzBcRLG5Yeq/HouOxdBJSewa14PEvr4XrgDYSvZLTFVqHOz
	 C+LXLylvVBg8xQQbviiAXRPN1l2IJ+ZK6aWrp2AmMZbu9fhlhUS4lT50nwz0wWgKuZ
	 gAbxNMS+8cs62tm6ey41aOGg8eb4yhkOc577PaRE=
Date: Mon, 29 Jun 2026 10:55:27 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,linuxoid@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_damon_sysfs-support-kdamond-refresh_ms.patch added to mm-new branch
Message-Id: <20260629175527.ED8CD1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_damon_sysfs: support kdamond refresh_ms
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-_damon_sysfs-support-kdamond-refresh_ms.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_damon_sysfs-support-kdamond-refresh_ms.patch

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
From: Ruslan Valiyev <linuxoid@gmail.com>
Subject: selftests/damon/_damon_sysfs: support kdamond refresh_ms
Date: Mon, 29 Jun 2026 07:49:25 -0700

Patch series "selftests/damon: test kdamond refresh_ms", v2.

The kdamond 'refresh_ms' sysfs file makes DAMON periodically update its
read-only sysfs files (DAMOS stats, tuned monitoring intervals and the
kdamond pid) on its own, so users don't have to write update keywords such
as 'update_schemes_stats' to the 'state' file.  It has no selftest
coverage.

The first patch adds refresh_ms support to the _damon_sysfs.py test
control module.  The second adds a test that sets refresh_ms and confirms
a scheme's stats are updated under sysfs without an explicit update
request; the test skips on kernels that predate the refresh_ms file.

Tested on current mainline under a DAMON-enabled kernel: the new test
passes and the existing DAMON selftests show no new failures.


This patch (of 2):

The Kdamond class has no way to set the kdamond-level 'refresh_ms' sysfs
file, which makes DAMON periodically update the read-only sysfs files
(DAMOS stats, tuned monitoring intervals and the kdamond pid) on its own.

Add a 'refresh_ms' parameter to Kdamond.  When it is set (including to
zero, to disable the periodic update), write it before turning the kdamond
on, so tests can exercise the auto-update behavior.  Leaving it unset
keeps the previous behavior of not touching the file, so callers running
against kernels without the feature are unaffected.

Link: https://lore.kernel.org/20260602131217.2210912-2-linuxoid@gmail.com
Link: https://lore.kernel.org/20260629144927.134237-2-sj@kernel.org
Signed-off-by: Ruslan Valiyev <linuxoid@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-support-kdamond-refresh_ms
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -698,12 +698,14 @@ class DamonCtx:
 class Kdamond:
     state = None
     pid = None
+    refresh_ms = None
     contexts = None
     idx = None      # index of this kdamond between siblings
     kdamonds = None # parent
 
-    def __init__(self, contexts=[]):
+    def __init__(self, contexts=[], refresh_ms=None):
         self.contexts = contexts
+        self.refresh_ms = refresh_ms
         for idx, context in enumerate(self.contexts):
             context.idx = idx
             context.kdamond = self
@@ -726,6 +728,11 @@ class Kdamond:
             err = context.stage()
             if err is not None:
                 return err
+        if self.refresh_ms is not None:
+            err = write_file(os.path.join(self.sysfs_dir(), 'refresh_ms'),
+                             '%d' % self.refresh_ms)
+            if err is not None:
+                return err
         err = write_file(os.path.join(self.sysfs_dir(), 'state'), 'on')
         if err is not None:
             return err
_

Patches currently in -mm which might be from linuxoid@gmail.com are

selftests-damon-_damon_sysfs-support-kdamond-refresh_ms.patch
selftests-damon-sysfs_refresh-test-kdamond-refresh_ms.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336C631282F
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298540; cv=none; b=Ajoe3tll+FtOXasi/lYfz3fkJmtl6t2se2PQghvDBnXDhR8l8AIkAas+gdT9pt0wYO3Nka97F66GB9ibqmwzetQowx6+NoIt22Ic2hhRk0Tfricoth8uS5TAQ0G8c2bmURDZNHPfrW52QtyWNVui47kYWYmkEBSOcKUXR/V3Cm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298540; c=relaxed/simple;
	bh=YTNLH4iNLCdU8cpYlfHFL4gpEfHCe+dP+aF9lKq8puY=;
	h=Date:To:From:Subject:Message-Id; b=gqpMrkK0FTJLe96wEERDvampCPgE3gZVQAMXvEoOTRP8/X6aFQ5DfZ0VHI79wdaa+ftaiFvM/+2bG/KOU8k4Kslt/AopEi+AU3qTZ6MFQ7RsPjF4Ci9omkIV7Hm8N1JlYz9TRn3tI+utacn8DDb8F02vT8NOLfvoFVuITEZm6RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=riGaClVr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="riGaClVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6991F000E9;
	Wed, 29 Jul 2026 04:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298538;
	bh=D1fwFaidesSJW2c6a6Fu+580DJwxls1lVTrvN9C86ZE=;
	h=Date:To:From:Subject;
	b=riGaClVr94+C8dRHJQVEQ25O26ugo0WsOBDRPpK0wOYnRVtMR/n00uwB1bjVw3Ij2
	 oUxMUjsuCVxw4Lv/MeTdOglcOZ+dQ7BhlcdZnjazmn0DvAhgZ6qqgzwyDs0Y4ay79U
	 9zeWLPYAZXX/BspxQRFYHMLxlSGAfNwT1JVdq7B8=
Date: Tue, 28 Jul 2026 21:15:37 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,linuxoid@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_damon_sysfs-support-kdamond-refresh_ms.patch removed from -mm tree
Message-Id: <20260729041538.0A6991F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_damon_sysfs: support kdamond refresh_ms
has been removed from the -mm tree.  Its filename was
     selftests-damon-_damon_sysfs-support-kdamond-refresh_ms.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



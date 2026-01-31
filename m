Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5EB38A73C
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898331; cv=none; b=KOjhoLcRIbOOhoi7OvbzjzuUW7rrnh5VAPMmw30NJyTjNhYPnTh8vwLRvWbtzUpePYkJZGOea3EEGPX5N2SP3JwBEaA1mV8Tn+e+08WGZFYeEP6ZWeQ9t0vVsenG7tJjay7NgRLX1WvMONDIxBqf2p2LUFFsRBYWe0eZalGarHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898331; c=relaxed/simple;
	bh=b8dekQn7cdQuoQhBGD7kb4BnS5IPzp9yzkTGEW49JGE=;
	h=Date:To:From:Subject:Message-Id; b=NeiY1zXO8568X6YCU5ygHJbOHVrovMYB5Kj+hL2YmLJ20/JrzKpkXv2k42YQN+DB/9IAskfXjDDoaaViwwpmUh5lcD7VbE5fBoqNkvzJVglsYrf84OuwpGxU4VYhd9/K522V3vukY+uxDA0WHS+gaGuCLGYoOUXCwJj4GU4uLoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=btNDMhFA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="btNDMhFA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEBB0C4CEF1;
	Sat, 31 Jan 2026 22:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898331;
	bh=b8dekQn7cdQuoQhBGD7kb4BnS5IPzp9yzkTGEW49JGE=;
	h=Date:To:From:Subject:From;
	b=btNDMhFAi0Xp7t9rO3wph5bdWFM/qWOW+92lZ9sWcDeL1bYIt0zjvbOtrln1Rz6+m
	 zltEyH1JLIq8WH5k4DvIEMDQeJ7Ruwxo65jvL9C1n5hh5WJnQc97TcQEIrNcuLjFLU
	 CatYbWwMnPjP6X+5I46klwPUM3Lg5FzNHA0AS4z4=
Date: Sat, 31 Jan 2026 14:25:30 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-wss_estimation-ensure-number-of-collected-wss.patch removed from -mm tree
Message-Id: <20260131222530.DEBB0C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/wss_estimation: ensure number of collected wss
has been removed from the -mm tree.  Its filename was
     selftests-damon-wss_estimation-ensure-number-of-collected-wss.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/wss_estimation: ensure number of collected wss
Date: Fri, 16 Jan 2026 18:07:27 -0800

DAMON selftest for working set size estimation collects DAMON's working
set size measurements of the running artificial memory access generator
program until the program is finished.  Depending on how quickly the
program finishes, and how quickly DAMON starts, the number of collected
working set size measurements may vary, and make the test results
unreliable.  Ensure it collects 40 measurements by using the repeat mode
of the artificial memory access generator program, and finish the
measurements only after the desired number of collections are made.

Link: https://lkml.kernel.org/r/20260117020731.226785-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py~selftests-damon-wss_estimation-ensure-number-of-collected-wss
+++ a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
@@ -8,7 +8,8 @@ import _damon_sysfs
 
 def pass_wss_estimation(sz_region):
     # access two regions of given size, 2 seocnds per each region
-    proc = subprocess.Popen(['./access_memory', '2', '%d' % sz_region, '2000'])
+    proc = subprocess.Popen(
+            ['./access_memory', '2', '%d' % sz_region, '2000', 'repeat'])
     kdamonds = _damon_sysfs.Kdamonds([_damon_sysfs.Kdamond(
             contexts=[_damon_sysfs.DamonCtx(
                 ops='vaddr',
@@ -26,7 +27,7 @@ def pass_wss_estimation(sz_region):
         exit(1)
 
     wss_collected = []
-    while proc.poll() == None:
+    while proc.poll() is None and len(wss_collected) < 40:
         time.sleep(0.1)
         err = kdamonds.kdamonds[0].update_schemes_tried_bytes()
         if err != None:
@@ -35,6 +36,7 @@ def pass_wss_estimation(sz_region):
 
         wss_collected.append(
                 kdamonds.kdamonds[0].contexts[0].schemes[0].tried_bytes)
+    proc.terminate()
     err = kdamonds.stop()
     if err is not None:
         print('kdamond stop failed: %s' % err)
_

Patches currently in -mm which might be from sj@kernel.org are



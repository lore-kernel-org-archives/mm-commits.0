Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B424538A9A1
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898327; cv=none; b=g4sGXo5CISrl1PQh7mZ6SmLBIqaq3Sn0jrjDGYflQkvSlkGGuFp2yHbHpf//N7WnRGE/QIHpFzVdDbK+R5FQWRSTVKLkpPWNEJwOPaY0fx2HrW6JUhh3PI/ZLuP+djNKgMm/pGWkk2oh9WsRIN93kiufygsckPfbEWQ4ayP/cNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898327; c=relaxed/simple;
	bh=BFEN1hSXc0v3S4r+ZC8QELtPBn2pD9miWPH+jaqwE6o=;
	h=Date:To:From:Subject:Message-Id; b=TrHQ/rE+SOgftuHHt5+wIeHr5bSLD35eoc9VVsUtEG6lIcfA/5Li5F0kN3q5uoTQRvSxPJSL6CzIOHoigE+ZjCspl2Ihc7ad7w5ZpUMzqR7r/07VuhA94VRLhuapXtIe2OGlAcS6t84d99fSRa5jeivRxB9fOPq6tGdk6z/yCXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ksD6SlJJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ksD6SlJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC4BC4CEF1;
	Sat, 31 Jan 2026 22:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898327;
	bh=BFEN1hSXc0v3S4r+ZC8QELtPBn2pD9miWPH+jaqwE6o=;
	h=Date:To:From:Subject:From;
	b=ksD6SlJJm/tPLvU6DBQqTsnwekku/xOTUUE5pr+8hqEjxWJniKvRE46F0lg5u30T4
	 UNz7+4RleS+kjc916CYueOTeFJ74leaberwYBl9AArhPSSUcsasP0sLcNUJ/5KLcrd
	 YCL2h4C/TSlOazuRTFEns2elSxpX2+jCTs6aE+XU=
Date: Sat, 31 Jan 2026 14:25:27 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfs_memcg_path_leaksh-use-kmemleak.patch removed from -mm tree
Message-Id: <20260131222527.8BC4BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs_memcg_path_leak.sh: use kmemleak
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfs_memcg_path_leaksh-use-kmemleak.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs_memcg_path_leak.sh: use kmemleak
Date: Fri, 16 Jan 2026 18:07:24 -0800

Patch series "selftests/damon: improve leak detection and wss estimation
reliability".

Two DAMON selftets, namely 'sysfs_memcg_leak' and
'sysfs_update_schemes_tried_regions_wss_estimation' frequently show
intermittent failures due to their unreliable leak detection and working
set size estimation.  Make those more reliable.


This patch (of 5):

sysfs_memcg_path_leak.sh determines if the memory leak has happened by
seeing if Slab size on /proc/meminfo increases more than expected after an
action.  Depending on the system and background workloads, the reasonable
expectation varies.  For the reason, the test frequently shows
intermittent failures.  Use kmemleak, which is much more reliable and
correct, instead.

Link: https://lkml.kernel.org/r/20260117020731.226785-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260117020731.226785-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs_memcg_path_leak.sh |   26 +++++-----
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh~selftests-damon-sysfs_memcg_path_leaksh-use-kmemleak
+++ a/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh
@@ -14,6 +14,13 @@ then
 	exit $ksft_skip
 fi
 
+kmemleak="/sys/kernel/debug/kmemleak"
+if [ ! -f "$kmemleak" ]
+then
+	echo "$kmemleak not found"
+	exit $ksft_skip
+fi
+
 # ensure filter directory
 echo 1 > "$damon_sysfs/kdamonds/nr_kdamonds"
 echo 1 > "$damon_sysfs/kdamonds/0/contexts/nr_contexts"
@@ -22,22 +29,17 @@ echo 1 > "$damon_sysfs/kdamonds/0/contex
 
 filter_dir="$damon_sysfs/kdamonds/0/contexts/0/schemes/0/filters/0"
 
-before_kb=$(grep Slab /proc/meminfo | awk '{print $2}')
-
-# try to leak 3000 KiB
-for i in {1..102400};
+# try to leak 128 times
+for i in {1..128};
 do
 	echo "012345678901234567890123456789" > "$filter_dir/memcg_path"
 done
 
-after_kb=$(grep Slab /proc/meminfo | awk '{print $2}')
-# expect up to 1500 KiB free from other tasks memory
-expected_after_kb_max=$((before_kb + 1500))
-
-if [ "$after_kb" -gt "$expected_after_kb_max" ]
+echo scan > "$kmemleak"
+kmemleak_report=$(cat "$kmemleak")
+if [ "$kmemleak_report" = "" ]
 then
-	echo "maybe memcg_path are leaking: $before_kb -> $after_kb"
-	exit 1
-else
 	exit 0
 fi
+echo "$kmemleak_report"
+exit 1
_

Patches currently in -mm which might be from sj@kernel.org are



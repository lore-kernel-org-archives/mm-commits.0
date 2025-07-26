Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577C521CA1D
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567805; cv=none; b=UL59m3chvGF1EXD4pnvWqUuRa3uvhay3g/oymLBvcHq5ZritJP0WZqc4s0i0NBU1oFk7IE6Co/TI9F9nm4K9DwwucWO/nFd6hcxR8ycvdWqNLKgNjqApDbvnav2qs8TGdfVRmGOzAT4679pPWywDzr4m5DiNav+QBM6hi9vzxEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567805; c=relaxed/simple;
	bh=WJdcC9LpX3bEOqyMmLNDjcKIkv4jczI7iXRodUK/P+0=;
	h=Date:To:From:Subject:Message-Id; b=lBaeWUWGoogP9rfqwrI+cc7TyzQitUYSLNbNDJe+EanOn+QDm/Wf+iXGfHNbSv8GNUXsnrOemer6DTYc4Tno0V0s0Kms/huQFB4axRCXgvd1VQrbpnEw+cH23+CAA9AEkiy1SFzPxKRPysYa3DcXcCZh8QhSCmr3WqkxVDMJllI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XhvRkMs9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XhvRkMs9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF6EC4CEED;
	Sat, 26 Jul 2025 22:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567805;
	bh=WJdcC9LpX3bEOqyMmLNDjcKIkv4jczI7iXRodUK/P+0=;
	h=Date:To:From:Subject:From;
	b=XhvRkMs99FSLJLTkJnbeZqDlBz8d1LyAgOK9/vSRwEHgnhpNp4bVW2xvnlNJ5onRa
	 avliHNx7wLt978ilfij24PdLg9HAUWpa3RQDTXOaWMLJYgHe2r8fueQ8eUwh4NJXSN
	 NkrPPjV+C4WZ5AY3lyh6jMFrNlCTKDLE75ZHsJuI=
Date: Sat, 26 Jul 2025 15:10:04 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,oliver.sang@intel.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfspy-stop-damon-for-dumping-failures.patch removed from -mm tree
Message-Id: <20250726221005.0BF6EC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.py: stop DAMON for dumping failures
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfspy-stop-damon-for-dumping-failures.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs.py: stop DAMON for dumping failures
Date: Mon, 21 Jul 2025 23:03:30 -0700

Commit 4ece01897627 ("selftests/damon: add python and drgn-based DAMON
sysfs test") in mm-stable tree introduced sysfs.py that runs drgn for
dumping DAMON status.  When the DAMON status dumping fails for reasons
including drgn uninstalled environment, the test fails without stopping
DAMON.  Following DAMON selftests that assumes DAMON is not running when
they executed therefore fail.  Catch dumping failures and stop DAMON for
that case.

Link: https://lkml.kernel.org/r/20250722060330.56068-1-sj@kernel.org
Fixes: 4ece01897627 ("selftests/damon: add python and drgn-based DAMON sysfs test")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202507220707.9c5d6247-lkp@intel.com
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-stop-damon-for-dumping-failures
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -8,6 +8,10 @@ import subprocess
 import _damon_sysfs
 
 def dump_damon_status_dict(pid):
+    try:
+        subprocess.check_output(['which', 'drgn'], stderr=subprocess.DEVNULL)
+    except:
+        return None, 'drgn not found'
     file_dir = os.path.dirname(os.path.abspath(__file__))
     dump_script = os.path.join(file_dir, 'drgn_dump_damon_status.py')
     rc = subprocess.call(['drgn', dump_script, pid, 'damon_dump_output'],
@@ -40,6 +44,7 @@ def main():
     status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
     if err is not None:
         print(err)
+        kdamonds.stop()
         exit(1)
 
     if len(status['contexts']) != 1:
_

Patches currently in -mm which might be from sj@kernel.org are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A361C5D6A
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 06:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753166628; cv=none; b=eG6PywbXP/HYsMo0Wn2O4AiPbwAYMlQ2Ew3nRHotVZu4Z4mVFKDzh6en/WimymYmwV1zQKtXdx/qmSEdFArDMwpactsiS4jZOJ9TEUnyX1eVxdEZjwcCFz/HpAU5A/qHuhQOemCGIzk7iFspgouWLyuSvVWt06TmmzvisySGfbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753166628; c=relaxed/simple;
	bh=IVNr0891AgUbZKYaVQsjzEBc78A/Y7y5xex1QPyx4fQ=;
	h=Date:To:From:Subject:Message-Id; b=l9BbTx/y22ftsseFtP9aT6Y2mKWTFsrj1SLIZYkg4sQqQ7r819P+M/nSszmMvBk0vS09v9ZPVbsOjyjoExwUr91OlvjUbsZc0fTO3BEdZZG69v2cX5lXCH+hyc7Iwv2sFs2uUwPRRGeL6sey2oHLC7/0jke7/lJ7qQY1yPOGNOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kKzVSbzv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kKzVSbzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0CCC4CEEB;
	Tue, 22 Jul 2025 06:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753166628;
	bh=IVNr0891AgUbZKYaVQsjzEBc78A/Y7y5xex1QPyx4fQ=;
	h=Date:To:From:Subject:From;
	b=kKzVSbzvbQaDskwlZF+bb3LKLGHmyVgEZkTm77RvkJJbEilaTTYVMTRQGKOQO1L2T
	 lC/OTIbmzoQpFBUubV9qYmD1QBrNup+bLSrcBo5BSFPq+73g1FLKXv9hVQpEb8mia0
	 HrPeT2dLCJSIXpek2cuEr/3TXf00tRWcO8nLV8OI=
Date: Mon, 21 Jul 2025 23:43:47 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,oliver.sang@intel.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfspy-stop-damon-for-dumping-failures.patch added to mm-unstable branch
Message-Id: <20250722064347.DA0CCC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/sysfs.py: stop DAMON for dumping failures
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-sysfspy-stop-damon-for-dumping-failures.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfspy-stop-damon-for-dumping-failures.patch

This patch will later appear in the mm-unstable branch at
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

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch
mm-damon-ops-common-ignore-migration-request-to-invalid-nodes.patch
selftests-damon-sysfspy-stop-damon-for-dumping-failures.patch
selftests-damon-_damon_sysfs-support-damos-watermarks-setup.patch
selftests-damon-_damon_sysfs-support-damos-filters-setup.patch
selftests-damon-_damon_sysfs-support-monitoring-intervals-goal-setup.patch
selftests-damon-_damon_sysfs-support-damos-quota-weights-setup.patch
selftests-damon-_damon_sysfs-support-damos-quota-goal-nid-setup.patch
selftests-damon-_damon_sysfs-support-damos-action-dests-setup.patch
selftests-damon-_damon_sysfs-support-damos-target_nid-setup.patch
selftests-damon-_damon_sysfs-use-232-1-as-max-nr_accesses-and-age.patch
selftests-damon-drgn_dump_damon_status-dump-damos-migrate_dests.patch
selftests-damon-drgn_dump_damon_status-dump-ctx-opsid.patch
selftests-damon-drgn_dump_damon_status-dump-damos-filters.patch
selftests-damon-sysfspy-generalize-damos-watermarks-commit-assertion.patch
selftests-damon-sysfspy-generalize-damosquota-commit-assertion.patch
selftests-damon-sysfspy-test-quota-goal-commitment.patch
selftests-damon-sysfspy-test-damos-destinations-commitment.patch
selftests-damon-sysfspy-generalize-damos-scheme-commit-assertion.patch
selftests-damon-sysfspy-test-damos-filters-commitment.patch
selftests-damon-sysfspy-generalize-damos-schemes-commit-assertion.patch
selftests-damon-sysfspy-generalize-monitoring-attributes-commit-assertion.patch
selftests-damon-sysfspy-generalize-damon-context-commit-assertion.patch
selftests-damon-sysfspy-test-non-default-parameters-runtime-commit.patch
selftests-damon-sysfspy-test-runtime-reduction-of-damon-parameters.patch


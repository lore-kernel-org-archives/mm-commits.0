Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E452E36FD
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 03:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153915; cv=none; b=JDaK1bqgBgP2446bUULo4EeUUKqM+qQnwq+ZXnKm7N6G+dwGDNngesNq6oxNyg01xrMeZAOcAOI/IltGULawC4oycSNp5YKGnCZAgSJdoZW4QJrI58n8LlZuccvdIvGJghHD6VmP/uHviofF+3aYBZBs+M/KUYwjibaesbrlulw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153915; c=relaxed/simple;
	bh=tdRQkMFjURtdynD13zS/mwbjxjWKDptyY3oXPbHokyI=;
	h=Date:To:From:Subject:Message-Id; b=n3k7WdJ4f+/kW3vQm+D5Y1prNaW8MYl++MMSAMLsQRQpWA2nSngfbhDsqFgpX32zAF3pPpCw+iYhYoHSkSV8GqLVFgLcA+kfOMrn/t9cTicgvlbWlIdiOoYIxLyWfr9dh1R4rcHBAOxcpmMO3v7qtm6kwg7B5iE+rCPDbKRqe0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1kpGP6G/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1kpGP6G/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CCDC4CEED;
	Tue, 22 Jul 2025 03:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753153914;
	bh=tdRQkMFjURtdynD13zS/mwbjxjWKDptyY3oXPbHokyI=;
	h=Date:To:From:Subject:From;
	b=1kpGP6G/W2Fx40x1zIak0WvIneRSZaSvjqml1In4UsrWusbjdnyLTk/7S/Qyw06TY
	 Whg3qoTecIPgl9fgIGCxLY9xITcnN9of+JW/ZRgyKMSKEdNEEoJQFGMU2ce867HJHg
	 oMbbHtUihxHKdOi33urTeyaz4Fq8xGTPb0XvDJh4=
Date: Mon, 21 Jul 2025 20:11:53 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfspy-generalize-damos-schemes-commit-assertion.patch added to mm-new branch
Message-Id: <20250722031154.92CCDC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/sysfs.py: generalize DAMOS schemes commit assertion
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-sysfspy-generalize-damos-schemes-commit-assertion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfspy-generalize-damos-schemes-commit-assertion.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
@@ -132,6 +132,11 @@ def assert_scheme_committed(scheme, dump
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
@@ -175,10 +180,7 @@ def main():
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

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch
mm-damon-ops-common-ignore-migration-request-to-invalid-nodes.patch
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
selftests-damon-sysfspy-generalize-damos-access-pattern-commit-assertion.patch
selftests-damon-sysfspy-test-damos-filters-commitment.patch
selftests-damon-sysfspy-generalize-damos-schemes-commit-assertion.patch
selftests-damon-sysfspy-generalize-monitoring-attributes-commit-assertion.patch
selftests-damon-sysfspy-generalize-damon-context-commit-assertion.patch
selftests-damon-sysfspy-test-non-default-parameters-runtime-commit.patch
selftests-damon-sysfspy-test-runtime-reduction-of-damon-parameters.patch


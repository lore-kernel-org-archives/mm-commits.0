Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CAD28BAB0
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 03:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153943; cv=none; b=YxqYWTIIny0lSGgxT5dJyLwlCsieJxCN28Wa5C5aCJJJa5yR21RRx+2CjXYr6e+MNU9CGCGTWVdXa+oE4dQfcrA434dN5WQh/FmsOb27PpQeeqSJO6LqgivyGm6rVQlkemstxIvw7+rGFpv0X4XBYZbw3iQ01aaVsa61XZUBUcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153943; c=relaxed/simple;
	bh=ru5bGk5VV+3gZjo9A5vR8doYwM/mwHrHcM7HruECdYY=;
	h=Date:To:From:Subject:Message-Id; b=JoRzxyig99KihZY9oqaUX/M3MKee32cARVYPt++47lKgpw4SRHvQQYHNox9pl4LWF6hxEeGZ7Q01Je/t7jXCp3CxFj5euYc582JIWo4xIoOtTZ7jU54NW6OiPz2Qn9+yqq635Km11ymq3FCov9Ow8wRXMVNx+fKW4B1IlBUsEXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GsnVmc/G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GsnVmc/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C667BC4CEED;
	Tue, 22 Jul 2025 03:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753153942;
	bh=ru5bGk5VV+3gZjo9A5vR8doYwM/mwHrHcM7HruECdYY=;
	h=Date:To:From:Subject:From;
	b=GsnVmc/GH8ImKgvf6o5KXi8iaFYGtWDRcQc1/xLNUq+FPq1G9Dm4U6YWcmzglrATn
	 YkNLICO+jNpHrfT3AZCBbHRTRMCIQryOqpCGxcdqtW4tWPHGZNXaROUdOSUM5LBdDg
	 TrsqOnILwX5Ok5gnc8jxnWw0Mr2xQqbKTn3Ykjbk=
Date: Mon, 21 Jul 2025 20:12:22 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfspy-generalize-monitoring-attributes-commit-assertion.patch added to mm-new branch
Message-Id: <20250722031222.C667BC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/sysfs.py: generalize monitoring attributes commit assertion
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-sysfspy-generalize-monitoring-attributes-commit-assertion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfspy-generalize-monitoring-attributes-commit-assertion.patch

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
Subject: selftests/damon/sysfs.py: generalize monitoring attributes commit assertion
Date: Sun, 20 Jul 2025 10:16:49 -0700

DAMON monitoring attributes commitment assertion is hard-coded for a
specific test case.  Split it out into a general version that can be
reused for different test cases.

Link: https://lkml.kernel.org/r/20250720171652.92309-20-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   42 +++++++++++++----------
 1 file changed, 25 insertions(+), 17 deletions(-)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-generalize-monitoring-attributes-commit-assertion
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -137,6 +137,29 @@ def assert_schemes_committed(schemes, du
     for idx, scheme in enumerate(schemes):
         assert_scheme_committed(scheme, dump[idx])
 
+def assert_monitoring_attrs_committed(attrs, dump):
+    assert_true(dump['sample_interval'] == attrs.sample_us, 'sample_interval',
+                dump)
+    assert_true(dump['aggr_interval'] == attrs.aggr_us, 'aggr_interval', dump)
+    assert_true(dump['intervals_goal']['access_bp'] ==
+                attrs.intervals_goal.access_bp, 'access_bp',
+                dump['intervals_goal'])
+    assert_true(dump['intervals_goal']['aggrs'] == attrs.intervals_goal.aggrs,
+                'aggrs', dump['intervals_goal'])
+    assert_true(dump['intervals_goal']['min_sample_us'] ==
+                attrs.intervals_goal.min_sample_us, 'min_sample_us',
+                dump['intervals_goal'])
+    assert_true(dump['intervals_goal']['max_sample_us'] ==
+                attrs.intervals_goal.max_sample_us, 'max_sample_us',
+                dump['intervals_goal'])
+
+    assert_true(dump['ops_update_interval'] == attrs.update_us,
+                'ops_update_interval', dump)
+    assert_true(dump['min_nr_regions'] == attrs.min_nr_regions,
+                'min_nr_regions', dump)
+    assert_true(dump['max_nr_regions'] == attrs.max_nr_regions,
+                'max_nr_regions', dump)
+
 def main():
     kdamonds = _damon_sysfs.Kdamonds(
             [_damon_sysfs.Kdamond(
@@ -158,23 +181,8 @@ def main():
         fail('number of contexts', status)
 
     ctx = status['contexts'][0]
-    attrs = ctx['attrs']
-    if attrs['sample_interval'] != 5000:
-        fail('sample interval', status)
-    if attrs['aggr_interval'] != 100000:
-        fail('aggr interval', status)
-    if attrs['ops_update_interval'] != 1000000:
-        fail('ops updte interval', status)
-
-    if attrs['intervals_goal'] != {
-            'access_bp': 0, 'aggrs': 0,
-            'min_sample_us': 0, 'max_sample_us': 0}:
-        fail('intervals goal')
-
-    if attrs['min_nr_regions'] != 10:
-        fail('min_nr_regions')
-    if attrs['max_nr_regions'] != 1000:
-        fail('max_nr_regions')
+
+    assert_monitoring_attrs_committed(_damon_sysfs.DamonAttrs(), ctx['attrs'])
 
     if ctx['adaptive_targets'] != [
             { 'pid': 0, 'nr_regions': 0, 'regions_list': []}]:
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


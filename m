Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2976E28BAAB
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 03:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153909; cv=none; b=iQ639bmntRmrMrQU9aPCvRyDDFMJq2+HuPv3xRmt4J9/5fMkQ3aOUn5aIRBgrEch1lLghtw6SOz7/W5R8re5aNFw+SwumEkkVCgcEBxEJzlKmoS1+amUmWjHtTd8gafjGW80MgKi8jhiyGUypshV1kTBNg/DnY+QrlRM7CFYMAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153909; c=relaxed/simple;
	bh=4xfe2mPO+/ZnLSfSWDl+KBdEoiG3T6/uJzWK9wBwoE8=;
	h=Date:To:From:Subject:Message-Id; b=CjVU9azVIlP5WU9AzCHIXWgNfyeJ1FrDhWqjMJQhTJGUhyfhU2rPCj7QrWULsvNN3vIY2zbpfUM3aViyzwacfSThjvwpTW3TdA67S1H7rCRTDO1NZD8xC5p2hcXFDNcqGTfLzzb6P35lOUwPYjHRSsWHaAS5HmRtLCRxrYCwt5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1vocLtCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1vocLtCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3570C4CEED;
	Tue, 22 Jul 2025 03:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753153909;
	bh=4xfe2mPO+/ZnLSfSWDl+KBdEoiG3T6/uJzWK9wBwoE8=;
	h=Date:To:From:Subject:From;
	b=1vocLtCenNxeP/UgxXQGukzKxk6I1cNXE3gtWnYODpRYo2DJRHW//CVM7/S+nJCuE
	 8SLD4XLx3yZetCjR+n9gA5mAHuDkYhtN1toLqBv34U9GolS0Elab9Th+sqjnjsc7a7
	 AA3suVCJ8gGKuO9UWeGCxnwZ/5pmjbD1Pdv/CsKU=
Date: Mon, 21 Jul 2025 20:11:48 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfspy-test-damos-destinations-commitment.patch added to mm-new branch
Message-Id: <20250722031148.F3570C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/sysfs.py: test DAMOS destinations commitment
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-sysfspy-test-damos-destinations-commitment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfspy-test-damos-destinations-commitment.patch

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
Subject: selftests/damon/sysfs.py: test DAMOS destinations commitment
Date: Sun, 20 Jul 2025 10:16:45 -0700

Current DAMOS commitment assertion is not testing quota destinations
commitment.  Add the test.

Link: https://lkml.kernel.org/r/20250720171652.92309-16-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-test-damos-destinations-commitment
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -69,6 +69,13 @@ def assert_quota_committed(quota, dump):
     assert_true(
             dump['weight_age'] == quota.weight_age_permil, 'weight_age', dump)
 
+
+def assert_migrate_dests_committed(dests, dump):
+    assert_true(dump['nr_dests'] == len(dests.dests), 'nr_dests', dump)
+    for idx, dest in enumerate(dests.dests):
+        assert_true(dump['node_id_arr'][idx] == dest.id, 'node_id', dump)
+        assert_true(dump['weight_arr'][idx] == dest.weight, 'weight', dump)
+
 def main():
     kdamonds = _damon_sysfs.Kdamonds(
             [_damon_sysfs.Kdamond(
@@ -132,14 +139,8 @@ def main():
     if scheme['target_nid'] != -1:
         fail('damos target nid', status)
 
-    migrate_dests = scheme['migrate_dests']
-    if migrate_dests['nr_dests'] != 0:
-        fail('nr_dests', status)
-    if migrate_dests['node_id_arr'] != []:
-        fail('node_id_arr', status)
-    if migrate_dests['weight_arr'] != []:
-        fail('weight_arr', status)
-
+    assert_migrate_dests_committed(_damon_sysfs.DamosDests(),
+                                   scheme['migrate_dests'])
     assert_quota_committed(_damon_sysfs.DamosQuota(), scheme['quota'])
     assert_watermarks_committed(_damon_sysfs.DamosWatermarks(),
                                 scheme['wmarks'])
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


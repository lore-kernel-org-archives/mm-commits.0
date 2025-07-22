Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C0128BAA9
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 03:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153898; cv=none; b=FpmYjujezHs8wCYMxrwV3SEgrcReCmmB4bgU+cAGva8xHEvzgzkw5BLlkPBmw2yzbSvDqHpTTkrl05+s4m9tbyKZvOW+4uO2tiL0LMsq4brR3LhQbuZf7S910yMhFU+FOlO/wB9yPKsuO4GiL/MKhT0p/BoPNLceIjitFmQLtbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153898; c=relaxed/simple;
	bh=FKgL3p6v7+P5pCOV4skm9URkwts66KgXf7/Se63PmHY=;
	h=Date:To:From:Subject:Message-Id; b=lPQub2HJbEzuHd5CvKQdExPJEGeanfcyi44gJw8ugegfCxmvoxAqhwQIe4hNVmFQuP2hnlDudEbiLkAfzZvWfr+plR2/jGbhnvmHkhHQu4wn9AP21eVNSdLn0uBwjhp5jlTPdRxqU+OQxlBjS5Ute4NOMyXvmtX0FHDB9Aa0pmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RbZnfLix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RbZnfLix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1470AC4CEED;
	Tue, 22 Jul 2025 03:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753153898;
	bh=FKgL3p6v7+P5pCOV4skm9URkwts66KgXf7/Se63PmHY=;
	h=Date:To:From:Subject:From;
	b=RbZnfLixpHqo+P/tG/UzyUyzVBvGHPgWtZLKXnVa+mKaBHVNgCUCOT79qDgmqiCdY
	 MPPPAhO2qHRGe2gLJWONBN7VBUQq44DpekM1Q6lkxjpQsSr1PS049g/wg/wt0qJ1aU
	 80QVr+X/3JD/4CfyL/GWWtHbxm6p6NcXOhgBmG/s=
Date: Mon, 21 Jul 2025 20:11:37 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-drgn_dump_damon_status-dump-damos-migrate_dests.patch added to mm-new branch
Message-Id: <20250722031138.1470AC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/drgn_dump_damon_status: dump damos->migrate_dests
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-drgn_dump_damon_status-dump-damos-migrate_dests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-drgn_dump_damon_status-dump-damos-migrate_dests.patch

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
Subject: selftests/damon/drgn_dump_damon_status: dump damos->migrate_dests
Date: Sun, 20 Jul 2025 10:16:39 -0700

drgn_dump_damon_status.py is a script for dumping DAMON internal status in
json format.  It is being used for seeing if DAMON parameters that are set
using _damon_sysfs.py are actually passed to DAMON in the kernel space. 
It is, however, not dumping full DAMON internal status, and it makes
increasing test coverage difficult.  Add damos->migrate_dests dumping for
more tests.

Link: https://lkml.kernel.org/r/20250720171652.92309-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/drgn_dump_damon_status.py |   14 ++++++++++
 1 file changed, 14 insertions(+)

--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py~selftests-damon-drgn_dump_damon_status-dump-damos-migrate_dests
+++ a/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -117,6 +117,19 @@ def damos_watermarks_to_dict(watermarks)
         ['high', int], ['mid', int], ['low', int],
         ])
 
+def damos_migrate_dests_to_dict(dests):
+    nr_dests = int(dests.nr_dests)
+    node_id_arr = []
+    weight_arr = []
+    for i in range(nr_dests):
+        node_id_arr.append(int(dests.node_id_arr[i]))
+        weight_arr.append(int(dests.weight_arr[i]))
+    return {
+            'node_id_arr': node_id_arr,
+            'weight_arr': weight_arr,
+            'nr_dests': nr_dests,
+            }
+
 def scheme_to_dict(scheme):
     return to_dict(scheme, [
         ['pattern', damos_access_pattern_to_dict],
@@ -125,6 +138,7 @@ def scheme_to_dict(scheme):
         ['quota', damos_quota_to_dict],
         ['wmarks', damos_watermarks_to_dict],
         ['target_nid', int],
+        ['migrate_dests', damos_migrate_dests_to_dict],
         ])
 
 def schemes_to_list(schemes):
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


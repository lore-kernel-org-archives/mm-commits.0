Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FE128BAA2
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 03:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153902; cv=none; b=Mk0JBXefs3thOWLuD9/9HM8LWIcPxr8Zn0V6u6oDIzCEPq59ZxuN5i+3tMLDVj4qpX4dbuC0pR1DCnLGT8VOfznukD6PK9oTHSwOEmQKoVnQjgkN0ZQDOOpNOivk7hcXoYpi/Xmi3+fzoi6gB/s/wCFxGTC0hyZN/fBofD22qZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153902; c=relaxed/simple;
	bh=z0adlg8jEQ/aaMTxGlb5MTYfWjHPRnUPYeeF+hQNDLk=;
	h=Date:To:From:Subject:Message-Id; b=H462AQbRZtZ5A69lxWCyULXfgMDQVYqATimCNpX7utiDnqdqpz4RL/V393YK10g5mhi6fZeAvBIX4Yz+bZGMAUs2i6ITPiNLR95SN+jB7e+nDBsCY87cWJ60GSJIj6LrVTFSMC0aDrLdztH8QCRHsKaAaEcqGtBKBousstbeSOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XoV5w1Ib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XoV5w1Ib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D60C4CEED;
	Tue, 22 Jul 2025 03:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753153901;
	bh=z0adlg8jEQ/aaMTxGlb5MTYfWjHPRnUPYeeF+hQNDLk=;
	h=Date:To:From:Subject:From;
	b=XoV5w1Ibdj+QP2PP9oyDB7lRcan4Nxz7mgcyH6Mw4kkBvnkmD4Nbrfk9iVnH6dDmV
	 TwpO/hCi0Q8wHIqjV3sJFwx7Vs5EY59j4qHqmJGGKcfgZOyZ9ZvDGLIlCkJJt86nSW
	 C1PvQsAsAzLl+nKbSF5JH5rxL/S9W9WZS4b19UKw=
Date: Mon, 21 Jul 2025 20:11:41 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-drgn_dump_damon_status-dump-damos-filters.patch added to mm-new branch
Message-Id: <20250722031141.B7D60C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/drgn_dump_damon_status: dump DAMOS filters
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-drgn_dump_damon_status-dump-damos-filters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-drgn_dump_damon_status-dump-damos-filters.patch

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
Subject: selftests/damon/drgn_dump_damon_status: dump DAMOS filters
Date: Sun, 20 Jul 2025 10:16:41 -0700

drgn_dump_damon_status.py is a script for dumping DAMON internal status in
json format.  It is being used for seeing if DAMON parameters that are set
using _damon_sysfs.py are actually passed to DAMON in the kernel space. 
It is, however, not dumping full DAMON internal status, and it makes
increasing test coverage difficult.  Add damos filters dumping for more
tests.

Link: https://lkml.kernel.org/r/20250720171652.92309-12-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/drgn_dump_damon_status.py |   43 +++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py~selftests-damon-drgn_dump_damon_status-dump-damos-filters
+++ a/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -135,8 +135,37 @@ def damos_migrate_dests_to_dict(dests):
             'nr_dests': nr_dests,
             }
 
+def damos_filter_to_dict(damos_filter):
+    filter_type_keyword = {
+            0: 'anon',
+            1: 'active',
+            2: 'memcg',
+            3: 'young',
+            4: 'hugepage_size',
+            5: 'unmapped',
+            6: 'addr',
+            7: 'target'
+            }
+    dict_ = {
+            'type': filter_type_keyword[int(damos_filter.type)],
+            'matching': bool(damos_filter.matching),
+            'allow': bool(damos_filter.allow),
+            }
+    type_ = dict_['type']
+    if type_ == 'memcg':
+        dict_['memcg_id'] = int(damos_filter.memcg_id)
+    elif type_ == 'addr':
+        dict_['addr_range'] = [int(damos_filter.addr_range.start),
+                               int(damos_filter.addr_range.end)]
+    elif type_ == 'target':
+        dict_['target_idx'] = int(damos_filter.target_idx)
+    elif type_ == 'hugeapge_size':
+        dict_['sz_range'] = [int(damos_filter.sz_range.min),
+                             int(damos_filter.sz_range.max)]
+    return dict_
+
 def scheme_to_dict(scheme):
-    return to_dict(scheme, [
+    dict_ = to_dict(scheme, [
         ['pattern', damos_access_pattern_to_dict],
         ['action', int],
         ['apply_interval_us', int],
@@ -145,6 +174,18 @@ def scheme_to_dict(scheme):
         ['target_nid', int],
         ['migrate_dests', damos_migrate_dests_to_dict],
         ])
+    filters = []
+    for f in list_for_each_entry(
+            'struct damos_filter', scheme.filters.address_of_(), 'list'):
+        filters.append(damos_filter_to_dict(f))
+    dict_['filters'] = filters
+    ops_filters = []
+    for f in list_for_each_entry(
+            'struct damos_filter', scheme.ops_filters.address_of_(), 'list'):
+        ops_filters.append(damos_filter_to_dict(f))
+    dict_['ops_filters'] = ops_filters
+
+    return dict_
 
 def schemes_to_list(schemes):
     return [scheme_to_dict(s)
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


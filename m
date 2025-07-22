Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E38E28BAA2
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 03:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153900; cv=none; b=JFqQu0HdMrRYdmDUfrmfNOLo7s0z3irDkOU2sXr/zbAPHjNWgcmJrNw4OcYRvi4sztm+7TrSNdOz+s3jLA+hjF3Eox5CpOjuCg1c5oNLtM4C2U4Zpb5xcGmQC4SCk9UPOk2cyrroRYlCmwmgBgB1aQqg039YWuOvgbB1bDMgxRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153900; c=relaxed/simple;
	bh=AZyoqtOGVtXIfKPl+c+FmhxQ3Z6xy4DZM+2B9TSwEv0=;
	h=Date:To:From:Subject:Message-Id; b=HfhaOvGCZv5HxqLzt4bLR8xBKwtLJE65MV+Ld968jJCWpYgXPO81VpoB9h/tS0LwW3lKNIqdXQQiqUahkO0b/nT2pqH/Q32Y+l6g0xkL7XzDbzc+rDVxsPgEAZkYFAk0vqIL4kInoUmUtl9kuX9Rhny7ZLbba/rV/PCgNVyNyCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IfEUZIPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IfEUZIPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5D3C4CEED;
	Tue, 22 Jul 2025 03:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753153899;
	bh=AZyoqtOGVtXIfKPl+c+FmhxQ3Z6xy4DZM+2B9TSwEv0=;
	h=Date:To:From:Subject:From;
	b=IfEUZIPd/eCsgfZV+7lLwR9E0hwQdn7PiqrV32uxRq99UT/wQgYVlTiGlEEQpDE6r
	 1lLh2auU1IUsLLpeWDsjHMkJQ0beE9cOA77+WH3yc0QyYAb7YB+mrsPtRVCUiR5YtB
	 ZRmArqsnshe0zd/YQla909jP+dE1gBpSX6WKzXTg=
Date: Mon, 21 Jul 2025 20:11:39 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-drgn_dump_damon_status-dump-ctx-opsid.patch added to mm-new branch
Message-Id: <20250722031139.DD5D3C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/drgn_dump_damon_status: dump ctx->ops.id
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-drgn_dump_damon_status-dump-ctx-opsid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-drgn_dump_damon_status-dump-ctx-opsid.patch

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
Subject: selftests/damon/drgn_dump_damon_status: dump ctx->ops.id
Date: Sun, 20 Jul 2025 10:16:40 -0700

drgn_dump_damon_status.py is a script for dumping DAMON internal status in
json format.  It is being used for seeing if DAMON parameters that are set
using _damon_sysfs.py are actually passed to DAMON in the kernel space. 
It is, however, not dumping full DAMON internal status, and it makes
increasing test coverage difficult.  Add ctx->ops.id dumping for more
tests.

Link: https://lkml.kernel.org/r/20250720171652.92309-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/drgn_dump_damon_status.py |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py~selftests-damon-drgn_dump_damon_status-dump-ctx-opsid
+++ a/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -25,6 +25,11 @@ def to_dict(object, attr_name_converter)
         d[attr_name] = converter(getattr(object, attr_name))
     return d
 
+def ops_to_dict(ops):
+    return to_dict(ops, [
+        ['id', int],
+        ])
+
 def intervals_goal_to_dict(goal):
     return to_dict(goal, [
         ['access_bp', int],
@@ -148,6 +153,7 @@ def schemes_to_list(schemes):
 
 def damon_ctx_to_dict(ctx):
     return to_dict(ctx, [
+        ['ops', ops_to_dict],
         ['attrs', attrs_to_dict],
         ['adaptive_targets', targets_to_list],
         ['schemes', schemes_to_list],
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


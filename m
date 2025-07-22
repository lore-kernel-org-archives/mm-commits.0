Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3975728BA9D
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 03:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153945; cv=none; b=oGP04BBOzpmXCFLySdxdrblynV/7cJkn8nPp94e7hv48dH4+AmZBNiKWIdBJs5Pbu9ZzNPCemEakAgMh9yku6zwAzDiTol3W5WLR17bOm5BCT/SB4ZSsMrXJxzJ78OPXUTF+6xs6FU325zvaqobfe/gu18pRVAlrG/KuLfai4p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153945; c=relaxed/simple;
	bh=xRRKv6Ld6MAUt9XrrcCAECLAFlZ/mdi8mToxkDc8xlQ=;
	h=Date:To:From:Subject:Message-Id; b=HufyukSFZUwLworE5J/UmuOPPhpE1/L9LCsDJRGFDEsFAydk449ALc7WcHoq8aely9Y4pmyoQY/Mqfp8yrn2uDt1CNCVvOkvbYFSR1kLu64Hfd2I9RccOiZmhViP4zm7cGu+gGuHEmkosxqP4C0gptS6EDqoVtxPkxSOCRlsSCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MtkvbJHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MtkvbJHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7CE9C4CEED;
	Tue, 22 Jul 2025 03:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753153944;
	bh=xRRKv6Ld6MAUt9XrrcCAECLAFlZ/mdi8mToxkDc8xlQ=;
	h=Date:To:From:Subject:From;
	b=MtkvbJHB/JPtRmdhHVGtZL6U4ZfSLFA5HCSqk2JWMr04esaGUo49+wNdgCHE8PQ9J
	 B8W8M7Vj1ei42qVi8Bni67eWRlySHIwmKlp4q/BBWOmDKIrLh5yg2bOwM9k1sM1aa9
	 Hwn6MsWTfCGR37tnibAnKQSozG8ElrzP8wDqtYLc=
Date: Mon, 21 Jul 2025 20:12:24 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfspy-generalize-damon-context-commit-assertion.patch added to mm-new branch
Message-Id: <20250722031224.A7CE9C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/sysfs.py: generalize DAMON context commit assertion
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-sysfspy-generalize-damon-context-commit-assertion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfspy-generalize-damon-context-commit-assertion.patch

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
Subject: selftests/damon/sysfs.py: generalize DAMON context commit assertion
Date: Sun, 20 Jul 2025 10:16:50 -0700

DAMON context commitment assertion is hard-coded for a specific test case.
Split it out into a general version that can be reused for different test
cases.

Link: https://lkml.kernel.org/r/20250720171652.92309-21-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   28 +++++++++++++----------
 1 file changed, 16 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-generalize-damon-context-commit-assertion
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -160,6 +160,21 @@ def assert_monitoring_attrs_committed(at
     assert_true(dump['max_nr_regions'] == attrs.max_nr_regions,
                 'max_nr_regions', dump)
 
+def assert_ctx_committed(ctx, dump):
+    ops_val = {
+            'vaddr': 0,
+            'fvaddr': 1,
+            'paddr': 2,
+            }
+    assert_true(dump['ops']['id'] == ops_val[ctx.ops], 'ops_id', dump)
+    assert_monitoring_attrs_committed(ctx.monitoring_attrs, dump['attrs'])
+    assert_schemes_committed(ctx.schemes, dump['schemes'])
+
+def assert_ctxs_committed(ctxs, dump):
+    assert_true(len(ctxs) == len(dump), 'ctxs length', dump)
+    for idx, ctx in enumerate(ctxs):
+        assert_ctx_committed(ctx, dump[idx])
+
 def main():
     kdamonds = _damon_sysfs.Kdamonds(
             [_damon_sysfs.Kdamond(
@@ -177,18 +192,7 @@ def main():
         print(err)
         exit(1)
 
-    if len(status['contexts']) != 1:
-        fail('number of contexts', status)
-
-    ctx = status['contexts'][0]
-
-    assert_monitoring_attrs_committed(_damon_sysfs.DamonAttrs(), ctx['attrs'])
-
-    if ctx['adaptive_targets'] != [
-            { 'pid': 0, 'nr_regions': 0, 'regions_list': []}]:
-        fail('adaptive targets', status)
-
-    assert_schemes_committed([_damon_sysfs.Damos()], ctx['schemes'])
+    assert_ctxs_committed(kdamonds.kdamonds[0].contexts, status['contexts'])
 
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914B31EF38E
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450025; cv=none; b=eoftkBD/WfDIwpA1/uEWMmHwtNEd7ukuCKIqQEyexJloOwQCMsC6fd7WbL8+TVBPNAqrSJ8H/E4xrDQFQor91HdUS6kH9gbATEl85gP04Dqv18o692kmLF6pHgga6G+xt3Enk/A5Fmt9qMkY5Hf0ke2R5kqTXllNjlx2NmTdvVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450025; c=relaxed/simple;
	bh=HJZvf49BcXgBDpxG0AXvrygbekD6btWsfkR2bAah7Mw=;
	h=Date:To:From:Subject:Message-Id; b=aXOcX1Bz2DUW47KDR+8gahPSHH84RowCpuN0o94v6IxWJMwTFNsNBBA4XEurjZybV7/hDf28Jc/NQ5IFKHGnXsY4HJRIg/2r6+xxyxNynpVtmbRQWiNImCBuJkgHl8OsxBpwRpJ00qJTLKqnezQrLqVsYwA/NRJkeAB9mOOb+08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zGaCifN6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zGaCifN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6499AC4CEE3;
	Sun, 13 Jul 2025 23:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450025;
	bh=HJZvf49BcXgBDpxG0AXvrygbekD6btWsfkR2bAah7Mw=;
	h=Date:To:From:Subject:From;
	b=zGaCifN6/CgVqFZ5FfXhj9ZpDXSppXWxQF8Kb5CFSv1b+3ZDDsf6hgNhA1poBPsiS
	 ylX3EFX+rlvw+pcjjsH+krKP+eLXunhGjuF+fd3MGeI4+trSU52GuI6r/PMTTVZ/wF
	 ICjXi5Dxw4WqDOpxBq9wBjdl031pUr/VJKv39+5Q=
Date: Sun, 13 Jul 2025 16:40:24 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-add-drgn-script-for-extracting-damon-status.patch removed from -mm tree
Message-Id: <20250713234025.6499AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: add drgn script for extracting damon status
has been removed from the -mm tree.  Its filename was
     selftests-damon-add-drgn-script-for-extracting-damon-status.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: add drgn script for extracting damon status
Date: Sat, 28 Jun 2025 09:04:23 -0700

Patch series "selftests/damon: add python and drgn based DAMON sysfs
functionality tests".

DAMON sysfs interface is the bridge between the user space and the kernel
space for DAMON parameters.  There is no good and simple test to see if
the parameters are set as expected.  Existing DAMON selftests therefore
test end-to-end features.  For example, damos_quota_goal.py runs a DAMOS
scheme with quota goal set against a test program running an artificial
access pattern, and see if the result is as expected.  Such tests cover
only a few part of DAMON.  Adding more tests is also complicated. 
Finally, the reliability of the test itself on different systems is bad.

'drgn' is a tool that can extract kernel internal data structures like
DAMON parameters.  Add a test that passes specific DAMON parameters via
DAMON sysfs reusing _damon_sysfs.py, extract resulting DAMON parameters
via 'drgn', and compare those.  Note that this test is not adding
exhaustive tests of all DAMON parameters and input combinations but very
basic things.  Advancing the test infrastructure and adding more tests are
future works.


This patch (of 6):

'drgn' is a useful tool for extracting kernel internal data structures
such as DAMON's parameter and running status.  Add a 'drgn' script that
extracts such DAMON internal data at runtime, for using it as a tool for
seeing if a test input has made expected results in the kernel.

The script saves or prints out the DAMON internal data as a json file or
string.  This is for making use of it not very depends on 'drgn'.  If
'drgn' is not available on a test setup and we find alternative tools for
doing that, the json-based tests can be updated to use an alternative tool
in future.

Note that the script is tested with 'drgn v0.0.22'.

Link: https://lkml.kernel.org/r/20250628160428.53115-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250628160428.53115-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/drgn_dump_damon_status.py |  161 ++++++++++
 1 file changed, 161 insertions(+)

diff --git a/tools/testing/selftests/damon/drgn_dump_damon_status.py a/tools/testing/selftests/damon/drgn_dump_damon_status.py
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -0,0 +1,161 @@
+#!/usr/bin/env drgn
+# SPDX-License-Identifier: GPL-2.0
+
+'''
+Read DAMON context data and dump as a json string.
+'''
+import drgn
+from drgn import FaultError, NULL, Object, cast, container_of, execscript, offsetof, reinterpret, sizeof
+from drgn.helpers.common import *
+from drgn.helpers.linux import *
+
+import json
+import sys
+
+if "prog" not in globals():
+    try:
+        prog = drgn.get_default_prog()
+    except drgn.NoDefaultProgramError:
+        prog = drgn.program_from_kernel()
+        drgn.set_default_prog(prog)
+
+def to_dict(object, attr_name_converter):
+    d = {}
+    for attr_name, converter in attr_name_converter:
+        d[attr_name] = converter(getattr(object, attr_name))
+    return d
+
+def intervals_goal_to_dict(goal):
+    return to_dict(goal, [
+        ['access_bp', int],
+        ['aggrs', int],
+        ['min_sample_us', int],
+        ['max_sample_us', int],
+        ])
+
+def attrs_to_dict(attrs):
+    return to_dict(attrs, [
+        ['sample_interval', int],
+        ['aggr_interval', int],
+        ['ops_update_interval', int],
+        ['intervals_goal', intervals_goal_to_dict],
+        ['min_nr_regions', int],
+        ['max_nr_regions', int],
+        ])
+
+def addr_range_to_dict(addr_range):
+    return to_dict(addr_range, [
+        ['start', int],
+        ['end', int],
+        ])
+
+def region_to_dict(region):
+    return to_dict(region, [
+        ['ar', addr_range_to_dict],
+        ['sampling_addr', int],
+        ['nr_accesses', int],
+        ['nr_accesses_bp', int],
+        ['age', int],
+        ])
+
+def regions_to_list(regions):
+    return [region_to_dict(r)
+            for r in list_for_each_entry(
+                'struct damon_region', regions.address_of_(), 'list')]
+
+def target_to_dict(target):
+    return to_dict(target, [
+        ['pid', int],
+        ['nr_regions', int],
+        ['regions_list', regions_to_list],
+        ])
+
+def targets_to_list(targets):
+    return [target_to_dict(t)
+            for t in list_for_each_entry(
+                'struct damon_target', targets.address_of_(), 'list')]
+
+def damos_access_pattern_to_dict(pattern):
+    return to_dict(pattern, [
+        ['min_sz_region', int],
+        ['max_sz_region', int],
+        ['min_nr_accesses', int],
+        ['max_nr_accesses', int],
+        ['min_age_region', int],
+        ['max_age_region', int],
+        ])
+
+def damos_quota_goal_to_dict(goal):
+    return to_dict(goal, [
+        ['metric', int],
+        ['target_value', int],
+        ['current_value', int],
+        ['last_psi_total', int],
+        ['nid', int],
+        ])
+
+def damos_quota_goals_to_list(goals):
+    return [damos_quota_goal_to_dict(g)
+            for g in list_for_each_entry(
+                'struct damos_quota_goal', goals.address_of_(), 'list')]
+
+def damos_quota_to_dict(quota):
+    return to_dict(quota, [
+        ['reset_interval', int],
+        ['ms', int], ['sz', int],
+        ['goals', damos_quota_goals_to_list],
+        ['esz', int],
+        ['weight_sz', int],
+        ['weight_nr_accesses', int],
+        ['weight_age', int],
+        ])
+
+def damos_watermarks_to_dict(watermarks):
+    return to_dict(watermarks, [
+        ['metric', int],
+        ['interval', int],
+        ['high', int], ['mid', int], ['low', int],
+        ])
+
+def scheme_to_dict(scheme):
+    return to_dict(scheme, [
+        ['pattern', damos_access_pattern_to_dict],
+        ['action', int],
+        ['apply_interval_us', int],
+        ['quota', damos_quota_to_dict],
+        ['wmarks', damos_watermarks_to_dict],
+        ['target_nid', int],
+        ])
+
+def schemes_to_list(schemes):
+    return [scheme_to_dict(s)
+            for s in list_for_each_entry(
+                'struct damos', schemes.address_of_(), 'list')]
+
+def damon_ctx_to_dict(ctx):
+    return to_dict(ctx, [
+        ['attrs', attrs_to_dict],
+        ['adaptive_targets', targets_to_list],
+        ['schemes', schemes_to_list],
+        ])
+
+def main():
+    if len(sys.argv) < 3:
+        print('Usage: %s <kdamond pid> <file>' % sys.argv[0])
+        exit(1)
+
+    pid = int(sys.argv[1])
+    file_to_store = sys.argv[2]
+
+    kthread_data = cast('struct kthread *',
+                        find_task(prog, pid).worker_private).data
+    ctx = cast('struct damon_ctx *', kthread_data)
+    status = {'contexts': [damon_ctx_to_dict(ctx)]}
+    if file_to_store == 'stdout':
+        print(json.dumps(status, indent=4))
+    else:
+        with open(file_to_store, 'w') as f:
+            json.dump(status, f, indent=4)
+
+if __name__ == '__main__':
+    main()
_

Patches currently in -mm which might be from sj@kernel.org are

samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch
samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch
samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch
mm-damon-sysfs-use-damon-core-api-damon_is_running.patch
mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch
docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch
mm-damon-add-struct-damos_migrate_dests.patch
mm-damon-core-add-damos-migrate_dests-field.patch
mm-damon-sysfs-schemes-implement-damos-action-destinations-directory.patch
mm-damon-sysfs-schemes-set-damos-migrate_dests.patch
docs-abi-damon-document-schemes-dests-directory.patch
docs-admin-guide-mm-damon-usage-document-dests-directory.patch
mm-damon-accept-parallel-damon_call-requests.patch
mm-damon-core-introduce-repeat-mode-damon_call.patch
mm-damon-stat-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-reclaim-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-lru_sort-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-prcl-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-wsse-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-core-do-not-call-opscleanup-when-destroying-targets.patch
mm-damon-core-add-cleanup_target-ops-callback.patch
mm-damon-vaddr-put-pid-in-cleanup_target.patch
mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch
mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch
mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch
mm-damon-core-remove-damon_callback.patch


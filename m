Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB61B21A428
	for <mm-commits@vger.kernel.org>; Sun, 29 Jun 2025 22:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751237275; cv=none; b=TSDcW3f70BdYT1eMfk0aEWrUpyUtjEB/e17RpE4sEgsPfo3L8QUUCxP7Owd6ZwQkIy49gdJuKEftrJdxjCe2JjLL0xh+AOs5N9YZLjEILBpEHaX4RtDoemhH9yYEYZqDEUWkZp51GcpKX1cesMxB92uhshQk9l9i9/gmGSYa73k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751237275; c=relaxed/simple;
	bh=8CmNj/inannMVN5saCGGeN0jjwBCGo8Sw2kg1RR+Rvo=;
	h=Date:To:From:Subject:Message-Id; b=VNEZDyLTElYTmVQtU3ApMwycJQRFadA+BI8ak68N9f2ByC5oK3PKzTYjQs+eTc8jeHfwgIeuL2Lj4Bz/zWyEoVtQsD/0RB2DZVExA/zePTPiu8NFpjChna7Pk/1a8Z33S9S9i2v8YJNJw8H4jaq7SzM7XMzY6KDRnzVBrBOBpUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r4zC2ePi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r4zC2ePi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44577C4CEEB;
	Sun, 29 Jun 2025 22:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751237275;
	bh=8CmNj/inannMVN5saCGGeN0jjwBCGo8Sw2kg1RR+Rvo=;
	h=Date:To:From:Subject:From;
	b=r4zC2ePiBHNGM4ce9J1Mu6NED3yTY8TsoyHKbQblq2QVyHpVqY918YB1OKGuuYBnY
	 AQIQXnXegfR8g11OTvs5a0eGdOrrza/IKXK8mlzcojuysdg2ymJL0vj/W1zEhktjMe
	 axRANZrRb5ph9MA7ysBJ9mIy/uEojsOXXPEDQFzE=
Date: Sun, 29 Jun 2025 15:47:54 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-add-drgn-script-for-extracting-damon-status.patch added to mm-new branch
Message-Id: <20250629224755.44577C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: add drgn script for extracting damon status
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-add-drgn-script-for-extracting-damon-status.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-add-drgn-script-for-extracting-damon-status.patch

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

mm-damon-core-handle-damon_call_control-as-normal-under-kdmond-deactivation.patch
mm-damon-introduce-damon_stat-module.patch
mm-damon-introduce-damon_stat-module-fix.patch
mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch
mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch
docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch
mm-damon-paddr-use-alloc_migartion_target-with-no-migration-fallback-nodemask.patch
revert-mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch
revert-mm-make-alloc_demote_folio-externally-invokable-for-migration.patch
selftets-damon-add-a-test-for-memcg_path-leak.patch
mm-damon-sysfs-schemes-decouple-from-damos_quota_goal_metric.patch
mm-damon-sysfs-schemes-decouple-from-damos_action.patch
mm-damon-sysfs-schemes-decouple-from-damos_wmark_metric.patch
mm-damon-sysfs-schemes-decouple-from-damos_filter_type.patch
mm-damon-sysfs-decouple-from-damon_ops_id.patch
selftests-damon-add-drgn-script-for-extracting-damon-status.patch
selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch
selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch
selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch
selftests-damon-sysfspy-test-adaptive-targets-parameter.patch
selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch


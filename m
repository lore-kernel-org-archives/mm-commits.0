Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854D71DE885
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567810; cv=none; b=GCL3LLgFaHS3W3jKmBnpKeeukxFlg6gVzI/wXuWrUQ3XLxs9rodIrixQ51O4/+6AoQcvtuewz6d53MfovtpwnOoHRJ1H3XYqfrxNfCqdyYG+7dRnvN9/9NYnTq4Vf364nMsmoxfzSo0ZQGG9F+4kOsdVcQVp4IGqvB4VBStRS9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567810; c=relaxed/simple;
	bh=peiwPhosB1yK5NcjCr5h6F8cMeaYhj0FEJgx/04GguM=;
	h=Date:To:From:Subject:Message-Id; b=ak1ZW1vFx2EzGpsBeNgPJW9aTioJMXzShF3i/1QuUzBMV1cbQJmdfqHEpdsb6HNMMZlGjIlT8V3hZwmx6m42T4TODU0RbzPgFQY6BJrxCYWBAwqnejqM7La2Sb7vKCRdvmEWVssju5ZL5/rvc4ZzllLOf6ERaiMHEl2X4ipnuXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NlnD8wXb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NlnD8wXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FF0C4CEED;
	Sat, 26 Jul 2025 22:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567809;
	bh=peiwPhosB1yK5NcjCr5h6F8cMeaYhj0FEJgx/04GguM=;
	h=Date:To:From:Subject:From;
	b=NlnD8wXbO2A594sEI9+lIIkHHG2HkdClvfslujLl18MHd+K4HXwE7Yhrd6MXNEly/
	 XbfCvLUSdpdr6s+3nkMArciZanvda5bCoVbrzEazDDqUnR2XsLrYfET8OCmErL7IKE
	 bNIENEQAoE/A7GaW4NvIygafp2zI5/Shu/dy5cx0=
Date: Sat, 26 Jul 2025 15:10:09 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_damon_sysfs-support-damos-quota-weights-setup.patch removed from -mm tree
Message-Id: <20250726221009.D2FF0C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_damon_sysfs: support DAMOS quota weights setup
has been removed from the -mm tree.  Its filename was
     selftests-damon-_damon_sysfs-support-damos-quota-weights-setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/_damon_sysfs: support DAMOS quota weights setup
Date: Sun, 20 Jul 2025 10:16:34 -0700

_damon_sysfs.py contains code for test-purpose DAMON sysfs interface
control.  Add support of DAMOS quotas prioritization weights setup for
more tests.

Link: https://lkml.kernel.org/r/20250720171652.92309-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |   24 +++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-support-damos-quota-weights-setup
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -125,12 +125,20 @@ class DamosQuota:
     ms = None                   # time quota
     goals = None                # quota goals
     reset_interval_ms = None    # quota reset interval
+    weight_sz_permil = None
+    weight_nr_accesses_permil = None
+    weight_age_permil = None
     scheme = None               # owner scheme
 
-    def __init__(self, sz=0, ms=0, goals=None, reset_interval_ms=0):
+    def __init__(self, sz=0, ms=0, goals=None, reset_interval_ms=0,
+                 weight_sz_permil=0, weight_nr_accesses_permil=0,
+                 weight_age_permil=0):
         self.sz = sz
         self.ms = ms
         self.reset_interval_ms = reset_interval_ms
+        self.weight_sz_permil = weight_sz_permil
+        self.weight_nr_accesses_permil = weight_nr_accesses_permil
+        self.weight_age_permil = weight_age_permil
         self.goals = goals if goals is not None else []
         for idx, goal in enumerate(self.goals):
             goal.idx = idx
@@ -151,6 +159,20 @@ class DamosQuota:
         if err is not None:
             return err
 
+        err = write_file(os.path.join(
+            self.sysfs_dir(), 'weights', 'sz_permil'), self.weight_sz_permil)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(
+            self.sysfs_dir(), 'weights', 'nr_accesses_permil'),
+                         self.weight_nr_accesses_permil)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(
+            self.sysfs_dir(), 'weights', 'age_permil'), self.weight_age_permil)
+        if err is not None:
+            return err
+
         nr_goals_file = os.path.join(self.sysfs_dir(), 'goals', 'nr_goals')
         content, err = read_file(nr_goals_file)
         if err is not None:
_

Patches currently in -mm which might be from sj@kernel.org are



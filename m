Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B8122333B
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567811; cv=none; b=jg584vAW+6vGMwKhCeCiVrbFg9SA69FIbkm6HfSj1bVlXWIvW/QSNgGR8G/1psuc4N0zbvzxOxvECpKPdltjdPTNmcF4VGIUiMkDWHsat56t+7IzLh65wvo0+fEHFxpkebwvgBuNkzOSKAnf9MQcQDM82O7AsDPsn+MAzjL1WVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567811; c=relaxed/simple;
	bh=4po68Qm2qvjJDxanFKEkvkcL0WCD7csfCFI1NO1pfOY=;
	h=Date:To:From:Subject:Message-Id; b=XEsGlROZSuIdOVS2VaJU5cqEO5Zr6/QoI9WGRc0yU+UCUmAT/GrV21D8QazjHzVRK6V0aGtcNfM9OW4I9sBj3y8YXn9HYRqNqaf2osq9xOZoEPG8tRnr76q4j8t1IKeyWpKilimaz6i8VNYLFqDOX23BRJTT/9H12d0Nn11KMqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ii1Dd4i1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ii1Dd4i1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E05BC4CEF4;
	Sat, 26 Jul 2025 22:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567811;
	bh=4po68Qm2qvjJDxanFKEkvkcL0WCD7csfCFI1NO1pfOY=;
	h=Date:To:From:Subject:From;
	b=Ii1Dd4i1C1pL8uAR9Oor1JOr+Pg4XM2ZKg8BQThOnIy0nMrt8XV3Hh71ShZHwBL6Z
	 jhILz+xiQf332AlI0CgCHA0dg++hV9NcmVmGjDLp+5MRrpbdD3FVVPjjAbeW6l3RH+
	 xwpQEMmOiIghAtL+QIT4NWt9/ofO0NGzU7zEX9ss=
Date: Sat, 26 Jul 2025 15:10:10 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_damon_sysfs-support-damos-quota-goal-nid-setup.patch removed from -mm tree
Message-Id: <20250726221011.0E05BC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_damon_sysfs: support DAMOS quota goal nid setup
has been removed from the -mm tree.  Its filename was
     selftests-damon-_damon_sysfs-support-damos-quota-goal-nid-setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/_damon_sysfs: support DAMOS quota goal nid setup
Date: Sun, 20 Jul 2025 10:16:35 -0700

_damon_sysfs.py contains code for test-purpose DAMON sysfs interface
control.  Add support of DAMOS quota goal nid setup for more tests.

Link: https://lkml.kernel.org/r/20250720171652.92309-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-support-damos-quota-goal-nid-setup
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -93,14 +93,16 @@ class DamosQuotaGoal:
     metric = None
     target_value = None
     current_value = None
+    nid = None
     effective_bytes = None
     quota = None            # owner quota
     idx = None
 
-    def __init__(self, metric, target_value=10000, current_value=0):
+    def __init__(self, metric, target_value=10000, current_value=0, nid=0):
         self.metric = metric
         self.target_value = target_value
         self.current_value = current_value
+        self.nid = nid
 
     def sysfs_dir(self):
         return os.path.join(self.quota.sysfs_dir(), 'goals', '%d' % self.idx)
@@ -118,6 +120,10 @@ class DamosQuotaGoal:
                          self.current_value)
         if err is not None:
             return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'nid'), self.nid)
+        if err is not None:
+            return err
+
         return None
 
 class DamosQuota:
_

Patches currently in -mm which might be from sj@kernel.org are



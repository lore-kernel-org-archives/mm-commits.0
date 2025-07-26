Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B6122333B
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567813; cv=none; b=byRSRcwnufQaUMYzcpsurrqBCBvIHRSPTsw+QE6m49z0YDktU1AebfbKVojQC/bGLRHQ9CghFKhR+9IYzP/2HHedRjoqKhuLJnaXyyEVxc8GRYvS+gJ7XA4GOww+a+neW8dqNMuz0VG39atqd3c58JqE7fnGHW4GZ4XfnadSlBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567813; c=relaxed/simple;
	bh=Q17vUcb8UPkkXFdp6gXDqtrCemRIipJb83ukF82GG8A=;
	h=Date:To:From:Subject:Message-Id; b=dK/7uuK6c67+zR7hAC9Mrl61xEFUPLvke8nmqzL7lEbN1FFxpHYjEN5ZPjTUdV46hkMBQJgncovENxvyx2dj/OBT6GiO2bHa8v6pRHM5udhJEultyTH3PJdLqrVnuJ8mfGI1gB7RPnX3H/BdZBME9cYXjmTi4jfSW9YzjP32b0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rh6v8SPm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rh6v8SPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AEF6C4CEED;
	Sat, 26 Jul 2025 22:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567813;
	bh=Q17vUcb8UPkkXFdp6gXDqtrCemRIipJb83ukF82GG8A=;
	h=Date:To:From:Subject:From;
	b=Rh6v8SPmOJ4zqz+gly5bHbynGnxES8B3Ncgl9ueHQUfrbPVW9hyREWFh6cG8ufJq1
	 IpOV1lP6J1XsGM0fOuAIFuS5nrBh8ZQX2oSiDnAonroD2Le6eCh4HINDwMzEvg70jC
	 naQZpdBbMEJibljTicmqONYG19MG7OcMGdxjFMso=
Date: Sat, 26 Jul 2025 15:10:12 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_damon_sysfs-support-damos-target_nid-setup.patch removed from -mm tree
Message-Id: <20250726221013.4AEF6C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_damon_sysfs: support DAMOS target_nid setup
has been removed from the -mm tree.  Its filename was
     selftests-damon-_damon_sysfs-support-damos-target_nid-setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/_damon_sysfs: support DAMOS target_nid setup
Date: Sun, 20 Jul 2025 10:16:37 -0700

_damon_sysfs.py contains code for test-purpose DAMON sysfs interface
control.  Add support of DAMOS action destination target_nid setup for
more tests.

Link: https://lkml.kernel.org/r/20250720171652.92309-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-support-damos-target_nid-setup
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -395,6 +395,7 @@ class Damos:
     ops_filters = None
     filters = None
     apply_interval_us = None
+    target_nid = None
     dests = None
     idx = None
     context = None
@@ -404,7 +405,7 @@ class Damos:
 
     def __init__(self, action='stat', access_pattern=DamosAccessPattern(),
                  quota=DamosQuota(), watermarks=DamosWatermarks(),
-                 core_filters=[], ops_filters=[], filters=[],
+                 core_filters=[], ops_filters=[], filters=[], target_nid=0,
                  dests=DamosDests(), apply_interval_us=0):
         self.action = action
         self.access_pattern = access_pattern
@@ -423,6 +424,7 @@ class Damos:
         self.filters = DamosFilters(name='filters', filters=filters)
         self.filters.scheme = self
 
+        self.target_nid = target_nid
         self.dests = dests
         self.dests.scheme = self
 
@@ -462,6 +464,11 @@ class Damos:
         if err is not None:
             return err
 
+        err = write_file(os.path.join(self.sysfs_dir(), 'target_nid'), '%d' %
+                         self.target_nid)
+        if err is not None:
+            return err
+
         err = self.dests.stage()
         if err is not None:
             return err
_

Patches currently in -mm which might be from sj@kernel.org are



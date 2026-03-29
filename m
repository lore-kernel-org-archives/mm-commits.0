Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1941C25B2FA
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744875; cv=none; b=q8odwQvvkZ4BdoKYoLUy79d4PJjvOYGiFy92SEPizhbb3KPkwyvor4Zzmet6O+J3mM8VyRtzMX3n+6FGB57tZra+Vgb7praK6iBC29MV6uUYuS6JZ8QC/D4EocjC2IlXxr0H2buKlT+X7zaVLtQCISUW/qgNx0NnfYGahmQf7iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744875; c=relaxed/simple;
	bh=TomM1sgvlQXrA9QZxEgOzGOyBueIUCDJJPuW3A15fbk=;
	h=Date:To:From:Subject:Message-Id; b=dgdz+sdUaGEtj4sUptkN41xTEjwcxofFHVg/CItuIJl5ETbfN31dz2O1ygAI5TVW9mYZk0JTtvuNIb7+KjXus2/xp0OQTjan8rZifJahL7Q5fR0mCTTQhGO6S7iPRFHZUj13a0e9goGgCgpzKQy7TM4j2wAAmtQIBIirKtGfn44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gS7fJNwy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gS7fJNwy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5184C4CEF7;
	Sun, 29 Mar 2026 00:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744875;
	bh=TomM1sgvlQXrA9QZxEgOzGOyBueIUCDJJPuW3A15fbk=;
	h=Date:To:From:Subject:From;
	b=gS7fJNwyP+Ft+VVm29HnWYqUaIi2GXbCdmcUblIwFDN3178VEnt+s9lFgS3sh7x07
	 8nsLIjVtntsGMVKwRD+Om+Y2/yCHsDaxRZQpWS3g096wKOkFqiOYRpwQwv6drPRE2f
	 bg3Uem9LmUUodiqc3GKDIZIdBdA4bOyANY19hfyc=
Date: Sat, 28 Mar 2026 17:41:14 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_damon_sysfs-support-goal_tuner-setup.patch removed from -mm tree
Message-Id: <20260329004114.E5184C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_damon_sysfs: support goal_tuner setup
has been removed from the -mm tree.  Its filename was
     selftests-damon-_damon_sysfs-support-goal_tuner-setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/_damon_sysfs: support goal_tuner setup
Date: Mon, 9 Mar 2026 18:05:25 -0700

Add support of goal_tuner setup to the test-purpose DAMON sysfs interface
control helper, _damon_sysfs.py.

Link: https://lkml.kernel.org/r/20260310010529.91162-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-support-goal_tuner-setup
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -130,15 +130,16 @@ class DamosQuota:
     sz = None                   # size quota, in bytes
     ms = None                   # time quota
     goals = None                # quota goals
+    goal_tuner = None           # quota goal tuner
     reset_interval_ms = None    # quota reset interval
     weight_sz_permil = None
     weight_nr_accesses_permil = None
     weight_age_permil = None
     scheme = None               # owner scheme
 
-    def __init__(self, sz=0, ms=0, goals=None, reset_interval_ms=0,
-                 weight_sz_permil=0, weight_nr_accesses_permil=0,
-                 weight_age_permil=0):
+    def __init__(self, sz=0, ms=0, goals=None, goal_tuner='consist',
+                 reset_interval_ms=0, weight_sz_permil=0,
+                 weight_nr_accesses_permil=0, weight_age_permil=0):
         self.sz = sz
         self.ms = ms
         self.reset_interval_ms = reset_interval_ms
@@ -146,6 +147,7 @@ class DamosQuota:
         self.weight_nr_accesses_permil = weight_nr_accesses_permil
         self.weight_age_permil = weight_age_permil
         self.goals = goals if goals is not None else []
+        self.goal_tuner = goal_tuner
         for idx, goal in enumerate(self.goals):
             goal.idx = idx
             goal.quota = self
@@ -191,6 +193,10 @@ class DamosQuota:
             err = goal.stage()
             if err is not None:
                 return err
+        err = write_file(
+                os.path.join(self.sysfs_dir(), 'goal_tuner'), self.goal_tuner)
+        if err is not None:
+            return err
         return None
 
 class DamosWatermarks:
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch


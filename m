Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FC08BF9
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560206; cv=none; b=QIASod3EP6XW2efnVWx5+ModeoZCK0tr9CUoVG4Pry9PR6exCGk5qFB+m8OY6nO85HTcmUaRJ1lPjJh1Ffs6d/MjK0XeGCSz4sBGKSe+gWRrLld1xs9PfNnulCFMZwIfHFiGplam0e22BR0cfFq1DS5ZeH4RE+To7ROz70hcx5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560206; c=relaxed/simple;
	bh=YxyK45hUOQsexs55QeCWxaawYJ7jWw6ncuXFz3fUpJg=;
	h=Date:To:From:Subject:Message-Id; b=gbLVOweUXUuDBu5798jEk/3gphE/CHA5L5+ZQ1tFU1Q32K7R88xUiwc/mYaSFysGqqnn7f7I2EkZ9xuSPNTLyw5HVVqpw/5ixEcK9YB/ZXRlyGAOT6nkiDZTYfhxLVgeV3/K7ph6lefCIGjGww1siqPctL3maNm/4HdvDlSzNJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U0CIXJHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U0CIXJHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF18C433F1;
	Thu, 22 Feb 2024 00:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560206;
	bh=YxyK45hUOQsexs55QeCWxaawYJ7jWw6ncuXFz3fUpJg=;
	h=Date:To:From:Subject:From;
	b=U0CIXJHap8NG3wx5eWQKwTyD8OcifCrW1tf4QIN/+pSGrg3pX8QVhqTaAMmzJ3t7v
	 dLj4NM06l1IsgrT5iOLfEr+11DyUbvm8K90xc1Ct6RgYu5QUQc3M8mTmP2gHS8PPgZ
	 0TsBsgKP8gAebbQaXihU7MXT5pTzyIEVuRC4VK48=
Date: Wed, 21 Feb 2024 16:03:26 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_damon_sysfs-support-damos-apply-interval.patch removed from -mm tree
Message-Id: <20240222000326.7DF18C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_damon_sysfs: support DAMOS apply interval
has been removed from the -mm tree.  Its filename was
     selftests-damon-_damon_sysfs-support-damos-apply-interval.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/_damon_sysfs: support DAMOS apply interval
Date: Wed, 7 Feb 2024 12:31:29 -0800

Update the test-purpose DAMON sysfs control Python module to support DAMOS
apply interval.

Link: https://lkml.kernel.org/r/20240207203134.69976-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-support-damos-apply-interval
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -114,6 +114,7 @@ class Damos:
     action = None
     access_pattern = None
     quota = None
+    apply_interval_us = None
     # todo: Support watermarks, stats, tried_regions
     idx = None
     context = None
@@ -121,12 +122,13 @@ class Damos:
     stats = None
 
     def __init__(self, action='stat', access_pattern=DamosAccessPattern(),
-                 quota=DamosQuota()):
+                 quota=DamosQuota(), apply_interval_us=0):
         self.action = action
         self.access_pattern = access_pattern
         self.access_pattern.scheme = self
         self.quota = quota
         self.quota.scheme = self
+        self.apply_interval_us = apply_interval_us
 
     def sysfs_dir(self):
         return os.path.join(
@@ -139,6 +141,11 @@ class Damos:
         err = self.access_pattern.stage()
         if err != None:
             return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'apply_interval_us'),
+                         '%d' % self.apply_interval_us)
+        if err != None:
+            return err
+
         err = self.quota.stage()
         if err != None:
             return err
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-maintainer-profile-fix-reference-links-for-mm-stable-tree.patch
docs-mm-damon-move-the-list-of-damos-actions-to-design-doc.patch
docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document.patch
docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document-fix.patch
docs-mm-damon-move-monitoring-target-regions-setup-detail-from-the-usage-to-the-design-document.patch
docs-admin-guide-mm-damon-usage-fix-wrong-quotas-diabling-condition.patch
mm-damon-core-set-damos_quota-esz-as-public-field-and-document.patch
mm-damon-sysfs-schemes-implement-quota-effective_bytes-file.patch
mm-damon-sysfs-implement-a-kdamond-command-for-updating-schemes-effective-quotas.patch
docs-abi-damon-document-effective_bytes-sysfs-file.patch
docs-admin-guide-mm-damon-usage-document-effective_bytes-file.patch
mm-damon-move-comments-and-fields-for-damos-quota-prioritization-to-the-end.patch
mm-damon-core-split-out-quota-goal-related-fields-to-a-struct.patch
mm-damon-core-add-multiple-goals-per-damos_quota-and-helpers-for-those.patch
mm-damon-sysfs-use-only-quota-goals.patch
mm-damon-core-remove-goal-field-of-damos_quota.patch
mm-damon-core-let-goal-specified-with-only-target-and-current-values.patch
mm-damon-core-support-multiple-metrics-for-quota-goal.patch
mm-damon-core-implement-psi-metric-damos-quota-goal.patch
mm-damon-sysfs-schemes-support-psi-based-quota-auto-tune.patch
docs-mm-damon-design-document-quota-goal-self-tuning.patch
docs-abi-damon-document-quota-goal-metric-file.patch
docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file.patch
docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file-fix.patch
mm-damon-reclaim-implement-user-feedback-driven-quota-auto-tuning.patch
mm-damon-reclaim-implement-memory-psi-driven-quota-self-tuning.patch
docs-admin-guide-mm-damon-reclaim-document-auto-tuning-parameters.patch


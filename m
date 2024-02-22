Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7B38BF9
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560206; cv=none; b=s7jCjC4zFU+wCWnQbnmBUNmoM4bXHko67prtShLXVxrOOwyiUByrU75Y6mSqgBu58pSYQJQUkcCIp724TBKHCQ1zE1RzfWzu9D+iqpU+u51YM65LWJ9i79iilyewNv0lmYvNqhuQ9ZBWzHjNqhER9j0r4y2YRj378jP1Q291Klg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560206; c=relaxed/simple;
	bh=LcBhyxh2KF8y6+Zrit2GwEuEUiNGgsVnfL5fOg38d+k=;
	h=Date:To:From:Subject:Message-Id; b=jdWkqNOoKaKzeNTje2LJUUPP5klpMxA4sKTb+pCjwmXNSq5LP0IJWmKdY8m8+P4grUXzPzs2s5VOnO2TF71XtCX6B1803ONLF7JjFHr/myjudu07TI+U24Aqm+cy97E+L6GPuHGY63AuLoXI15hDtp29Lfcu14wGie802uHulxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VOfPF8av; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VOfPF8av"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F4BC433C7;
	Thu, 22 Feb 2024 00:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560205;
	bh=LcBhyxh2KF8y6+Zrit2GwEuEUiNGgsVnfL5fOg38d+k=;
	h=Date:To:From:Subject:From;
	b=VOfPF8avoNHx4UGlZhn6jmbO5m7JLyXFgYBhoDgpMLnYZma7zqJA7jDG8DhDHBYud
	 21Kh8xTMMEvLKLDqHTKA1a7YbWxasnbXrcBnezesMhQ2VbgAJWgYGfGB9fDOAh6xcY
	 cuOMsVwuLS394F1JrCQp9F0h12d2KkMSgol3+oEY=
Date: Wed, 21 Feb 2024 16:03:25 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_damon_sysfs-support-damos-stats.patch removed from -mm tree
Message-Id: <20240222000325.B2F4BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_damon_sysfs: support DAMOS stats
has been removed from the -mm tree.  Its filename was
     selftests-damon-_damon_sysfs-support-damos-stats.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/_damon_sysfs: support DAMOS stats
Date: Wed, 7 Feb 2024 12:31:28 -0800

Update the test-purpose DAMON sysfs control Python module to support DAMOS
stats.

Link: https://lkml.kernel.org/r/20240207203134.69976-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |   32 ++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-support-damos-stats
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -96,6 +96,20 @@ class DamosQuota:
         if err != None:
             return err
 
+class DamosStats:
+    nr_tried = None
+    sz_tried = None
+    nr_applied = None
+    sz_applied = None
+    qt_exceeds = None
+
+    def __init__(self, nr_tried, sz_tried, nr_applied, sz_applied, qt_exceeds):
+        self.nr_tried = nr_tried
+        self.sz_tried = sz_tried
+        self.nr_applied = nr_applied
+        self.sz_applied = sz_applied
+        self.qt_exceeds = qt_exceeds
+
 class Damos:
     action = None
     access_pattern = None
@@ -104,6 +118,7 @@ class Damos:
     idx = None
     context = None
     tried_bytes = None
+    stats = None
 
     def __init__(self, action='stat', access_pattern=DamosAccessPattern(),
                  quota=DamosQuota()):
@@ -322,6 +337,23 @@ class Kdamond:
                     return err
                 scheme.tried_bytes = int(content)
 
+    def update_schemes_stats(self):
+        err = write_file(os.path.join(self.sysfs_dir(), 'state'),
+                'update_schemes_stats')
+        if err != None:
+            return err
+        for context in self.contexts:
+            for scheme in context.schemes:
+                stat_values = []
+                for stat in ['nr_tried', 'sz_tried', 'nr_applied',
+                             'sz_applied', 'qt_exceeds']:
+                    content, err = read_file(
+                            os.path.join(scheme.sysfs_dir(), 'stats', stat))
+                    if err != None:
+                        return err
+                    stat_values.append(int(content))
+                scheme.stats = DamosStats(*stat_values)
+
 class Kdamonds:
     kdamonds = []
 
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


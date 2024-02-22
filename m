Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6188BF9
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560205; cv=none; b=IwvE33m5m6CAQp7MrhXOvbPgx3oZ06/rpJy3y1eIPUZvIXsHWAyc8EOQH3HPrJYf0brB8ZxRMlHaJsgZOE1zY/PWZt/6cOTpfqcBxxVwk9+fGJlKH+bl2+R5Hi3ORROHncOphDTyPwAuwIp09W8wTkYHFSIPz8Ajn1ZfT0JtDv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560205; c=relaxed/simple;
	bh=+6a/KMoIAWpqqExpYRLuuyt+VG2Vqag4h1HHQFRVSgQ=;
	h=Date:To:From:Subject:Message-Id; b=UXgBNk/PfqInBJvJoNP/5MBqW16vUrk8FS6ymbAcXQdbddG2JZfLJH56tmVf/OYJh4W42Sx3vo5YxcksJUotSXHxNFsPWxN371/Ok1eXQBIqYMp8L7l2GAkXMVwcWe+0EMLBkfrIPXYlkjFUf2FOclC+ob1KyYq8HTxi5iW6IOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qX0wQIkA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qX0wQIkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3674C433F1;
	Thu, 22 Feb 2024 00:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560204;
	bh=+6a/KMoIAWpqqExpYRLuuyt+VG2Vqag4h1HHQFRVSgQ=;
	h=Date:To:From:Subject:From;
	b=qX0wQIkAC6M/cPJMTO8HkxEgwNYcz6M7CRHpiiOA44YL9q4o2JuG8Ui/Odh7XXtTF
	 OqDsXP0LeVGS/c0fTwVfOnqrvrMNPel7NgnUf1HM8LUQdmYvGNJ0ShcFPb/e7BRHme
	 JUDNp/kO+ujqvMorelNX1j3P8tjgmVX6GDr/KRxU=
Date: Wed, 21 Feb 2024 16:03:24 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_damon_sysfs-support-damos-quota.patch removed from -mm tree
Message-Id: <20240222000324.D3674C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_damon_sysfs: support DAMOS quota
has been removed from the -mm tree.  Its filename was
     selftests-damon-_damon_sysfs-support-damos-quota.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/_damon_sysfs: support DAMOS quota
Date: Wed, 7 Feb 2024 12:31:27 -0800

Patch series "selftests/damon: add more tests for core functionalities and
corner cases".

Continue DAMON selftests' test coverage improvement works with a trivial
improvement of the test code itself.  The sequence of the patches in
patchset is as follows.

The first five patches add two DAMON core functionalities tests.  Those
begins with three patches (patches 1-3) that update the test-purpose DAMON
sysfs interface wrapper to support DAMOS quota, stats, and apply interval
features, respectively.  The fourth patch implements and adds a selftest
for DAMOS quota feature, using the DAMON sysfs interface wrapper's newly
added support of the quota and the stats feature.  The fifth patch further
implements and adds a selftest for DAMOS apply interval using the DAMON
sysfs interface wrapper's newly added support of the apply interval and
the stats feature.

Two patches (patches 6 and 7) for implementing and adding two corner cases
handling selftests follow.  Those try to avoid two previously fixed bugs
from recurring.

Finally, a patch for making DAMON debugfs selftests dependency checker to
use /proc/mounts instead of the hard-coded mount point assumption follows.


This patch (of 8):

Update the test-purpose DAMON sysfs control Python module to support DAMOS
quota.

Link: https://lkml.kernel.org/r/20240207203134.69976-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240207203134.69976-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |   42 ++++++++++++----
 1 file changed, 33 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-support-damos-quota
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -70,18 +70,48 @@ class DamosAccessPattern:
         if err != None:
             return err
 
+class DamosQuota:
+    sz = None                   # size quota, in bytes
+    ms = None                   # time quota
+    reset_interval_ms = None    # quota reset interval
+    scheme = None               # owner scheme
+
+    def __init__(self, sz=0, ms=0, reset_interval_ms=0):
+        self.sz = sz
+        self.ms = ms
+        self.reset_interval_ms = reset_interval_ms
+
+    def sysfs_dir(self):
+        return os.path.join(self.scheme.sysfs_dir(), 'quotas')
+
+    def stage(self):
+        err = write_file(os.path.join(self.sysfs_dir(), 'bytes'), self.sz)
+        if err != None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'ms'), self.ms)
+        if err != None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'reset_interval_ms'),
+                         self.reset_interval_ms)
+        if err != None:
+            return err
+
 class Damos:
     action = None
     access_pattern = None
-    # todo: Support quotas, watermarks, stats, tried_regions
+    quota = None
+    # todo: Support watermarks, stats, tried_regions
     idx = None
     context = None
     tried_bytes = None
 
-    def __init__(self, action='stat', access_pattern=DamosAccessPattern()):
+    def __init__(self, action='stat', access_pattern=DamosAccessPattern(),
+                 quota=DamosQuota()):
         self.action = action
         self.access_pattern = access_pattern
         self.access_pattern.scheme = self
+        self.quota = quota
+        self.quota.scheme = self
 
     def sysfs_dir(self):
         return os.path.join(
@@ -94,13 +124,7 @@ class Damos:
         err = self.access_pattern.stage()
         if err != None:
             return err
-
-        # disable quotas
-        err = write_file(os.path.join(self.sysfs_dir(), 'quotas', 'ms'), '0')
-        if err != None:
-            return err
-        err = write_file(
-                os.path.join(self.sysfs_dir(), 'quotas', 'bytes'), '0')
+        err = self.quota.stage()
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


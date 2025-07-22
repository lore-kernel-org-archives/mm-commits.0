Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D105A2E36FD
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 03:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153885; cv=none; b=c42LHh4ksT7n8Lb/GRMXdMUXszS+kPYNQrWN3seFJjlASC2FKONn27tt8MD5gTGvfXU/SubQySwFp+qM86e2rT2xSNis85TzGWCm/td+mMJ/7344yAaM0btDZch5uncj3tfOlYoDEj3PBGH9+ejzqwyEaZRBR83bKhoqjXQ6qRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153885; c=relaxed/simple;
	bh=C2t2ASHXEVjRak+Hthl/eFzP4Zfcsv7Xe6iQrhV/lZw=;
	h=Date:To:From:Subject:Message-Id; b=Q8TcTUhHViUtWT9z+11jVveAftaVbej0V1fCu4P9X7Af1+oGcAGZ1I2gZWkjSbGEBievS65CEgwH5386cI1mv2VpU7YVxmSN2oB1LyvG15eNfEVSuSmKeyRJS/gWHQmlUxRiahUg8X1UbdgEXXDL3z0QyX3P1deDQT3HfMmo1Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g9m0R1Jq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g9m0R1Jq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454B6C4CEED;
	Tue, 22 Jul 2025 03:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753153885;
	bh=C2t2ASHXEVjRak+Hthl/eFzP4Zfcsv7Xe6iQrhV/lZw=;
	h=Date:To:From:Subject:From;
	b=g9m0R1Jqw2qr0KfkdcMP4SC5IT8Np2sDVWnQJUYPMCQPc3CU+edIaNF/FOvIkz4xs
	 BUphdYyujsY81qbd6U/FicMi+B/ck6NvVOTMb09ZPrEnormbsQ9qvJMbKnCYD4I9SZ
	 pSJcxIicLUjBEqKs9utrG9whDeacKO/SXMEn6bb4=
Date: Mon, 21 Jul 2025 20:11:24 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_damon_sysfs-support-damos-filters-setup.patch added to mm-new branch
Message-Id: <20250722031125.454B6C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_damon_sysfs: support DAMOS filters setup
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-_damon_sysfs-support-damos-filters-setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_damon_sysfs-support-damos-filters-setup.patch

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
Subject: selftests/damon/_damon_sysfs: support DAMOS filters setup
Date: Sun, 20 Jul 2025 10:16:32 -0700

_damon_sysfs.py contains code for test-purpose DAMON sysfs interface
control.  Add support of DAMOS filters setup for more tests.

Link: https://lkml.kernel.org/r/20250720171652.92309-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |  115 +++++++++++++++-
 1 file changed, 111 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-support-damos-filters-setup
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -201,6 +201,96 @@ class DamosWatermarks:
         if err is not None:
             return err
 
+class DamosFilter:
+    type_ = None
+    matching = None
+    allow = None
+    memcg_path = None
+    addr_start = None
+    addr_end = None
+    target_idx = None
+    min_ = None
+    max_ = None
+    idx = None
+    filters = None  # owner filters
+
+    def __init__(self, type_='anon', matching=False, allow=False,
+                 memcg_path='', addr_start=0, addr_end=0, target_idx=0, min_=0,
+                 max_=0):
+        self.type_ = type_
+        self.matching = matching
+        self.allow = allow
+        self.memcg_path = memcg_path,
+        self.addr_start = addr_start
+        self.addr_end = addr_end
+        self.target_idx = target_idx
+        self.min_ = min_
+        self.max_ = max_
+
+    def sysfs_dir(self):
+        return os.path.join(self.filters.sysfs_dir(), '%d' % self.idx)
+
+    def stage(self):
+        err = write_file(os.path.join(self.sysfs_dir(), 'type'), self.type_)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'matching'),
+                         self.matching)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'allow'), self.allow)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'memcg_path'),
+                         self.memcg_path)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'addr_start'),
+                         self.addr_start)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'addr_end'),
+                         self.addr_end)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'damon_target_idx'),
+                         self.target_idx)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'min'), self.min_)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'max'), self.max_)
+        if err is not None:
+            return err
+        return None
+
+class DamosFilters:
+    name = None
+    filters = None
+    scheme = None   # owner scheme
+
+    def __init__(self, name, filters=[]):
+        self.name = name
+        self.filters = filters
+        for idx, filter_ in enumerate(self.filters):
+            filter_.idx = idx
+            filter_.filters = self
+
+    def sysfs_dir(self):
+        return os.path.join(self.scheme.sysfs_dir(), self.name)
+
+    def stage(self):
+        err = write_file(os.path.join(self.sysfs_dir(), 'nr_filters'),
+                         len(self.filters))
+        if err is not None:
+            return err
+        for filter_ in self.filters:
+            err = filter_.stage()
+            if err is not None:
+                return err
+        return None
+
 class DamosStats:
     nr_tried = None
     sz_tried = None
@@ -227,8 +317,10 @@ class Damos:
     access_pattern = None
     quota = None
     watermarks = None
+    core_filters = None
+    ops_filters = None
+    filters = None
     apply_interval_us = None
-    # todo: Support watermarks, stats
     idx = None
     context = None
     tried_bytes = None
@@ -237,6 +329,7 @@ class Damos:
 
     def __init__(self, action='stat', access_pattern=DamosAccessPattern(),
                  quota=DamosQuota(), watermarks=DamosWatermarks(),
+                 core_filters=[], ops_filters=[], filters=[],
                  apply_interval_us=0):
         self.action = action
         self.access_pattern = access_pattern
@@ -245,6 +338,16 @@ class Damos:
         self.quota.scheme = self
         self.watermarks = watermarks
         self.watermarks.scheme = self
+
+        self.core_filters = DamosFilters(name='core_filters',
+                                         filters=core_filters)
+        self.core_filters.scheme = self
+        self.ops_filters = DamosFilters(name='ops_filters',
+                                         filters=ops_filters)
+        self.ops_filters.scheme = self
+        self.filters = DamosFilters(name='filters', filters=filters)
+        self.filters.scheme = self
+
         self.apply_interval_us = apply_interval_us
 
     def sysfs_dir(self):
@@ -271,9 +374,13 @@ class Damos:
         if err is not None:
             return err
 
-        # disable filters
-        err = write_file(
-                os.path.join(self.sysfs_dir(), 'filters', 'nr_filters'), '0')
+        err = self.core_filters.stage()
+        if err is not None:
+            return err
+        err = self.ops_filters.stage()
+        if err is not None:
+            return err
+        err = self.filters.stage()
         if err is not None:
             return err
 
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


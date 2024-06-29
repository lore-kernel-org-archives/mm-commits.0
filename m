Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4A71864C
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628306; cv=none; b=nWr4pXmQkTu7HQVWa+BNyqUTzxb0yOjgmAvMfLj1Lg5cphilI2NGPgWuu8TgKiOHkw4uFCcdmIKdoSierYbyvAEnVVzZHIFXUQ5cNPCxBuAQcH4Lm+PGdqfDDX09fYkeGNrlHtASGCvaOpFqfLF8hbRhqp40bddbb0/9vBKVJmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628306; c=relaxed/simple;
	bh=U+bP/NYA6dZMA77ImCrJ1qh/I8+4a+VrDMAwCx59O7c=;
	h=Date:To:From:Subject:Message-Id; b=AyYXNKDucaX6JeqsfPkf0LbgbAu6XG2WJtYo23x9lOyFtzD5VyBFdIZosE2K08jzpz1663bTY45Ws+5E6b/yXn1iTMRxAI/FrMeF9DcfUO2P597Mqrzg/sSIAeHi+EIBZJafZrRqKzYp0zTAgpPF+xvpKCJmLPqHKTqGXES3UgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ib0TpzdK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ib0TpzdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01365C32786;
	Sat, 29 Jun 2024 02:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628306;
	bh=U+bP/NYA6dZMA77ImCrJ1qh/I8+4a+VrDMAwCx59O7c=;
	h=Date:To:From:Subject:From;
	b=ib0TpzdKkwqmVbzzcBiSwifS6q8QYHE+XXE2gMaK4/M2yMEvPYdWXm6sVF4UT6dcy
	 73Y1XQ4t8kHOIFUe2kDBXZ7sqjox/E+sr8PBRzzpt3A9tR1C57Zi7x8xy07A2mGbv9
	 PlKSzfQ1l0TKrHGRHvDJwS5Jqa8Hwc/fPyoAVxCs=
Date: Fri, 28 Jun 2024 19:31:45 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_damon_sysfs-support-schemes_update_tried_regions.patch removed from -mm tree
Message-Id: <20240629023146.01365C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_damon_sysfs: support schemes_update_tried_regions
has been removed from the -mm tree.  Its filename was
     selftests-damon-_damon_sysfs-support-schemes_update_tried_regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/_damon_sysfs: support schemes_update_tried_regions
Date: Tue, 25 Jun 2024 11:05:32 -0700

Implement schemes_update_tried_regions DAMON sysfs command on
_damon_sysfs.py, to use on implementations of future tests for the
feature.

Link: https://lkml.kernel.org/r/20240625180538.73134-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |   35 +++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-support-schemes_update_tried_regions
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -175,16 +175,24 @@ class DamosStats:
         self.sz_applied = sz_applied
         self.qt_exceeds = qt_exceeds
 
+class DamosTriedRegion:
+    def __init__(self, start, end, nr_accesses, age):
+        self.start = start
+        self.end = end
+        self.nr_accesses = nr_accesses
+        self.age = age
+
 class Damos:
     action = None
     access_pattern = None
     quota = None
     apply_interval_us = None
-    # todo: Support watermarks, stats, tried_regions
+    # todo: Support watermarks, stats
     idx = None
     context = None
     tried_bytes = None
     stats = None
+    tried_regions = None
 
     def __init__(self, action='stat', access_pattern=DamosAccessPattern(),
                  quota=DamosQuota(), apply_interval_us=0):
@@ -398,6 +406,31 @@ class Kdamond:
         err = write_file(os.path.join(self.sysfs_dir(), 'state'), 'on')
         return err
 
+    def update_schemes_tried_regions(self):
+        err = write_file(os.path.join(self.sysfs_dir(), 'state'),
+                         'update_schemes_tried_regions')
+        if err is not None:
+            return err
+        for context in self.contexts:
+            for scheme in context.schemes:
+                tried_regions = []
+                tried_regions_dir = os.path.join(
+                        scheme.sysfs_dir(), 'tried_regions')
+                for filename in os.listdir(
+                        os.path.join(scheme.sysfs_dir(), 'tried_regions')):
+                    tried_region_dir = os.path.join(tried_regions_dir, filename)
+                    if not os.path.isdir(tried_region_dir):
+                        continue
+                    region_values = []
+                    for f in ['start', 'end', 'nr_accesses', 'age']:
+                        content, err = read_file(
+                                os.path.join(tried_region_dir, f))
+                        if err is not None:
+                            return err
+                        region_values.append(int(content))
+                    tried_regions.append(DamosTriedRegion(*region_values))
+                scheme.tried_regions = tried_regions
+
     def update_schemes_tried_bytes(self):
         err = write_file(os.path.join(self.sysfs_dir(), 'state'),
                 'update_schemes_tried_bytes')
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix-2.patch


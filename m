Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830BF30B53E
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334290; cv=none; b=DycoHhJi/j2t8Qhbu3IBANri4zYQxhmlX3/xyyGMe0RrQu0uf5ZUp/p8VJSlbmvUdcB3k45vfUd+kIwJKF14C3DmiCCrB/TamTz1zvxAJjMy6E/aedFOVTjj9kE31PeO1I2MA0SVnKh9iZezMZd8focMRF3kOwzaMwdJtsYRoh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334290; c=relaxed/simple;
	bh=e8bCyLrIz/Rmm5kEaLGDjhuuaWkJOq8fV547hVjqkwA=;
	h=Date:To:From:Subject:Message-Id; b=pz0WvUo91q6s/tXa/dzAvCRwE7sEk5/6xBbTJchV+cQgziRu1ewCsX6vgqkT9gRn5Y8GQwJkJqowORICU4voz3gRABfpxdPqMRPK/uhmiYP3O+OQW1A9Nv/ciL3cBhMrqluSTHcQn1N8tfh4f7LCOLM05GEg07hdsMisZV222c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o41edjSf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o41edjSf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD281F0089B;
	Wed,  7 Oct 2026 00:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334289;
	bh=MaROh+/zsgMFqYoVUTzicDMSxg7Yinq+zpIIavPeE7Y=;
	h=Date:To:From:Subject;
	b=o41edjSfmzv/67qSV1y1DGlW6anGjyJG63D8p+1sm4qqX97wNTL8fcqmr4uQ41hW7
	 FCo1nyM6sejX47EYBW/H246WK0WJziu8u5UbcMPWTgVIaG/sVn3y+/qLZ49jP0XJ3Z
	 lJYtjLTNkwb09QURxDBI1n3/gAHApS70gOehGEAk=
Date: Tue, 06 Oct 2026 17:51:28 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,sj@kernel.org,shuah@kernel.org,liyouhong@kylinos.cn,lienze@kylinos.cn,jaeyeon.lee.dev@gmail.com,harimishal1@gmail.com,gregkh@linuxfoundation.org,zhaozhengzhuo@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-prevent-remaining-cross-object-state-pollution.patch removed from -mm tree
Message-Id: <20261007005129.5AD281F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: prevent remaining cross-object state pollution
has been removed from the -mm tree.  Its filename was
     selftests-damon-prevent-remaining-cross-object-state-pollution.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Subject: selftests/damon: prevent remaining cross-object state pollution
Date: Mon, 31 Aug 2026 07:26:08 -0700

_damon_sysfs.py defines constructors with mutable default arguments,
including DamosAccessPattern(), DamosQuota(), DamosWatermarks(),
DamosDests(), IntervalsGoal(), and empty lists.

Default arguments are evaluated once at function definition time.  Damos()
instances created without explicit arguments therefore share the same
DamosQuota(), and the other default-constructed sub-objects and lists are
shared in the same way.  The sub-objects keep back-pointers to their owner
scheme, so constructing the second Damos() rebinds the shared quota's
scheme pointer to the second object.  An item appended to one object's
default contexts or filters list is also visible from other
default-constructed objects.

The shared state can corrupt test configurations.  DamosQuota.sysfs_dir()
derives the sysfs directory from its scheme pointer, so operating on the
first scheme's default quota may write to the second scheme's directory. 
The wrong values often match the defaults, so tests still pass, but the
behavior depends on object creation order.

Commit 8319dadcbd81 ("selftests/damon: prevent cross-context state
pollution in DamonCtx") fixed the same pattern in DamonCtx only.  Fix the
remaining constructors by defaulting to None and creating fresh objects or
lists inside each constructor.  Explicit arguments keep their previous
behavior.

Link: https://lore.kernel.org/20260831142611.77572-7-sj@kernel.org
Signed-off-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Enze Li <lienze@kylinos.cn>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hari Mishal <harimishal1@gmail.com>
Cc: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Cc: Li Youhong <liyouhong@kylinos.cn>
Cc: Shuah Khan <shuah@kernel.org>
Cc: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
---

 tools/testing/selftests/damon/_damon_sysfs.py |   38 +++++++++++-----
 1 file changed, 28 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-prevent-remaining-cross-object-state-pollution
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -321,8 +321,10 @@ class DamosFilters:
     filters = None
     scheme = None   # owner scheme
 
-    def __init__(self, name, filters=[]):
+    def __init__(self, name, filters=None):
         self.name = name
+        if filters is None:
+            filters = []
         self.filters = filters
         for idx, filter_ in enumerate(self.filters):
             filter_.idx = idx
@@ -368,7 +370,9 @@ class DamosDests:
     dests = None
     scheme = None   # owner scheme
 
-    def __init__(self, dests=[]):
+    def __init__(self, dests=None):
+        if dests is None:
+            dests = []
         self.dests = dests
         for idx, dest in enumerate(self.dests):
             dest.idx = idx
@@ -426,15 +430,21 @@ class Damos:
     stats = None
     tried_regions = None
 
-    def __init__(self, action='stat', access_pattern=DamosAccessPattern(),
-                 quota=DamosQuota(), watermarks=DamosWatermarks(),
-                 core_filters=[], ops_filters=[], filters=[], target_nid=0,
-                 dests=DamosDests(), apply_interval_us=0):
+    def __init__(self, action='stat', access_pattern=None, quota=None,
+                 watermarks=None, core_filters=None, ops_filters=None,
+                 filters=None, target_nid=0, dests=None,
+                 apply_interval_us=0):
         self.action = action
+        if access_pattern is None:
+            access_pattern = DamosAccessPattern()
         self.access_pattern = access_pattern
         self.access_pattern.scheme = self
+        if quota is None:
+            quota = DamosQuota()
         self.quota = quota
         self.quota.scheme = self
+        if watermarks is None:
+            watermarks = DamosWatermarks()
         self.watermarks = watermarks
         self.watermarks.scheme = self
 
@@ -448,6 +458,8 @@ class Damos:
         self.filters.scheme = self
 
         self.target_nid = target_nid
+        if dests is None:
+            dests = DamosDests()
         self.dests = dests
         self.dests.scheme = self
 
@@ -568,10 +580,12 @@ class DamonAttrs:
     context = None
 
     def __init__(self, sample_us=5000, aggr_us=100000,
-                 intervals_goal=IntervalsGoal(), update_us=1000000,
-            min_nr_regions=10, max_nr_regions=1000):
+                 intervals_goal=None, update_us=1000000, min_nr_regions=10,
+                 max_nr_regions=1000):
         self.sample_us = sample_us
         self.aggr_us = aggr_us
+        if intervals_goal is None:
+            intervals_goal = IntervalsGoal()
         self.intervals_goal = intervals_goal
         self.intervals_goal.attrs = self
         self.update_us = update_us
@@ -703,7 +717,9 @@ class Kdamond:
     idx = None      # index of this kdamond between siblings
     kdamonds = None # parent
 
-    def __init__(self, contexts=[], refresh_ms=None):
+    def __init__(self, contexts=None, refresh_ms=None):
+        if contexts is None:
+            contexts = []
         self.contexts = contexts
         self.refresh_ms = refresh_ms
         for idx, context in enumerate(self.contexts):
@@ -853,7 +869,9 @@ class Kdamond:
 class Kdamonds:
     kdamonds = []
 
-    def __init__(self, kdamonds=[]):
+    def __init__(self, kdamonds=None):
+        if kdamonds is None:
+            kdamonds = []
         self.kdamonds = kdamonds
         for idx, kdamond in enumerate(self.kdamonds):
             kdamond.idx = idx
_

Patches currently in -mm which might be from zhaozhengzhuo@uniontech.com are

mm-migrate_device-fix-function-name-in-kernel-doc.patch


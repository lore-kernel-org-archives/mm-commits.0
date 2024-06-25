Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BE117C7AE
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 19:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719342484; cv=none; b=QkducUgfRwVXsGGY5GDVAnI9lm+881+HjE23MqNHNcYD6P2+eW/17TbFkWhTmCFybW8TmYvQAbao2bbbLkJp6ZeBp5gTPtJJAmLSLi5BDGeDkbXuXj9umWaY5fWqmFhenaeI+otswc4daAEy/pryXqbsPJcqWX9+zWEadRDj0z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719342484; c=relaxed/simple;
	bh=R1vVqNn858YVswFnxp89+ONFgHdy6OdszYvg1bzbaRk=;
	h=Date:To:From:Subject:Message-Id; b=lpfbP2T0qYXZe4eTk6MnPg5wkG9z6dqXt2NOOa6fMsmpV1tsMLQ3aOW5Yy4LCplf/tcWGrms+bs5G2AyDEV81SI5gFa9MMEpya0EnaGEI1PJQ4Ofu2zyLkPZQKp77lhWkdlWPVSTGhuFR0Ka8z5rwhhcgfyQuz9blXudcxA5dWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KnfIzEge; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KnfIzEge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1498C32781;
	Tue, 25 Jun 2024 19:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719342483;
	bh=R1vVqNn858YVswFnxp89+ONFgHdy6OdszYvg1bzbaRk=;
	h=Date:To:From:Subject:From;
	b=KnfIzEgeH0yVTRRevcHhWwOOwis0aKY39RKzSIgYzP0UyT9W8iBUhWDy9E+Drz2XQ
	 qBh0wIRYYgQSeVFDDnpQGv+PEPJEM03d2DwypR+VuVFGs/3AKRPDRj7JyDr/uKQ2Rz
	 bmKZjV93zTHQ1+nLyu6mn2oiXctwt7sPW0t0kPrg=
Date: Tue, 25 Jun 2024 12:08:03 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_damon_sysfs-support-schemes_update_tried_regions.patch added to mm-unstable branch
Message-Id: <20240625190803.B1498C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_damon_sysfs: support schemes_update_tried_regions
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-_damon_sysfs-support-schemes_update_tried_regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_damon_sysfs-support-schemes_update_tried_regions.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
docs-mm-damon-maintainer-profile-introduce-hackermail.patch
docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch
selftests-damon-access_memory-use-user-defined-region-size.patch
selftests-damon-_damon_sysfs-support-schemes_update_tried_regions.patch
selftests-damon-implement-a-program-for-even-numbered-memory-regions-access.patch
selftests-damon-implement-damos-tried-regions-test.patch
selftests-damon-_damon_sysfs-implement-kdamonds-stop-function.patch
selftests-damon-implement-test-for-min-max_nr_regions.patch
_damon_sysfs-implement-commit-for-online-parameters-update.patch
selftests-damon-damon_nr_regions-test-online-tuned-max_nr_regions.patch


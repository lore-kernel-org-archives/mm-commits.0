Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EEC017A932
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 19:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719342491; cv=none; b=DmHF5C5dkM+9Njr6rxuHpHkhDJyANuBI13NjiUEQ2OwXq+GC/MJTvajOKooGzQM9ZjvgmAa0Ny8zAXNb8RE9X6FipkdBtVJxhhyYRDe7L7KDnyavKQRz8HhCeDUQojfREYZBLrAkHcfsYTaStLnJ8fXqkp7+ytmDYhYDJgmnlqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719342491; c=relaxed/simple;
	bh=crLq77rUy19CZFio7Qa9/U4LKnkhn4OV6SOeDGem9jA=;
	h=Date:To:From:Subject:Message-Id; b=KzjRtSLpj8LqXc+btkEPrvhpSdZ/cl64vTS9NIqn6YRssCNMTm9hk9I6bXbrNNcgnDdnHIPBD71g3p+11d1lRwmipwJIIvNcC4eCUC5jD1ZVT8ppL4MpSLwPUGUgqPJmqzBjpvTvOzeoIYgN4tOFrLxlkm+pD8oY+IDSuqbEEH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IQuMGTlJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IQuMGTlJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0128C32781;
	Tue, 25 Jun 2024 19:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719342490;
	bh=crLq77rUy19CZFio7Qa9/U4LKnkhn4OV6SOeDGem9jA=;
	h=Date:To:From:Subject:From;
	b=IQuMGTlJTfuxA7wWdP4JCOoS2Zg2XLEYkJ3JaX7nloijTGkJNuHwUlcASkWgjipTE
	 TnH4+z5CF1ww8IyK2lxoKzZanm0r/rrd4JrN2RMPHOEpGOCN6AsqwKXZmhj+AuVF4f
	 zO4V9ILJTPx1arIAsf0ypxn0/hNnxBiyVJmb6Uio=
Date: Tue, 25 Jun 2024 12:08:10 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_damon_sysfs-implement-kdamonds-stop-function.patch added to mm-unstable branch
Message-Id: <20240625190810.B0128C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_damon_sysfs: implement kdamonds stop function
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-_damon_sysfs-implement-kdamonds-stop-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_damon_sysfs-implement-kdamonds-stop-function.patch

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
Subject: selftests/damon/_damon_sysfs: implement kdamonds stop function
Date: Tue, 25 Jun 2024 11:05:35 -0700

Implement DAMON stop function on the test-purpose DAMON sysfs interface
wrapper Python module, _damon_sysfs.py.  This feature will be used by
future DAMON tests that need to start/stop DAMON multiple times.

Link: https://lkml.kernel.org/r/20240625180538.73134-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-implement-kdamonds-stop-function
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -406,6 +406,10 @@ class Kdamond:
         err = write_file(os.path.join(self.sysfs_dir(), 'state'), 'on')
         return err
 
+    def stop(self):
+        err = write_file(os.path.join(self.sysfs_dir(), 'state'), 'off')
+        return err
+
     def update_schemes_tried_regions(self):
         err = write_file(os.path.join(self.sysfs_dir(), 'state'),
                          'update_schemes_tried_regions')
@@ -511,3 +515,10 @@ class Kdamonds:
             if err is not None:
                 return err
         return None
+
+    def stop(self):
+        for kdamond in self.kdamonds:
+            err = kdamond.stop()
+            if err is not None:
+                return err
+        return None
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


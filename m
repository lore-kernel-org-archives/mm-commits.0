Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6AB28BA9A
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 03:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153897; cv=none; b=fWDSgHNqs9t3nD+Hk/v2js2SFKH06Wt1GumGTg4kdMXjE4uhw8sZbUsDMYZSZEHBHHT53rEmpsD8KIZyEXIKdy+qPbRxH26vX6tPHBTHl3diisNkljtGK3tGU1V7Vi+0J9CTYUssvWOtlpYHCYt4F2XJ6j5IX+yvPKLlWjqe6EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153897; c=relaxed/simple;
	bh=zWBqZ+W2ZXvyXmEgvkgDAU6+RMo2WSL+Xgre3si6768=;
	h=Date:To:From:Subject:Message-Id; b=I7HP1V+cZnHWfrZGrd96kG0HFvWAH9SoKPhHWEyxTP/XTnHlGSu2XYnPV4Gg5YDKCI8lXwxwPX1h10hQ237H9t810ZXGn8xYLeNhEZ88h92BreO4Xhkq4JPNksu2l0a8T7Zj1vI+6bgutJ6SSx/iv6+BBujljAyCQbQG4SviIqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jj/AqFqi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jj/AqFqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4674EC4CEED;
	Tue, 22 Jul 2025 03:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753153896;
	bh=zWBqZ+W2ZXvyXmEgvkgDAU6+RMo2WSL+Xgre3si6768=;
	h=Date:To:From:Subject:From;
	b=Jj/AqFqi/U7g1rqtPKumua6JHpc4g0rz3dH68PzN3KvZdH9vaTZrmyzpF7UPROzb6
	 s6Gz6mVn3DfU5NoEQB3qQP4ZLlMXbXyDnNKGQhdI+17sHRsc/2St9zAxHuBSghuBrw
	 rjWNUzEEalf/XmkQBakCmM/PxkmKyV8wENgPp04Y=
Date: Mon, 21 Jul 2025 20:11:35 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_damon_sysfs-use-232-1-as-max-nr_accesses-and-age.patch added to mm-new branch
Message-Id: <20250722031136.4674EC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_damon_sysfs: use 2**32 - 1 as max nr_accesses and age
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-_damon_sysfs-use-232-1-as-max-nr_accesses-and-age.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_damon_sysfs-use-232-1-as-max-nr_accesses-and-age.patch

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
Subject: selftests/damon/_damon_sysfs: use 2**32 - 1 as max nr_accesses and age
Date: Sun, 20 Jul 2025 10:16:38 -0700

nr_accesses and age are unsigned int.  Use the proper max value.

Link: https://lkml.kernel.org/r/20250720171652.92309-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-use-232-1-as-max-nr_accesses-and-age
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -52,9 +52,9 @@ class DamosAccessPattern:
         if self.size is None:
             self.size = [0, 2**64 - 1]
         if self.nr_accesses is None:
-            self.nr_accesses = [0, 2**64 - 1]
+            self.nr_accesses = [0, 2**32 - 1]
         if self.age is None:
-            self.age = [0, 2**64 - 1]
+            self.age = [0, 2**32 - 1]
 
     def sysfs_dir(self):
         return os.path.join(self.scheme.sysfs_dir(), 'access_pattern')
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


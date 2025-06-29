Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476DF522A
	for <mm-commits@vger.kernel.org>; Sun, 29 Jun 2025 22:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751237278; cv=none; b=caKzpktaG/H7LNXc0+FZNZy0FtuzsemSAPLRejuB8KGq3Lxk2jwgv6l1F+VggI3bJdBc+iryzVEP5Igd6srV8Eb/wC6VIbkig11T3UZVQVa+7LcXXWXqtkp5CzaIrArjpxZPn7ClmpC30S7CvfYGbGtukAnlJG5+vPwRJhk7/uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751237278; c=relaxed/simple;
	bh=HDvwL6pKsc7U+tOy5dGCMHcGrLAyxieEiuHZvb6dG/Q=;
	h=Date:To:From:Subject:Message-Id; b=G8zHCAkeajJxVBs6puVvDjCv2c/8WEK/xFKrAYrMTFSCDux7V+CsXOFO3asJAqGHQz1f18zDdDlu3tzLj8LdlsXWDdYJOpf0qvjj1STKiTNTxUFBri2fatIwYlkxVh3f1433pmKvwPlfH9GBFX8kxUKpTRA9qK/1JjqZoG33dP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gIQ9P8dU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gIQ9P8dU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87B8C4CEEB;
	Sun, 29 Jun 2025 22:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751237277;
	bh=HDvwL6pKsc7U+tOy5dGCMHcGrLAyxieEiuHZvb6dG/Q=;
	h=Date:To:From:Subject:From;
	b=gIQ9P8dU1ksp0TQFQ7DWsi5y0E9NMr6HmHL0tR98UnJHyBgW3m+6f5gB8UW4tuluI
	 Q1TrOkONggep+p2kjub8vAhcUIL44PFavG7Is0OlXtfzsdQptezYKgTr3xv8PO6alR
	 CwUoK4r344KtHQFf8p0D2keNU8AfX87p+fk/4AF0=
Date: Sun, 29 Jun 2025 15:47:57 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch added to mm-new branch
Message-Id: <20250629224757.A87B8C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_damon_sysfs: set Kdamond.pid in start()
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch

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
Subject: selftests/damon/_damon_sysfs: set Kdamond.pid in start()
Date: Sat, 28 Jun 2025 09:04:24 -0700

_damon_sysfs.py is a Python module for reading and writing DAMON sysfs for
testing.  It is not reading resulting kdamond pids.  Read and update those
when starting kdamonds.

Link: https://lkml.kernel.org/r/20250628160428.53115-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-set-kdamondpid-in-start
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -408,6 +408,9 @@ class Kdamond:
             if err is not None:
                 return err
         err = write_file(os.path.join(self.sysfs_dir(), 'state'), 'on')
+        if err is not None:
+            return err
+        self.pid, err = read_file(os.path.join(self.sysfs_dir(), 'pid'))
         return err
 
     def stop(self):
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-handle-damon_call_control-as-normal-under-kdmond-deactivation.patch
mm-damon-introduce-damon_stat-module.patch
mm-damon-introduce-damon_stat-module-fix.patch
mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch
mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch
docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch
mm-damon-paddr-use-alloc_migartion_target-with-no-migration-fallback-nodemask.patch
revert-mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch
revert-mm-make-alloc_demote_folio-externally-invokable-for-migration.patch
selftets-damon-add-a-test-for-memcg_path-leak.patch
mm-damon-sysfs-schemes-decouple-from-damos_quota_goal_metric.patch
mm-damon-sysfs-schemes-decouple-from-damos_action.patch
mm-damon-sysfs-schemes-decouple-from-damos_wmark_metric.patch
mm-damon-sysfs-schemes-decouple-from-damos_filter_type.patch
mm-damon-sysfs-decouple-from-damon_ops_id.patch
selftests-damon-add-drgn-script-for-extracting-damon-status.patch
selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch
selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch
selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch
selftests-damon-sysfspy-test-adaptive-targets-parameter.patch
selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch


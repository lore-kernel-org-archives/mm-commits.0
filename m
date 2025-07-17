Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09AB1A2541
	for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2025 23:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752793950; cv=none; b=JBNH4tP/I9iGBUzDZJdyh4iyXaZfANx/02Hcm8rhss1yhn7oLVhFAUOpyANmhc9L3fgpepXKFsG7BM8EBsJvta8GygVx/wgXT1ZZ5+U2ho3UzH40EiiWrLjvE/fvLN04aEPesZagwIfZipuxHROH8nUWueDQQrUdxyRw2/p+dPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752793950; c=relaxed/simple;
	bh=yUObJPhp6JNl5wXWmdkYkKCcFV61TdE5QoQA5qKp8xY=;
	h=Date:To:From:Subject:Message-Id; b=CFewu2y18xbYYwl7PsGt/8DeK6/f1O3LyeuhCA0s+pUguNsTrXOXHWfeEcQ93f4wOXbRYw3f2oj/XthDjbhj+u90h/Ag5VIsKv+6m/mKmL/yoa1iq3LANHpIMSu8glEtAtAnI5886r7DoDciw6RPTFbvRd2OD6NsdR8Q8XXMLOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hJ2gP0nQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hJ2gP0nQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4ED8C4CEE3;
	Thu, 17 Jul 2025 23:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752793949;
	bh=yUObJPhp6JNl5wXWmdkYkKCcFV61TdE5QoQA5qKp8xY=;
	h=Date:To:From:Subject:From;
	b=hJ2gP0nQf3XPPkVEjEyqYaHnTK4x2zkmGXAPwXShtHmO8E5z1suZLfTE3vMJGfA/7
	 0RlvED4xWerzfLE8SPwaBA6TtlVxCr9dXHxzDXBZQzkkUmIMz7iSZ6/8ftAm1E0cK0
	 YW6FCQNFGZnRMeI+bX42CXfIGQWgDPRK1q13z0Mo=
Date: Thu, 17 Jul 2025 16:12:29 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch added to mm-new branch
Message-Id: <20250717231229.A4ED8C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document refresh_ms file
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch

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
Subject: Docs/admin-guide/mm/damon/usage: document refresh_ms file
Date: Wed, 16 Jul 2025 22:54:47 -0700

Document the new DAMON sysfs file, refresh_ms, on the usage document.

Link: https://lkml.kernel.org/r/20250717055448.56976-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-refresh_ms-file
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -59,7 +59,7 @@ comma (",").
 
     :ref:`/sys/kernel/mm/damon <sysfs_root>`/admin
     │ :ref:`kdamonds <sysfs_kdamonds>`/nr_kdamonds
-    │ │ :ref:`0 <sysfs_kdamond>`/state,pid
+    │ │ :ref:`0 <sysfs_kdamond>`/state,pid,refresh_ms
     │ │ │ :ref:`contexts <sysfs_contexts>`/nr_contexts
     │ │ │ │ :ref:`0 <sysfs_context>`/avail_operations,operations
     │ │ │ │ │ :ref:`monitoring_attrs <sysfs_monitoring_attrs>`/
@@ -123,8 +123,8 @@ kdamond.
 kdamonds/<N>/
 -------------
 
-In each kdamond directory, two files (``state`` and ``pid``) and one directory
-(``contexts``) exist.
+In each kdamond directory, three files (``state``, ``pid`` and ``refresh_ms``)
+and one directory (``contexts``) exist.
 
 Reading ``state`` returns ``on`` if the kdamond is currently running, or
 ``off`` if it is not running.
@@ -161,6 +161,13 @@ Users can write below commands for the k
 
 If the state is ``on``, reading ``pid`` shows the pid of the kdamond thread.
 
+Users can ask the kernel to periodically update files showing auto-tuned
+parameters and DAMOS stats instead of manually writing
+``update_tuned_intervals`` like keywords to ``state`` file.  For this, users
+should write the desired update time interval in milliseconds to ``refresh_ms``
+file.  If the interval is zero, the periodic update is disabled.  Reading the
+file shows currently set time interval.
+
 ``contexts`` directory contains files for controlling the monitoring contexts
 that this kdamond will execute.
 
_

Patches currently in -mm which might be from sj@kernel.org are

samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch
samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch
samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch
mm-damon-sysfs-use-damon-core-api-damon_is_running.patch
mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch
docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch
mm-damon-add-struct-damos_migrate_dests.patch
mm-damon-core-add-damos-migrate_dests-field.patch
mm-damon-sysfs-schemes-implement-damos-action-destinations-directory.patch
mm-damon-sysfs-schemes-set-damos-migrate_dests.patch
docs-abi-damon-document-schemes-dests-directory.patch
docs-admin-guide-mm-damon-usage-document-dests-directory.patch
mm-damon-accept-parallel-damon_call-requests.patch
mm-damon-core-introduce-repeat-mode-damon_call.patch
mm-damon-stat-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-reclaim-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-lru_sort-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-prcl-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-wsse-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-core-do-not-call-opscleanup-when-destroying-targets.patch
mm-damon-core-add-cleanup_target-ops-callback.patch
mm-damon-core-add-cleanup_target-ops-callback-fix.patch
mm-damon-core-add-cleanup_target-ops-callback-fix-2.patch
mm-damon-vaddr-put-pid-in-cleanup_target.patch
mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch
mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch
mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch
mm-damon-core-remove-damon_callback.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch


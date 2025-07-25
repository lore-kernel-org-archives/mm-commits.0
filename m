Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A22212F98
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409689; cv=none; b=XLZde85NPohJayoMAofVUjGVFAxvoFnM3BnJwaK+xiX5lrF7bOV9ty49ryuBGBOKyo9dhDH2jRmnjo77buREks8ETKrrwLI/QtPOs1epYPaQSxcRZPenDFVpoDy9e8gcqTIge8YBqfATNkwRBGLd2j4+rUkWer0RD6rgBAdhIKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409689; c=relaxed/simple;
	bh=zCLt1oZyiHCkFSVOYbHL+RsgPT/dgTxUi2+PxJ+6W54=;
	h=Date:To:From:Subject:Message-Id; b=KTEaSX6zFu2HB0qqb4raYcZIn/UNKAAsZmn13X7pxaVvvBoNvDSUFdhL1X7sMALjpxTJritflIjoHI3Kq8hAqdqDsbDgkYsMtvqJEAac8QxGafcr8zThbuJvfjntz9kzTMc6dik2aj4U+g4PGxi+JkSu/me0PQjQLNAx0Qfb/wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g6XQfuho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g6XQfuho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278F3C4CEED;
	Fri, 25 Jul 2025 02:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409689;
	bh=zCLt1oZyiHCkFSVOYbHL+RsgPT/dgTxUi2+PxJ+6W54=;
	h=Date:To:From:Subject:From;
	b=g6XQfuho2RUYnnSSJ+zqHXKwjG+faoAj3uSxqlERO5NqzfSXD+4NRFnXruao74fD7
	 mr5EordQ0ixOuL8gie+o6sLjwpo8EoZLo9DPCZaLPiywL1Q5fczrQ2T9nkOq8HuPDO
	 Mvb4OLr4XQyONM3eKzs81fog4IQOE7Bimlxu6eGo=
Date: Thu, 24 Jul 2025 19:14:48 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch removed from -mm tree
Message-Id: <20250725021449.278F3C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document refresh_ms file
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-damon-sysfspy-stop-damon-for-dumping-failures.patch
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
selftests-damon-sysfspy-generalize-damos-scheme-commit-assertion.patch
selftests-damon-sysfspy-test-damos-filters-commitment.patch
selftests-damon-sysfspy-generalize-damos-schemes-commit-assertion.patch
selftests-damon-sysfspy-generalize-monitoring-attributes-commit-assertion.patch
selftests-damon-sysfspy-generalize-damon-context-commit-assertion.patch
selftests-damon-sysfspy-test-non-default-parameters-runtime-commit.patch
selftests-damon-sysfspy-test-runtime-reduction-of-damon-parameters.patch


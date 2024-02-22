Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D2D2919
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560136; cv=none; b=bSNoUGMXq8FpP/dgq6xOh8D83JmOauj2UV156EVQ6vtPFhI1iqk7IvSsaPjXvydPIeEzMXUmCY9OFU2ub+5aq7wQrHzfdjS0ZsdPHjVB0cvqCxyYyuW1RqyxKzNQFsn6w64N0JnsLCVc6JzwWCNljbpX75X6YbPGMxn1A1e1EUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560136; c=relaxed/simple;
	bh=wD/hihbNjeYT8Np6v/MDx/amUMYHgLL/fpu6miObuVg=;
	h=Date:To:From:Subject:Message-Id; b=LLTcD5eZ6Z3Gz+CEqius5h6GahWu8Benrgr7KcQbUH4e0hxJsBMIyq1eguTPVlGEvulkLBPTd0JXk+jAj+lRCyX8MLWLp2/FQ7Q7AoRZ4M7L3yr3vY5pxva7KR6XinMC0mlz7zEzu+MiiCb5nbq6F8f1KDrDrJCLDtMMkgzlfB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FOycKPuo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FOycKPuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFC3C433F1;
	Thu, 22 Feb 2024 00:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560136;
	bh=wD/hihbNjeYT8Np6v/MDx/amUMYHgLL/fpu6miObuVg=;
	h=Date:To:From:Subject:From;
	b=FOycKPuo/PbQWWigN3ItDPDkLAqf7r+Jp+wMnJfPZUQJYncWxIkuJuiWDnsxIueoz
	 W1kkeWc6rzvFJr18oFqVHrGgCfFjW0ImcZgyX9OPzUxYk+xWfC/rx10gFQF3GLz6jr
	 NPXZg6hcOzMhwVs5314ulkPrnwe+kx7mjq4/iu2c=
Date: Wed, 21 Feb 2024 16:02:16 -0800
To: mm-commits@vger.kernel.org,siyanteng@loongson.cn,shuah@kernel.org,corbet@lwn.net,alexs@kernel.org,2023002089@link.tyut.edu.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-update-for-monitor_on-renaming.patch removed from -mm tree
Message-Id: <20240222000216.9CFC3C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for monitor_on renaming
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-update-for-monitor_on-renaming.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: update for monitor_on renaming
Date: Mon, 29 Jan 2024 17:35:47 -0800

Update DAMON debugfs interface sections on the usage document to reflect
the fact that 'monitor_on' file has renamed to 'monitor_on_DEPRECATED'.

Link: https://lkml.kernel.org/r/20240130013549.89538-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   29 ++++++++---------
 1 file changed, 15 insertions(+), 14 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-monitor_on-renaming
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -629,8 +629,9 @@ debugfs Interface (DEPRECATED!)
   linux-mm@kvack.org.
 
 DAMON exports nine files, ``DEPRECATED``, ``attrs``, ``target_ids``,
-``init_regions``, ``schemes``, ``monitor_on``, ``kdamond_pid``, ``mk_contexts``
-and ``rm_contexts`` under its debugfs directory, ``<debugfs>/damon/``.
+``init_regions``, ``schemes``, ``monitor_on_DEPRECATED``, ``kdamond_pid``,
+``mk_contexts`` and ``rm_contexts`` under its debugfs directory,
+``<debugfs>/damon/``.
 
 
 ``DEPRECATED`` is a read-only file for the DAMON debugfs interface deprecation
@@ -855,16 +856,16 @@ Turning On/Off
 
 Setting the files as described above doesn't incur effect unless you explicitly
 start the monitoring.  You can start, stop, and check the current status of the
-monitoring by writing to and reading from the ``monitor_on`` file.  Writing
-``on`` to the file starts the monitoring of the targets with the attributes.
-Writing ``off`` to the file stops those.  DAMON also stops if every target
-process is terminated.  Below example commands turn on, off, and check the
-status of DAMON::
+monitoring by writing to and reading from the ``monitor_on_DEPRECATED`` file.
+Writing ``on`` to the file starts the monitoring of the targets with the
+attributes.  Writing ``off`` to the file stops those.  DAMON also stops if
+every target process is terminated.  Below example commands turn on, off, and
+check the status of DAMON::
 
     # cd <debugfs>/damon
-    # echo on > monitor_on
-    # echo off > monitor_on
-    # cat monitor_on
+    # echo on > monitor_on_DEPRECATED
+    # echo off > monitor_on_DEPRECATED
+    # cat monitor_on_DEPRECATED
     off
 
 Please note that you cannot write to the above-mentioned debugfs files while
@@ -880,11 +881,11 @@ can get the pid of the thread by reading
 monitoring is turned off, reading the file returns ``none``. ::
 
     # cd <debugfs>/damon
-    # cat monitor_on
+    # cat monitor_on_DEPRECATED
     off
     # cat kdamond_pid
     none
-    # echo on > monitor_on
+    # echo on > monitor_on_DEPRECATED
     # cat kdamond_pid
     18594
 
@@ -914,5 +915,5 @@ directory by putting the name of the con
     # ls foo
     # ls: cannot access 'foo': No such file or directory
 
-Note that ``mk_contexts``, ``rm_contexts``, and ``monitor_on`` files are in the
-root directory only.
+Note that ``mk_contexts``, ``rm_contexts``, and ``monitor_on_DEPRECATED`` files
+are in the root directory only.
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723788002D
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O8vR+/g6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B852C433CA;
	Tue, 12 Dec 2023 18:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407577;
	bh=PfLFBcib+UgSh0vPVzfYrgISTxlMSbb3kHG01tExXr8=;
	h=Date:To:From:Subject:From;
	b=O8vR+/g63Hm0zA3Kvgqenl+2w/UmeJ6OtfsRMO3F76zgRLdLu13/hywD8ACoNjsxB
	 XVTw67bMPjauD+gwhokqE+ASIhy2WNi7iSOrptgsTTtFZTJE00ideKNT26LrNUmtmX
	 e2sGmoTw6mgbLxNvaL6vyWnMz5VlQkk5FD1D2m2c=
Date: Tue, 12 Dec 2023 10:59:36 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,corbet@lwn.net,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-document-for-quota-goals.patch removed from -mm tree
Message-Id: <20231212185937.3B852C433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document for quota goals
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-document-for-quota-goals.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: document for quota goals
Date: Thu, 30 Nov 2023 02:36:52 +0000

Update DAMON sysfs usage for newly added DAMOS quota goals interface.

Link: https://lkml.kernel.org/r/20231130023652.50284-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   48 ++++++++++++++---
 Documentation/mm/damon/design.rst            |    2 
 2 files changed, 43 insertions(+), 7 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-for-quota-goals
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -83,6 +83,8 @@ comma (","). ::
     │ │ │ │ │ │ │ │ age/min,max
     │ │ │ │ │ │ │ quotas/ms,bytes,reset_interval_ms
     │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
+    │ │ │ │ │ │ │ │ goals/nr_goals
+    │ │ │ │ │ │ │ │ │ 0/target_value,current_value
     │ │ │ │ │ │ │ watermarks/metric,interval_us,high,mid,low
     │ │ │ │ │ │ │ filters/nr_filters
     │ │ │ │ │ │ │ │ 0/type,matching,memcg_id
@@ -113,6 +115,8 @@ details) exists.  In the beginning, this
 child directories named ``0`` to ``N-1``.  Each directory represents each
 kdamond.
 
+.. _sysfs_kdamond:
+
 kdamonds/<N>/
 -------------
 
@@ -121,11 +125,18 @@ In each kdamond directory, two files (``
 
 Reading ``state`` returns ``on`` if the kdamond is currently running, or
 ``off`` if it is not running.  Writing ``on`` or ``off`` makes the kdamond be
-in the state.  Writing ``commit`` to the ``state`` file makes kdamond reads the
+in the state.
+
+Writing ``commit`` to the ``state`` file makes kdamond reads the
 user inputs in the sysfs files except ``state`` file again.  Writing
-``update_schemes_stats`` to ``state`` file updates the contents of stats files
-for each DAMON-based operation scheme of the kdamond.  For details of the
-stats, please refer to :ref:`stats section <sysfs_schemes_stats>`.
+``commit_schemes_quota_goals`` to the ``state`` file makes kdamond reads the
+DAMON-based operation schemes' :ref:`quota goals <sysfs_schemes_quota_goals>`
+of the kdamond.
+
+Writing ``update_schemes_stats`` to ``state`` file updates the
+contents of stats files for each DAMON-based operation scheme of the kdamond.
+For details of the stats, please refer to :ref:`stats section
+<sysfs_schemes_stats>`.
 
 Writing ``update_schemes_tried_regions`` to ``state`` file updates the
 DAMON-based operation scheme action tried regions directory for each
@@ -319,8 +330,7 @@ The directory for the :ref:`quotas <damo
 DAMON-based operation scheme.
 
 Under ``quotas`` directory, three files (``ms``, ``bytes``,
-``reset_interval_ms``) and one directory (``weights``) having three files
-(``sz_permil``, ``nr_accesses_permil``, and ``age_permil``) in it exist.
+``reset_interval_ms``) and two directores (``weights`` and ``goals``) exist.
 
 You can set the ``time quota`` in milliseconds, ``size quota`` in bytes, and
 ``reset interval`` in milliseconds by writing the values to the three files,
@@ -330,11 +340,35 @@ apply the action to only up to ``bytes``
 ``reset_interval_ms``.  Setting both ``ms`` and ``bytes`` zero disables the
 quota limits.
 
-You can also set the :ref:`prioritization weights
+Under ``weights`` directory, three files (``sz_permil``,
+``nr_accesses_permil``, and ``age_permil``) exist.
+You can set the :ref:`prioritization weights
 <damon_design_damos_quotas_prioritization>` for size, access frequency, and age
 in per-thousand unit by writing the values to the three files under the
 ``weights`` directory.
 
+.. _sysfs_schemes_quota_goals:
+
+schemes/<N>/quotas/goals/
+-------------------------
+
+The directory for the :ref:`automatic quota tuning goals
+<damon_design_damos_quotas_auto_tuning>` of the given DAMON-based operation
+scheme.
+
+In the beginning, this directory has only one file, ``nr_goals``.  Writing a
+number (``N``) to the file creates the number of child directories named ``0``
+to ``N-1``.  Each directory represents each goal and current achievement.
+Among the multiple feedback, the best one is used.
+
+Each goal directory contains two files, namely ``target_value`` and
+``current_value``.  Users can set and get any number to those files to set the
+feedback.  User space main workload's latency or throughput, system metrics
+like free memory ratio or memory pressure stall time (PSI) could be example
+metrics for the values.  Note that users should write
+``commit_schemes_quota_goals`` to the ``state`` file of the :ref:`kdamond
+directory <sysfs_kdamond>` to pass the feedback to DAMON.
+
 schemes/<N>/watermarks/
 -----------------------
 
--- a/Documentation/mm/damon/design.rst~docs-admin-guide-mm-damon-usage-document-for-quota-goals
+++ a/Documentation/mm/damon/design.rst
@@ -346,6 +346,8 @@ the weight will be respected are up to t
 implementation.
 
 
+.. _damon_design_damos_quotas_auto_tuning:
+
 Aim-oriented Feedback-driven Auto-tuning
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-make-damon_start-waits-until-kdamond_fn-starts.patch


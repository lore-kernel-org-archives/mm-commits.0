Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62233745C3
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 19:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OTg85Pbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF20CC433C7;
	Wed, 13 Dec 2023 19:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702496975;
	bh=kHxQUlOCtydNloc0e65XeffnHEHKS6ELMAJBFKVubhk=;
	h=Date:To:From:Subject:From;
	b=OTg85PbxtuIeqiJ1NKKImu8JrudeGFJjlTPlMJ46UaatHXgCHC/KFtW8ZZeHmLgI0
	 biyu5WaFFwPDLSXNL9BOvM4oNo584zP5FKWy9QMo1dAtipcnA5+eoITA0YfGd0GJIe
	 XLPGGc43bJy3rh8wOidxzmc1FBPR3vMw/lvQkKHc=
Date: Wed, 13 Dec 2023 11:49:35 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-add-links-to-sysfs-files-hierarchy.patch added to mm-unstable branch
Message-Id: <20231213194935.CF20CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: add links to sysfs files hierarchy
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-add-links-to-sysfs-files-hierarchy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-add-links-to-sysfs-files-hierarchy.patch

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
Subject: Docs/admin-guide/mm/damon/usage: add links to sysfs files hierarchy
Date: Wed, 13 Dec 2023 19:03:37 +0000

'Sysfs Files Hierarchy' section of DAMON usage document shows whole
picture of the interface.  Then sections for detailed explanation of the
files follow.  Due to the amount of the files, navigating between the
whole picture and the section for specific files sometimes require no
subtle amount of scrolling.  Add links from the whole picture to the
dedicated sections for making the navigation easier.

Link: https://lkml.kernel.org/r/20231213190338.54146-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   68 ++++++++++++-----
 1 file changed, 48 insertions(+), 20 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-add-links-to-sysfs-files-hierarchy
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -59,43 +59,47 @@ Files Hierarchy
 The files hierarchy of DAMON sysfs interface is shown below.  In the below
 figure, parents-children relations are represented with indentations, each
 directory is having ``/`` suffix, and files in each directory are separated by
-comma (","). ::
+comma (",").
 
-    /sys/kernel/mm/damon/admin
-    │ kdamonds/nr_kdamonds
-    │ │ 0/state,pid
-    │ │ │ contexts/nr_contexts
-    │ │ │ │ 0/avail_operations,operations
-    │ │ │ │ │ monitoring_attrs/
+.. parsed-literal::
+
+    :ref:`/sys/kernel/mm/damon <sysfs_root>`/admin
+    │ :ref:`kdamonds <sysfs_kdamonds>`/nr_kdamonds
+    │ │ :ref:`0 <sysfs_kdamond>`/state,pid
+    │ │ │ :ref:`contexts <sysfs_contexts>`/nr_contexts
+    │ │ │ │ :ref:`0 <sysfs_context>`/avail_operations,operations
+    │ │ │ │ │ :ref:`monitoring_attrs <sysfs_monitoring_attrs>`/
     │ │ │ │ │ │ intervals/sample_us,aggr_us,update_us
     │ │ │ │ │ │ nr_regions/min,max
-    │ │ │ │ │ targets/nr_targets
-    │ │ │ │ │ │ 0/pid_target
-    │ │ │ │ │ │ │ regions/nr_regions
-    │ │ │ │ │ │ │ │ 0/start,end
+    │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
+    │ │ │ │ │ │ :ref:`0 <sysfs_target>`/pid_target
+    │ │ │ │ │ │ │ :ref:`regions <sysfs_regions>`/nr_regions
+    │ │ │ │ │ │ │ │ :ref:`0 <sysfs_region>`/start,end
     │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ ...
-    │ │ │ │ │ schemes/nr_schemes
-    │ │ │ │ │ │ 0/action,apply_interval_us
-    │ │ │ │ │ │ │ access_pattern/
+    │ │ │ │ │ :ref:`schemes <sysfs_schemes>`/nr_schemes
+    │ │ │ │ │ │ :ref:`0 <sysfs_scheme>`/action,apply_interval_us
+    │ │ │ │ │ │ │ :ref:`access_pattern <sysfs_access_pattern>`/
     │ │ │ │ │ │ │ │ sz/min,max
     │ │ │ │ │ │ │ │ nr_accesses/min,max
     │ │ │ │ │ │ │ │ age/min,max
-    │ │ │ │ │ │ │ quotas/ms,bytes,reset_interval_ms
+    │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms
     │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
-    │ │ │ │ │ │ │ │ goals/nr_goals
+    │ │ │ │ │ │ │ │ :ref:`goals <sysfs_schemes_quota_goals>`/nr_goals
     │ │ │ │ │ │ │ │ │ 0/target_value,current_value
-    │ │ │ │ │ │ │ watermarks/metric,interval_us,high,mid,low
-    │ │ │ │ │ │ │ filters/nr_filters
+    │ │ │ │ │ │ │ :ref:`watermarks <sysfs_watermarks>`/metric,interval_us,high,mid,low
+    │ │ │ │ │ │ │ :ref:`filters <sysfs_filters>`/nr_filters
     │ │ │ │ │ │ │ │ 0/type,matching,memcg_id
-    │ │ │ │ │ │ │ stats/nr_tried,sz_tried,nr_applied,sz_applied,qt_exceeds
-    │ │ │ │ │ │ │ tried_regions/total_bytes
+    │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,qt_exceeds
+    │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
     │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age
     │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ ...
     │ │ │ │ ...
     │ │ ...
 
+.. _sysfs_root:
+
 Root
 ----
 
@@ -104,6 +108,8 @@ has one directory named ``admin``.  The
 privileged user space programs' control of DAMON.  User space tools or daemons
 having the root permission could use this directory.
 
+.. _sysfs_kdamonds:
+
 kdamonds/
 ---------
 
@@ -154,6 +160,8 @@ If the state is ``on``, reading ``pid``
 ``contexts`` directory contains files for controlling the monitoring contexts
 that this kdamond will execute.
 
+.. _sysfs_contexts:
+
 kdamonds/<N>/contexts/
 ----------------------
 
@@ -214,6 +222,8 @@ writing to and rading from the files.
 For more details about the intervals and monitoring regions range, please refer
 to the Design document (:doc:`/mm/damon/design`).
 
+.. _sysfs_targets:
+
 contexts/<N>/targets/
 ---------------------
 
@@ -221,6 +231,8 @@ In the beginning, this directory has onl
 number (``N``) to the file creates the number of child directories named ``0``
 to ``N-1``.  Each directory represents each monitoring target.
 
+.. _sysfs_target:
+
 targets/<N>/
 ------------
 
@@ -255,6 +267,8 @@ In the beginning, this directory has onl
 number (``N``) to the file creates the number of child directories named ``0``
 to ``N-1``.  Each directory represents each initial monitoring target region.
 
+.. _sysfs_region:
+
 regions/<N>/
 ------------
 
@@ -265,6 +279,8 @@ region by writing to and reading from th
 Each region should not overlap with others.  ``end`` of directory ``N`` should
 be equal or smaller than ``start`` of directory ``N+1``.
 
+.. _sysfs_schemes:
+
 contexts/<N>/schemes/
 ---------------------
 
@@ -276,6 +292,8 @@ In the beginning, this directory has onl
 number (``N``) to the file creates the number of child directories named ``0``
 to ``N-1``.  Each directory represents each DAMON-based operation scheme.
 
+.. _sysfs_scheme:
+
 schemes/<N>/
 ------------
 
@@ -310,6 +328,8 @@ Note that support of each action depends
 The ``apply_interval_us`` file is for setting and getting the scheme's
 :ref:`apply_interval <damon_design_damos>` in microseconds.
 
+.. _sysfs_access_pattern:
+
 schemes/<N>/access_pattern/
 ---------------------------
 
@@ -323,6 +343,8 @@ to and reading from the ``min`` and ``ma
 ``nr_accesses``, and ``age`` directories, respectively.  Note that the ``min``
 and the ``max`` form a closed interval.
 
+.. _sysfs_quotas:
+
 schemes/<N>/quotas/
 -------------------
 
@@ -369,6 +391,8 @@ metrics for the values.  Note that users
 ``commit_schemes_quota_goals`` to the ``state`` file of the :ref:`kdamond
 directory <sysfs_kdamond>` to pass the feedback to DAMON.
 
+.. _sysfs_watermarks:
+
 schemes/<N>/watermarks/
 -----------------------
 
@@ -388,6 +412,8 @@ as below.
 
 The ``interval`` should written in microseconds unit.
 
+.. _sysfs_filters:
+
 schemes/<N>/filters/
 --------------------
 
@@ -483,6 +509,8 @@ and query-like efficient data access mon
 latter use case, in particular, users can set the ``action`` as ``stat`` and
 set the ``access pattern`` as their interested pattern that they want to query.
 
+.. _sysfs_schemes_tried_region:
+
 tried_regions/<N>/
 ------------------
 
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-implement-a-python-module-for-test-purpose-damon-sysfs-controls.patch
selftests-damon-_damon_sysfs-implement-kdamonds-start-function.patch
selftests-damon-_damon_sysfs-implement-updat_schemes_tried_bytes-command.patch
selftests-damon-add-a-test-for-update_schemes_tried_regions-sysfs-command.patch
selftests-damon-add-a-test-for-update_schemes_tried_regions-hang-bug.patch
mm-damon-update-email-of-seongjae.patch
mm-damon-core-test-test-max_nr_accesses-overflow-caused-divide-by-zero.patch
docs-mm-damon-design-place-execution-model-and-data-structures-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-context-directory-section-label.patch
docs-admin-guide-mm-damon-usage-add-links-to-sysfs-files-hierarchy.patch
docs-admin-guide-mm-damon-usage-use-a-list-for-state-sysfs-file-input-commands.patch


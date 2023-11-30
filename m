Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD60CC10F04
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 22:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377137AbjK3WXf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 17:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377155AbjK3WXW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 17:23:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A411171E
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 14:23:26 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D8CC433C7;
        Thu, 30 Nov 2023 22:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701383006;
        bh=OoYx1/V71+cprmNUIyIpjf4XM7bwyVYSMCenz7UfR/w=;
        h=Date:To:From:Subject:From;
        b=lwMJsK7EvtI6XZRFK5rKO431IM/7ifCw1TA2LgbNjGOObRb1LZHE3MJkidjpuA6bE
         +LJEQ//A2NsCRJkt/Fb7sHFA+wV7MB2Sdyg+M8CO1bWgGLVv8qDawMOD84AlMsUMTZ
         dG7oux7I8/t0VKt7SzbPelXJ5ojLzjhxRIkwZk4o=
Date:   Thu, 30 Nov 2023 14:23:25 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, davidgow@google.com,
        corbet@lwn.net, brendanhiggins@google.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-document-for-quota-goals.patch added to mm-unstable branch
Message-Id: <20231130222326.05D8CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document for quota goals
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-document-for-quota-goals.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-document-for-quota-goals.patch

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

mm-damon-core-copy-nr_accesses-when-splitting-region.patch
mm-damon-sysfs-schemes-add-timeout-for-update_schemes_tried_regions.patch
mm-damon-core-test-test-damon_split_region_ats-access-rate-copying.patch
mm-damon-core-implement-goal-oriented-feedback-driven-quota-auto-tuning.patch
mm-damon-sysfs-schemes-implement-files-for-scheme-quota-goals-setup.patch
mm-damon-sysfs-schemes-commit-damos-quota-goals-user-input-to-damos.patch
mm-damon-sysfs-schemes-implement-a-command-for-scheme-quota-goals-only-commit.patch
mm-damon-core-test-add-a-unit-test-for-the-feedback-loop-algorithm.patch
selftests-damon-test-quota-goals-directory.patch
docs-mm-damon-design-document-damos-quota-auto-tuning.patch
docs-abi-damon-document-damos-quota-goals.patch
docs-admin-guide-mm-damon-usage-document-for-quota-goals.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3173C4321E
	for <mm-commits@archiver.kernel.org>; Tue,  1 Nov 2022 22:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiKAW64 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Nov 2022 18:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiKAW6n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2022 18:58:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDA921AA
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 15:58:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1D99B82000
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 22:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8CDC433D6;
        Tue,  1 Nov 2022 22:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667343519;
        bh=PXp8h9BNsbvUw37fbRB/LvlUynshC+5zU6485sorG1U=;
        h=Date:To:From:Subject:From;
        b=FVZR7opp6MgJsWqmPYSywvD7hhPm+62xsE9Jr4RmEOrSTarllQr/e7JNOxDwcdzTd
         JVBW1OSPjAjdm0uhRkrPxJeXuRBi3ScgPMOfhVR4UdtA1FO4g5/kY++5HDFnh7XzSd
         UOhmt3y06qjqrEFQyszub7AMOHdA3+35eYqvKP84=
Date:   Tue, 01 Nov 2022 15:58:39 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch added to mm-unstable branch
Message-Id: <20221101225839.7D8CDC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document schemes/<s>/tried_regions sysfs directory
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch

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
Subject: Docs/admin-guide/mm/damon/usage: document schemes/<s>/tried_regions sysfs directory
Date: Tue, 1 Nov 2022 22:03:27 +0000

Document 'tried_regions' directory in DAMON sysfs interface usage in the
administrator guide.

Link: https://lkml.kernel.org/r/20221101220328.95765-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   45 +++++++++++++++--
 1 file changed, 42 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -88,6 +88,9 @@ comma (","). ::
     │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
     │ │ │ │ │ │ │ watermarks/metric,interval_us,high,mid,low
     │ │ │ │ │ │ │ stats/nr_tried,sz_tried,nr_applied,sz_applied,qt_exceeds
+    │ │ │ │ │ │ │ tried_regions/
+    │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age
+    │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ ...
     │ │ │ │ ...
     │ │ ...
@@ -125,7 +128,14 @@ in the state.  Writing ``commit`` to the
 user inputs in the sysfs files except ``state`` file again.  Writing
 ``update_schemes_stats`` to ``state`` file updates the contents of stats files
 for each DAMON-based operation scheme of the kdamond.  For details of the
-stats, please refer to :ref:`stats section <sysfs_schemes_stats>`.
+stats, please refer to :ref:`stats section <sysfs_schemes_stats>`.  Writing
+``update_schemes_tried_regions`` to ``state`` file updates the DAMON-based
+operation scheme action tried regions directory for each DAMON-based operation
+scheme of the kdamond.  Writing ``clear_schemes_tried_regions`` to ``state``
+file clears the DAMON-based operating scheme action tried regions directory for
+each DAMON-based operation scheme of the kdamond.  For details of the
+DAMON-based operation scheme action tried regions directory, please refer to
+:ref:tried_regions section <sysfs_schemes_tried_regions>`.
 
 If the state is ``on``, reading ``pid`` shows the pid of the kdamond thread.
 
@@ -166,6 +176,8 @@ You can set and get what type of monitor
 context by writing one of the keywords listed in ``avail_operations`` file and
 reading from the ``operations`` file.
 
+.. _sysfs_monitoring_attrs:
+
 contexts/<N>/monitoring_attrs/
 ------------------------------
 
@@ -255,8 +267,9 @@ to ``N-1``.  Each directory represents e
 schemes/<N>/
 ------------
 
-In each scheme directory, four directories (``access_pattern``, ``quotas``,
-``watermarks``, and ``stats``) and one file (``action``) exist.
+In each scheme directory, five directories (``access_pattern``, ``quotas``,
+``watermarks``, ``stats``, and ``tried_regions``) and one file (``action``)
+exist.
 
 The ``action`` file is for setting and getting what action you want to apply to
 memory regions having specific access pattern of the interest.  The keywords
@@ -351,6 +364,32 @@ should ask DAMON sysfs interface to updt
 stats by writing a special keyword, ``update_schemes_stats`` to the relevant
 ``kdamonds/<N>/state`` file.
 
+.. _sysfs_schemes_tried_regions:
+
+schemes/<N>/tried_regions/
+--------------------------
+
+When a special keyword, ``update_schemes_tried_regions``, is written to the
+relevant ``kdamonds/<N>/state`` file, DAMON creates directories named integer
+starting from ``0`` under this directory.  Each directory contains files
+exposing detailed information about each of the memory region that the
+corresponding scheme's ``action`` has tried to be applied under this directory,
+during next :ref:`aggregation interval <sysfs_monitoring_attrs>`.  The
+information includes address range, ``nr_accesses``, , and ``age`` of the
+region.
+
+The directories will be removed when another special keyword,
+``clear_schemes_tried_regions``, is written to the relevant
+``kdamonds/<N>/state`` file.
+
+tried_regions/<N>/
+------------------
+
+In each region directory, you will find four files (``start``, ``end``,
+``nr_accesses``, and ``age``).  Reading the files will show the start and end
+addresses, ``nr_accesses``, and ``age`` of the region that corresponding
+DAMON-based operation scheme ``action`` has tried to be applied.
+
 Example
 ~~~~~~~
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-split-out-damos-charged-region-skip-logic-into-a-new-function.patch
mm-damon-core-split-damos-application-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-stat-update-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-quota-adjustment-logic-into-a-new-function.patch
mm-damon-sysfs-use-damon_addr_range-for-regions-start-and-end-values.patch
mm-damon-sysfs-remove-parameters-of-damon_sysfs_region_alloc.patch
mm-damon-sysfs-move-sysfs_lock-to-common-module.patch
mm-damon-sysfs-move-unsigned-long-range-directory-to-common-module.patch
mm-damon-sysfs-split-out-kdamond-independent-schemes-stats-update-logic-into-a-new-function.patch
mm-damon-sysfs-split-out-schemes-directory-implementation-to-separate-file.patch
mm-damon-modules-deduplicate-init-steps-for-damon-context-setup.patch
mm-damon-reclaimlru_sort-remove-unnecessarily-included-headers.patch
mm-damon-reclaim-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_reclaims-enabled-parameter.patch
mm-damon-lru_sort-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_lru_sorts-enabled-parameter.patch
docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch
docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch
mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch
mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch
mm-damon-sysfs-schemes-implement-scheme-region-directory.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch
tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch
docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch
docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch


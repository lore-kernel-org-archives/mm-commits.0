Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8AE7C4321E
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 16:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379065AbiD2Q3z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 12:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379070AbiD2Q3f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 12:29:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF7AD95F8
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 09:26:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C629D62315
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 16:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D515C385A4;
        Fri, 29 Apr 2022 16:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651249573;
        bh=msH11BAjZVORdN78rRRjfGM654F3sfPCIn4EFlw8YMI=;
        h=Date:To:From:Subject:From;
        b=fqpZvjmYVxbE/CZrfC8KDGmBp5+tC+Sq/pGQWugZcHD/PbNwW9lGkh01075xubq4H
         +BViqvOqpoK4l3A3YhXzb5qslH9WZDuf+fB+owBzLvCWlnco2LsJxsCJb6VG8GF4wU
         lsul0YO6dlXHlpsDFFO0+NBQviwQiOt7LHEWWJ6g=
Date:   Fri, 29 Apr 2022 09:26:12 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-abiadmin-guide-damon-update-for-state-sysfs-file-input-keyword-commit.patch added to mm-unstable branch
Message-Id: <20220429162613.2D515C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/{ABI,admin-guide}/damon: Update for 'state' sysfs file input keyword, 'commit'
has been added to the -mm mm-unstable branch.  Its filename is
     docs-abiadmin-guide-damon-update-for-state-sysfs-file-input-keyword-commit.patch

This patch should soon appear in the mm-unstable branch at
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
Subject: Docs/{ABI,admin-guide}/damon: Update for 'state' sysfs file input keyword, 'commit'

This commit documents the newly added 'state' sysfs file input keyword,
'commit', which allows online tuning of DAMON contexts.

Link: https://lkml.kernel.org/r/20220429160606.127307-13-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    7 ++++---
 Documentation/admin-guide/mm/damon/usage.rst    |    9 +++++----
 2 files changed, 9 insertions(+), 7 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abiadmin-guide-damon-update-for-state-sysfs-file-input-keyword-commit
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -23,9 +23,10 @@ Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing 'on' or 'off' to this file makes the kdamond starts or
 		stops, respectively.  Reading the file returns the keywords
-		based on the current status.  Writing 'update_schemes_stats' to
-		the file updates contents of schemes stats files of the
-		kdamond.
+		based on the current status.  Writing 'commit' to this file
+		makes the kdamond reads the user inputs in the sysfs files
+		except 'state' again.  Writing 'update_schemes_stats' to the
+		file updates contents of schemes stats files of the kdamond.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/pid
 Date:		Mar 2022
--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-abiadmin-guide-damon-update-for-state-sysfs-file-input-keyword-commit
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -121,10 +121,11 @@ In each kdamond directory, two files (``
 
 Reading ``state`` returns ``on`` if the kdamond is currently running, or
 ``off`` if it is not running.  Writing ``on`` or ``off`` makes the kdamond be
-in the state.  Writing ``update_schemes_stats`` to ``state`` file updates the
-contents of stats files for each DAMON-based operation scheme of the kdamond.
-For details of the stats, please refer to :ref:`stats section
-<sysfs_schemes_stats>`.
+in the state.  Writing ``commit`` to the ``state`` file makes kdamond reads the
+user inputs in the sysfs files except ``state`` file again.  Writing
+``update_schemes_stats`` to ``state`` file updates the contents of stats files
+for each DAMON-based operation scheme of the kdamond.  For details of the
+stats, please refer to :ref:`stats section <sysfs_schemes_stats>`.
 
 If the state is ``on``, reading ``pid`` shows the pid of the kdamond thread.
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-test-add-a-kunit-test-case-for-ops-registration.patch
mm-damon-core-add-a-function-for-damon_operations-registration-checks.patch
mm-damon-sysfs-add-a-file-for-listing-available-monitoring-ops.patch
selftets-damon-sysfs-test-existence-and-permission-of-avail_operations.patch
docs-abiadmin-guide-damon-document-avail_operations-sysfs-file.patch
mm-damon-vaddr-register-a-damon_operations-for-fixed-virtual-address-ranges-monitoring.patch
mm-damon-sysfs-support-fixed-virtual-address-ranges-monitoring.patch
docs-abiadmin-guide-damon-update-for-fixed-virtual-address-ranges-monitoring.patch
mm-damon-core-add-a-new-callback-for-watermarks-checks.patch
mm-damon-core-finish-kdamond-as-soon-as-any-callback-returns-an-error.patch
mm-damon-vaddr-generalize-damon_va_apply_three_regions.patch
mm-damon-vaddr-move-damon_set_regions-to-core.patch
mm-damon-vaddr-remove-damon_va_apply_three_regions.patch
mm-damon-sysfs-prohibit-multiple-physical-address-space-monitoring-targets.patch
mm-damon-sysfs-move-targets-setup-code-to-a-separated-function.patch
mm-damon-sysfs-reuse-damon_set_regions-for-regions-setting.patch
mm-damon-sysfs-use-enum-for-state-input-handling.patch
mm-damon-sysfs-update-schemes-stat-in-the-kdamond-context.patch
mm-damon-sysfs-support-online-inputs-update.patch
docs-abiadmin-guide-damon-update-for-state-sysfs-file-input-keyword-commit.patch
mm-damon-reclaim-support-online-inputs-update.patch
docs-admin-guide-mm-damon-reclaim-document-commit_inputs-parameter.patch


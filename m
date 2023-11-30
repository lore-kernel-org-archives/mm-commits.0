Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 271B5C4167B
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 22:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377147AbjK3WXe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 17:23:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377137AbjK3WXW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 17:23:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BDA171C
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 14:23:25 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5650C433C8;
        Thu, 30 Nov 2023 22:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701383005;
        bh=EQKIA+4px2lWvm2gy4DiLIWdCYdEuZluHpNeor7fGuo=;
        h=Date:To:From:Subject:From;
        b=AvcrL8iGTXvUTfvv5AUrcagnEdosMGJuLsV2T6gaFWy7XUY5eUIOvezwtwEW0wtNm
         8XsdP8tkWh5gZwE3gyqEx2vCuiyyZm5TX26P9YOpudejlBwbjrfwBKRtUTJU+/fy9W
         aUEVvnHIgYNtxb9chKEtZzB1cV8mS6RDpD7tVIAw=
Date:   Thu, 30 Nov 2023 14:23:24 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, davidgow@google.com,
        corbet@lwn.net, brendanhiggins@google.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-abi-damon-document-damos-quota-goals.patch added to mm-unstable branch
Message-Id: <20231130222324.E5650C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/ABI/damon: document DAMOS quota goals
has been added to the -mm mm-unstable branch.  Its filename is
     docs-abi-damon-document-damos-quota-goals.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-abi-damon-document-damos-quota-goals.patch

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
Subject: Docs/ABI/damon: document DAMOS quota goals
Date: Thu, 30 Nov 2023 02:36:51 +0000

Update DAMON ABI document for the newly added DAMON sysfs files and inputs
for DAMOS quota goals.

Link: https://lkml.kernel.org/r/20231130023652.50284-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |   33 +++++++++++---
 1 file changed, 27 insertions(+), 6 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-document-damos-quota-goals
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -25,12 +25,14 @@ Description:	Writing 'on' or 'off' to th
 		stops, respectively.  Reading the file returns the keywords
 		based on the current status.  Writing 'commit' to this file
 		makes the kdamond reads the user inputs in the sysfs files
-		except 'state' again.  Writing 'update_schemes_stats' to the
-		file updates contents of schemes stats files of the kdamond.
-		Writing 'update_schemes_tried_regions' to the file updates
-		contents of 'tried_regions' directory of every scheme directory
-		of this kdamond.  Writing 'update_schemes_tried_bytes' to the
-		file updates only '.../tried_regions/total_bytes' files of this
+		except 'state' again.  Writing 'commit_schemes_quota_goals' to
+		this file makes the kdamond reads the quota goal files again.
+		Writing 'update_schemes_stats' to the file updates contents of
+		schemes stats files of the kdamond.  Writing
+		'update_schemes_tried_regions' to the file updates contents of
+		'tried_regions' directory of every scheme directory of this
+		kdamond.  Writing 'update_schemes_tried_bytes' to the file
+		updates only '.../tried_regions/total_bytes' files of this
 		kdamond.  Writing 'clear_schemes_tried_regions' to the file
 		removes contents of the 'tried_regions' directory.
 
@@ -212,6 +214,25 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the quotas
 		charge reset interval of the scheme in milliseconds.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/nr_goals
+Date:		Nov 2023
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a number 'N' to this file creates the number of
+		directories for setting automatic tuning of the scheme's
+		aggressiveness named '0' to 'N-1' under the goals/ directory.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/target_value
+Date:		Nov 2023
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the target
+		value of the goal metric.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/current_value
+Date:		Nov 2023
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the current
+		value of the goal metric.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/weights/sz_permil
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
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


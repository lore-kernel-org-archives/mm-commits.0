Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D36EFA3740
	for <mm-commits@archiver.kernel.org>; Thu, 27 Oct 2022 20:15:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbiJ0UPZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 16:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236007AbiJ0UPX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 16:15:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12C64F6BE
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 13:15:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FC45624C5
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 20:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41BCC433B5;
        Thu, 27 Oct 2022 20:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666901718;
        bh=lDa4qpWi2RxVfCWGtV3oAtab5D/4YzdhRcEJkuH/wV4=;
        h=Date:To:From:Subject:From;
        b=CgQxden0udhSYZwTnOOBOvyIFhBfz0Afcl2Jfhf22H3i+Dm/xqi2/ebtIPyH3ht1t
         smf6aZRmU2Xld2mynH6uRx/XvR0UT5pxj2Nt8sdhtJsXjNCEKADa1DoxUeX0tXhYRo
         wPZXfgFTWmKLDAZqiyyg+qalS+ei/iZb0YRKvm4o=
Date:   Thu, 27 Oct 2022 13:15:17 -0700
To:     mm-commits@vger.kernel.org, vpetrucci@gmail.com, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch added to mm-unstable branch
Message-Id: <20221027201518.B41BCC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: fix wrong usage example of init_regions file
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch

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
Subject: Docs/admin-guide/mm/damon/usage: fix wrong usage example of init_regions file
Date: Mon, 24 Oct 2022 17:46:19 +0000

DAMON debugfs interface assumes the users will write all inputs at once. 
However, redirecting a string of multiple lines sometimes end up writing
line by line.  Therefore, the example usage of 'init_regions' file, which
writes input as a string of multiple lines can fail.  Fix it to use a
single line string instead.  Also update the description of the usage to
not assume users will write inputs in multiple lines.

Link: https://lkml.kernel.org/r/20221024174619.15600-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Vinicius Petrucci <vpetrucci@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -468,8 +468,9 @@ regions in case of physical memory monit
 monitoring target regions by themselves.
 
 In such cases, users can explicitly set the initial monitoring target regions
-as they want, by writing proper values to the ``init_regions`` file.  Each line
-of the input should represent one region in below form.::
+as they want, by writing proper values to the ``init_regions`` file.  The input
+should be a sequence of three integers separated by white spaces that represent
+one region in below form.::
 
     <target idx> <start address> <end address>
 
@@ -484,9 +485,9 @@ ranges, ``20-40`` and ``50-100`` as that
     # cd <debugfs>/damon
     # cat target_ids
     42 4242
-    # echo "0   1       100
-            0   100     200
-            1   20      40
+    # echo "0   1       100 \
+            0   100     200 \
+            1   20      40  \
             1   50      100" > init_regions
 
 Note that this sets the initial monitoring target regions only.  In case of
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


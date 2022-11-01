Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4E1BC433FE
	for <mm-commits@archiver.kernel.org>; Tue,  1 Nov 2022 22:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiKAW6z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Nov 2022 18:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiKAW6m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2022 18:58:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14A01002
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 15:58:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 251A4B82003
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 22:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18ADC433D7;
        Tue,  1 Nov 2022 22:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667343517;
        bh=xJsp1DQxqKpJ+4+38sXqdWN30GgKJGVw0OwZGT+/5tE=;
        h=Date:To:From:Subject:From;
        b=OQE9RPTvksT4oKqY+nlV5n/gkQiYgN5p5GNMMHK2bJg+0z9X9s0tHChXUdOIETw2F
         bDN7E/dZtNBG83io0zrwq2JAKyQsO331KcWCWB2EUnzthwsKdWnUWSopM0I9dfThfp
         5rcBhBChc1mtcB6pK/kP0v0Y16ljgC5hLNbMH6bI=
Date:   Tue, 01 Nov 2022 15:58:37 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch added to mm-unstable branch
Message-Id: <20221101225837.C18ADC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/selftets/damon/sysfs: test tried_regions directory existence
has been added to the -mm mm-unstable branch.  Its filename is
     tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch

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
Subject: tools/selftets/damon/sysfs: test tried_regions directory existence
Date: Tue, 1 Nov 2022 22:03:26 +0000

Add a simple test case for ensuring tried_regions directory existence.

Link: https://lkml.kernel.org/r/20221101220328.95765-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.sh |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/testing/selftests/damon/sysfs.sh~tools-selftets-damon-sysfs-test-tried_regions-directory-existence
+++ a/tools/testing/selftests/damon/sysfs.sh
@@ -80,6 +80,12 @@ test_range()
 	ensure_file "$range_dir/max" "exist" 600
 }
 
+test_tried_regions()
+{
+	tried_regions_dir=$1
+	ensure_dir "$tried_regions_dir" "exist"
+}
+
 test_stats()
 {
 	stats_dir=$1
@@ -138,6 +144,7 @@ test_scheme()
 	test_quotas "$scheme_dir/quotas"
 	test_watermarks "$scheme_dir/watermarks"
 	test_stats "$scheme_dir/stats"
+	test_tried_regions "$scheme_dir/tried_regions"
 }
 
 test_schemes()
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


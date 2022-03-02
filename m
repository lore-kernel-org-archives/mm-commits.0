Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E50BDC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  2 Mar 2022 00:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238760AbiCBA0r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Mar 2022 19:26:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiCBA0r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2022 19:26:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EF98EB46
        for <mm-commits@vger.kernel.org>; Tue,  1 Mar 2022 16:26:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D80961541
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 00:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DDDC340F1;
        Wed,  2 Mar 2022 00:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646180761;
        bh=JzwaKyrcouO3o0tOepJuPqN9hgVQuTbOr9BktYSI05c=;
        h=Date:To:From:Subject:From;
        b=J5kWPY0RlMTxQ9MaShisUbEFc9b7ZqB67EYNh/bwRfR6O9AQQC3dEPoCHl8bmZxez
         +sYbuzy8khL7mLWbp3UboBpEDCcchs1S6ozJbC+J4poEiqcjNsYJ/SJQyVdn05oaCr
         mUhKiQJm7hzphTQICcFoLNFtc0KXb9dLYSYdynBg=
Date:   Tue, 01 Mar 2022 16:26:00 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-support-damos-watermarks-fix.patch added to -mm tree
Message-Id: <20220302002601.72DDDC340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: fix out-of-bound array access for wmark_metric_strs[]
has been added to the -mm tree.  Its filename is
     mm-damon-sysfs-support-damos-watermarks-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-sysfs-support-damos-watermarks-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-sysfs-support-damos-watermarks-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: fix out-of-bound array access for wmark_metric_strs[]

Commit 7a8630be880e ("mm/damon/sysfs: support DAMOS watermarks") on -mm
tree which introduced by a patch[1] titled
mm-damon-sysfs-support-damos-watermarks.patch allows out-of-bound access
to damon_sysfs_wmark_metric_strs[] array due to wrong bound check.  This
commit fixes the wrong bound check.  The issue has found by Coverity
report for linux-next.

[1] https://www.ozlabs.org/~akpm/mmotm/broken-out/mm-damon-sysfs-support-damos-watermarks.patch

Addresses-Coverity: ("Out-of-bounds read")
Link: https://lkml.kernel.org/r/20220301185619.2904-1-sj@kernel.org
Fixes: 7a8630be880e ("mm/damon/sysfs: support DAMOS watermarks")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-support-damos-watermarks-fix
+++ a/mm/damon/sysfs.c
@@ -167,7 +167,7 @@ static ssize_t metric_store(struct kobje
 			struct damon_sysfs_watermarks, kobj);
 	enum damos_wmark_metric metric;
 
-	for (metric = 0; metric <= NR_DAMOS_WMARK_METRICS; metric++) {
+	for (metric = 0; metric < NR_DAMOS_WMARK_METRICS; metric++) {
 		if (sysfs_streq(buf, damon_sysfs_wmark_metric_strs[metric])) {
 			watermarks->metric = metric;
 			return count;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-dbgfs-init_regions-use-target-index-instead-of-target-id.patch
docs-admin-guide-mm-damon-usage-update-for-changed-initail_regions-file-input.patch
mm-damon-core-move-damon_set_targets-into-dbgfs.patch
mm-damon-remove-the-target-id-concept.patch
mm-damon-rename-damon_primitives-to-damon_operations.patch
mm-damon-let-monitoring-operations-can-be-registered-and-selected.patch
mm-damon-paddrvaddr-register-themselves-to-damon-in-subsys_initcall.patch
mm-damon-reclaim-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch
mm-damon-dbgfs-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch
mm-damon-dbgfs-use-operations-id-for-knowing-if-the-target-has-pid.patch
mm-damon-dbgfs-test-fix-is_target_id-change.patch
mm-damon-paddrvaddr-remove-damon_pva_target_validset_operations.patch
docs-vm-damon-call-low-level-monitoring-primitives-the-operations.patch
docs-vm-damon-design-update-damon-idle-page-tracking-interference-handling.patch
docs-damon-update-outdated-term-regions-update-interval.patch
mm-damon-core-allow-non-exclusive-damon-start-stop.patch
mm-damon-core-add-number-of-each-enum-type-values.patch
mm-damon-implement-a-minimal-stub-for-sysfs-based-damon-interface.patch
mm-damon-sysfs-link-damon-for-virtual-address-spaces-monitoring.patch
mm-damon-sysfs-support-the-physical-address-space-monitoring.patch
mm-damon-sysfs-support-damon-based-operation-schemes.patch
mm-damon-sysfs-support-damos-quotas.patch
mm-damon-sysfs-support-schemes-prioritization.patch
mm-damon-sysfs-support-damos-watermarks.patch
mm-damon-sysfs-support-damos-watermarks-fix.patch
mm-damon-sysfs-support-damos-stats.patch
selftests-damon-add-a-test-for-damon-sysfs-interface.patch
docs-admin-guide-mm-damon-usage-document-damon-sysfs-interface.patch
docs-abi-testing-add-damon-sysfs-interface-abi-document.patch


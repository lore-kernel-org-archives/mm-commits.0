Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE79DC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 19:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbiCVTT7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 15:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiCVTT6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 15:19:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C8966C85
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 12:18:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C05B3B81D4B
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 19:18:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F148C340EC;
        Tue, 22 Mar 2022 19:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647976706;
        bh=z5ZTtdiLwnh3B5T8Wfg9fL5a6U3y3r7AlKf48FvcwQ8=;
        h=Date:To:From:Subject:From;
        b=I0mwMzMiJgpV1jrEnwaCrMOWOnAGB+P2eB9+iFnLIsMaAbJXmiVhzuhdfHj3xssTS
         mT9rawI/7mGxIitysJkCfd+NTqneiF61nUD+76uhlSVmTRx0MGgI7+p2Krt2NA19AM
         CLtekMHwRQJuwZaV/QhdskiaI6DswY1wX4gBDScY=
Date:   Tue, 22 Mar 2022 12:18:25 -0700
To:     mm-commits@vger.kernel.org, colin.i.king@gmail.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-sysfs-support-damos-watermarks-fix.patch removed from -mm tree
Message-Id: <20220322191826.7F148C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: fix out-of-bound array access for wmark_metric_strs[]
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-support-damos-watermarks-fix.patch

This patch was dropped because it was folded into mm-damon-sysfs-support-damos-watermarks.patch

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
Cc: Colin Ian King <colin.i.king@gmail.com>
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
mm-damon-sysfs-support-damos-stats.patch
selftests-damon-add-a-test-for-damon-sysfs-interface.patch
docs-admin-guide-mm-damon-usage-document-damon-sysfs-interface.patch
docs-abi-testing-add-damon-sysfs-interface-abi-document.patch


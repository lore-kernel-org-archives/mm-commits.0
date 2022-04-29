Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D08C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 16:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379104AbiD2Q3f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 12:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379075AbiD2Q30 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 12:29:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2CDD95E3
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 09:26:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43BE0B83697
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 16:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79E1C385B0;
        Fri, 29 Apr 2022 16:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651249561;
        bh=Y30CsO3rCcvNi5pBNhMWef4hH4zTONejh5hA9OUw3qU=;
        h=Date:To:From:Subject:From;
        b=zTBRB3TXEaeGzrtP5FwZO60dEgTWwuiL4jOH2afphRZH+6LGT5pVTp/SfXkUd89VP
         bLIIyfOW5cP4cBsyedH+f+nivOGaLk17NHMFWDvm4xumwLsudYS7SmX1Hcamna9x1D
         1PvPNXgTo/blQJ8c/FLSvk7ha+nEx81nyr/o/iLA=
Date:   Fri, 29 Apr 2022 09:26:01 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-prohibit-multiple-physical-address-space-monitoring-targets.patch added to mm-unstable branch
Message-Id: <20220429162601.D79E1C385B0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: prohibit multiple physical address space monitoring targets
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-prohibit-multiple-physical-address-space-monitoring-targets.patch

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
Subject: mm/damon/sysfs: prohibit multiple physical address space monitoring targets

Having multiple targets for physical address space monitoring makes no
sense.  This commit prohibits such a ridiculous DAMON context setup my
making the DAMON context build function to check and return an error for
the case.

Link: https://lkml.kernel.org/r/20220429160606.127307-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-prohibit-multiple-physical-address-space-monitoring-targets
+++ a/mm/damon/sysfs.c
@@ -2124,6 +2124,10 @@ static int damon_sysfs_set_targets(struc
 {
 	int i, err;
 
+	/* Multiple physical address space monitoring targets makes no sense */
+	if (ctx->ops.id == DAMON_OPS_PADDR && sysfs_targets->nr > 1)
+		return -EINVAL;
+
 	for (i = 0; i < sysfs_targets->nr; i++) {
 		struct damon_sysfs_target *sys_target =
 			sysfs_targets->targets_arr[i];
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


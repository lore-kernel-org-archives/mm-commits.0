Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D04C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 16:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379072AbiD2Q3p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 12:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379090AbiD2Q3i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 12:29:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D02D8933
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 09:26:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D928B83697
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 16:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E08C385A7;
        Fri, 29 Apr 2022 16:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651249577;
        bh=zlEbNgjrYfOVNGpPwHvJv/aCcbUKSH8xFqJoPWPmFoI=;
        h=Date:To:From:Subject:From;
        b=zreV75i8E7VvBfgi5fk1tI5Nkyos/6ios9rzRsZwNoAEaCrV4vZuQDU3G5Z4k2+WQ
         20sDoeR+NBuxgikAtKaPQQSdsd6tkFYBywq4e95L4nJ+6a4mm+ZeOoBbqCCE5AHium
         xZhTg3pVKLg4R3dCPIK/oN0PNJNIwR2JTGzwswN8=
Date:   Fri, 29 Apr 2022 09:26:16 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-reclaim-document-commit_inputs-parameter.patch added to mm-unstable branch
Message-Id: <20220429162617.04E08C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/reclaim: document 'commit_inputs' parameter
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-reclaim-document-commit_inputs-parameter.patch

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
Subject: Docs/admin-guide/mm/damon/reclaim: document 'commit_inputs' parameter

This commit documents the new DAMON_RECLAIM parameter, 'commit_inputs' in
its usage document.

Link: https://lkml.kernel.org/r/20220429160606.127307-15-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/reclaim.rst |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/Documentation/admin-guide/mm/damon/reclaim.rst~docs-admin-guide-mm-damon-reclaim-document-commit_inputs-parameter
+++ a/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -66,6 +66,17 @@ Setting it as ``N`` disables DAMON_RECLA
 no real monitoring and reclamation due to the watermarks-based activation
 condition.  Refer to below descriptions for the watermarks parameter for this.
 
+commit_inputs
+-------------
+
+Make DAMON_RECLAIM reads the input parameters again, except ``enabled``.
+
+Input parameters that updated while DAMON_RECLAIM is running are not applied
+by default.  Once this parameter is set as ``Y``, DAMON_RECLAIM reads values
+of parametrs except ``enabled`` again.  Once the re-reading is done, this
+parameter is set as ``N``.  If invalid parameters are found while the
+re-reading, DAMON_RECLAIM will be disabled.
+
 min_age
 -------
 
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


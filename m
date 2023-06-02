Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 972CFC7EE2A
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jun 2023 02:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbjFBCbm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 22:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233218AbjFBCbm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 22:31:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08B8184
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 19:31:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81FC564BC7
        for <mm-commits@vger.kernel.org>; Fri,  2 Jun 2023 02:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9702C4339B;
        Fri,  2 Jun 2023 02:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685673099;
        bh=K98P8BCpplp+IhsIQ14G2siibfSDR5XCGYpwSeUeYG8=;
        h=Date:To:From:Subject:From;
        b=QolxPDR5M9/9Xo60PbkGca5O2/gtFmOQcpNNgVsdjpP7Pth+Anq/hB1u9T+jj1ny/
         0GZTF1xWngShGvcWPIKr0cD6NH+paAejIRXqPTsYkdHn2siN6cP5ZG2BoN4b5ocrqH
         bHc6fxqKElyXaAk3KqPUKbyVZeDWNRCMOi/Bp3lY=
Date:   Thu, 01 Jun 2023 19:31:39 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-uffd-stress-unused-function-warning.patch added to mm-unstable branch
Message-Id: <20230602023139.D9702C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: fix uffd-stress unused function warning
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-uffd-stress-unused-function-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-uffd-stress-unused-function-warning.patch

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
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/mm: fix uffd-stress unused function warning
Date: Thu, 1 Jun 2023 18:33:47 -0700

Patch series "A minor flurry of selftest/mm fixes".

It turned out that an even dozen patches were required in order to get the
selftests building cleanly, and all running, once again. I made it worse on
myself by insisting on using clang, which seems to uncover a few more warnings
than gcc these days.


This patch (of 12):

uffd_minor_feature() was unused.  Remove it in order to fix the associated
clang build warning.

Link: https://lkml.kernel.org/r/20230602013358.900637-1-jhubbard@nvidia.com
Link: https://lkml.kernel.org/r/20230602013358.900637-2-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-fix-uffd-stress-unused-function-warning
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -88,16 +88,6 @@ static void uffd_stats_reset(struct uffd
 	}
 }
 
-static inline uint64_t uffd_minor_feature(void)
-{
-	if (test_type == TEST_HUGETLB && map_shared)
-		return UFFD_FEATURE_MINOR_HUGETLBFS;
-	else if (test_type == TEST_SHMEM)
-		return UFFD_FEATURE_MINOR_SHMEM;
-	else
-		return 0;
-}
-
 static void *locking_thread(void *arg)
 {
 	unsigned long cpu = (unsigned long) arg;
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

selftests-mm-fix-uffd-stress-unused-function-warning.patch
selftests-mm-fix-unused-variable-warning-in-hugetlb-madvisec.patch
selftests-mm-fix-unused-variable-warning-in-migrationc.patch
selftests-mm-fix-a-char-assignment-in-mlock2-testsc.patch
selftests-mm-fix-invocation-of-tests-that-are-run-via-shell-scripts.patch
selftests-mm-gitignore-add-mkdirty-va_high_addr_switch.patch
selftests-mm-set-wno-format-security-to-avoid-uffd-build-warnings.patch
selftests-mm-fix-a-possibly-uninitialized-warning-in-pkey-x86h.patch
selftests-mm-move-psize-pshift-into-vm_utilsc.patch
selftests-mm-move-uffd-routines-from-vm_utilc-to-uffd-commonc.patch
selftests-mm-fix-missing-uffdio_continue_mode_wp-and-similar-build-failures.patch
selftests-mm-fix-uffd-unit-testsc-build-failure-due-to-missing-madv_collapse.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2E85C7EE23
	for <mm-commits@archiver.kernel.org>; Mon,  5 Jun 2023 22:44:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbjFEWod (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Jun 2023 18:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjFEWod (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jun 2023 18:44:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3F2C5
        for <mm-commits@vger.kernel.org>; Mon,  5 Jun 2023 15:44:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFD5C61DE1
        for <mm-commits@vger.kernel.org>; Mon,  5 Jun 2023 22:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D63C433EF;
        Mon,  5 Jun 2023 22:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686005070;
        bh=Zj9IRuPYLzmeH9NiwSQxE8pMb5XTLohpA9r+b5nNi50=;
        h=Date:To:From:Subject:From;
        b=DtDwlG/R4I0N2k2dPsxXL2CGcm6HOcepQplwQ0lIV4TozA/WVpwOxehXrwcodQAOY
         jxyLM/dVQzj/c94/Yz7D5/4pRz7jxGZzxQsx4xPkRGdGANwlHOg/lvQLNBakePf9iI
         89bF3peIjcPuw0zwBprxmL+fhBA8ji2DdSZBVP6g=
Date:   Mon, 05 Jun 2023 15:44:29 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-uffd-stress-unused-function-warning.patch added to mm-unstable branch
Message-Id: <20230605224430.38D63C433EF@smtp.kernel.org>
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
Date: Fri, 2 Jun 2023 19:15:48 -0700

Patch series "A minor flurry of selftest/mm fixes", v2.

A series that fixes up build errors and warnings for at least the 64-bit
builds on x86 with clang.

The series also includes an optional "improvement" of moving some uffd
code into uffd-common.[ch], which is proving to be somewhat controversial,
and so if that doesn't get resolved, then patches 9 and 10 may just get
dropped.  They are not required in order to get a clean build, now that
"make headers" is happening.

[1]: https://lore.kernel.org/all/20230602013358.900637-1-jhubbard@nvidia.com/


This patch (of 11):

uffd_minor_feature() was unused. Remove it in order to fix the
associated clang build warning.

Link: https://lkml.kernel.org/r/20230603021558.95299-1-jhubbard@nvidia.com
Link: https://lkml.kernel.org/r/20230603021558.95299-2-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
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
selftests-mm-fix-unused-variable-warnings-in-hugetlb-madvisec-migrationc.patch
selftests-mm-fix-warning-expression-which-evaluates-to-zero-in-mlock2-testsc.patch
selftests-mm-fix-invocation-of-tests-that-are-run-via-shell-scripts.patch
selftests-mm-gitignore-add-mkdirty-va_high_addr_switch.patch
selftests-mm-fix-two-wformat-security-warnings-in-uffd-builds.patch
selftests-mm-fix-a-possibly-uninitialized-warning-in-pkey-x86h.patch
selftests-mm-fix-uffd-unit-testsc-build-failure-due-to-missing-madv_collapse.patch
selftests-mm-move-psize-pshift-into-vm_utilsc.patch
selftests-mm-move-uffd-routines-from-vm_utilc-to-uffd-commonc.patch
documentation-kselftest-make-headers-is-a-prerequisite.patch
selftests-error-out-if-kernel-header-files-are-not-yet-built.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30F03C7EE2F
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jun 2023 02:31:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbjFBCbx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 22:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbjFBCbw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 22:31:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F721192
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 19:31:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09CDC64BC5
        for <mm-commits@vger.kernel.org>; Fri,  2 Jun 2023 02:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61AE2C433D2;
        Fri,  2 Jun 2023 02:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685673110;
        bh=N2mDGL0S/1GF5yUksvjSZqsIJ+msj1uC/KGpn3g2HjM=;
        h=Date:To:From:Subject:From;
        b=1x8bz1iT3EBCMHztdgn0W0D3LM29pHcNqCuKinfMuwGhHMqtjoriXJm/X6PnAdQtE
         CyjP0t9VFEU+Ci8h23P5Kl4/OWTiQwL5tM0O/P/ddCUukeIGsItX658lUXxEDxzL2o
         lzZWKmAMEPRGMnejdoLWBB0fyqzICJA/BaCZCTZY=
Date:   Thu, 01 Jun 2023 19:31:49 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-set-wno-format-security-to-avoid-uffd-build-warnings.patch added to mm-unstable branch
Message-Id: <20230602023150.61AE2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: set -Wno-format-security to avoid uffd build warnings
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-set-wno-format-security-to-avoid-uffd-build-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-set-wno-format-security-to-avoid-uffd-build-warnings.patch

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
Subject: selftests/mm: set -Wno-format-security to avoid uffd build warnings
Date: Thu, 1 Jun 2023 18:33:53 -0700

The uffd_test_start() is perhaps a little too elaborate about how it
dispatches tests, leading to a clang warning that looks roughly like
this:

"uffd-unit-tests.c:1198:20: warning: format string is not a string literal
(potentially insecure) [-Wformat-security] ...note: treat the string as
an argument to avoid this.
    uffd_test_start(test_name);
"

However, it doesn't seem worth it to rewrite the way uffd_test_start()
works, given that these tests are already deeply unsafe to begin with.

Fix this by just disabling the compiler warning, but only for
uffd-unit-tests.

Link: https://lkml.kernel.org/r/20230602013358.900637-8-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-set-wno-format-security-to-avoid-uffd-build-warnings
+++ a/tools/testing/selftests/mm/Makefile
@@ -173,6 +173,8 @@ $(OUTPUT)/ksm_tests: LDLIBS += -lnuma
 
 $(OUTPUT)/migration: LDLIBS += -lnuma
 
+$(OUTPUT)/uffd-unit-tests: CFLAGS += -Wno-format-security
+
 local_config.mk local_config.h: check_config.sh
 	/bin/sh ./check_config.sh $(CC)
 
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


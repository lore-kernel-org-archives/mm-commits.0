Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A61C1C7EE31
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jun 2023 02:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbjFBCcC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 22:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233508AbjFBCcB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 22:32:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85ABB184
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 19:32:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C51A64BBB
        for <mm-commits@vger.kernel.org>; Fri,  2 Jun 2023 02:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763E0C433D2;
        Fri,  2 Jun 2023 02:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685673119;
        bh=N35jl+rSyveyJ6LGTL1sp/bYRCVjQhzIDJNFeGH9Ric=;
        h=Date:To:From:Subject:From;
        b=TWdCTWm97K7ccQI+nYGzksAu3FKqNoYbv1TOpzKTaXgjLzvk6iJUAECnQ/E9daRcn
         PmMdWQxwyWQjspnK4t9+gMpcD0ggPGLDtM35K+RFH8CBEoEItse1wJKIxRiTL10XN2
         hkN/h66Bx+cquQhlmDTle+sCzNyfzRVOPZUU99UI=
Date:   Thu, 01 Jun 2023 19:31:58 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-missing-uffdio_continue_mode_wp-and-similar-build-failures.patch added to mm-unstable branch
Message-Id: <20230602023159.763E0C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: fix missing UFFDIO_CONTINUE_MODE_WP and similar build failures
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-missing-uffdio_continue_mode_wp-and-similar-build-failures.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-missing-uffdio_continue_mode_wp-and-similar-build-failures.patch

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
Subject: selftests/mm: fix missing UFFDIO_CONTINUE_MODE_WP and similar build failures
Date: Thu, 1 Jun 2023 18:33:57 -0700

UFFDIO_CONTINUE_MODE_WP, UFFD_FEATURE_WP_UNPOPULATED, USERFAULTFD_IOC, and
USERFAULTFD_IOC_NEW are needed lately, but they are not in my host (Arch
Linux) distro's userfaultfd.h yet.  So put them in here.

A better approach would be to include the uapi version of userfaultfd.h
from the kernel tree, but that currently fails with rather difficult
linker problems (__packed is defined multiple times, ugg), so defer that
to another day and just fix the build for now.

Link: https://lkml.kernel.org/r/20230602013358.900637-12-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/tools/testing/selftests/mm/uffd-common.h~selftests-mm-fix-missing-uffdio_continue_mode_wp-and-similar-build-failures
+++ a/tools/testing/selftests/mm/uffd-common.h
@@ -36,6 +36,23 @@
 
 #define UFFD_FLAGS	(O_CLOEXEC | O_NONBLOCK | UFFD_USER_MODE_ONLY)
 
+#ifndef UFFDIO_CONTINUE_MODE_WP
+#define UFFDIO_CONTINUE_MODE_WP			((__u64)1<<1)
+#endif
+
+#ifndef UFFD_FEATURE_WP_UNPOPULATED
+#define UFFD_FEATURE_WP_UNPOPULATED		(1<<13)
+#endif
+
+/* ioctls for /dev/userfaultfd */
+#ifndef USERFAULTFD_IOC
+#define USERFAULTFD_IOC 0xAA
+#endif
+
+#ifndef USERFAULTFD_IOC_NEW
+#define USERFAULTFD_IOC_NEW _IO(USERFAULTFD_IOC, 0x00)
+#endif
+
 #define _err(fmt, ...)						\
 	do {							\
 		int ret = errno;				\
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


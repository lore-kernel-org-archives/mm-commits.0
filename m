Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 571B0C7EE2A
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jun 2023 02:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbjFBCcL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 22:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjFBCcD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 22:32:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E65C184
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 19:32:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB81564BCA
        for <mm-commits@vger.kernel.org>; Fri,  2 Jun 2023 02:32:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C71FC433EF;
        Fri,  2 Jun 2023 02:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685673121;
        bh=AVjY8QrNMuwUzOi0dpU1ZAsIji6ZhIuRZgN12VOZs3A=;
        h=Date:To:From:Subject:From;
        b=Fa2kRFWSXZ9Dr0nyUcUupjdHpqRsecy9fNkdvU+pjUzGhYKrFAaa7SmyivVefk9IZ
         dnOa2VT7Rxp980o3GdxIhdO/zCXt7g8g9dHRLXajRlyYRRGX5bteSQ9u9j/32jpX8b
         uHfE/BW067OJ0BqPBQ8rT+u4A7GwOrn1HIqYfD+o=
Date:   Thu, 01 Jun 2023 19:32:00 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-uffd-unit-testsc-build-failure-due-to-missing-madv_collapse.patch added to mm-unstable branch
Message-Id: <20230602023201.3C71FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: fix uffd-unit-tests.c build failure due to missing MADV_COLLAPSE
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-uffd-unit-testsc-build-failure-due-to-missing-madv_collapse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-uffd-unit-testsc-build-failure-due-to-missing-madv_collapse.patch

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
Subject: selftests/mm: fix uffd-unit-tests.c build failure due to missing MADV_COLLAPSE
Date: Thu, 1 Jun 2023 18:33:58 -0700

MADV_PAGEOUT, MADV_POPULATE_READ, MADV_COLLAPSE are conditionally defined
as necessary.  However, that was being done in .c files, and a new build
failure came up that would have been automatically avoided had these been
in a common header file.

So consolidate and move them all to vm_util.h, which fixes the build
failure.

Link: https://lkml.kernel.org/r/20230602013358.900637-13-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c        |    7 -------
 tools/testing/selftests/mm/khugepaged.c |   10 ----------
 tools/testing/selftests/mm/vm_util.h    |   10 ++++++++++
 3 files changed, 10 insertions(+), 17 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-fix-uffd-unit-testsc-build-failure-due-to-missing-madv_collapse
+++ a/tools/testing/selftests/mm/cow.c
@@ -29,13 +29,6 @@
 #include "../kselftest.h"
 #include "vm_util.h"
 
-#ifndef MADV_PAGEOUT
-#define MADV_PAGEOUT 21
-#endif
-#ifndef MADV_COLLAPSE
-#define MADV_COLLAPSE 25
-#endif
-
 static size_t pagesize;
 static int pagemap_fd;
 static size_t thpsize;
--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-fix-uffd-unit-testsc-build-failure-due-to-missing-madv_collapse
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -22,16 +22,6 @@
 
 #include "vm_util.h"
 
-#ifndef MADV_PAGEOUT
-#define MADV_PAGEOUT 21
-#endif
-#ifndef MADV_POPULATE_READ
-#define MADV_POPULATE_READ 22
-#endif
-#ifndef MADV_COLLAPSE
-#define MADV_COLLAPSE 25
-#endif
-
 #define BASE_ADDR ((void *)(1UL << 30))
 static unsigned long hpage_pmd_size;
 static unsigned long page_size;
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-fix-uffd-unit-testsc-build-failure-due-to-missing-madv_collapse
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -42,3 +42,13 @@ int detect_hugetlb_page_sizes(size_t siz
 
 #define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
 #define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
+
+#ifndef MADV_PAGEOUT
+#define MADV_PAGEOUT 21
+#endif
+#ifndef MADV_POPULATE_READ
+#define MADV_POPULATE_READ 22
+#endif
+#ifndef MADV_COLLAPSE
+#define MADV_COLLAPSE 25
+#endif
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


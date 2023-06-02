Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1137FC7EE2E
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jun 2023 02:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbjFBCcC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 22:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233429AbjFBCbz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 22:31:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66E8193
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 19:31:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D69064BC8
        for <mm-commits@vger.kernel.org>; Fri,  2 Jun 2023 02:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D283BC4339B;
        Fri,  2 Jun 2023 02:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685673113;
        bh=VB+ofsNxsSSMzjjO6p3uG3uo1DMVqzyvEARiiu11E3c=;
        h=Date:To:From:Subject:From;
        b=WWrdijZDX+t2uxoe1isvE8LU1bYTdjhlqzUxuBZVS9BY8NiqfZ/WNmNgJGadPZSSe
         aQgu/rltmhswI2qWla77XRae3OUzK1Nrxq+zTa/vHanjJokRagNHpTSYrPwr3kL3Oo
         cyWoDQEZp4uZubFPybM/xKI/n0dFRTWbaCXb4Ytw=
Date:   Thu, 01 Jun 2023 19:31:53 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-move-psize-pshift-into-vm_utilsc.patch added to mm-unstable branch
Message-Id: <20230602023153.D283BC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: move psize(), pshift() into vm_utils.c
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-move-psize-pshift-into-vm_utilsc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-move-psize-pshift-into-vm_utilsc.patch

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
Subject: selftests/mm: move psize(), pshift() into vm_utils.c
Date: Thu, 1 Jun 2023 18:33:55 -0700

This is in preparation for linking test programs with both vm_utils.c and
uffd-common.c.  The static inline routines would prevent that, and there
is no particular need for inlining here, so turn these into normal
functions that are more flexible to build and link.

Link: https://lkml.kernel.org/r/20230602013358.900637-10-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |   14 ++++++++++++++
 tools/testing/selftests/mm/vm_util.h |   16 ++--------------
 2 files changed, 16 insertions(+), 14 deletions(-)

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-move-psize-pshift-into-vm_utilsc
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -328,3 +328,17 @@ int uffd_get_features(uint64_t *features
 
 	return 0;
 }
+
+unsigned int psize(void)
+{
+	if (!__page_size)
+		__page_size = sysconf(_SC_PAGESIZE);
+	return __page_size;
+}
+
+unsigned int pshift(void)
+{
+	if (!__page_shift)
+		__page_shift = (ffsl(psize()) - 1);
+	return __page_shift;
+}
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-move-psize-pshift-into-vm_utilsc
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -3,7 +3,6 @@
 #include <stdbool.h>
 #include <sys/mman.h>
 #include <err.h>
-#include <string.h> /* ffsl() */
 #include <unistd.h> /* _SC_PAGESIZE */
 
 #define BIT_ULL(nr)                   (1ULL << (nr))
@@ -17,19 +16,8 @@
 extern unsigned int __page_size;
 extern unsigned int __page_shift;
 
-static inline unsigned int psize(void)
-{
-	if (!__page_size)
-		__page_size = sysconf(_SC_PAGESIZE);
-	return __page_size;
-}
-
-static inline unsigned int pshift(void)
-{
-	if (!__page_shift)
-		__page_shift = (ffsl(psize()) - 1);
-	return __page_shift;
-}
+unsigned int psize(void);
+unsigned int pshift(void);
 
 uint64_t pagemap_get_entry(int fd, char *start);
 bool pagemap_is_softdirty(int fd, char *start);
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


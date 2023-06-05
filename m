Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12517C7EE24
	for <mm-commits@archiver.kernel.org>; Mon,  5 Jun 2023 22:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbjFEWo6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Jun 2023 18:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbjFEWou (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jun 2023 18:44:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3141210B
        for <mm-commits@vger.kernel.org>; Mon,  5 Jun 2023 15:44:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1B8862B76
        for <mm-commits@vger.kernel.org>; Mon,  5 Jun 2023 22:44:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E13CC433D2;
        Mon,  5 Jun 2023 22:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686005086;
        bh=vPi0B8JGCBHd775BRnpF5chOMWP9V9fxE2+ynU5iatE=;
        h=Date:To:From:Subject:From;
        b=uctZFzvsIWm6gydLiRnY9pPG0PYnfu1Pny8qjd5tx21AuQq7FO10dNPVB274yx49i
         mjiB0ugNjxZQnYM2xhjyuuw6g54hSEJgGVqVp1wrJ1T3HIah6cK1JGYUBm5P2P1OfI
         B7JXESj4a8clXFG/CihqLDh/a+FfuT4gv4uCfPkU=
Date:   Mon, 05 Jun 2023 15:44:45 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-move-psize-pshift-into-vm_utilsc.patch added to mm-unstable branch
Message-Id: <20230605224446.1E13CC433D2@smtp.kernel.org>
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
Date: Fri, 2 Jun 2023 19:15:56 -0700

This is in preparation for linking test programs with both vm_utils.c
and uffd-common.c. The static inline routines, while normally not a
problem, in this case complicate an already fragile header file
situation: the header files including other header files leads to
compilation failures in a subsequent patch that moves code around.

Anyway, there is no particular need for inlining here, so turn these
into normal functions, as a workaround to avoid refactoring the header
file includes for now.

Link: https://lkml.kernel.org/r/20230603021558.95299-10-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
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


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E9E1C54FB9
	for <mm-commits@archiver.kernel.org>; Fri, 17 Nov 2023 18:20:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbjKQSUb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Nov 2023 13:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjKQSUa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2023 13:20:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC68AA
        for <mm-commits@vger.kernel.org>; Fri, 17 Nov 2023 10:20:26 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E8CC433C7;
        Fri, 17 Nov 2023 18:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700245226;
        bh=odk66iIWbVdjrb1LOYvbkF08juTYzLae5D6hUmmq8TQ=;
        h=Date:To:From:Subject:From;
        b=LjtZQFfSh2jvsUuLwJfaBrRuK9re4XA1KqcIZmkZ8ZYHXQLTxG3aFOdQb+yfOA4TQ
         mzBS1ByzKJ6mzptl4anOa2qHBqAu9fTwfksMUABhwQnR4qIrApjXTo5AS5tRu2dGnE
         PVXqFZDfQ6AhsL4qrnQy2BPdhOK14yY/dvu08bWA=
Date:   Fri, 17 Nov 2023 10:20:25 -0800
To:     mm-commits@vger.kernel.org, ryan.roberts@arm.com,
        avagin@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-check-that-pagemap_scan-returns-correct-categories-fix.patch added to mm-unstable branch
Message-Id: <20231117182026.58E8CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: don't fail if pagemap_scan isn't supported
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-check-that-pagemap_scan-returns-correct-categories-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-check-that-pagemap_scan-returns-correct-categories-fix.patch

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
From: Andrei Vagin <avagin@google.com>
Subject: selftests/mm: don't fail if pagemap_scan isn't supported
Date: Fri, 17 Nov 2023 10:11:27 -0800

This change allows to run tests on old kernels.

Link: https://lkml.kernel.org/r/20231117181127.2574897-1-avagin@google.com
Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Closes: https://lore.kernel.org/lkml/696a0a99-eb42-4e13-be14-58a88c9c33f7@arm.com/
Signed-off-by: Andrei Vagin <avagin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |   51 +++++++++++++++++++------
 1 file changed, 39 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-check-that-pagemap_scan-returns-correct-categories-fix
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -29,15 +29,13 @@ uint64_t pagemap_get_entry(int fd, char
 	return entry;
 }
 
-static uint64_t pagemap_scan_get_categories(int fd, char *start)
+static uint64_t __pagemap_scan_get_categories(int fd, char *start, struct page_region *r)
 {
 	struct pm_scan_arg arg;
-	struct page_region r;
-	long ret;
 
 	arg.start = (uintptr_t)start;
 	arg.end = (uintptr_t)(start + psize());
-	arg.vec = (uintptr_t)&r;
+	arg.vec = (uintptr_t)r;
 	arg.vec_len = 1;
 	arg.flags = 0;
 	arg.size = sizeof(struct pm_scan_arg);
@@ -49,7 +47,15 @@ static uint64_t pagemap_scan_get_categor
 				  PAGE_IS_HUGE | PAGE_IS_SOFT_DIRTY;
 	arg.return_mask = arg.category_anyof_mask;
 
-	ret = ioctl(fd, PAGEMAP_SCAN, &arg);
+	return ioctl(fd, PAGEMAP_SCAN, &arg);
+}
+
+static uint64_t pagemap_scan_get_categories(int fd, char *start)
+{
+	struct page_region r;
+	long ret;
+
+	ret = __pagemap_scan_get_categories(fd, start, &r);
 	if (ret < 0)
 		ksft_exit_fail_msg("PAGEMAP_SCAN failed: %s\n", strerror(errno));
 	if (ret == 0)
@@ -57,18 +63,39 @@ static uint64_t pagemap_scan_get_categor
 	return r.categories;
 }
 
+/* `start` is any valid address. */
+static bool pagemap_scan_supported(int fd, char *start)
+{
+	static int supported = -1;
+	int ret;
+
+	if (supported != -1)
+		return supported;
+
+	/* Provide an invalid address in order to trigger EFAULT. */
+	ret = __pagemap_scan_get_categories(fd, start, (struct page_region *) ~0UL);
+	if (ret == 0)
+		ksft_exit_fail_msg("PAGEMAP_SCAN succedded unexpectedly\n");
+
+	supported = errno == EFAULT;
+
+	return supported;
+}
+
 static bool page_entry_is(int fd, char *start, char *desc,
 			  uint64_t pagemap_flags, uint64_t pagescan_flags)
 {
-	bool m, s;
+	bool m = pagemap_get_entry(fd, start) & pagemap_flags;
+
+	if (pagemap_scan_supported(fd, start)) {
+		bool s = pagemap_scan_get_categories(fd, start) & pagescan_flags;
 
-	m = pagemap_get_entry(fd, start) & pagemap_flags;
-	s = pagemap_scan_get_categories(fd, start) & pagescan_flags;
-	if (m == s)
-		return m;
+		if (m == s)
+			return m;
 
-	ksft_exit_fail_msg(
-		"read and ioctl return unmatched results for %s: %d %d", desc, m, s);
+		ksft_exit_fail_msg(
+			"read and ioctl return unmatched results for %s: %d %d", desc, m, s);
+	}
 	return m;
 }
 
_

Patches currently in -mm which might be from avagin@google.com are

fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl.patch
fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl-v3.patch
selftests-mm-check-that-pagemap_scan-returns-correct-categories.patch
selftests-mm-check-that-pagemap_scan-returns-correct-categories-fix.patch


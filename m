Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB9BC4332F
	for <mm-commits@archiver.kernel.org>; Tue,  7 Nov 2023 15:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbjKGPoj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Nov 2023 10:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235056AbjKGPoj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Nov 2023 10:44:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFC594
        for <mm-commits@vger.kernel.org>; Tue,  7 Nov 2023 07:44:37 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7A8C433C8;
        Tue,  7 Nov 2023 15:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699371877;
        bh=WFjNYTmGIcDMJ968z+7oNL5bv+1WUEmoa9VisEvD9UM=;
        h=Date:To:From:Subject:From;
        b=JuY0oLUHl65u9qvuLM5ElXp8SzTYvzPLOTT2ZS9Vb+Y7H53OFNz02RSbMt3eFnn1C
         IOqQPDptpmwnqkGDk2azUpNrNX7DvUdWXSeTzIjXIlStoitfuqO9cF2gvQoCc/DJW3
         UjbePw8NDNtJmnwyi9hh2v+H7nNOW6n3giDbUUh4=
Date:   Tue, 07 Nov 2023 07:44:36 -0800
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        mirq-linux@rere.qmqm.pl, avagin@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-check-that-pagemap_scan-returns-correct-categories.patch added to mm-unstable branch
Message-Id: <20231107154436.DE7A8C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: check that PAGEMAP_SCAN returns correct categories
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-check-that-pagemap_scan-returns-correct-categories.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-check-that-pagemap_scan-returns-correct-categories.patch

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
Subject: selftests/mm: check that PAGEMAP_SCAN returns correct categories
Date: Mon, 6 Nov 2023 14:09:59 -0800

Right now, tests read page flags from /proc/pid/pagemap files.  With this
change, tests will check that PAGEMAP_SCAN return correct information too.

Link: https://lkml.kernel.org/r/20231106220959.296568-2-avagin@google.com
Signed-off-by: Andrei Vagin <avagin@google.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |   53 +++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-check-that-pagemap_scan-returns-correct-categories
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -4,6 +4,7 @@
 #include <dirent.h>
 #include <sys/ioctl.h>
 #include <linux/userfaultfd.h>
+#include <linux/fs.h>
 #include <sys/syscall.h>
 #include <unistd.h>
 #include "../kselftest.h"
@@ -28,19 +29,65 @@ uint64_t pagemap_get_entry(int fd, char
 	return entry;
 }
 
+static uint64_t pagemap_scan_get_categories(int fd, char *start)
+{
+	struct pm_scan_arg arg;
+	struct page_region r;
+	long ret;
+
+	arg.start = (uintptr_t)start;
+	arg.end = (uintptr_t)(start + psize());
+	arg.vec = (uintptr_t)&r;
+	arg.vec_len = 1;
+	arg.flags = 0;
+	arg.size = sizeof(struct pm_scan_arg);
+	arg.max_pages = 0;
+	arg.category_inverted = 0;
+	arg.category_mask = 0;
+	arg.category_anyof_mask = PAGE_IS_WPALLOWED | PAGE_IS_WRITTEN | PAGE_IS_FILE |
+				  PAGE_IS_PRESENT | PAGE_IS_SWAPPED | PAGE_IS_PFNZERO |
+				  PAGE_IS_HUGE | PAGE_IS_SOFT_DIRTY;
+	arg.return_mask = arg.category_anyof_mask;
+
+	ret = ioctl(fd, PAGEMAP_SCAN, &arg);
+	if (ret < 0)
+		ksft_exit_fail_msg("PAGEMAP_SCAN failed: %s\n", strerror(errno));
+	if (ret == 0)
+		return 0;
+	return r.categories;
+}
+
+static bool page_entry_is(int fd, char *start, char *desc,
+			  uint64_t pagemap_flags, uint64_t pagescan_flags)
+{
+	bool m, s;
+
+	m = pagemap_get_entry(fd, start) & pagemap_flags;
+	s = pagemap_scan_get_categories(fd, start) & pagescan_flags;
+	if (m == s)
+		return m;
+
+	ksft_exit_fail_msg(
+		"read and ioctl return unmatched results for %s: %d %d", desc, m, s);
+	return m;
+}
+
 bool pagemap_is_softdirty(int fd, char *start)
 {
-	return pagemap_get_entry(fd, start) & PM_SOFT_DIRTY;
+	return page_entry_is(fd, start, "soft-dirty",
+				PM_SOFT_DIRTY, PAGE_IS_SOFT_DIRTY);
 }
 
 bool pagemap_is_swapped(int fd, char *start)
 {
-	return pagemap_get_entry(fd, start) & PM_SWAP;
+	return page_entry_is(fd, start, "swap", PM_SWAP, PAGE_IS_SWAPPED);
 }
 
 bool pagemap_is_populated(int fd, char *start)
 {
-	return pagemap_get_entry(fd, start) & (PM_PRESENT | PM_SWAP);
+	return page_entry_is(fd, start, "populated",
+				PM_PRESENT | PM_SWAP,
+				PAGE_IS_PRESENT | PAGE_IS_SWAPPED);
 }
 
 unsigned long pagemap_get_pfn(int fd, char *start)
_

Patches currently in -mm which might be from avagin@google.com are

fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl.patch
selftests-mm-check-that-pagemap_scan-returns-correct-categories.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 116A7C04A95
	for <mm-commits@archiver.kernel.org>; Sun, 25 Sep 2022 19:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbiIYTN4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 25 Sep 2022 15:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233137AbiIYTN2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 25 Sep 2022 15:13:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436662983A
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 12:13:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5D69B80D4E
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 19:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FE3C433C1;
        Sun, 25 Sep 2022 19:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664133204;
        bh=9PP/k75UTrLUiNknocJyQwrtiN6UyWKicjmKdzd1qBU=;
        h=Date:To:From:Subject:From;
        b=RfsN10rG2c8Rm4PrD1zSXb6s2reZWAiMQj6w8mTYGWxlY0vTzZx1U+97QKFb2WKhG
         ShbnktlyqmJLULcEgUM9ofQoUK3ZIvwDfFkSbh/4S8FSns/gkW88caqBaIVEud0NTG
         yIHhXJon4mwEJ3VECMQF8RzGxBGTyIOiatSiKZQU=
Date:   Sun, 25 Sep 2022 12:13:23 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        songliubraving@fb.com, sj@kernel.org, shy828301@gmail.com,
        rongwei.wang@linux.alibaba.com, rientjes@google.com,
        peterx@redhat.com, pasha.tatashin@soleen.com, minchan@kernel.org,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jthoughton@google.com, hughd@google.com, david@redhat.com,
        ckennelly@google.com, axelrasmussen@google.com, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-retry-on-eagain-for-madv_collapse-selftest.patch added to mm-unstable branch
Message-Id: <20220925191324.68FE3C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: retry on EAGAIN for MADV_COLLAPSE selftest
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-retry-on-eagain-for-madv_collapse-selftest.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-retry-on-eagain-for-madv_collapse-selftest.patch

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
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: selftests/vm: retry on EAGAIN for MADV_COLLAPSE selftest
Date: Thu, 22 Sep 2022 11:46:51 -0700

MADV_COLLAPSE is a best-effort request that will set errno to an
actionable value if the request cannot be performed.

For example, if pages are not found on the LRU, or if they are currently
locked by something else, MADV_COLLAPSE will fail and set errno to EAGAIN
to inform callers that they may try again.

Since the khugepaged selftest is the first public use of MADV_COLLAPSE,
set a best practice of checking errno and retrying on EAGAIN.

Link: https://lkml.kernel.org/r/20220922184651.1016461-2-zokeefe@google.com
Fixes: 9330694de59f ("selftests/vm: add MADV_COLLAPSE collapse context to selftests")
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/tools/testing/selftests/vm/khugepaged.c~selftests-vm-retry-on-eagain-for-madv_collapse-selftest
+++ a/tools/testing/selftests/vm/khugepaged.c
@@ -1,4 +1,5 @@
 #define _GNU_SOURCE
+#include <errno.h>
 #include <fcntl.h>
 #include <limits.h>
 #include <signal.h>
@@ -478,6 +479,26 @@ static void fill_memory(int *p, unsigned
 }
 
 /*
+ * MADV_COLLAPSE is a best-effort request and may fail if an internal
+ * resource is temporarily unavailable, in which case it will set errno to
+ * EAGAIN.  In such a case, immediately reattempt the operation one more
+ * time.
+ */
+static int madvise_collapse_retry(void *p, unsigned long size)
+{
+	bool retry = true;
+	int ret;
+
+retry:
+	ret = madvise(p, size, MADV_COLLAPSE);
+	if (ret && errno == EAGAIN && retry) {
+		retry = false;
+		goto retry;
+	}
+	return ret;
+}
+
+/*
  * Returns pmd-mapped hugepage in VMA marked VM_HUGEPAGE, filled with
  * validate_memory()'able contents.
  */
@@ -531,7 +552,7 @@ static void madvise_collapse(const char
 
 	/* Clear VM_NOHUGEPAGE */
 	madvise(p, nr_hpages * hpage_pmd_size, MADV_HUGEPAGE);
-	ret = madvise(p, nr_hpages * hpage_pmd_size, MADV_COLLAPSE);
+	ret = madvise_collapse_retry(p, nr_hpages * hpage_pmd_size);
 	if (((bool)ret) == expect)
 		fail("Fail: Bad return value");
 	else if (check_huge(p, nr_hpages) != expect)
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-khugepaged-check-compound_order-in-collapse_pte_mapped_thp.patch
mm-madvise-madv_collapse-return-eagain-when-page-cannot-be-isolated.patch
selftests-vm-retry-on-eagain-for-madv_collapse-selftest.patch
mm-shmem-add-flag-to-enforce-shmem-thp-in-hugepage_vma_check.patch
mm-khugepaged-attempt-to-map-file-shmem-backed-pte-mapped-thps-by-pmds.patch
mm-madvise-add-file-and-shmem-support-to-madv_collapse.patch
mm-khugepaged-add-tracepoint-to-hpage_collapse_scan_file.patch
selftests-vm-dedup-thp-helpers.patch
selftests-vm-modularize-thp-collapse-memory-operations.patch
selftests-vm-add-thp-collapse-file-and-tmpfs-testing.patch
selftests-vm-add-thp-collapse-shmem-testing.patch
selftests-vm-add-file-shmem-madv_collapse-selftest-for-cleared-pmd.patch
selftests-vm-add-selftest-for-madv_collapse-of-uffd-minor-memory.patch


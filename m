Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AFD7C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  8 Mar 2022 00:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236184AbiCHAV2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Mar 2022 19:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235382AbiCHAV1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2022 19:21:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA612EA
        for <mm-commits@vger.kernel.org>; Mon,  7 Mar 2022 16:20:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28895B8175A
        for <mm-commits@vger.kernel.org>; Tue,  8 Mar 2022 00:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA77C340E9;
        Tue,  8 Mar 2022 00:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646698829;
        bh=6Rr6mkQwlkK52a9u7VxT5aiu4HOJbB5/GJWd+lc2BYk=;
        h=Date:To:From:Subject:From;
        b=XYOf2bjTsLtWDmEJyURQE9U4Ll8Ft7oocZSA6D8FXMPCJtaHrt1QEMMK2V791/n7d
         b5LccMgpqnQ8pPUhZWO4kTSEsdZP6VfO7Un0JxseF8rLmEcwAF95AZzxv9t5/MI53i
         9o4PENYhyFLWx7L2XYrgw64HklJDVawmK8QP4awg=
Date:   Mon, 07 Mar 2022 16:20:29 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, rppt@linux.ibm.com,
        aneesh.kumar@linux.ibm.com, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-vm-add-helpers-to-detect-page_size-and-page_shift.patch added to -mm tree
Message-Id: <20220308002029.CFA77C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest/vm: add helpers to detect PAGE_SIZE and PAGE_SHIFT
has been added to the -mm tree.  Its filename is
     selftest-vm-add-helpers-to-detect-page_size-and-page_shift.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftest-vm-add-helpers-to-detect-page_size-and-page_shift.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftest-vm-add-helpers-to-detect-page_size-and-page_shift.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@kernel.org>
Subject: selftest/vm: add helpers to detect PAGE_SIZE and PAGE_SHIFT

PAGE_SIZE is not 4096 in many configurations, particularly ppc64 uses 64K
pages in majority of cases.

Add helpers to detect PAGE_SIZE and PAGE_SHIFT dynamically.

Without this tests are broken w.r.t reading /proc/self/pagemap

    if (pread(pagemap_fd, ent, sizeof(ent),
              (uintptr_t)ptr >> (PAGE_SHIFT - 3)) != sizeof(ent))
              err(2, "read pagemap");

Link: https://lkml.kernel.org/r/20220307054355.149820-2-aneesh.kumar@linux.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/gup_test.c |    3 +-
 tools/testing/selftests/vm/util.h     |   27 +++++++++++++++++++++---
 2 files changed, 26 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/vm/gup_test.c~selftest-vm-add-helpers-to-detect-page_size-and-page_shift
+++ a/tools/testing/selftests/vm/gup_test.c
@@ -10,8 +10,9 @@
 #include <assert.h>
 #include "../../../../mm/gup_test.h"
 
+#include "util.h"
+
 #define MB (1UL << 20)
-#define PAGE_SIZE sysconf(_SC_PAGESIZE)
 
 /* Just the flags we need, copied from mm.h: */
 #define FOLL_WRITE	0x01	/* check pte is writable */
--- a/tools/testing/selftests/vm/util.h~selftest-vm-add-helpers-to-detect-page_size-and-page_shift
+++ a/tools/testing/selftests/vm/util.h
@@ -6,11 +6,32 @@
 #include <stdint.h>
 #include <sys/mman.h>
 #include <err.h>
+#include <string.h> /* ffsl() */
+#include <unistd.h> /* _SC_PAGESIZE */
 
-#define PAGE_SHIFT	12
-#define HPAGE_SHIFT	21
+static unsigned int __page_size;
+static unsigned int __page_shift;
 
-#define PAGE_SIZE (1 << PAGE_SHIFT)
+static inline unsigned int page_size(void)
+{
+	if (!__page_size)
+		__page_size = sysconf(_SC_PAGESIZE);
+	return __page_size;
+}
+
+static inline unsigned int page_shift(void)
+{
+	if (!__page_shift)
+		__page_shift = (ffsl(page_size()) - 1);
+	return __page_shift;
+}
+
+#define PAGE_SHIFT	(page_shift())
+#define PAGE_SIZE	(page_size())
+/*
+ * On ppc64 this will only work with radix 2M hugepage size
+ */
+#define HPAGE_SHIFT 21
 #define HPAGE_SIZE (1 << HPAGE_SHIFT)
 
 #define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
_

Patches currently in -mm which might be from rppt@kernel.org are

selftest-vm-add-helpers-to-detect-page_size-and-page_shift.patch


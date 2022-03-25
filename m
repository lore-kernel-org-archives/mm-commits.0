Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34BA8C43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbiCYWn6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233932AbiCYWnZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77BE209A41
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8497CB82A31
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E099C340ED;
        Fri, 25 Mar 2022 22:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248108;
        bh=VILigrJ/jeoAXtkRvCqwsmULEdf2jERycCbZRoWrmxM=;
        h=Date:To:From:Subject:From;
        b=rOTb0Nq96EPbuoovmTWJlZbHYQ5Swv7lobHHakm2/uFGzlxpzeRNA3xxL5GLTv2Kb
         p8Yzcaqpuqw3Iggk+lKFDF3NdbdL9aRCy59qfkT/rFfL1sBuNEX28fXo1SDZu4uOAw
         0EfUa8BTT8KQu2XCb++cuoKqyo+URpvsFacYhErE=
Date:   Fri, 25 Mar 2022 15:41:47 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, rppt@linux.ibm.com,
        aneesh.kumar@linux.ibm.com, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] selftest-vm-add-helpers-to-detect-page_size-and-page_shift.patch removed from -mm tree
Message-Id: <20220325224148.3E099C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest/vm: add helpers to detect PAGE_SIZE and PAGE_SHIFT
has been removed from the -mm tree.  Its filename was
     selftest-vm-add-helpers-to-detect-page_size-and-page_shift.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



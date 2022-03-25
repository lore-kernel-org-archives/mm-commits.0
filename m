Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E89CFC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357150AbiCYBL0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357158AbiCYBLZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:11:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD04762CB3
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:09:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8976DB8270B
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49968C340EE;
        Fri, 25 Mar 2022 01:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170587;
        bh=rLj7PEI5rE0+gZUsAXJCpZPs59KBUytd/Ofr3qhg30s=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=eTx85JjY7nQk/VhRHt14uD9x/BpUWpn+UyVu4JQSuPcv3EbuDjK0DQnuIVIt56szK
         bscbcigqKacCvMJog5Q17E+shYvpoxKHECR0j594UJLIub1GGOCOV4neGhKwNNL8rZ
         /kjZWYD4cT8euHl0RZ0i2Yb0gbs9fpRhHvx1o8Zg=
Date:   Thu, 24 Mar 2022 18:09:46 -0700
To:     shuah@kernel.org, rppt@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        rppt@kernel.org, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 024/114] selftest/vm: add helpers to detect PAGE_SIZE and PAGE_SHIFT
Message-Id: <20220325010947.49968C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

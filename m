Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8229C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357142AbiCYBLZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357155AbiCYBLY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:11:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC5F62A1C
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:09:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6C21B82707
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB90C340F1;
        Fri, 25 Mar 2022 01:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170584;
        bh=VCfBKXPCX8Qv+RGaF635bQP4aqqslaKYcYiux2j4CXo=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=pBy3WZkGqZZtbdWVN87TzS1OqYnSIJq/FRgaabWTX7sn2EpHrpkzYvk0CGP/QKNfu
         TIJspIjp4hS4WJ7eEQeZ2sWhnc0u9ko8Q6AFTaDBaJtLIZSIvuCKQY1DIPLYgqOIy1
         7q6CIxGhF8fJN3MD2Xarv0oluEpvMJqK8GleV+v4=
Date:   Thu, 24 Mar 2022 18:09:43 -0700
To:     shuah@kernel.org, rppt@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 023/114] selftest/vm: add util.h and and move helper functions there
Message-Id: <20220325010944.5DB90C340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: selftest/vm: add util.h and and move helper functions there

Avoid code duplication by adding util.h.  No functional change in this
patch.

Link: https://lkml.kernel.org/r/20220307054355.149820-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/ksm_tests.c        |   38 ------------
 tools/testing/selftests/vm/transhuge-stress.c |   41 +------------
 tools/testing/selftests/vm/util.h             |   48 ++++++++++++++++
 3 files changed, 52 insertions(+), 75 deletions(-)

--- a/tools/testing/selftests/vm/ksm_tests.c~selftest-vm-add-utilh-and-and-move-helper-functions-there
+++ a/tools/testing/selftests/vm/ksm_tests.c
@@ -12,6 +12,7 @@
 
 #include "../kselftest.h"
 #include "../../../../include/vdso/time64.h"
+#include "util.h"
 
 #define KSM_SYSFS_PATH "/sys/kernel/mm/ksm/"
 #define KSM_FP(s) (KSM_SYSFS_PATH s)
@@ -22,15 +23,6 @@
 #define KSM_MERGE_ACROSS_NODES_DEFAULT true
 #define MB (1ul << 20)
 
-#define PAGE_SHIFT 12
-#define HPAGE_SHIFT 21
-
-#define PAGE_SIZE (1 << PAGE_SHIFT)
-#define HPAGE_SIZE (1 << HPAGE_SHIFT)
-
-#define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
-#define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
-
 struct ksm_sysfs {
 	unsigned long max_page_sharing;
 	unsigned long merge_across_nodes;
@@ -456,34 +448,6 @@ err_out:
 	return KSFT_FAIL;
 }
 
-int64_t allocate_transhuge(void *ptr, int pagemap_fd)
-{
-	uint64_t ent[2];
-
-	/* drop pmd */
-	if (mmap(ptr, HPAGE_SIZE, PROT_READ | PROT_WRITE,
-				MAP_FIXED | MAP_ANONYMOUS |
-				MAP_NORESERVE | MAP_PRIVATE, -1, 0) != ptr)
-		errx(2, "mmap transhuge");
-
-	if (madvise(ptr, HPAGE_SIZE, MADV_HUGEPAGE))
-		err(2, "MADV_HUGEPAGE");
-
-	/* allocate transparent huge page */
-	*(volatile void **)ptr = ptr;
-
-	if (pread(pagemap_fd, ent, sizeof(ent),
-			(uintptr_t)ptr >> (PAGE_SHIFT - 3)) != sizeof(ent))
-		err(2, "read pagemap");
-
-	if (PAGEMAP_PRESENT(ent[0]) && PAGEMAP_PRESENT(ent[1]) &&
-	    PAGEMAP_PFN(ent[0]) + 1 == PAGEMAP_PFN(ent[1]) &&
-	    !(PAGEMAP_PFN(ent[0]) & ((1 << (HPAGE_SHIFT - PAGE_SHIFT)) - 1)))
-		return PAGEMAP_PFN(ent[0]);
-
-	return -1;
-}
-
 static int ksm_merge_hugepages_time(int mapping, int prot, int timeout, size_t map_size)
 {
 	void *map_ptr, *map_ptr_orig;
--- a/tools/testing/selftests/vm/transhuge-stress.c~selftest-vm-add-utilh-and-and-move-helper-functions-there
+++ a/tools/testing/selftests/vm/transhuge-stress.c
@@ -15,48 +15,12 @@
 #include <fcntl.h>
 #include <string.h>
 #include <sys/mman.h>
+#include "util.h"
 
-#define PAGE_SHIFT 12
-#define HPAGE_SHIFT 21
-
-#define PAGE_SIZE (1 << PAGE_SHIFT)
-#define HPAGE_SIZE (1 << HPAGE_SHIFT)
-
-#define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
-#define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
-
-int pagemap_fd;
 int backing_fd = -1;
 int mmap_flags = MAP_ANONYMOUS | MAP_NORESERVE | MAP_PRIVATE;
 #define PROT_RW (PROT_READ | PROT_WRITE)
 
-int64_t allocate_transhuge(void *ptr)
-{
-	uint64_t ent[2];
-
-	/* drop pmd */
-	if (mmap(ptr, HPAGE_SIZE, PROT_RW, MAP_FIXED | mmap_flags,
-		 backing_fd, 0) != ptr)
-		errx(2, "mmap transhuge");
-
-	if (madvise(ptr, HPAGE_SIZE, MADV_HUGEPAGE))
-		err(2, "MADV_HUGEPAGE");
-
-	/* allocate transparent huge page */
-	*(volatile void **)ptr = ptr;
-
-	if (pread(pagemap_fd, ent, sizeof(ent),
-			(uintptr_t)ptr >> (PAGE_SHIFT - 3)) != sizeof(ent))
-		err(2, "read pagemap");
-
-	if (PAGEMAP_PRESENT(ent[0]) && PAGEMAP_PRESENT(ent[1]) &&
-	    PAGEMAP_PFN(ent[0]) + 1 == PAGEMAP_PFN(ent[1]) &&
-	    !(PAGEMAP_PFN(ent[0]) & ((1 << (HPAGE_SHIFT - PAGE_SHIFT)) - 1)))
-		return PAGEMAP_PFN(ent[0]);
-
-	return -1;
-}
-
 int main(int argc, char **argv)
 {
 	size_t ram, len;
@@ -67,6 +31,7 @@ int main(int argc, char **argv)
 	double s;
 	uint8_t *map;
 	size_t map_len;
+	int pagemap_fd;
 
 	ram = sysconf(_SC_PHYS_PAGES);
 	if (ram > SIZE_MAX / sysconf(_SC_PAGESIZE) / 4)
@@ -122,7 +87,7 @@ int main(int argc, char **argv)
 		for (p = ptr; p < ptr + len; p += HPAGE_SIZE) {
 			int64_t pfn;
 
-			pfn = allocate_transhuge(p);
+			pfn = allocate_transhuge(p, pagemap_fd);
 
 			if (pfn < 0) {
 				nr_failed++;
--- /dev/null
+++ a/tools/testing/selftests/vm/util.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __KSELFTEST_VM_UTIL_H
+#define __KSELFTEST_VM_UTIL_H
+
+#include <stdint.h>
+#include <sys/mman.h>
+#include <err.h>
+
+#define PAGE_SHIFT	12
+#define HPAGE_SHIFT	21
+
+#define PAGE_SIZE (1 << PAGE_SHIFT)
+#define HPAGE_SIZE (1 << HPAGE_SHIFT)
+
+#define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
+#define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
+
+
+static inline int64_t allocate_transhuge(void *ptr, int pagemap_fd)
+{
+	uint64_t ent[2];
+
+	/* drop pmd */
+	if (mmap(ptr, HPAGE_SIZE, PROT_READ | PROT_WRITE,
+		 MAP_FIXED | MAP_ANONYMOUS |
+		 MAP_NORESERVE | MAP_PRIVATE, -1, 0) != ptr)
+		errx(2, "mmap transhuge");
+
+	if (madvise(ptr, HPAGE_SIZE, MADV_HUGEPAGE))
+		err(2, "MADV_HUGEPAGE");
+
+	/* allocate transparent huge page */
+	*(volatile void **)ptr = ptr;
+
+	if (pread(pagemap_fd, ent, sizeof(ent),
+		  (uintptr_t)ptr >> (PAGE_SHIFT - 3)) != sizeof(ent))
+		err(2, "read pagemap");
+
+	if (PAGEMAP_PRESENT(ent[0]) && PAGEMAP_PRESENT(ent[1]) &&
+	    PAGEMAP_PFN(ent[0]) + 1 == PAGEMAP_PFN(ent[1]) &&
+	    !(PAGEMAP_PFN(ent[0]) & ((1 << (HPAGE_SHIFT - PAGE_SHIFT)) - 1)))
+		return PAGEMAP_PFN(ent[0]);
+
+	return -1;
+}
+
+#endif
_

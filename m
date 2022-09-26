Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C4CC07E9D
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 20:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiIZU0T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 16:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiIZU0S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 16:26:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF349875C
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 13:26:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E252612E7
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 20:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7D2C433C1;
        Mon, 26 Sep 2022 20:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664223975;
        bh=9cDKDbxMkwY7M+gSUUqrfT/fTf57eVoyOe6VIcXlSIs=;
        h=Date:To:From:Subject:From;
        b=hCj5sYNh9DZaS+oTlmgbCZBl3VAfUGISIFueAY5GcxY4nNqLzPy7+mpAZi3vUTBkW
         2xnSACkSvwExqtNzJmcikAaY8OLaudWKwLzowuJw+QPhT9h931F5GH/+9l/cIV6hUt
         wWLkqB+0XoUC1Q1tpWckarw1Rt3DYOnQGurkcdiI=
Date:   Mon, 26 Sep 2022 13:26:14 -0700
To:     mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        peterx@redhat.com, mpenttil@redhat.com, logang@deltatee.com,
        jhubbard@nvidia.com, jgg@nvidia.com, david@redhat.com,
        alex.sierra@amd.com, apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-hmm-tests-add-test-for-dirty-bits-fix.patch removed from -mm tree
Message-Id: <20220926202615.BE7D2C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hmm-tests: fix migrate_dirty_page test
has been removed from the -mm tree.  Its filename was
     selftests-hmm-tests-add-test-for-dirty-bits-fix.patch

This patch was dropped because it was folded into selftests-hmm-tests-add-test-for-dirty-bits.patch

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: hmm-tests: fix migrate_dirty_page test
Date: Wed, 14 Sep 2022 19:12:05 +1000

As noted by John Hubbard the original test relied on side effects of the
implementation of migrate_vma_setup() to detect if pages had been
swapped to disk or not. This is subject to change in future so
explicitly check for swap entries via pagemap instead. Fix a spelling
mistake while we're at it.

Link: https://lkml.kernel.org/r/20220914091205.557676-1-apopple@nvidia.com
Fixes: 5cc88e844e87 ("selftests/hmm-tests: add test for dirty bits")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Mika Penttilä <mpenttil@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile    |    1 
 tools/testing/selftests/vm/hmm-tests.c |   28 +++++++++++++++++++----
 tools/testing/selftests/vm/vm_util.c   |   22 ++++++++++++++++++
 tools/testing/selftests/vm/vm_util.h   |    2 +
 4 files changed, 49 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/vm/hmm-tests.c~selftests-hmm-tests-add-test-for-dirty-bits-fix
+++ a/tools/testing/selftests/vm/hmm-tests.c
@@ -33,6 +33,7 @@
  */
 #include "../../../../lib/test_hmm_uapi.h"
 #include "../../../../mm/gup_test.h"
+#include "vm_util.h"
 
 struct hmm_buffer {
 	void		*ptr;
@@ -1301,9 +1302,24 @@ static int destroy_cgroup(void)
 	return 0;
 }
 
+/* Returns true if at least one page in the range is on swap */
+static bool pages_swapped(void *ptr, size_t size)
+{
+	int fd = open("/proc/self/pagemap", O_RDONLY);
+	bool ret;
+
+	if (fd < 0)
+		return false;
+
+	ret = pagemap_range_some_swapped(fd, ptr, size);
+	close(fd);
+
+	return ret;
+}
+
 /*
  * Try and migrate a dirty page that has previously been swapped to disk. This
- * checks that we don't loose dirty bits.
+ * checks that we don't lose dirty bits.
  */
 TEST_F(hmm, migrate_dirty_page)
 {
@@ -1340,6 +1356,10 @@ TEST_F(hmm, migrate_dirty_page)
 
 	ASSERT_FALSE(write_cgroup_param(cgroup, "memory.reclaim", 1UL<<30));
 
+	/* Make sure at least some pages got paged to disk. */
+	if (!pages_swapped(buffer->ptr, size))
+		SKIP(return, "Pages weren't swapped when they should have been");
+
 	/* Fault pages back in from swap as clean pages */
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 		tmp += ptr[i];
@@ -1349,10 +1369,10 @@ TEST_F(hmm, migrate_dirty_page)
 		ptr[i] = i;
 
 	/*
-	 * Attempt to migrate memory to device, which should fail because
-	 * hopefully some pages are backed by swap storage.
+	 * Attempt to migrate memory to device. This might fail if some pages
+	 * are/were backed by swap but that's ok.
 	 */
-	ASSERT_TRUE(hmm_migrate_sys_to_dev(self->fd, buffer, npages));
+	hmm_migrate_sys_to_dev(self->fd, buffer, npages);
 
 	ASSERT_FALSE(write_cgroup_param(cgroup, "memory.reclaim", 1UL<<30));
 
--- a/tools/testing/selftests/vm/Makefile~selftests-hmm-tests-add-test-for-dirty-bits-fix
+++ a/tools/testing/selftests/vm/Makefile
@@ -98,6 +98,7 @@ include ../lib.mk
 $(OUTPUT)/madv_populate: vm_util.c
 $(OUTPUT)/soft-dirty: vm_util.c
 $(OUTPUT)/split_huge_page_test: vm_util.c
+$(OUTPUT)/hmm-tests: vm_util.c
 
 ifeq ($(MACHINE),x86_64)
 BINARIES_32 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
--- a/tools/testing/selftests/vm/vm_util.c~selftests-hmm-tests-add-test-for-dirty-bits-fix
+++ a/tools/testing/selftests/vm/vm_util.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <unistd.h>
 #include <string.h>
 #include <fcntl.h>
 #include "../kselftest.h"
@@ -20,6 +21,14 @@ uint64_t pagemap_get_entry(int fd, char
 	return entry;
 }
 
+bool pagemap_is_swapped(int fd, char *start)
+{
+	uint64_t entry = pagemap_get_entry(fd, start);
+
+	// Check if swap entry bit (62nd bit) is set
+	return entry & 0x4000000000000000ull;
+}
+
 bool pagemap_is_softdirty(int fd, char *start)
 {
 	uint64_t entry = pagemap_get_entry(fd, start);
@@ -28,6 +37,19 @@ bool pagemap_is_softdirty(int fd, char *
 	return entry & 0x0080000000000000ull;
 }
 
+/* Returns true if at least one page in the range is in swap */
+bool pagemap_range_some_swapped(int fd, char *start, size_t len)
+{
+	unsigned long i;
+	unsigned long npages = len / getpagesize();
+
+	for (i = 0; i < npages; i++)
+		if (pagemap_is_swapped(fd, start + i * getpagesize()))
+			return true;
+
+	return false;
+}
+
 void clear_softdirty(void)
 {
 	int ret;
--- a/tools/testing/selftests/vm/vm_util.h~selftests-hmm-tests-add-test-for-dirty-bits-fix
+++ a/tools/testing/selftests/vm/vm_util.h
@@ -4,6 +4,8 @@
 
 uint64_t pagemap_get_entry(int fd, char *start);
 bool pagemap_is_softdirty(int fd, char *start);
+bool pagemap_is_swapped(int fd, char *start);
+bool pagemap_range_some_swapped(int fd, char *start, size_t len);
 void clear_softdirty(void);
 uint64_t read_pmd_pagesize(void);
 uint64_t check_huge(void *addr);
_

Patches currently in -mm which might be from apopple@nvidia.com are

selftests-hmm-tests-add-test-for-dirty-bits.patch


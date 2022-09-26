Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07625C32771
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 20:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiIZU2u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 16:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiIZU2t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 16:28:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F46A3456
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 13:28:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FDB86131B
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 20:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85696C433C1;
        Mon, 26 Sep 2022 20:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664224126;
        bh=933Lk9Bb6u9eCMfBhmOyTZ35mdMnpUEP7iU6X8tWITw=;
        h=Date:To:From:Subject:From;
        b=fs57xtlJhFm5bt9/fbDHTcvcJL9sHHdUx6lDU6fhvjske8OC1tCex8/4vTnlGLq6c
         bycXTrx/EDG5tyzSpy87mKhY3HSjmMficwH4R8Hedvdol6jMbYb3Bpa5SamPOl+eTc
         yeJXMBrszSXyO/hSvp3TsSfW/IWMlgU/cHH5jH8M=
Date:   Mon, 26 Sep 2022 13:28:45 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, rcampbell@nvidia.com, peterx@redhat.com,
        paulus@ozlabs.org, mpenttil@redhat.com, lyude@redhat.com,
        logang@deltatee.com, kherbst@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, felix.kuehling@amd.com, david@redhat.com,
        bskeggs@redhat.com, alex.sierra@amd.com, apopple@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-hmm-tests-add-test-for-dirty-bits.patch removed from -mm tree
Message-Id: <20220926202846.85696C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/hmm-tests: add test for dirty bits
has been removed from the -mm tree.  Its filename was
     selftests-hmm-tests-add-test-for-dirty-bits.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: selftests/hmm-tests: add test for dirty bits
Date: Tue, 16 Aug 2022 17:39:25 +1000

We were not correctly copying PTE dirty bits to pages during
migrate_vma_setup() calls.  This could potentially lead to data loss, so
add a test for this.

[apopple@nvidia.com: fix migrate_dirty_page test]
  Link: https://lkml.kernel.org/r/20220914091205.557676-1-apopple@nvidia.com
Link: https://lkml.kernel.org/r/23069a5c6e07d16d4c4f0951ff003591ffc4f656.1660635033.git-series.apopple@nvidia.com
Link: https://lkml.kernel.org/r/68cf1d70f3fb8ce4e3c1a4899c19df4f6c382a13.1662078528.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Mika Penttilä <mpenttil@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile    |    1 
 tools/testing/selftests/vm/hmm-tests.c |  144 +++++++++++++++++++++++
 tools/testing/selftests/vm/vm_util.c   |   22 +++
 tools/testing/selftests/vm/vm_util.h   |    2 
 4 files changed, 169 insertions(+)

--- a/tools/testing/selftests/vm/hmm-tests.c~selftests-hmm-tests-add-test-for-dirty-bits
+++ a/tools/testing/selftests/vm/hmm-tests.c
@@ -33,6 +33,7 @@
  */
 #include "../../../../lib/test_hmm_uapi.h"
 #include "../../../../mm/gup_test.h"
+#include "vm_util.h"
 
 struct hmm_buffer {
 	void		*ptr;
@@ -1240,6 +1241,149 @@ TEST_F(hmm, migrate_multiple)
 	}
 }
 
+static char cgroup[] = "/sys/fs/cgroup/hmm-test-XXXXXX";
+static int write_cgroup_param(char *cgroup_path, char *param, long value)
+{
+	int ret;
+	FILE *f;
+	char *filename;
+
+	if (asprintf(&filename, "%s/%s", cgroup_path, param) < 0)
+		return -1;
+
+	f = fopen(filename, "w");
+	if (!f) {
+		ret = -1;
+		goto out;
+	}
+
+	ret = fprintf(f, "%ld\n", value);
+	if (ret < 0)
+		goto out1;
+
+	ret = 0;
+
+out1:
+	fclose(f);
+out:
+	free(filename);
+
+	return ret;
+}
+
+static int setup_cgroup(void)
+{
+	pid_t pid = getpid();
+	int ret;
+
+	if (!mkdtemp(cgroup))
+		return -1;
+
+	ret = write_cgroup_param(cgroup, "cgroup.procs", pid);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int destroy_cgroup(void)
+{
+	pid_t pid = getpid();
+	int ret;
+
+	ret = write_cgroup_param("/sys/fs/cgroup/cgroup.procs",
+				"cgroup.proc", pid);
+	if (ret)
+		return ret;
+
+	if (rmdir(cgroup))
+		return -1;
+
+	return 0;
+}
+
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
+/*
+ * Try and migrate a dirty page that has previously been swapped to disk. This
+ * checks that we don't lose dirty bits.
+ */
+TEST_F(hmm, migrate_dirty_page)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	unsigned long i;
+	int *ptr;
+	int tmp = 0;
+
+	npages = ALIGN(HMM_BUFFER_SIZE, self->page_size) >> self->page_shift;
+	ASSERT_NE(npages, 0);
+	size = npages << self->page_shift;
+
+	buffer = malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd = -1;
+	buffer->size = size;
+	buffer->mirror = malloc(size);
+	ASSERT_NE(buffer->mirror, NULL);
+
+	ASSERT_EQ(setup_cgroup(), 0);
+
+	buffer->ptr = mmap(NULL, size,
+			   PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANONYMOUS,
+			   buffer->fd, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	/* Initialize buffer in system memory. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ptr[i] = 0;
+
+	ASSERT_FALSE(write_cgroup_param(cgroup, "memory.reclaim", 1UL<<30));
+
+	/* Make sure at least some pages got paged to disk. */
+	if (!pages_swapped(buffer->ptr, size))
+		SKIP(return, "Pages weren't swapped when they should have been");
+
+	/* Fault pages back in from swap as clean pages */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		tmp += ptr[i];
+
+	/* Dirty the pte */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ptr[i] = i;
+
+	/*
+	 * Attempt to migrate memory to device. This might fail if some pages
+	 * are/were backed by swap but that's ok.
+	 */
+	hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+
+	ASSERT_FALSE(write_cgroup_param(cgroup, "memory.reclaim", 1UL<<30));
+
+	/* Check we still see the updated data after restoring from swap. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], i);
+
+	hmm_buffer_free(buffer);
+	destroy_cgroup();
+}
+
 /*
  * Read anonymous memory multiple times.
  */
--- a/tools/testing/selftests/vm/Makefile~selftests-hmm-tests-add-test-for-dirty-bits
+++ a/tools/testing/selftests/vm/Makefile
@@ -98,6 +98,7 @@ include ../lib.mk
 $(OUTPUT)/madv_populate: vm_util.c
 $(OUTPUT)/soft-dirty: vm_util.c
 $(OUTPUT)/split_huge_page_test: vm_util.c
+$(OUTPUT)/hmm-tests: vm_util.c
 
 ifeq ($(MACHINE),x86_64)
 BINARIES_32 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
--- a/tools/testing/selftests/vm/vm_util.c~selftests-hmm-tests-add-test-for-dirty-bits
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
--- a/tools/testing/selftests/vm/vm_util.h~selftests-hmm-tests-add-test-for-dirty-bits
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



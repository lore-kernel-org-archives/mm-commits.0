Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9696C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235978AbiEJEQt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236130AbiEJEPq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:15:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116CE939EE
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3594B817CC
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75415C385A6;
        Tue, 10 May 2022 04:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155883;
        bh=JjQX38tCl0D9N4E4dOKUirbjZTKb3I+1nFY8pJr1FpY=;
        h=Date:To:From:Subject:From;
        b=gyVNEaq/l6AXBVROBktth4xSoqixVjiFY7Tkr8OKeFxi2LUR8vWrWJ7mtLZM0qmSb
         /UZXkj3aiycIsGVt5gYS6oZlQPsgU7vPtGgGcJrEosj0FkainqwQP8t8HpCZk/afoB
         AvR43Nv4Z/4QSyQjfrY6+ayJluu14EL9P/iCX77k=
Date:   Mon, 09 May 2022 21:11:22 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tglx@linutronix.de, songmuchun@bytedance.com, shuah@kernel.org,
        rcampbell@nvidia.com, kirill.shutemov@linux.intel.com,
        jhubbard@nvidia.com, jack@suse.cz, hughd@google.com,
        bigeasy@linutronix.de, apopple@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-selftests-for-migration-entries.patch removed from -mm tree
Message-Id: <20220510041123.75415C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add selftests for migration entries
has been removed from the -mm tree.  Its filename was
     mm-add-selftests-for-migration-entries.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm: add selftests for migration entries

Add some basic migration tests and in particular tests that will
stress both the pte and pmd migration entry wait paths.

Link: https://lkml.kernel.org/r/20220324014349.229253-1-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile    |    3 
 tools/testing/selftests/vm/migration.c |  193 +++++++++++++++++++++++
 2 files changed, 196 insertions(+)

--- a/tools/testing/selftests/vm/Makefile~mm-add-selftests-for-migration-entries
+++ a/tools/testing/selftests/vm/Makefile
@@ -41,6 +41,7 @@ TEST_GEN_FILES += map_fixed_noreplace
 TEST_GEN_FILES += map_hugetlb
 TEST_GEN_FILES += map_populate
 TEST_GEN_FILES += memfd_secret
+TEST_GEN_FILES += migration
 TEST_GEN_FILES += mlock-random-test
 TEST_GEN_FILES += mlock2-tests
 TEST_GEN_FILES += mremap_dontunmap
@@ -149,6 +150,8 @@ $(OUTPUT)/hmm-tests: LDLIBS += $(HMM_EXT
 
 $(OUTPUT)/ksm_tests: LDLIBS += -lnuma
 
+$(OUTPUT)/migration: LDLIBS += -lnuma
+
 local_config.mk local_config.h: check_config.sh
 	/bin/sh ./check_config.sh $(CC)
 
--- /dev/null
+++ a/tools/testing/selftests/vm/migration.c
@@ -0,0 +1,193 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * The main purpose of the tests here is to exercise the migration entry code
+ * paths in the kernel.
+ */
+
+#include "../kselftest_harness.h"
+#include <strings.h>
+#include <pthread.h>
+#include <numa.h>
+#include <numaif.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <signal.h>
+#include <time.h>
+
+#define TWOMEG (2<<20)
+#define RUNTIME (60)
+
+#define ALIGN(x, a) (((x) + (a - 1)) & (~((a) - 1)))
+
+FIXTURE(migration)
+{
+	pthread_t *threads;
+	pid_t *pids;
+	int nthreads;
+	int n1;
+	int n2;
+};
+
+FIXTURE_SETUP(migration)
+{
+	int n;
+
+	ASSERT_EQ(numa_available(), 0);
+	self->nthreads = numa_num_task_cpus() - 1;
+	self->n1 = -1;
+	self->n2 = -1;
+
+	for (n = 0; n < numa_max_possible_node(); n++)
+		if (numa_bitmask_isbitset(numa_all_nodes_ptr, n)) {
+			if (self->n1 == -1) {
+				self->n1 = n;
+			} else {
+				self->n2 = n;
+				break;
+			}
+		}
+
+	self->threads = malloc(self->nthreads * sizeof(*self->threads));
+	ASSERT_NE(self->threads, NULL);
+	self->pids = malloc(self->nthreads * sizeof(*self->pids));
+	ASSERT_NE(self->pids, NULL);
+};
+
+FIXTURE_TEARDOWN(migration)
+{
+	free(self->threads);
+	free(self->pids);
+}
+
+int migrate(uint64_t *ptr, int n1, int n2)
+{
+	int ret, tmp;
+	int status = 0;
+	struct timespec ts1, ts2;
+
+	if (clock_gettime(CLOCK_MONOTONIC, &ts1))
+		return -1;
+
+	while (1) {
+		if (clock_gettime(CLOCK_MONOTONIC, &ts2))
+			return -1;
+
+		if (ts2.tv_sec - ts1.tv_sec >= RUNTIME)
+			return 0;
+
+		ret = move_pages(0, 1, (void **) &ptr, &n2, &status,
+				MPOL_MF_MOVE_ALL);
+		if (ret) {
+			if (ret > 0)
+				printf("Didn't migrate %d pages\n", ret);
+			else
+				perror("Couldn't migrate pages");
+			return -2;
+		}
+
+		tmp = n2;
+		n2 = n1;
+		n1 = tmp;
+	}
+
+	return 0;
+}
+
+void *access_mem(void *ptr)
+{
+	uint64_t y = 0;
+	volatile uint64_t *x = ptr;
+
+	while (1) {
+		pthread_testcancel();
+		y += *x;
+	}
+
+	return NULL;
+}
+
+/*
+ * Basic migration entry testing. One thread will move pages back and forth
+ * between nodes whilst other threads try and access them triggering the
+ * migration entry wait paths in the kernel.
+ */
+TEST_F_TIMEOUT(migration, private_anon, 2*RUNTIME)
+{
+	uint64_t *ptr;
+	int i;
+
+	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
+		SKIP(return, "Not enough threads or NUMA nodes available");
+
+	ptr = mmap(NULL, TWOMEG, PROT_READ | PROT_WRITE,
+		MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	memset(ptr, 0xde, TWOMEG);
+	for (i = 0; i < self->nthreads - 1; i++)
+		if (pthread_create(&self->threads[i], NULL, access_mem, ptr))
+			perror("Couldn't create thread");
+
+	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
+	for (i = 0; i < self->nthreads - 1; i++)
+		ASSERT_EQ(pthread_cancel(self->threads[i]), 0);
+}
+
+/*
+ * Same as the previous test but with shared memory.
+ */
+TEST_F_TIMEOUT(migration, shared_anon, 2*RUNTIME)
+{
+	pid_t pid;
+	uint64_t *ptr;
+	int i;
+
+	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
+		SKIP(return, "Not enough threads or NUMA nodes available");
+
+	ptr = mmap(NULL, TWOMEG, PROT_READ | PROT_WRITE,
+		MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	memset(ptr, 0xde, TWOMEG);
+	for (i = 0; i < self->nthreads - 1; i++) {
+		pid = fork();
+		if (!pid)
+			access_mem(ptr);
+		else
+			self->pids[i] = pid;
+	}
+
+	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
+	for (i = 0; i < self->nthreads - 1; i++)
+		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
+}
+
+/*
+ * Tests the pmd migration entry paths.
+ */
+TEST_F_TIMEOUT(migration, private_anon_thp, 2*RUNTIME)
+{
+	uint64_t *ptr;
+	int i;
+
+	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
+		SKIP(return, "Not enough threads or NUMA nodes available");
+
+	ptr = mmap(NULL, 2*TWOMEG, PROT_READ | PROT_WRITE,
+		MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	ptr = (uint64_t *) ALIGN((uintptr_t) ptr, TWOMEG);
+	ASSERT_EQ(madvise(ptr, TWOMEG, MADV_HUGEPAGE), 0);
+	memset(ptr, 0xde, TWOMEG);
+	for (i = 0; i < self->nthreads - 1; i++)
+		if (pthread_create(&self->threads[i], NULL, access_mem, ptr))
+			perror("Couldn't create thread");
+
+	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
+	for (i = 0; i < self->nthreads - 1; i++)
+		ASSERT_EQ(pthread_cancel(self->threads[i]), 0);
+}
+
+TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from apopple@nvidia.com are



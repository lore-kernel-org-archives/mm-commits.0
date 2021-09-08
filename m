Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A168C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29E1D61131
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347292AbhIHDA4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347231AbhIHDAo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:00:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E5FB61131;
        Wed,  8 Sep 2021 02:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069976;
        bh=+/hVb9TR3Sk62wJk5ZMbQMu7j7xXRh8KQPEOdYgRAGU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DryqCVwfChvOiA9h6FJbbYWKNsKqpkXcS5XK/6f5LT2Q+mdXDC869amCBCOPaYv+m
         ZFXIe6oITBi0+qDCOmaZSQqkbzLpQBjFyfn1wj6WhWTSxcpLHf+pZpv5XHBcfXNnjG
         c6eqNJcq+dDSrFkDg18uMmulECeLnKt1LaF/uO3Q=
Date:   Tue, 07 Sep 2021 19:59:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aklimov@redhat.com, akpm@linux-foundation.org, alobakin@pm.me,
        andriy.shevchenko@linux.intel.com, dennis@kernel.org,
        jolsa@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, ulf.hansson@linaro.org,
        will@kernel.org, wsa+renesas@sang-engineering.com,
        yury.norov@gmail.com
Subject:  [patch 119/147] tools: rename bitmap_alloc() to
 bitmap_zalloc()
Message-ID: <20210908025935.eIOGdXgx8%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: tools: rename bitmap_alloc() to bitmap_zalloc()

Rename bitmap_alloc() to bitmap_zalloc() in tools to follow the bitmap API
in the kernel.

No functional changes intended.

Link: https://lkml.kernel.org/r/20210814211713.180533-14-yury.norov@gmail.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Suggested-by: Yury Norov <yury.norov@gmail.com>
Acked-by: Yury Norov <yury.norov@gmail.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Alexey Klimov <aklimov@redhat.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/linux/bitmap.h                            |    4 ++--
 tools/perf/bench/find-bit-bench.c                       |    2 +-
 tools/perf/builtin-c2c.c                                |    6 +++---
 tools/perf/builtin-record.c                             |    2 +-
 tools/perf/tests/bitmap.c                               |    2 +-
 tools/perf/tests/mem2node.c                             |    2 +-
 tools/perf/util/affinity.c                              |    4 ++--
 tools/perf/util/header.c                                |    4 ++--
 tools/perf/util/metricgroup.c                           |    2 +-
 tools/perf/util/mmap.c                                  |    4 ++--
 tools/testing/selftests/kvm/dirty_log_perf_test.c       |    2 +-
 tools/testing/selftests/kvm/dirty_log_test.c            |    4 ++--
 tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c |    2 +-
 13 files changed, 20 insertions(+), 20 deletions(-)

--- a/tools/include/linux/bitmap.h~tools-rename-bitmap_alloc-to-bitmap_zalloc
+++ a/tools/include/linux/bitmap.h
@@ -112,10 +112,10 @@ static inline int test_and_clear_bit(int
 }
 
 /**
- * bitmap_alloc - Allocate bitmap
+ * bitmap_zalloc - Allocate bitmap
  * @nbits: Number of bits
  */
-static inline unsigned long *bitmap_alloc(int nbits)
+static inline unsigned long *bitmap_zalloc(int nbits)
 {
 	return calloc(1, BITS_TO_LONGS(nbits) * sizeof(unsigned long));
 }
--- a/tools/perf/bench/find-bit-bench.c~tools-rename-bitmap_alloc-to-bitmap_zalloc
+++ a/tools/perf/bench/find-bit-bench.c
@@ -54,7 +54,7 @@ static bool asm_test_bit(long nr, const
 
 static int do_for_each_set_bit(unsigned int num_bits)
 {
-	unsigned long *to_test = bitmap_alloc(num_bits);
+	unsigned long *to_test = bitmap_zalloc(num_bits);
 	struct timeval start, end, diff;
 	u64 runtime_us;
 	struct stats fb_time_stats, tb_time_stats;
--- a/tools/perf/builtin-c2c.c~tools-rename-bitmap_alloc-to-bitmap_zalloc
+++ a/tools/perf/builtin-c2c.c
@@ -139,11 +139,11 @@ static void *c2c_he_zalloc(size_t size)
 	if (!c2c_he)
 		return NULL;
 
-	c2c_he->cpuset = bitmap_alloc(c2c.cpus_cnt);
+	c2c_he->cpuset = bitmap_zalloc(c2c.cpus_cnt);
 	if (!c2c_he->cpuset)
 		return NULL;
 
-	c2c_he->nodeset = bitmap_alloc(c2c.nodes_cnt);
+	c2c_he->nodeset = bitmap_zalloc(c2c.nodes_cnt);
 	if (!c2c_he->nodeset)
 		return NULL;
 
@@ -2047,7 +2047,7 @@ static int setup_nodes(struct perf_sessi
 		struct perf_cpu_map *map = n[node].map;
 		unsigned long *set;
 
-		set = bitmap_alloc(c2c.cpus_cnt);
+		set = bitmap_zalloc(c2c.cpus_cnt);
 		if (!set)
 			return -ENOMEM;
 
--- a/tools/perf/builtin-record.c~tools-rename-bitmap_alloc-to-bitmap_zalloc
+++ a/tools/perf/builtin-record.c
@@ -2786,7 +2786,7 @@ int cmd_record(int argc, const char **ar
 
 	if (rec->opts.affinity != PERF_AFFINITY_SYS) {
 		rec->affinity_mask.nbits = cpu__max_cpu();
-		rec->affinity_mask.bits = bitmap_alloc(rec->affinity_mask.nbits);
+		rec->affinity_mask.bits = bitmap_zalloc(rec->affinity_mask.nbits);
 		if (!rec->affinity_mask.bits) {
 			pr_err("Failed to allocate thread mask for %zd cpus\n", rec->affinity_mask.nbits);
 			err = -ENOMEM;
--- a/tools/perf/tests/bitmap.c~tools-rename-bitmap_alloc-to-bitmap_zalloc
+++ a/tools/perf/tests/bitmap.c
@@ -14,7 +14,7 @@ static unsigned long *get_bitmap(const c
 	unsigned long *bm = NULL;
 	int i;
 
-	bm = bitmap_alloc(nbits);
+	bm = bitmap_zalloc(nbits);
 
 	if (map && bm) {
 		for (i = 0; i < map->nr; i++)
--- a/tools/perf/tests/mem2node.c~tools-rename-bitmap_alloc-to-bitmap_zalloc
+++ a/tools/perf/tests/mem2node.c
@@ -27,7 +27,7 @@ static unsigned long *get_bitmap(const c
 	unsigned long *bm = NULL;
 	int i;
 
-	bm = bitmap_alloc(nbits);
+	bm = bitmap_zalloc(nbits);
 
 	if (map && bm) {
 		for (i = 0; i < map->nr; i++) {
--- a/tools/perf/util/affinity.c~tools-rename-bitmap_alloc-to-bitmap_zalloc
+++ a/tools/perf/util/affinity.c
@@ -25,11 +25,11 @@ int affinity__setup(struct affinity *a)
 {
 	int cpu_set_size = get_cpu_set_size();
 
-	a->orig_cpus = bitmap_alloc(cpu_set_size * 8);
+	a->orig_cpus = bitmap_zalloc(cpu_set_size * 8);
 	if (!a->orig_cpus)
 		return -1;
 	sched_getaffinity(0, cpu_set_size, (cpu_set_t *)a->orig_cpus);
-	a->sched_cpus = bitmap_alloc(cpu_set_size * 8);
+	a->sched_cpus = bitmap_zalloc(cpu_set_size * 8);
 	if (!a->sched_cpus) {
 		zfree(&a->orig_cpus);
 		return -1;
--- a/tools/perf/util/header.c~tools-rename-bitmap_alloc-to-bitmap_zalloc
+++ a/tools/perf/util/header.c
@@ -278,7 +278,7 @@ static int do_read_bitmap(struct feat_fd
 	if (ret)
 		return ret;
 
-	set = bitmap_alloc(size);
+	set = bitmap_zalloc(size);
 	if (!set)
 		return -ENOMEM;
 
@@ -1294,7 +1294,7 @@ static int memory_node__read(struct memo
 
 	size++;
 
-	n->set = bitmap_alloc(size);
+	n->set = bitmap_zalloc(size);
 	if (!n->set) {
 		closedir(dir);
 		return -ENOMEM;
--- a/tools/perf/util/metricgroup.c~tools-rename-bitmap_alloc-to-bitmap_zalloc
+++ a/tools/perf/util/metricgroup.c
@@ -313,7 +313,7 @@ static int metricgroup__setup_events(str
 	struct evsel *evsel, *tmp;
 	unsigned long *evlist_used;
 
-	evlist_used = bitmap_alloc(perf_evlist->core.nr_entries);
+	evlist_used = bitmap_zalloc(perf_evlist->core.nr_entries);
 	if (!evlist_used)
 		return -ENOMEM;
 
--- a/tools/perf/util/mmap.c~tools-rename-bitmap_alloc-to-bitmap_zalloc
+++ a/tools/perf/util/mmap.c
@@ -106,7 +106,7 @@ static int perf_mmap__aio_bind(struct mm
 		data = map->aio.data[idx];
 		mmap_len = mmap__mmap_len(map);
 		node_index = cpu__get_node(cpu);
-		node_mask = bitmap_alloc(node_index + 1);
+		node_mask = bitmap_zalloc(node_index + 1);
 		if (!node_mask) {
 			pr_err("Failed to allocate node mask for mbind: error %m\n");
 			return -1;
@@ -258,7 +258,7 @@ static void build_node_mask(int node, st
 static int perf_mmap__setup_affinity_mask(struct mmap *map, struct mmap_params *mp)
 {
 	map->affinity_mask.nbits = cpu__max_cpu();
-	map->affinity_mask.bits = bitmap_alloc(map->affinity_mask.nbits);
+	map->affinity_mask.bits = bitmap_zalloc(map->affinity_mask.nbits);
 	if (!map->affinity_mask.bits)
 		return -1;
 
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c~tools-rename-bitmap_alloc-to-bitmap_zalloc
+++ a/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -121,7 +121,7 @@ static void run_test(enum vm_guest_mode
 	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm_get_page_shift(vm);
 	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
 	host_num_pages = vm_num_host_pages(mode, guest_num_pages);
-	bmap = bitmap_alloc(host_num_pages);
+	bmap = bitmap_zalloc(host_num_pages);
 
 	if (dirty_log_manual_caps) {
 		cap.cap = KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2;
--- a/tools/testing/selftests/kvm/dirty_log_test.c~tools-rename-bitmap_alloc-to-bitmap_zalloc
+++ a/tools/testing/selftests/kvm/dirty_log_test.c
@@ -749,8 +749,8 @@ static void run_test(enum vm_guest_mode
 
 	pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
 
-	bmap = bitmap_alloc(host_num_pages);
-	host_bmap_track = bitmap_alloc(host_num_pages);
+	bmap = bitmap_zalloc(host_num_pages);
+	host_bmap_track = bitmap_zalloc(host_num_pages);
 
 	/* Add an extra memory slot for testing dirty logging */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
--- a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c~tools-rename-bitmap_alloc-to-bitmap_zalloc
+++ a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
@@ -111,7 +111,7 @@ int main(int argc, char *argv[])
 	nested_map(vmx, vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, 4096);
 	nested_map(vmx, vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, 4096);
 
-	bmap = bitmap_alloc(TEST_MEM_PAGES);
+	bmap = bitmap_zalloc(TEST_MEM_PAGES);
 	host_test_mem = addr_gpa2hva(vm, GUEST_TEST_MEM);
 
 	while (!done) {
_

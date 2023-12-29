Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD30134AF
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="blEXhhna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FF3C433C8;
	Fri, 29 Dec 2023 19:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879977;
	bh=sv+YGV+Fmr+Ys26I7nyLAT+yxTO2RwpF0qX89MPhfF0=;
	h=Date:To:From:Subject:From;
	b=blEXhhnaa4TN8Q/dw4fovkd8ePT+ictWPnz+GWdXgTBYhGZr8AUevYxsIcCGIJ+ra
	 /zgVCsqVSR1GfEBJ6UlrQWkcMXvAisEpPMlRfOooQ06FjYHOkHiZhUqcvde+qdlVBO
	 q5POjQ5shZ/TV2yKWY1RFNBdiZFJZTpRb3gWUAEA=
Date: Fri, 29 Dec 2023 11:59:36 -0800
To: mm-commits@vger.kernel.org,zhangpeng362@huawei.com,willy@infradead.org,viro@zeniv.linux.org.uk,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,ngeoffray@google.com,mhocko@suse.com,lokeshgidra@google.com,Liam.Howlett@oracle.com,kaleshsingh@google.com,jannh@google.com,hughd@google.com,david@redhat.com,brauner@kernel.org,bgeffon@google.com,axelrasmussen@google.com,aarcange@redhat.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-uffd_test_case_ops-to-allow-test-case-specific-operations.patch removed from -mm tree
Message-Id: <20231229195937.76FF3C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add uffd_test_case_ops to allow test case-specific operations
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-uffd_test_case_ops-to-allow-test-case-specific-operations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: selftests/mm: add uffd_test_case_ops to allow test case-specific operations
Date: Wed, 6 Dec 2023 02:36:58 -0800

Currently each test can specify unique operations using uffd_test_ops,
however these operations are per-memory type and not per-test.  Add
uffd_test_case_ops which each test case can customize for its own needs
regardless of the memory type being used.  Pre- and post-allocation
operations are added, some of which will be used in the next patch to
implement test-specific operations like madvise after memory is allocated
but before it is accessed.

Link: https://lkml.kernel.org/r/20231206103702.3873743-5-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Nicolas Geoffray <ngeoffray@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: ZhangPeng <zhangpeng362@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.c     |   13 +++++++++++++
 tools/testing/selftests/mm/uffd-common.h     |    7 +++++++
 tools/testing/selftests/mm/uffd-unit-tests.c |    2 ++
 3 files changed, 22 insertions(+)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-add-uffd_test_case_ops-to-allow-test-case-specific-operations
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -17,6 +17,7 @@ bool map_shared;
 bool test_uffdio_wp = true;
 unsigned long long *count_verify;
 uffd_test_ops_t *uffd_test_ops;
+uffd_test_case_ops_t *uffd_test_case_ops;
 
 static int uffd_mem_fd_create(off_t mem_size, bool hugetlb)
 {
@@ -298,6 +299,12 @@ int uffd_test_ctx_init(uint64_t features
 	unsigned long nr, cpu;
 	int ret;
 
+	if (uffd_test_case_ops && uffd_test_case_ops->pre_alloc) {
+		ret = uffd_test_case_ops->pre_alloc(errmsg);
+		if (ret)
+			return ret;
+	}
+
 	ret = uffd_test_ops->allocate_area((void **)&area_src, true);
 	ret |= uffd_test_ops->allocate_area((void **)&area_dst, false);
 	if (ret) {
@@ -306,6 +313,12 @@ int uffd_test_ctx_init(uint64_t features
 		return ret;
 	}
 
+	if (uffd_test_case_ops && uffd_test_case_ops->post_alloc) {
+		ret = uffd_test_case_ops->post_alloc(errmsg);
+		if (ret)
+			return ret;
+	}
+
 	ret = userfaultfd_open(&features);
 	if (ret) {
 		if (errmsg)
--- a/tools/testing/selftests/mm/uffd-common.h~selftests-mm-add-uffd_test_case_ops-to-allow-test-case-specific-operations
+++ a/tools/testing/selftests/mm/uffd-common.h
@@ -90,6 +90,12 @@ struct uffd_test_ops {
 };
 typedef struct uffd_test_ops uffd_test_ops_t;
 
+struct uffd_test_case_ops {
+	int (*pre_alloc)(const char **errmsg);
+	int (*post_alloc)(const char **errmsg);
+};
+typedef struct uffd_test_case_ops uffd_test_case_ops_t;
+
 extern unsigned long nr_cpus, nr_pages, nr_pages_per_cpu, page_size;
 extern char *area_src, *area_src_alias, *area_dst, *area_dst_alias, *area_remap;
 extern int uffd, uffd_flags, finished, *pipefd, test_type;
@@ -102,6 +108,7 @@ extern uffd_test_ops_t anon_uffd_test_op
 extern uffd_test_ops_t shmem_uffd_test_ops;
 extern uffd_test_ops_t hugetlb_uffd_test_ops;
 extern uffd_test_ops_t *uffd_test_ops;
+extern uffd_test_case_ops_t *uffd_test_case_ops;
 
 void uffd_stats_report(struct uffd_args *args, int n_cpus);
 int uffd_test_ctx_init(uint64_t features, const char **errmsg);
--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-add-uffd_test_case_ops-to-allow-test-case-specific-operations
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -78,6 +78,7 @@ typedef struct {
 	uffd_test_fn uffd_fn;
 	unsigned int mem_targets;
 	uint64_t uffd_feature_required;
+	uffd_test_case_ops_t *test_case_ops;
 } uffd_test_case_t;
 
 static void uffd_test_report(void)
@@ -185,6 +186,7 @@ uffd_setup_environment(uffd_test_args_t
 {
 	map_shared = mem_type->shared;
 	uffd_test_ops = mem_type->mem_ops;
+	uffd_test_case_ops = test->test_case_ops;
 
 	if (mem_type->mem_flag & (MEM_HUGETLB_PRIVATE | MEM_HUGETLB))
 		page_size = default_huge_page_size();
_

Patches currently in -mm which might be from surenb@google.com are



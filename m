Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEBD134A9
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vAzueSAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10EEAC433C8;
	Fri, 29 Dec 2023 19:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879976;
	bh=LAgEmVYYh1DUBNjKgtWDwxz/meuJgISOrvGTIWtLwX8=;
	h=Date:To:From:Subject:From;
	b=vAzueSALBYzXo+D6XHHlW+PtrpHu6Z9tfSy/Mrot1PJnD9/Kd0desk3SNO6yrOpdE
	 md4rneBhrR68c3oTjElByyMQM+pY8lXmxUYsXqGrsaAsYzGoBGf3Va+wusiD07ehmj
	 BC7b3YWR733sEutpsmsDUHOmBCtTM3EYvMM4dR9s=
Date: Fri, 29 Dec 2023 11:59:35 -0800
To: mm-commits@vger.kernel.org,zhangpeng362@huawei.com,willy@infradead.org,viro@zeniv.linux.org.uk,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,ngeoffray@google.com,mhocko@suse.com,lokeshgidra@google.com,Liam.Howlett@oracle.com,kaleshsingh@google.com,jannh@google.com,hughd@google.com,david@redhat.com,brauner@kernel.org,bgeffon@google.com,axelrasmussen@google.com,aarcange@redhat.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-call-uffd_test_ctx_clear-at-the-end-of-the-test.patch removed from -mm tree
Message-Id: <20231229195936.10EEAC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: call uffd_test_ctx_clear at the end of the test
has been removed from the -mm tree.  Its filename was
     selftests-mm-call-uffd_test_ctx_clear-at-the-end-of-the-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: selftests/mm: call uffd_test_ctx_clear at the end of the test
Date: Wed, 6 Dec 2023 02:36:57 -0800

uffd_test_ctx_clear() is being called from uffd_test_ctx_init() to unmap
areas used in the previous test run.  This approach is problematic because
while unmapping areas uffd_test_ctx_clear() uses page_size and nr_pages
which might differ from one test run to another.  Fix this by calling
uffd_test_ctx_clear() after each test is done.

Link: https://lkml.kernel.org/r/20231206103702.3873743-4-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
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
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: ZhangPeng <zhangpeng362@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.c     |    4 +---
 tools/testing/selftests/mm/uffd-common.h     |    1 +
 tools/testing/selftests/mm/uffd-stress.c     |    5 ++++-
 tools/testing/selftests/mm/uffd-unit-tests.c |    1 +
 4 files changed, 7 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-call-uffd_test_ctx_clear-at-the-end-of-the-test
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -262,7 +262,7 @@ static inline void munmap_area(void **ar
 	*area = NULL;
 }
 
-static void uffd_test_ctx_clear(void)
+void uffd_test_ctx_clear(void)
 {
 	size_t i;
 
@@ -298,8 +298,6 @@ int uffd_test_ctx_init(uint64_t features
 	unsigned long nr, cpu;
 	int ret;
 
-	uffd_test_ctx_clear();
-
 	ret = uffd_test_ops->allocate_area((void **)&area_src, true);
 	ret |= uffd_test_ops->allocate_area((void **)&area_dst, false);
 	if (ret) {
--- a/tools/testing/selftests/mm/uffd-common.h~selftests-mm-call-uffd_test_ctx_clear-at-the-end-of-the-test
+++ a/tools/testing/selftests/mm/uffd-common.h
@@ -105,6 +105,7 @@ extern uffd_test_ops_t *uffd_test_ops;
 
 void uffd_stats_report(struct uffd_args *args, int n_cpus);
 int uffd_test_ctx_init(uint64_t features, const char **errmsg);
+void uffd_test_ctx_clear(void);
 int userfaultfd_open(uint64_t *features);
 int uffd_read_msg(int ufd, struct uffd_msg *msg);
 void wp_range(int ufd, __u64 start, __u64 len, bool wp);
--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-call-uffd_test_ctx_clear-at-the-end-of-the-test
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -323,8 +323,10 @@ static int userfaultfd_stress(void)
 		uffd_stats_reset(args, nr_cpus);
 
 		/* bounce pass */
-		if (stress(args))
+		if (stress(args)) {
+			uffd_test_ctx_clear();
 			return 1;
+		}
 
 		/* Clear all the write protections if there is any */
 		if (test_uffdio_wp)
@@ -354,6 +356,7 @@ static int userfaultfd_stress(void)
 
 		uffd_stats_report(args, nr_cpus);
 	}
+	uffd_test_ctx_clear();
 
 	return 0;
 }
--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-call-uffd_test_ctx_clear-at-the-end-of-the-test
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1319,6 +1319,7 @@ int main(int argc, char *argv[])
 				continue;
 			}
 			test->uffd_fn(&args);
+			uffd_test_ctx_clear();
 		}
 	}
 
_

Patches currently in -mm which might be from surenb@google.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E3C134A4
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zgewWg0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C04C433C8;
	Fri, 29 Dec 2023 19:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879978;
	bh=TutIsCwctVXMG8ZAAuNpdk9wcW0+p9/eAW+M200jpas=;
	h=Date:To:From:Subject:From;
	b=zgewWg0zzeExeK+TBT3AFYFDBQrNfdLwLgAGaFvZcgZtTm02AgPPWBKj+uHYapjU6
	 jU9102XRxDpPB5/hNi/o/AkmUeqKIcQNAxi5o9/LOaoAWx/C+G8R6u4xhCMnC+1XFn
	 oCgUQ1kH+uxKHa36y0A8kauAU0E8uAuTe9YjIgtQ=
Date: Fri, 29 Dec 2023 11:59:38 -0800
To: mm-commits@vger.kernel.org,zhangpeng362@huawei.com,willy@infradead.org,viro@zeniv.linux.org.uk,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,ngeoffray@google.com,mhocko@suse.com,lokeshgidra@google.com,Liam.Howlett@oracle.com,kaleshsingh@google.com,jannh@google.com,hughd@google.com,david@redhat.com,brauner@kernel.org,bgeffon@google.com,axelrasmussen@google.com,aarcange@redhat.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-uffdio_move-ioctl-test.patch removed from -mm tree
Message-Id: <20231229195938.D4C04C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add UFFDIO_MOVE ioctl test
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-uffdio_move-ioctl-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: selftests/mm: add UFFDIO_MOVE ioctl test
Date: Wed, 6 Dec 2023 02:36:59 -0800

Add tests for new UFFDIO_MOVE ioctl which uses uffd to move source into
destination buffer while checking the contents of both after the move. 
After the operation the content of the destination buffer should match the
original source buffer's content while the source buffer should be zeroed.
Separate tests are designed for PMD aligned and unaligned cases because
they utilize different code paths in the kernel.

Link: https://lkml.kernel.org/r/20231206103702.3873743-6-surenb@google.com
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

 tools/testing/selftests/mm/uffd-common.c     |   24 ++
 tools/testing/selftests/mm/uffd-common.h     |    1 
 tools/testing/selftests/mm/uffd-unit-tests.c |  189 +++++++++++++++++
 3 files changed, 214 insertions(+)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-add-uffdio_move-ioctl-test
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -631,6 +631,30 @@ int copy_page(int ufd, unsigned long off
 	return __copy_page(ufd, offset, false, wp);
 }
 
+int move_page(int ufd, unsigned long offset, unsigned long len)
+{
+	struct uffdio_move uffdio_move;
+
+	if (offset + len > nr_pages * page_size)
+		err("unexpected offset %lu and length %lu\n", offset, len);
+	uffdio_move.dst = (unsigned long) area_dst + offset;
+	uffdio_move.src = (unsigned long) area_src + offset;
+	uffdio_move.len = len;
+	uffdio_move.mode = UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES;
+	uffdio_move.move = 0;
+	if (ioctl(ufd, UFFDIO_MOVE, &uffdio_move)) {
+		/* real retval in uffdio_move.move */
+		if (uffdio_move.move != -EEXIST)
+			err("UFFDIO_MOVE error: %"PRId64,
+			    (int64_t)uffdio_move.move);
+		wake_range(ufd, uffdio_move.dst, len);
+	} else if (uffdio_move.move != len) {
+		err("UFFDIO_MOVE error: %"PRId64, (int64_t)uffdio_move.move);
+	} else
+		return 1;
+	return 0;
+}
+
 int uffd_open_dev(unsigned int flags)
 {
 	int fd, uffd;
--- a/tools/testing/selftests/mm/uffd-common.h~selftests-mm-add-uffdio_move-ioctl-test
+++ a/tools/testing/selftests/mm/uffd-common.h
@@ -119,6 +119,7 @@ void wp_range(int ufd, __u64 start, __u6
 void uffd_handle_page_fault(struct uffd_msg *msg, struct uffd_args *args);
 int __copy_page(int ufd, unsigned long offset, bool retry, bool wp);
 int copy_page(int ufd, unsigned long offset, bool wp);
+int move_page(int ufd, unsigned long offset, unsigned long len);
 void *uffd_poll_thread(void *arg);
 
 int uffd_open_dev(unsigned int flags);
--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-add-uffdio_move-ioctl-test
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -23,6 +23,9 @@
 #define  MEM_ALL  (MEM_ANON | MEM_SHMEM | MEM_SHMEM_PRIVATE | \
 		   MEM_HUGETLB | MEM_HUGETLB_PRIVATE)
 
+#define ALIGN_UP(x, align_to) \
+	((__typeof__(x))((((unsigned long)(x)) + ((align_to)-1)) & ~((align_to)-1)))
+
 struct mem_type {
 	const char *name;
 	unsigned int mem_flag;
@@ -1064,6 +1067,178 @@ static void uffd_poison_test(uffd_test_a
 	uffd_test_pass();
 }
 
+static void
+uffd_move_handle_fault_common(struct uffd_msg *msg, struct uffd_args *args,
+			      unsigned long len)
+{
+	unsigned long offset;
+
+	if (msg->event != UFFD_EVENT_PAGEFAULT)
+		err("unexpected msg event %u", msg->event);
+
+	if (msg->arg.pagefault.flags &
+	    (UFFD_PAGEFAULT_FLAG_WP | UFFD_PAGEFAULT_FLAG_MINOR | UFFD_PAGEFAULT_FLAG_WRITE))
+		err("unexpected fault type %llu", msg->arg.pagefault.flags);
+
+	offset = (char *)(unsigned long)msg->arg.pagefault.address - area_dst;
+	offset &= ~(len-1);
+
+	if (move_page(uffd, offset, len))
+		args->missing_faults++;
+}
+
+static void uffd_move_handle_fault(struct uffd_msg *msg,
+				   struct uffd_args *args)
+{
+	uffd_move_handle_fault_common(msg, args, page_size);
+}
+
+static void uffd_move_pmd_handle_fault(struct uffd_msg *msg,
+				       struct uffd_args *args)
+{
+	uffd_move_handle_fault_common(msg, args, read_pmd_pagesize());
+}
+
+static void
+uffd_move_test_common(uffd_test_args_t *targs, unsigned long chunk_size,
+		      void (*handle_fault)(struct uffd_msg *msg, struct uffd_args *args))
+{
+	unsigned long nr;
+	pthread_t uffd_mon;
+	char c;
+	unsigned long long count;
+	struct uffd_args args = { 0 };
+	char *orig_area_src, *orig_area_dst;
+	unsigned long step_size, step_count;
+	unsigned long src_offs = 0;
+	unsigned long dst_offs = 0;
+
+	/* Prevent source pages from being mapped more than once */
+	if (madvise(area_src, nr_pages * page_size, MADV_DONTFORK))
+		err("madvise(MADV_DONTFORK) failure");
+
+	if (uffd_register(uffd, area_dst, nr_pages * page_size,
+			  true, false, false))
+		err("register failure");
+
+	args.handle_fault = handle_fault;
+	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
+		err("uffd_poll_thread create");
+
+	step_size = chunk_size / page_size;
+	step_count = nr_pages / step_size;
+
+	if (chunk_size > page_size) {
+		char *aligned_src = ALIGN_UP(area_src, chunk_size);
+		char *aligned_dst = ALIGN_UP(area_dst, chunk_size);
+
+		if (aligned_src != area_src || aligned_dst != area_dst) {
+			src_offs = (aligned_src - area_src) / page_size;
+			dst_offs = (aligned_dst - area_dst) / page_size;
+			step_count--;
+		}
+		orig_area_src = area_src;
+		orig_area_dst = area_dst;
+		area_src = aligned_src;
+		area_dst = aligned_dst;
+	}
+
+	/*
+	 * Read each of the pages back using the UFFD-registered mapping. We
+	 * expect that the first time we touch a page, it will result in a missing
+	 * fault. uffd_poll_thread will resolve the fault by moving source
+	 * page to destination.
+	 */
+	for (nr = 0; nr < step_count * step_size; nr += step_size) {
+		unsigned long i;
+
+		/* Check area_src content */
+		for (i = 0; i < step_size; i++) {
+			count = *area_count(area_src, nr + i);
+			if (count != count_verify[src_offs + nr + i])
+				err("nr %lu source memory invalid %llu %llu\n",
+				    nr + i, count, count_verify[src_offs + nr + i]);
+		}
+
+		/* Faulting into area_dst should move the page or the huge page */
+		for (i = 0; i < step_size; i++) {
+			count = *area_count(area_dst, nr + i);
+			if (count != count_verify[dst_offs + nr + i])
+				err("nr %lu memory corruption %llu %llu\n",
+				    nr, count, count_verify[dst_offs + nr + i]);
+		}
+
+		/* Re-check area_src content which should be empty */
+		for (i = 0; i < step_size; i++) {
+			count = *area_count(area_src, nr + i);
+			if (count != 0)
+				err("nr %lu move failed %llu %llu\n",
+				    nr, count, count_verify[src_offs + nr + i]);
+		}
+	}
+	if (step_size > page_size) {
+		area_src = orig_area_src;
+		area_dst = orig_area_dst;
+	}
+
+	if (write(pipefd[1], &c, sizeof(c)) != sizeof(c))
+		err("pipe write");
+	if (pthread_join(uffd_mon, NULL))
+		err("join() failed");
+
+	if (args.missing_faults != step_count || args.minor_faults != 0)
+		uffd_test_fail("stats check error");
+	else
+		uffd_test_pass();
+}
+
+static void uffd_move_test(uffd_test_args_t *targs)
+{
+	uffd_move_test_common(targs, page_size, uffd_move_handle_fault);
+}
+
+static void uffd_move_pmd_test(uffd_test_args_t *targs)
+{
+	uffd_move_test_common(targs, read_pmd_pagesize(),
+			      uffd_move_pmd_handle_fault);
+}
+
+static int prevent_hugepages(const char **errmsg)
+{
+	/* This should be done before source area is populated */
+	if (madvise(area_src, nr_pages * page_size, MADV_NOHUGEPAGE)) {
+		/* Ignore only if CONFIG_TRANSPARENT_HUGEPAGE=n */
+		if (errno != EINVAL) {
+			if (errmsg)
+				*errmsg = "madvise(MADV_NOHUGEPAGE) failed";
+			return -errno;
+		}
+	}
+	return 0;
+}
+
+static int request_hugepages(const char **errmsg)
+{
+	/* This should be done before source area is populated */
+	if (madvise(area_src, nr_pages * page_size, MADV_HUGEPAGE)) {
+		if (errmsg) {
+			*errmsg = (errno == EINVAL) ?
+				"CONFIG_TRANSPARENT_HUGEPAGE is not set" :
+				"madvise(MADV_HUGEPAGE) failed";
+		}
+		return -errno;
+	}
+	return 0;
+}
+
+struct uffd_test_case_ops uffd_move_test_case_ops = {
+	.post_alloc = prevent_hugepages,
+};
+
+struct uffd_test_case_ops uffd_move_test_pmd_case_ops = {
+	.post_alloc = request_hugepages,
+};
+
 /*
  * Test the returned uffdio_register.ioctls with different register modes.
  * Note that _UFFDIO_ZEROPAGE is tested separately in the zeropage test.
@@ -1142,6 +1317,20 @@ uffd_test_case_t uffd_tests[] = {
 		.uffd_feature_required = 0,
 	},
 	{
+		.name = "move",
+		.uffd_fn = uffd_move_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required = UFFD_FEATURE_MOVE,
+		.test_case_ops = &uffd_move_test_case_ops,
+	},
+	{
+		.name = "move-pmd",
+		.uffd_fn = uffd_move_pmd_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required = UFFD_FEATURE_MOVE,
+		.test_case_ops = &uffd_move_test_pmd_case_ops,
+	},
+	{
 		.name = "wp-fork",
 		.uffd_fn = uffd_wp_fork_test,
 		.mem_targets = MEM_ALL,
_

Patches currently in -mm which might be from surenb@google.com are



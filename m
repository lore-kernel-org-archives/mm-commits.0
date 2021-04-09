Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB798C43460
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 05:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5E1F61178
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 05:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbhDIFHm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 01:07:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233256AbhDIFHU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 01:07:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74A7761181;
        Fri,  9 Apr 2021 05:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617944826;
        bh=r10Pnz4BCS9jwTINGnNS7dYOQj5mihLtJdiyp2nccXc=;
        h=Date:From:To:Subject:From;
        b=Jk0SxfqKRrEQlbuz+q6zZ2wR1GPLmxBNGQRtR5dOKVCrJ0C60q91Zcb82vUxz1stx
         KKCV3oU5NQ1qYEfBO56vU09lH3mPCe1tjoVPblkURziEIM851kCp/eTVyZWFz3IQT2
         iqAr+myvFF6YvoB1iVAXp7ZsIfSRFdN9yPq62nOA=
Date:   Thu, 08 Apr 2021 22:07:06 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, axelrasmussen@google.com,
        mm-commits@vger.kernel.org, nadav.amit@gmail.com, peterx@redhat.com
Subject:  [to-be-updated]
 userfaultfd-selftests-unify-error-handling.patch removed from -mm tree
Message-ID: <20210409050706.zDfrQWTpb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: unify error handling
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftests-unify-error-handling.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: userfaultfd/selftests: unify error handling

Introduce err()/_err() and replace all the different ways to fail the
program, mostly "fprintf" and "perror" with tons of exit() calls.  Always
stop the test program at any failure.

Link: https://lkml.kernel.org/r/20210310004511.51996-6-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |  655 ++++++---------------
 1 file changed, 216 insertions(+), 439 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-unify-error-handling
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -142,11 +142,18 @@ static void usage(void)
 	exit(1);
 }
 
-#define uffd_error(code, fmt, ...)                                             \
-	do {                                                                   \
-		fprintf(stderr, fmt, ##__VA_ARGS__);                           \
-		fprintf(stderr, ": %" PRId64 "\n", (int64_t)(code));           \
-		exit(1);                                                       \
+#define _err(fmt, ...)						\
+	do {							\
+		int ret = errno;				\
+		fprintf(stderr, "ERROR: " fmt, ##__VA_ARGS__);	\
+		fprintf(stderr, " (errno=%d, line=%d)\n",	\
+			ret, __LINE__);				\
+	} while (0)
+
+#define err(fmt, ...)				\
+	do {					\
+		_err(fmt, ##__VA_ARGS__);	\
+		exit(1);			\
 	} while (0)
 
 static void uffd_stats_reset(struct uffd_stats *uffd_stats,
@@ -195,44 +202,28 @@ static void uffd_stats_report(struct uff
 	printf("\n");
 }
 
-static int anon_release_pages(char *rel_area)
+static void anon_release_pages(char *rel_area)
 {
-	int ret = 0;
-
-	if (madvise(rel_area, nr_pages * page_size, MADV_DONTNEED)) {
-		perror("madvise");
-		ret = 1;
-	}
-
-	return ret;
+	if (madvise(rel_area, nr_pages * page_size, MADV_DONTNEED))
+		err("madvise(MADV_DONTNEED) failed");
 }
 
 static void anon_allocate_area(void **alloc_area)
 {
-	if (posix_memalign(alloc_area, page_size, nr_pages * page_size)) {
-		fprintf(stderr, "out of memory\n");
-		*alloc_area = NULL;
-	}
+	if (posix_memalign(alloc_area, page_size, nr_pages * page_size))
+		err("posix_memalign() failed");
 }
 
 static void noop_alias_mapping(__u64 *start, size_t len, unsigned long offset)
 {
 }
 
-/* HugeTLB memory */
-static int hugetlb_release_pages(char *rel_area)
+static void hugetlb_release_pages(char *rel_area)
 {
-	int ret = 0;
-
 	if (fallocate(huge_fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
-				rel_area == huge_fd_off0 ? 0 :
-				nr_pages * page_size,
-				nr_pages * page_size)) {
-		perror("fallocate");
-		ret = 1;
-	}
-
-	return ret;
+		      rel_area == huge_fd_off0 ? 0 : nr_pages * page_size,
+		      nr_pages * page_size))
+		err("fallocate() failed");
 }
 
 static void hugetlb_allocate_area(void **alloc_area)
@@ -245,20 +236,16 @@ static void hugetlb_allocate_area(void *
 			   MAP_HUGETLB,
 			   huge_fd, *alloc_area == area_src ? 0 :
 			   nr_pages * page_size);
-	if (*alloc_area == MAP_FAILED) {
-		perror("mmap of hugetlbfs file failed");
-		goto fail;
-	}
+	if (*alloc_area == MAP_FAILED)
+		err("mmap of hugetlbfs file failed");
 
 	if (map_shared) {
 		area_alias = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
 				  MAP_SHARED | MAP_HUGETLB,
 				  huge_fd, *alloc_area == area_src ? 0 :
 				  nr_pages * page_size);
-		if (area_alias == MAP_FAILED) {
-			perror("mmap of hugetlb file alias failed");
-			goto fail_munmap;
-		}
+		if (area_alias == MAP_FAILED)
+			err("mmap of hugetlb file alias failed");
 	}
 
 	if (*alloc_area == area_src) {
@@ -267,18 +254,9 @@ static void hugetlb_allocate_area(void *
 	} else {
 		alloc_area_alias = &area_dst_alias;
 	}
+
 	if (area_alias)
 		*alloc_area_alias = area_alias;
-
-	return;
-
-fail_munmap:
-	if (munmap(*alloc_area, nr_pages * page_size) < 0) {
-		perror("hugetlb munmap");
-		exit(1);
-	}
-fail:
-	*alloc_area = NULL;
 }
 
 static void hugetlb_alias_mapping(__u64 *start, size_t len, unsigned long offset)
@@ -294,17 +272,10 @@ static void hugetlb_alias_mapping(__u64
 	*start = (unsigned long) area_dst_alias + offset;
 }
 
-/* Shared memory */
-static int shmem_release_pages(char *rel_area)
+static void shmem_release_pages(char *rel_area)
 {
-	int ret = 0;
-
-	if (madvise(rel_area, nr_pages * page_size, MADV_REMOVE)) {
-		perror("madvise");
-		ret = 1;
-	}
-
-	return ret;
+	if (madvise(rel_area, nr_pages * page_size, MADV_REMOVE))
+		err("madvise(MADV_REMOVE) failed");
 }
 
 static void shmem_allocate_area(void **alloc_area)
@@ -315,32 +286,18 @@ static void shmem_allocate_area(void **a
 
 	*alloc_area = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
 			   MAP_SHARED, shm_fd, offset);
-	if (*alloc_area == MAP_FAILED) {
-		perror("mmap of memfd failed");
-		goto fail;
-	}
+	if (*alloc_area == MAP_FAILED)
+		err("mmap of memfd failed");
 
 	area_alias = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
 			  MAP_SHARED, shm_fd, offset);
-	if (area_alias == MAP_FAILED) {
-		perror("mmap of memfd alias failed");
-		goto fail_munmap;
-	}
+	if (area_alias == MAP_FAILED)
+		err("mmap of memfd alias failed");
 
 	if (is_src)
 		area_src_alias = area_alias;
 	else
 		area_dst_alias = area_alias;
-
-	return;
-
-fail_munmap:
-	if (munmap(*alloc_area, nr_pages * page_size) < 0) {
-		perror("munmap of memfd failed\n");
-		exit(1);
-	}
-fail:
-	*alloc_area = NULL;
 }
 
 static void shmem_alias_mapping(__u64 *start, size_t len, unsigned long offset)
@@ -351,7 +308,7 @@ static void shmem_alias_mapping(__u64 *s
 struct uffd_test_ops {
 	unsigned long expected_ioctls;
 	void (*allocate_area)(void **alloc_area);
-	int (*release_pages)(char *rel_area);
+	void (*release_pages)(char *rel_area);
 	void (*alias_mapping)(__u64 *start, size_t len, unsigned long offset);
 };
 
@@ -392,25 +349,17 @@ static int userfaultfd_open(uint64_t *fe
 	struct uffdio_api uffdio_api;
 
 	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK | UFFD_USER_MODE_ONLY);
-	if (uffd < 0) {
-		fprintf(stderr,
-			"userfaultfd syscall not available in this kernel\n");
-		return 1;
-	}
+	if (uffd < 0)
+		err("userfaultfd syscall not available in this kernel");
 	uffd_flags = fcntl(uffd, F_GETFD, NULL);
 
 	uffdio_api.api = UFFD_API;
 	uffdio_api.features = *features;
-	if (ioctl(uffd, UFFDIO_API, &uffdio_api)) {
-		fprintf(stderr, "UFFDIO_API failed.\nPlease make sure to "
-			"run with either root or ptrace capability.\n");
-		return 1;
-	}
-	if (uffdio_api.api != UFFD_API) {
-		fprintf(stderr, "UFFDIO_API error: %" PRIu64 "\n",
-			(uint64_t)uffdio_api.api);
-		return 1;
-	}
+	if (ioctl(uffd, UFFDIO_API, &uffdio_api))
+		err("UFFDIO_API failed.\nPlease make sure to "
+		    "run with either root or ptrace capability.");
+	if (uffdio_api.api != UFFD_API)
+		err("UFFDIO_API error: %" PRIu64, (uint64_t)uffdio_api.api);
 
 	*features = uffdio_api.features;
 	return 0;
@@ -427,20 +376,15 @@ static int uffd_test_ctx_init_ext(uint64
 	if (!area_dst)
 		return 1;
 
-	if (uffd_test_ops->release_pages(area_src))
-		return 1;
-
-	if (uffd_test_ops->release_pages(area_dst))
-		return 1;
+	uffd_test_ops->release_pages(area_src);
+	uffd_test_ops->release_pages(area_dst);
 
 	if (userfaultfd_open(features))
 		return 1;
 
 	count_verify = malloc(nr_pages * sizeof(unsigned long long));
-	if (!count_verify) {
-		perror("count_verify");
-		return 1;
-	}
+	if (!count_verify)
+		err("count_verify");
 
 	for (nr = 0; nr < nr_pages; nr++) {
 		*area_mutex(area_src, nr) =
@@ -457,16 +401,11 @@ static int uffd_test_ctx_init_ext(uint64
 	}
 
 	pipefd = malloc(sizeof(int) * nr_cpus * 2);
-	if (!pipefd) {
-		perror("pipefd");
-		return 1;
-	}
-	for (cpu = 0; cpu < nr_cpus; cpu++) {
-		if (pipe2(&pipefd[cpu * 2], O_CLOEXEC | O_NONBLOCK)) {
-			perror("pipe");
-			return 1;
-		}
-	}
+	if (!pipefd)
+		err("pipefd");
+	for (cpu = 0; cpu < nr_cpus; cpu++)
+		if (pipe2(&pipefd[cpu * 2], O_CLOEXEC | O_NONBLOCK))
+			err("pipe");
 
 	return 0;
 }
@@ -478,12 +417,9 @@ static inline int uffd_test_ctx_init(uin
 
 static inline int munmap_area(void **area)
 {
-	if (*area) {
-		if (munmap(*area, nr_pages * page_size)) {
-			perror("munmap");
-			return 1;
-		}
-	}
+	if (*area)
+		if (munmap(*area, nr_pages * page_size))
+			err("munmap");
 
 	*area = NULL;
 	return 0;
@@ -496,10 +432,8 @@ static int uffd_test_ctx_clear(void)
 
 	if (pipefd) {
 		for (i = 0; i < nr_cpus * 2; ++i) {
-			if (close(pipefd[i])) {
-				perror("close pipefd");
-				ret = 1;
-			}
+			if (close(pipefd[i]))
+				err("close pipefd");
 		}
 		free(pipefd);
 		pipefd = NULL;
@@ -511,10 +445,8 @@ static int uffd_test_ctx_clear(void)
 	}
 
 	if (uffd != -1) {
-		if (close(uffd)) {
-			perror("close uffd");
-			ret = 1;
-		}
+		if (close(uffd))
+			err("close uffd");
 		uffd = -1;
 	}
 
@@ -546,11 +478,8 @@ static void wp_range(int ufd, __u64 star
 	/* Undo write-protect, do wakeup after that */
 	prms.mode = wp ? UFFDIO_WRITEPROTECT_MODE_WP : 0;
 
-	if (ioctl(ufd, UFFDIO_WRITEPROTECT, &prms)) {
-		fprintf(stderr, "clear WP failed for address 0x%" PRIx64 "\n",
-			(uint64_t)start);
-		exit(1);
-	}
+	if (ioctl(ufd, UFFDIO_WRITEPROTECT, &prms))
+		err("clear WP failed: address=0x%"PRIx64, (uint64_t)start);
 
 	/*
 	 * Error handling within the kernel for continue is subtly different
@@ -559,10 +488,8 @@ static void wp_range(int ufd, __u64 star
 	 */
 	req.mapped = 0;
 	ret = ioctl(ufd, UFFDIO_CONTINUE, &req);
-	if (ret >= 0 || req.mapped != -EEXIST) {
-		fprintf(stderr, "failed to exercise UFFDIO_CONTINUE error handling, ret=%d, mapped=%" PRId64, ret, req.mapped);
-		exit(1);
-	}
+	if (ret >= 0 || req.mapped != -EEXIST)
+		err("failed to exercise UFFDIO_CONTINUE error handling, ret=%d, mapped=%" PRId64, ret, req.mapped);
 }
 
 static void continue_range(int ufd, __u64 start, __u64 len)
@@ -574,12 +501,9 @@ static void continue_range(int ufd, __u6
 	req.range.len = len;
 	req.mode = 0;
 
-	if (ioctl(ufd, UFFDIO_CONTINUE, &req)) {
-		fprintf(stderr,
-			"UFFDIO_CONTINUE failed for address 0x%" PRIx64 "\n",
-			(uint64_t)start);
-		exit(1);
-	}
+	if (ioctl(ufd, UFFDIO_CONTINUE, &req))
+		err("UFFDIO_CONTINUE failed for address 0x%" PRIx64,
+		    (uint64_t)start);
 }
 
 static void *locking_thread(void *arg)
@@ -598,10 +522,8 @@ static void *locking_thread(void *arg)
 			seed += cpu;
 		bzero(&rand, sizeof(rand));
 		bzero(&randstate, sizeof(randstate));
-		if (initstate_r(seed, randstate, sizeof(randstate), &rand)) {
-			fprintf(stderr, "srandom_r error\n");
-			exit(1);
-		}
+		if (initstate_r(seed, randstate, sizeof(randstate), &rand))
+			err("initstate_r failed");
 	} else {
 		page_nr = -bounces;
 		if (!(bounces & BOUNCE_RACINGFAULTS))
@@ -610,16 +532,12 @@ static void *locking_thread(void *arg)
 
 	while (!finished) {
 		if (bounces & BOUNCE_RANDOM) {
-			if (random_r(&rand, &rand_nr)) {
-				fprintf(stderr, "random_r 1 error\n");
-				exit(1);
-			}
+			if (random_r(&rand, &rand_nr))
+				err("random_r failed");
 			page_nr = rand_nr;
 			if (sizeof(page_nr) > sizeof(rand_nr)) {
-				if (random_r(&rand, &rand_nr)) {
-					fprintf(stderr, "random_r 2 error\n");
-					exit(1);
-				}
+				if (random_r(&rand, &rand_nr))
+					err("random_r failed");
 				page_nr |= (((unsigned long) rand_nr) << 16) <<
 					   16;
 			}
@@ -628,12 +546,9 @@ static void *locking_thread(void *arg)
 		page_nr %= nr_pages;
 		pthread_mutex_lock(area_mutex(area_dst, page_nr));
 		count = *area_count(area_dst, page_nr);
-		if (count != count_verify[page_nr]) {
-			fprintf(stderr,
-				"page_nr %lu memory corruption %Lu %Lu\n",
-				page_nr, count,
-				count_verify[page_nr]); exit(1);
-		}
+		if (count != count_verify[page_nr])
+			err("page_nr %lu memory corruption %llu %llu",
+			    page_nr, count, count_verify[page_nr]);
 		count++;
 		*area_count(area_dst, page_nr) = count_verify[page_nr] = count;
 		pthread_mutex_unlock(area_mutex(area_dst, page_nr));
@@ -650,22 +565,21 @@ static void retry_copy_page(int ufd, str
 				     offset);
 	if (ioctl(ufd, UFFDIO_COPY, uffdio_copy)) {
 		/* real retval in ufdio_copy.copy */
-		if (uffdio_copy->copy != -EEXIST) {
-			uffd_error(uffdio_copy->copy,
-				   "UFFDIO_COPY retry error");
-		}
-	} else
-		uffd_error(uffdio_copy->copy, "UFFDIO_COPY retry unexpected");
+		if (uffdio_copy->copy != -EEXIST)
+			err("UFFDIO_COPY retry error: %"PRId64,
+			    (int64_t)uffdio_copy->copy);
+	} else {
+		err("UFFDIO_COPY retry unexpected: %"PRId64,
+		    (int64_t)uffdio_copy->copy);
+	}
 }
 
 static int __copy_page(int ufd, unsigned long offset, bool retry)
 {
 	struct uffdio_copy uffdio_copy;
 
-	if (offset >= nr_pages * page_size) {
-		fprintf(stderr, "unexpected offset %lu\n", offset);
-		exit(1);
-	}
+	if (offset >= nr_pages * page_size)
+		err("unexpected offset %lu\n", offset);
 	uffdio_copy.dst = (unsigned long) area_dst + offset;
 	uffdio_copy.src = (unsigned long) area_src + offset;
 	uffdio_copy.len = page_size;
@@ -677,9 +591,10 @@ static int __copy_page(int ufd, unsigned
 	if (ioctl(ufd, UFFDIO_COPY, &uffdio_copy)) {
 		/* real retval in ufdio_copy.copy */
 		if (uffdio_copy.copy != -EEXIST)
-			uffd_error(uffdio_copy.copy, "UFFDIO_COPY error");
+			err("UFFDIO_COPY error: %"PRId64,
+			    (int64_t)uffdio_copy.copy);
 	} else if (uffdio_copy.copy != page_size) {
-		uffd_error(uffdio_copy.copy, "UFFDIO_COPY unexpected copy");
+		err("UFFDIO_COPY error: %"PRId64, (int64_t)uffdio_copy.copy);
 	} else {
 		if (test_uffdio_copy_eexist && retry) {
 			test_uffdio_copy_eexist = false;
@@ -708,11 +623,10 @@ static int uffd_read_msg(int ufd, struct
 		if (ret < 0) {
 			if (errno == EAGAIN)
 				return 1;
-			perror("blocking read error");
+			err("blocking read error");
 		} else {
-			fprintf(stderr, "short read\n");
+			err("short read");
 		}
-		exit(1);
 	}
 
 	return 0;
@@ -723,10 +637,8 @@ static void uffd_handle_page_fault(struc
 {
 	unsigned long offset;
 
-	if (msg->event != UFFD_EVENT_PAGEFAULT) {
-		fprintf(stderr, "unexpected msg event %u\n", msg->event);
-		exit(1);
-	}
+	if (msg->event != UFFD_EVENT_PAGEFAULT)
+		err("unexpected msg event %u", msg->event);
 
 	if (msg->arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_WP) {
 		/* Write protect page faults */
@@ -757,10 +669,8 @@ static void uffd_handle_page_fault(struc
 		stats->minor_faults++;
 	} else {
 		/* Missing page faults */
-		if (msg->arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_WRITE) {
-			fprintf(stderr, "unexpected write fault\n");
-			exit(1);
-		}
+		if (msg->arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_WRITE)
+			err("unexpected write fault");
 
 		offset = (char *)(unsigned long)msg->arg.pagefault.address - area_dst;
 		offset &= ~(page_size-1);
@@ -787,32 +697,20 @@ static void *uffd_poll_thread(void *arg)
 
 	for (;;) {
 		ret = poll(pollfd, 2, -1);
-		if (!ret) {
-			fprintf(stderr, "poll error %d\n", ret);
-			exit(1);
-		}
-		if (ret < 0) {
-			perror("poll");
-			exit(1);
-		}
+		if (ret <= 0)
+			err("poll error: %d", ret);
 		if (pollfd[1].revents & POLLIN) {
-			if (read(pollfd[1].fd, &tmp_chr, 1) != 1) {
-				fprintf(stderr, "read pipefd error\n");
-				exit(1);
-			}
+			if (read(pollfd[1].fd, &tmp_chr, 1) != 1)
+				err("read pipefd error");
 			break;
 		}
-		if (!(pollfd[0].revents & POLLIN)) {
-			fprintf(stderr, "pollfd[0].revents %d\n",
-				pollfd[0].revents);
-			exit(1);
-		}
+		if (!(pollfd[0].revents & POLLIN))
+			err("pollfd[0].revents %d", pollfd[0].revents);
 		if (uffd_read_msg(uffd, &msg))
 			continue;
 		switch (msg.event) {
 		default:
-			fprintf(stderr, "unexpected msg event %u\n",
-				msg.event); exit(1);
+			err("unexpected msg event %u\n", msg.event);
 			break;
 		case UFFD_EVENT_PAGEFAULT:
 			uffd_handle_page_fault(&msg, stats);
@@ -826,10 +724,8 @@ static void *uffd_poll_thread(void *arg)
 			uffd_reg.range.start = msg.arg.remove.start;
 			uffd_reg.range.len = msg.arg.remove.end -
 				msg.arg.remove.start;
-			if (ioctl(uffd, UFFDIO_UNREGISTER, &uffd_reg.range)) {
-				fprintf(stderr, "remove failure\n");
-				exit(1);
-			}
+			if (ioctl(uffd, UFFDIO_UNREGISTER, &uffd_reg.range))
+				err("remove failure");
 			break;
 		case UFFD_EVENT_REMAP:
 			area_dst = (char *)(unsigned long)msg.arg.remap.to;
@@ -932,9 +828,7 @@ static int stress(struct uffd_stats *uff
 	 * UFFDIO_COPY without writing zero pages into area_dst
 	 * because the background threads already completed).
 	 */
-	if (uffd_test_ops->release_pages(area_src))
-		return 1;
-
+	uffd_test_ops->release_pages(area_src);
 
 	finished = 1;
 	for (cpu = 0; cpu < nr_cpus; cpu++)
@@ -944,10 +838,8 @@ static int stress(struct uffd_stats *uff
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		char c;
 		if (bounces & BOUNCE_POLL) {
-			if (write(pipefd[cpu*2+1], &c, 1) != 1) {
-				fprintf(stderr, "pipefd write error\n");
-				return 1;
-			}
+			if (write(pipefd[cpu*2+1], &c, 1) != 1)
+				err("pipefd write error");
 			if (pthread_join(uffd_threads[cpu],
 					 (void *)&uffd_stats[cpu]))
 				return 1;
@@ -1013,10 +905,8 @@ static int faulting_process(int signal_t
 		memset(&act, 0, sizeof(act));
 		act.sa_sigaction = sighndl;
 		act.sa_flags = SA_SIGINFO;
-		if (sigaction(SIGBUS, &act, 0)) {
-			perror("sigaction");
-			return 1;
-		}
+		if (sigaction(SIGBUS, &act, 0))
+			err("sigaction");
 		lastnr = (unsigned long)-1;
 	}
 
@@ -1026,10 +916,8 @@ static int faulting_process(int signal_t
 
 		if (signal_test) {
 			if (sigsetjmp(*sigbuf, 1) != 0) {
-				if (steps == 1 && nr == lastnr) {
-					fprintf(stderr, "Signal repeated\n");
-					return 1;
-				}
+				if (steps == 1 && nr == lastnr)
+					err("Signal repeated");
 
 				lastnr = nr;
 				if (signal_test == 1) {
@@ -1054,12 +942,9 @@ static int faulting_process(int signal_t
 		}
 
 		count = *area_count(area_dst, nr);
-		if (count != count_verify[nr]) {
-			fprintf(stderr,
-				"nr %lu memory corruption %Lu %Lu\n",
-				nr, count,
-				count_verify[nr]);
-	        }
+		if (count != count_verify[nr])
+			err("nr %lu memory corruption %llu %llu\n",
+			    nr, count, count_verify[nr]);
 		/*
 		 * Trigger write protection if there is by writing
 		 * the same value back.
@@ -1075,20 +960,16 @@ static int faulting_process(int signal_t
 
 	area_dst = mremap(area_dst, nr_pages * page_size,  nr_pages * page_size,
 			  MREMAP_MAYMOVE | MREMAP_FIXED, area_src);
-	if (area_dst == MAP_FAILED) {
-		perror("mremap");
-		exit(1);
-	}
+	if (area_dst == MAP_FAILED)
+		err("mremap");
 	/* Reset area_src since we just clobbered it */
 	area_src = NULL;
 
 	for (; nr < nr_pages; nr++) {
 		count = *area_count(area_dst, nr);
 		if (count != count_verify[nr]) {
-			fprintf(stderr,
-				"nr %lu memory corruption %Lu %Lu\n",
-				nr, count,
-				count_verify[nr]); exit(1);
+			err("nr %lu memory corruption %llu %llu\n",
+			    nr, count, count_verify[nr]);
 		}
 		/*
 		 * Trigger write protection if there is by writing
@@ -1097,15 +978,11 @@ static int faulting_process(int signal_t
 		*area_count(area_dst, nr) = count;
 	}
 
-	if (uffd_test_ops->release_pages(area_dst))
-		return 1;
+	uffd_test_ops->release_pages(area_dst);
 
-	for (nr = 0; nr < nr_pages; nr++) {
-		if (my_bcmp(area_dst + nr * page_size, zeropage, page_size)) {
-			fprintf(stderr, "nr %lu is not zero\n", nr);
-			exit(1);
-		}
-	}
+	for (nr = 0; nr < nr_pages; nr++)
+		if (my_bcmp(area_dst + nr * page_size, zeropage, page_size))
+			err("nr %lu is not zero", nr);
 
 	return 0;
 }
@@ -1118,13 +995,12 @@ static void retry_uffdio_zeropage(int uf
 				     uffdio_zeropage->range.len,
 				     offset);
 	if (ioctl(ufd, UFFDIO_ZEROPAGE, uffdio_zeropage)) {
-		if (uffdio_zeropage->zeropage != -EEXIST) {
-			uffd_error(uffdio_zeropage->zeropage,
-				   "UFFDIO_ZEROPAGE retry error");
-		}
+		if (uffdio_zeropage->zeropage != -EEXIST)
+			err("UFFDIO_ZEROPAGE error: %"PRId64,
+			    (int64_t)uffdio_zeropage->zeropage);
 	} else {
-		uffd_error(uffdio_zeropage->zeropage,
-			   "UFFDIO_ZEROPAGE retry unexpected");
+		err("UFFDIO_ZEROPAGE error: %"PRId64,
+		    (int64_t)uffdio_zeropage->zeropage);
 	}
 }
 
@@ -1137,10 +1013,8 @@ static int __uffdio_zeropage(int ufd, un
 
 	has_zeropage = uffd_test_ops->expected_ioctls & (1 << _UFFDIO_ZEROPAGE);
 
-	if (offset >= nr_pages * page_size) {
-		fprintf(stderr, "unexpected offset %lu\n", offset);
-		exit(1);
-	}
+	if (offset >= nr_pages * page_size)
+		err("unexpected offset %lu", offset);
 	uffdio_zeropage.range.start = (unsigned long) area_dst + offset;
 	uffdio_zeropage.range.len = page_size;
 	uffdio_zeropage.mode = 0;
@@ -1148,14 +1022,13 @@ static int __uffdio_zeropage(int ufd, un
 	res = uffdio_zeropage.zeropage;
 	if (ret) {
 		/* real retval in ufdio_zeropage.zeropage */
-		if (has_zeropage) {
-			uffd_error(res, "UFFDIO_ZEROPAGE %s",
-				   res == -EEXIST ? "-EEXIST" : "error");
-		} else if (res != -EINVAL)
-			uffd_error(res, "UFFDIO_ZEROPAGE not -EINVAL");
+		if (has_zeropage)
+			err("UFFDIO_ZEROPAGE error: %"PRId64, (int64_t)res);
+		else if (res != -EINVAL)
+			err("UFFDIO_ZEROPAGE not -EINVAL");
 	} else if (has_zeropage) {
 		if (res != page_size) {
-			uffd_error(res, "UFFDIO_ZEROPAGE unexpected");
+			err("UFFDIO_ZEROPAGE unexpected size");
 		} else {
 			if (test_uffdio_zeropage_eexist && retry) {
 				test_uffdio_zeropage_eexist = false;
@@ -1165,7 +1038,7 @@ static int __uffdio_zeropage(int ufd, un
 			return 1;
 		}
 	} else
-		uffd_error(res, "UFFDIO_ZEROPAGE succeeded");
+		err("UFFDIO_ZEROPAGE succeeded");
 
 	return 0;
 }
@@ -1192,25 +1065,16 @@ static int userfaultfd_zeropage_test(voi
 	uffdio_register.mode = UFFDIO_REGISTER_MODE_MISSING;
 	if (test_uffdio_wp)
 		uffdio_register.mode |= UFFDIO_REGISTER_MODE_WP;
-	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register)) {
-		fprintf(stderr, "register failure\n");
-		exit(1);
-	}
+	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
+		err("register failure");
 
 	expected_ioctls = uffd_test_ops->expected_ioctls;
-	if ((uffdio_register.ioctls & expected_ioctls) !=
-	    expected_ioctls) {
-		fprintf(stderr,
-			"unexpected missing ioctl for anon memory\n");
-		exit(1);
-	}
+	if ((uffdio_register.ioctls & expected_ioctls) != expected_ioctls)
+		err("unexpected missing ioctl for anon memory");
 
-	if (uffdio_zeropage(uffd, 0)) {
-		if (my_bcmp(area_dst, zeropage, page_size)) {
-			fprintf(stderr, "zeropage is not zero\n");
-			exit(1);
-		}
-	}
+	if (uffdio_zeropage(uffd, 0))
+		if (my_bcmp(area_dst, zeropage, page_size))
+			err("zeropage is not zero");
 
 	printf("done.\n");
 	return 0;
@@ -1241,41 +1105,28 @@ static int userfaultfd_events_test(void)
 	uffdio_register.mode = UFFDIO_REGISTER_MODE_MISSING;
 	if (test_uffdio_wp)
 		uffdio_register.mode |= UFFDIO_REGISTER_MODE_WP;
-	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register)) {
-		fprintf(stderr, "register failure\n");
-		exit(1);
-	}
+	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
+		err("register failure");
 
 	expected_ioctls = uffd_test_ops->expected_ioctls;
-	if ((uffdio_register.ioctls & expected_ioctls) != expected_ioctls) {
-		fprintf(stderr, "unexpected missing ioctl for anon memory\n");
-		exit(1);
-	}
+	if ((uffdio_register.ioctls & expected_ioctls) != expected_ioctls)
+		err("unexpected missing ioctl for anon memory");
 
-	if (pthread_create(&uffd_mon, &attr, uffd_poll_thread, &stats)) {
-		perror("uffd_poll_thread create");
-		exit(1);
-	}
+	if (pthread_create(&uffd_mon, &attr, uffd_poll_thread, &stats))
+		err("uffd_poll_thread create");
 
 	pid = fork();
-	if (pid < 0) {
-		perror("fork");
-		exit(1);
-	}
+	if (pid < 0)
+		err("fork");
 
 	if (!pid)
 		exit(faulting_process(0));
 
 	waitpid(pid, &err, 0);
-	if (err) {
-		fprintf(stderr, "faulting process failed\n");
-		exit(1);
-	}
-
-	if (write(pipefd[1], &c, sizeof(c)) != sizeof(c)) {
-		perror("pipe write");
-		exit(1);
-	}
+	if (err)
+		err("faulting process failed");
+	if (write(pipefd[1], &c, sizeof(c)) != sizeof(c))
+		err("pipe write");
 	if (pthread_join(uffd_mon, NULL))
 		return 1;
 
@@ -1309,56 +1160,39 @@ static int userfaultfd_sig_test(void)
 	uffdio_register.mode = UFFDIO_REGISTER_MODE_MISSING;
 	if (test_uffdio_wp)
 		uffdio_register.mode |= UFFDIO_REGISTER_MODE_WP;
-	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register)) {
-		fprintf(stderr, "register failure\n");
-		exit(1);
-	}
+	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
+		err("register failure");
 
 	expected_ioctls = uffd_test_ops->expected_ioctls;
-	if ((uffdio_register.ioctls & expected_ioctls) != expected_ioctls) {
-		fprintf(stderr, "unexpected missing ioctl for anon memory\n");
-		exit(1);
-	}
+	if ((uffdio_register.ioctls & expected_ioctls) != expected_ioctls)
+		err("unexpected missing ioctl for anon memory");
 
-	if (faulting_process(1)) {
-		fprintf(stderr, "faulting process failed\n");
-		exit(1);
-	}
+	if (faulting_process(1))
+		err("faulting process failed");
 
-	if (uffd_test_ops->release_pages(area_dst))
-		return 1;
+	uffd_test_ops->release_pages(area_dst);
 
-	if (pthread_create(&uffd_mon, &attr, uffd_poll_thread, &stats)) {
-		perror("uffd_poll_thread create");
-		exit(1);
-	}
+	if (pthread_create(&uffd_mon, &attr, uffd_poll_thread, &stats))
+		err("uffd_poll_thread create");
 
 	pid = fork();
-	if (pid < 0) {
-		perror("fork");
-		exit(1);
-	}
+	if (pid < 0)
+		err("fork");
 
 	if (!pid)
 		exit(faulting_process(2));
 
 	waitpid(pid, &err, 0);
-	if (err) {
-		fprintf(stderr, "faulting process failed\n");
-		exit(1);
-	}
-
-	if (write(pipefd[1], &c, sizeof(c)) != sizeof(c)) {
-		perror("pipe write");
-		exit(1);
-	}
+	if (err)
+		err("faulting process failed");
+	if (write(pipefd[1], &c, sizeof(c)) != sizeof(c))
+		err("pipe write");
 	if (pthread_join(uffd_mon, (void **)&userfaults))
 		return 1;
 
 	printf("done.\n");
 	if (userfaults)
-		fprintf(stderr, "Signal test failed, userfaults: %ld\n",
-			userfaults);
+		err("Signal test failed, userfaults: %ld", userfaults);
 	return userfaults != 0;
 }
 
@@ -1400,17 +1234,13 @@ static int userfaultfd_minor_test(void)
 	uffdio_register.range.start = (unsigned long)area_dst_alias;
 	uffdio_register.range.len = nr_pages * page_size;
 	uffdio_register.mode = UFFDIO_REGISTER_MODE_MINOR;
-	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register)) {
-		perror("register failure");
-		exit(1);
-	}
+	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
+		err("register failure");
 
 	expected_ioctls = uffd_test_ops->expected_ioctls;
 	expected_ioctls |= 1 << _UFFDIO_CONTINUE;
-	if ((uffdio_register.ioctls & expected_ioctls) != expected_ioctls) {
-		fprintf(stderr, "unexpected missing ioctl(s)\n");
-		exit(1);
-	}
+	if ((uffdio_register.ioctls & expected_ioctls) != expected_ioctls)
+		err("unexpected missing ioctl(s)");
 
 	/*
 	 * After registering with UFFD, populate the non-UFFD-registered side of
@@ -1421,10 +1251,8 @@ static int userfaultfd_minor_test(void)
 		       page_size);
 	}
 
-	if (pthread_create(&uffd_mon, &attr, uffd_poll_thread, &stats)) {
-		perror("uffd_poll_thread create");
-		exit(1);
-	}
+	if (pthread_create(&uffd_mon, &attr, uffd_poll_thread, &stats))
+		err("uffd_poll_thread create");
 
 	/*
 	 * Read each of the pages back using the UFFD-registered mapping. We
@@ -1433,26 +1261,19 @@ static int userfaultfd_minor_test(void)
 	 * page's contents, and then issuing a CONTINUE ioctl.
 	 */
 
-	if (posix_memalign(&expected_page, page_size, page_size)) {
-		fprintf(stderr, "out of memory\n");
-		return 1;
-	}
+	if (posix_memalign(&expected_page, page_size, page_size))
+		err("out of memory");
 
 	for (p = 0; p < nr_pages; ++p) {
 		expected_byte = ~((uint8_t)(p % ((uint8_t)-1)));
 		memset(expected_page, expected_byte, page_size);
 		if (my_bcmp(expected_page, area_dst_alias + (p * page_size),
-			    page_size)) {
-			fprintf(stderr,
-				"unexpected page contents after minor fault\n");
-			exit(1);
-		}
+			    page_size))
+			err("unexpected page contents after minor fault");
 	}
 
-	if (write(pipefd[1], &c, sizeof(c)) != sizeof(c)) {
-		perror("pipe write");
-		exit(1);
-	}
+	if (write(pipefd[1], &c, sizeof(c)) != sizeof(c))
+		err("pipe write");
 	if (pthread_join(uffd_mon, NULL))
 		return 1;
 
@@ -1467,16 +1288,13 @@ static int userfaultfd_stress(void)
 	char *tmp_area;
 	unsigned long nr;
 	struct uffdio_register uffdio_register;
-	int err;
 	struct uffd_stats uffd_stats[nr_cpus];
 
 	if (uffd_test_ctx_init(0))
 		return 1;
 
-	if (posix_memalign(&area, page_size, page_size)) {
-		fprintf(stderr, "out of memory\n");
-		return 1;
-	}
+	if (posix_memalign(&area, page_size, page_size))
+		err("out of memory");
 	zeropage = area;
 	bzero(zeropage, page_size);
 
@@ -1485,7 +1303,6 @@ static int userfaultfd_stress(void)
 	pthread_attr_init(&attr);
 	pthread_attr_setstacksize(&attr, 16*1024*1024);
 
-	err = 0;
 	while (bounces--) {
 		unsigned long expected_ioctls;
 
@@ -1514,25 +1331,18 @@ static int userfaultfd_stress(void)
 		uffdio_register.mode = UFFDIO_REGISTER_MODE_MISSING;
 		if (test_uffdio_wp)
 			uffdio_register.mode |= UFFDIO_REGISTER_MODE_WP;
-		if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register)) {
-			fprintf(stderr, "register failure\n");
-			return 1;
-		}
+		if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
+			err("register failure");
 		expected_ioctls = uffd_test_ops->expected_ioctls;
 		if ((uffdio_register.ioctls & expected_ioctls) !=
-		    expected_ioctls) {
-			fprintf(stderr,
-				"unexpected missing ioctl for anon memory\n");
-			return 1;
-		}
+		    expected_ioctls)
+			err("unexpected missing ioctl for anon memory");
 
 		if (area_dst_alias) {
 			uffdio_register.range.start = (unsigned long)
 				area_dst_alias;
-			if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register)) {
-				fprintf(stderr, "register failure alias\n");
-				return 1;
-			}
+			if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
+				err("register failure alias");
 		}
 
 		/*
@@ -1559,8 +1369,7 @@ static int userfaultfd_stress(void)
 		 * MADV_DONTNEED only after the UFFDIO_REGISTER, so it's
 		 * required to MADV_DONTNEED here.
 		 */
-		if (uffd_test_ops->release_pages(area_dst))
-			return 1;
+		uffd_test_ops->release_pages(area_dst);
 
 		uffd_stats_reset(uffd_stats, nr_cpus);
 
@@ -1574,33 +1383,22 @@ static int userfaultfd_stress(void)
 				 nr_pages * page_size, false);
 
 		/* unregister */
-		if (ioctl(uffd, UFFDIO_UNREGISTER, &uffdio_register.range)) {
-			fprintf(stderr, "unregister failure\n");
-			return 1;
-		}
+		if (ioctl(uffd, UFFDIO_UNREGISTER, &uffdio_register.range))
+			err("unregister failure");
 		if (area_dst_alias) {
 			uffdio_register.range.start = (unsigned long) area_dst;
 			if (ioctl(uffd, UFFDIO_UNREGISTER,
-				  &uffdio_register.range)) {
-				fprintf(stderr, "unregister failure alias\n");
-				return 1;
-			}
+				  &uffdio_register.range))
+				err("unregister failure alias");
 		}
 
 		/* verification */
-		if (bounces & BOUNCE_VERIFY) {
-			for (nr = 0; nr < nr_pages; nr++) {
-				if (*area_count(area_dst, nr) != count_verify[nr]) {
-					fprintf(stderr,
-						"error area_count %Lu %Lu %lu\n",
-						*area_count(area_src, nr),
-						count_verify[nr],
-						nr);
-					err = 1;
-					bounces = 0;
-				}
-			}
-		}
+		if (bounces & BOUNCE_VERIFY)
+			for (nr = 0; nr < nr_pages; nr++)
+				if (*area_count(area_dst, nr) != count_verify[nr])
+					err("error area_count %llu %llu %lu\n",
+					    *area_count(area_src, nr),
+					    count_verify[nr], nr);
 
 		/* prepare next bounce */
 		tmp_area = area_src;
@@ -1614,9 +1412,6 @@ static int userfaultfd_stress(void)
 		uffd_stats_report(uffd_stats, nr_cpus);
 	}
 
-	if (err)
-		return err;
-
 	return userfaultfd_zeropage_test() || userfaultfd_sig_test()
 		|| userfaultfd_events_test() || userfaultfd_minor_test();
 }
@@ -1667,7 +1462,7 @@ static void set_test_type(const char *ty
 		uffd_test_ops = &shmem_uffd_test_ops;
 		test_uffdio_minor = true;
 	} else {
-		fprintf(stderr, "Unknown test type: %s\n", type); exit(1);
+		err("Unknown test type: %s", type);
 	}
 
 	if (test_type == TEST_HUGETLB)
@@ -1675,15 +1470,11 @@ static void set_test_type(const char *ty
 	else
 		page_size = sysconf(_SC_PAGE_SIZE);
 
-	if (!page_size) {
-		fprintf(stderr, "Unable to determine page size\n");
-		exit(2);
-	}
+	if (!page_size)
+		err("Unable to determine page size");
 	if ((unsigned long) area_count(NULL, 0) + sizeof(unsigned long long) * 2
-	    > page_size) {
-		fprintf(stderr, "Impossible to run this test\n");
-		exit(2);
-	}
+	    > page_size)
+		err("Impossible to run this test");
 }
 
 static void sigalrm(int sig)
@@ -1700,10 +1491,8 @@ int main(int argc, char **argv)
 	if (argc < 4)
 		usage();
 
-	if (signal(SIGALRM, sigalrm) == SIG_ERR) {
-		fprintf(stderr, "failed to arm SIGALRM");
-		exit(1);
-	}
+	if (signal(SIGALRM, sigalrm) == SIG_ERR)
+		err("failed to arm SIGALRM");
 	alarm(ALARM_INTERVAL_SECS);
 
 	set_test_type(argv[1]);
@@ -1712,13 +1501,13 @@ int main(int argc, char **argv)
 	nr_pages_per_cpu = atol(argv[2]) * 1024*1024 / page_size /
 		nr_cpus;
 	if (!nr_pages_per_cpu) {
-		fprintf(stderr, "invalid MiB\n");
+		_err("invalid MiB");
 		usage();
 	}
 
 	bounces = atoi(argv[3]);
 	if (bounces <= 0) {
-		fprintf(stderr, "invalid bounces\n");
+		_err("invalid bounces");
 		usage();
 	}
 	nr_pages = nr_pages_per_cpu * nr_cpus;
@@ -1727,32 +1516,20 @@ int main(int argc, char **argv)
 		if (argc < 5)
 			usage();
 		huge_fd = open(argv[4], O_CREAT | O_RDWR, 0755);
-		if (huge_fd < 0) {
-			fprintf(stderr, "Open of %s failed", argv[4]);
-			perror("open");
-			exit(1);
-		}
-		if (ftruncate(huge_fd, 0)) {
-			fprintf(stderr, "ftruncate %s to size 0 failed", argv[4]);
-			perror("ftruncate");
-			exit(1);
-		}
+		if (huge_fd < 0)
+			err("Open of %s failed", argv[4]);
+		if (ftruncate(huge_fd, 0))
+			err("ftruncate %s to size 0 failed", argv[4]);
 	} else if (test_type == TEST_SHMEM) {
 		shm_fd = memfd_create(argv[0], 0);
-		if (shm_fd < 0) {
-			perror("memfd_create");
-			exit(1);
-		}
-		if (ftruncate(shm_fd, nr_pages * page_size * 2)) {
-			perror("ftruncate");
-			exit(1);
-		}
+		if (shm_fd < 0)
+			err("memfd_create");
+		if (ftruncate(shm_fd, nr_pages * page_size * 2))
+			err("ftruncate");
 		if (fallocate(shm_fd,
 			      FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0,
-			      nr_pages * page_size * 2)) {
-			perror("fallocate");
-			exit(1);
-		}
+			      nr_pages * page_size * 2))
+			err("fallocate");
 	}
 	printf("nr_pages: %lu, nr_pages_per_cpu: %lu\n",
 	       nr_pages, nr_pages_per_cpu);
_

Patches currently in -mm which might be from peterx@redhat.com are

hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share.patch
hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share-fix.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled-fix.patch
mm-hugetlb-move-flush_hugetlb_tlb_range-into-hugetlbh.patch
hugetlb-userfaultfd-unshare-all-pmds-for-hugetlbfs-when-register-wp.patch
userfaultfd-add-minor-fault-registration-mode-fix.patch


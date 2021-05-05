Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 299B9C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 015586141D
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:35:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbhEEBgz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:36:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230361AbhEEBgy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:36:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E18DE6141C;
        Wed,  5 May 2021 01:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178558;
        bh=F+6LickVe0JuTVZn/11cZt/t3dNB/pKrUJeoES8lE8E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=v4Qfdk3ONOXmlQxXf4SEmjX5j6iSYpJ7QUn+sjNBIr8zBIUe82YsFwBsdu5HvQakR
         WaPLiAeST5ySrJPSU9y0ACoS3PJZU2Qf5l0EbqoaDTZSuJX3lV5gEQy2ewIjd95pMt
         fJpByt7QYNXRwRGXl/VMVhB2HEoOj2fzvrAWnxmk=
Date:   Tue, 04 May 2021 18:35:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, adobriyan@gmail.com,
        akpm@linux-foundation.org, almasrymina@google.com,
        anshuman.khandual@arm.com, axelrasmussen@google.com,
        cannonmatthews@google.com, catalin.marinas@arm.com,
        chinwen.chang@mediatek.com, dgilbert@redhat.com, jannh@google.com,
        jglisse@redhat.com, kirill@shutemov.name, linux-mm@kvack.org,
        lokeshgidra@google.com, mike.kravetz@oracle.com, mingo@redhat.com,
        mkoutny@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        npiggin@gmail.com, oupton@google.com, peterx@redhat.com,
        rientjes@google.com, rostedt@goodmis.org, rppt@linux.vnet.ibm.com,
        ruprecht@google.com, shawn@anastas.io, shli@fb.com,
        steven.price@arm.com, torvalds@linux-foundation.org,
        vbabka@suse.cz, viro@zeniv.linux.org.uk, walken@google.com,
        willy@infradead.org, ying.huang@intel.com
Subject:  [patch 059/143] userfaultfd/selftests: add test
 exercising minor fault handling
Message-ID: <20210505013557.EwFsMXKMt%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd/selftests: add test exercising minor fault handling

Fix a dormant bug in userfaultfd_events_test(), where we did `return
faulting_process(0)` instead of `exit(faulting_process(0))`.  This caused
the forked process to keep running, trying to execute any further test
cases after the events test in parallel with the "real" process.

Add a simple test case which exercises minor faults. In short, it does
the following:

1. "Sets up" an area (area_dst) and a second shared mapping to the same
   underlying pages (area_dst_alias).

2. Register one of these areas with userfaultfd, in minor fault mode.

3. Start a second thread to handle any minor faults.

4. Populate the underlying pages with the non-UFFD-registered side of
   the mapping. Basically, memset() each page with some arbitrary
   contents.

5. Then, using the UFFD-registered mapping, read all of the page
   contents, asserting that the contents match expectations (we expect
   the minor fault handling thread can modify the page contents before
   resolving the fault).

The minor fault handling thread, upon receiving an event, flips all the
bits (~) in that page, just to prove that it can modify it in some
arbitrary way.  Then it issues a UFFDIO_CONTINUE ioctl, to setup the
mapping and resolve the fault.  The reading thread should wake up and see
this modification.

Currently the minor fault test is only enabled in hugetlb_shared mode, as
this is the only configuration the kernel feature supports.

Link: https://lkml.kernel.org/r/20210301222728.176417-7-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Adam Ruprecht <ruprecht@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Cannon Matthews <cannonmatthews@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michal Koutn" <mkoutny@suse.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shawn Anastasio <shawn@anastas.io>
Cc: Steven Price <steven.price@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |  164 ++++++++++++++++++++-
 1 file changed, 158 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-add-test-exercising-minor-fault-handling
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -81,6 +81,8 @@ static volatile bool test_uffdio_copy_ee
 static volatile bool test_uffdio_zeropage_eexist = true;
 /* Whether to test uffd write-protection */
 static bool test_uffdio_wp = false;
+/* Whether to test uffd minor faults */
+static bool test_uffdio_minor = false;
 
 static bool map_shared;
 static int huge_fd;
@@ -96,6 +98,7 @@ struct uffd_stats {
 	int cpu;
 	unsigned long missing_faults;
 	unsigned long wp_faults;
+	unsigned long minor_faults;
 };
 
 /* pthread_mutex_t starts at page offset 0 */
@@ -153,17 +156,19 @@ static void uffd_stats_reset(struct uffd
 		uffd_stats[i].cpu = i;
 		uffd_stats[i].missing_faults = 0;
 		uffd_stats[i].wp_faults = 0;
+		uffd_stats[i].minor_faults = 0;
 	}
 }
 
 static void uffd_stats_report(struct uffd_stats *stats, int n_cpus)
 {
 	int i;
-	unsigned long long miss_total = 0, wp_total = 0;
+	unsigned long long miss_total = 0, wp_total = 0, minor_total = 0;
 
 	for (i = 0; i < n_cpus; i++) {
 		miss_total += stats[i].missing_faults;
 		wp_total += stats[i].wp_faults;
+		minor_total += stats[i].minor_faults;
 	}
 
 	printf("userfaults: %llu missing (", miss_total);
@@ -172,6 +177,9 @@ static void uffd_stats_report(struct uff
 	printf("\b), %llu wp (", wp_total);
 	for (i = 0; i < n_cpus; i++)
 		printf("%lu+", stats[i].wp_faults);
+	printf("\b), %llu minor (", minor_total);
+	for (i = 0; i < n_cpus; i++)
+		printf("%lu+", stats[i].minor_faults);
 	printf("\b)\n");
 }
 
@@ -328,7 +336,7 @@ static struct uffd_test_ops shmem_uffd_t
 };
 
 static struct uffd_test_ops hugetlb_uffd_test_ops = {
-	.expected_ioctls = UFFD_API_RANGE_IOCTLS_BASIC,
+	.expected_ioctls = UFFD_API_RANGE_IOCTLS_BASIC & ~(1 << _UFFDIO_CONTINUE),
 	.allocate_area	= hugetlb_allocate_area,
 	.release_pages	= hugetlb_release_pages,
 	.alias_mapping = hugetlb_alias_mapping,
@@ -362,6 +370,22 @@ static void wp_range(int ufd, __u64 star
 	}
 }
 
+static void continue_range(int ufd, __u64 start, __u64 len)
+{
+	struct uffdio_continue req;
+
+	req.range.start = start;
+	req.range.len = len;
+	req.mode = 0;
+
+	if (ioctl(ufd, UFFDIO_CONTINUE, &req)) {
+		fprintf(stderr,
+			"UFFDIO_CONTINUE failed for address 0x%" PRIx64 "\n",
+			(uint64_t)start);
+		exit(1);
+	}
+}
+
 static void *locking_thread(void *arg)
 {
 	unsigned long cpu = (unsigned long) arg;
@@ -569,8 +593,32 @@ static void uffd_handle_page_fault(struc
 	}
 
 	if (msg->arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_WP) {
+		/* Write protect page faults */
 		wp_range(uffd, msg->arg.pagefault.address, page_size, false);
 		stats->wp_faults++;
+	} else if (msg->arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_MINOR) {
+		uint8_t *area;
+		int b;
+
+		/*
+		 * Minor page faults
+		 *
+		 * To prove we can modify the original range for testing
+		 * purposes, we're going to bit flip this range before
+		 * continuing.
+		 *
+		 * Note that this requires all minor page fault tests operate on
+		 * area_dst (non-UFFD-registered) and area_dst_alias
+		 * (UFFD-registered).
+		 */
+
+		area = (uint8_t *)(area_dst +
+				   ((char *)msg->arg.pagefault.address -
+				    area_dst_alias));
+		for (b = 0; b < page_size; ++b)
+			area[b] = ~area[b];
+		continue_range(uffd, msg->arg.pagefault.address, page_size);
+		stats->minor_faults++;
 	} else {
 		/* Missing page faults */
 		if (bounces & BOUNCE_VERIFY &&
@@ -779,7 +827,7 @@ static int stress(struct uffd_stats *uff
 	return 0;
 }
 
-static int userfaultfd_open(int features)
+static int userfaultfd_open_ext(uint64_t *features)
 {
 	struct uffdio_api uffdio_api;
 
@@ -792,7 +840,7 @@ static int userfaultfd_open(int features
 	uffd_flags = fcntl(uffd, F_GETFD, NULL);
 
 	uffdio_api.api = UFFD_API;
-	uffdio_api.features = features;
+	uffdio_api.features = *features;
 	if (ioctl(uffd, UFFDIO_API, &uffdio_api)) {
 		fprintf(stderr, "UFFDIO_API failed.\nPlease make sure to "
 			"run with either root or ptrace capability.\n");
@@ -804,9 +852,15 @@ static int userfaultfd_open(int features
 		return 1;
 	}
 
+	*features = uffdio_api.features;
 	return 0;
 }
 
+static int userfaultfd_open(uint64_t features)
+{
+	return userfaultfd_open_ext(&features);
+}
+
 sigjmp_buf jbuf, *sigbuf;
 
 static void sighndl(int sig, siginfo_t *siginfo, void *ptr)
@@ -1112,7 +1166,7 @@ static int userfaultfd_events_test(void)
 	}
 
 	if (!pid)
-		return faulting_process(0);
+		exit(faulting_process(0));
 
 	waitpid(pid, &err, 0);
 	if (err) {
@@ -1215,6 +1269,102 @@ static int userfaultfd_sig_test(void)
 	return userfaults != 0;
 }
 
+static int userfaultfd_minor_test(void)
+{
+	struct uffdio_register uffdio_register;
+	unsigned long expected_ioctls;
+	unsigned long p;
+	pthread_t uffd_mon;
+	uint8_t expected_byte;
+	void *expected_page;
+	char c;
+	struct uffd_stats stats = { 0 };
+	uint64_t features = UFFD_FEATURE_MINOR_HUGETLBFS;
+
+	if (!test_uffdio_minor)
+		return 0;
+
+	printf("testing minor faults: ");
+	fflush(stdout);
+
+	if (uffd_test_ops->release_pages(area_dst))
+		return 1;
+
+	if (userfaultfd_open_ext(&features))
+		return 1;
+	/* If kernel reports the feature isn't supported, skip the test. */
+	if (!(features & UFFD_FEATURE_MINOR_HUGETLBFS)) {
+		printf("skipping test due to lack of feature support\n");
+		fflush(stdout);
+		return 0;
+	}
+
+	uffdio_register.range.start = (unsigned long)area_dst_alias;
+	uffdio_register.range.len = nr_pages * page_size;
+	uffdio_register.mode = UFFDIO_REGISTER_MODE_MINOR;
+	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register)) {
+		fprintf(stderr, "register failure\n");
+		exit(1);
+	}
+
+	expected_ioctls = uffd_test_ops->expected_ioctls;
+	expected_ioctls |= 1 << _UFFDIO_CONTINUE;
+	if ((uffdio_register.ioctls & expected_ioctls) != expected_ioctls) {
+		fprintf(stderr, "unexpected missing ioctl(s)\n");
+		exit(1);
+	}
+
+	/*
+	 * After registering with UFFD, populate the non-UFFD-registered side of
+	 * the shared mapping. This should *not* trigger any UFFD minor faults.
+	 */
+	for (p = 0; p < nr_pages; ++p) {
+		memset(area_dst + (p * page_size), p % ((uint8_t)-1),
+		       page_size);
+	}
+
+	if (pthread_create(&uffd_mon, &attr, uffd_poll_thread, &stats)) {
+		perror("uffd_poll_thread create");
+		exit(1);
+	}
+
+	/*
+	 * Read each of the pages back using the UFFD-registered mapping. We
+	 * expect that the first time we touch a page, it will result in a minor
+	 * fault. uffd_poll_thread will resolve the fault by bit-flipping the
+	 * page's contents, and then issuing a CONTINUE ioctl.
+	 */
+
+	if (posix_memalign(&expected_page, page_size, page_size)) {
+		fprintf(stderr, "out of memory\n");
+		return 1;
+	}
+
+	for (p = 0; p < nr_pages; ++p) {
+		expected_byte = ~((uint8_t)(p % ((uint8_t)-1)));
+		memset(expected_page, expected_byte, page_size);
+		if (my_bcmp(expected_page, area_dst_alias + (p * page_size),
+			    page_size)) {
+			fprintf(stderr,
+				"unexpected page contents after minor fault\n");
+			exit(1);
+		}
+	}
+
+	if (write(pipefd[1], &c, sizeof(c)) != sizeof(c)) {
+		perror("pipe write");
+		exit(1);
+	}
+	if (pthread_join(uffd_mon, NULL))
+		return 1;
+
+	close(uffd);
+
+	uffd_stats_report(&stats, 1);
+
+	return stats.missing_faults != 0 || stats.minor_faults != nr_pages;
+}
+
 static int userfaultfd_stress(void)
 {
 	void *area;
@@ -1413,7 +1563,7 @@ static int userfaultfd_stress(void)
 
 	close(uffd);
 	return userfaultfd_zeropage_test() || userfaultfd_sig_test()
-		|| userfaultfd_events_test();
+		|| userfaultfd_events_test() || userfaultfd_minor_test();
 }
 
 /*
@@ -1454,6 +1604,8 @@ static void set_test_type(const char *ty
 		map_shared = true;
 		test_type = TEST_HUGETLB;
 		uffd_test_ops = &hugetlb_uffd_test_ops;
+		/* Minor faults require shared hugetlb; only enable here. */
+		test_uffdio_minor = true;
 	} else if (!strcmp(type, "shmem")) {
 		map_shared = true;
 		test_type = TEST_SHMEM;
_

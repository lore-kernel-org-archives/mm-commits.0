Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81066C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B15061469
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238403AbhGABvq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:51:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238384AbhGABvo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:51:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E507C61466;
        Thu,  1 Jul 2021 01:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104154;
        bh=5XBSRVRXfFJDd5DpJNwandjUuEDDnsRSeJOE67UUtaA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WOv8Pddnuo5DfQf7Y741usywRwZmpD8f3PT0eqEd5XmlAwxcHctvDxwUghM5jW+Tg
         UIW7ahfLGueCIu/lcGqv0OcVTGuRmz7/uKHAI6bA3FbcnuLS+3yy3gqhwRTyXICiq6
         h7fXzDlsX5ZOOKwgy1axiYnJlv500QQq4MBStItM=
Date:   Wed, 30 Jun 2021 18:49:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        almasrymina@google.com, axelrasmussen@google.com,
        bgeffon@google.com, dgilbert@redhat.com, hughd@google.com,
        jglisse@redhat.com, joe@perches.com, kirill@shutemov.name,
        linux-mm@kvack.org, lokeshgidra@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        oupton@google.com, peterx@redhat.com, rppt@linux.vnet.ibm.com,
        sfr@canb.auug.org.au, shli@fb.com, shuah@kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        wangqing@vivo.com
Subject:  [patch 039/192] userfaultfd/selftests: add pagemap
 uffd-wp test
Message-ID: <20210701014913.l05nEifZW%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: userfaultfd/selftests: add pagemap uffd-wp test

Add one anonymous specific test to start using pagemap.  With pagemap
support, we can directly read the uffd-wp bit from pgtable without
triggering any fault, so it's easier to do sanity checks in unit tests.

Meanwhile this test also leverages the newly introduced MADV_PAGEOUT
madvise function to test swap ptes with uffd-wp bit set, and across
fork()s.

Link: https://lkml.kernel.org/r/20210428225030.9708-7-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wang Qing <wangqing@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |  154 +++++++++++++++++++++
 1 file changed, 154 insertions(+)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-add-pagemap-uffd-wp-test
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -1170,6 +1170,144 @@ static int userfaultfd_minor_test(void)
 	return stats.missing_faults != 0 || stats.minor_faults != nr_pages;
 }
 
+#define BIT_ULL(nr)                   (1ULL << (nr))
+#define PM_SOFT_DIRTY                 BIT_ULL(55)
+#define PM_MMAP_EXCLUSIVE             BIT_ULL(56)
+#define PM_UFFD_WP                    BIT_ULL(57)
+#define PM_FILE                       BIT_ULL(61)
+#define PM_SWAP                       BIT_ULL(62)
+#define PM_PRESENT                    BIT_ULL(63)
+
+static int pagemap_open(void)
+{
+	int fd = open("/proc/self/pagemap", O_RDONLY);
+
+	if (fd < 0)
+		err("open pagemap");
+
+	return fd;
+}
+
+static uint64_t pagemap_read_vaddr(int fd, void *vaddr)
+{
+	uint64_t value;
+	int ret;
+
+	ret = pread(fd, &value, sizeof(uint64_t),
+		    ((uint64_t)vaddr >> 12) * sizeof(uint64_t));
+	if (ret != sizeof(uint64_t))
+		err("pread() on pagemap failed");
+
+	return value;
+}
+
+/* This macro let __LINE__ works in err() */
+#define  pagemap_check_wp(value, wp) do {				\
+		if (!!(value & PM_UFFD_WP) != wp)			\
+			err("pagemap uffd-wp bit error: 0x%"PRIx64, value); \
+	} while (0)
+
+static int pagemap_test_fork(bool present)
+{
+	pid_t child = fork();
+	uint64_t value;
+	int fd, result;
+
+	if (!child) {
+		/* Open the pagemap fd of the child itself */
+		fd = pagemap_open();
+		value = pagemap_read_vaddr(fd, area_dst);
+		/*
+		 * After fork() uffd-wp bit should be gone as long as we're
+		 * without UFFD_FEATURE_EVENT_FORK
+		 */
+		pagemap_check_wp(value, false);
+		/* Succeed */
+		exit(0);
+	}
+	waitpid(child, &result, 0);
+	return result;
+}
+
+static void userfaultfd_pagemap_test(unsigned int test_pgsize)
+{
+	struct uffdio_register uffdio_register;
+	int pagemap_fd;
+	uint64_t value;
+
+	/* Pagemap tests uffd-wp only */
+	if (!test_uffdio_wp)
+		return;
+
+	/* Not enough memory to test this page size */
+	if (test_pgsize > nr_pages * page_size)
+		return;
+
+	printf("testing uffd-wp with pagemap (pgsize=%u): ", test_pgsize);
+	/* Flush so it doesn't flush twice in parent/child later */
+	fflush(stdout);
+
+	uffd_test_ops->release_pages(area_dst);
+
+	if (test_pgsize > page_size) {
+		/* This is a thp test */
+		if (madvise(area_dst, nr_pages * page_size, MADV_HUGEPAGE))
+			err("madvise(MADV_HUGEPAGE) failed");
+	} else if (test_pgsize == page_size) {
+		/* This is normal page test; force no thp */
+		if (madvise(area_dst, nr_pages * page_size, MADV_NOHUGEPAGE))
+			err("madvise(MADV_NOHUGEPAGE) failed");
+	}
+
+	if (userfaultfd_open(0))
+		err("userfaultfd_open");
+
+	uffdio_register.range.start = (unsigned long) area_dst;
+	uffdio_register.range.len = nr_pages * page_size;
+	uffdio_register.mode = UFFDIO_REGISTER_MODE_WP;
+	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
+		err("register failed");
+
+	pagemap_fd = pagemap_open();
+
+	/* Touch the page */
+	*area_dst = 1;
+	wp_range(uffd, (uint64_t)area_dst, test_pgsize, true);
+	value = pagemap_read_vaddr(pagemap_fd, area_dst);
+	pagemap_check_wp(value, true);
+	/* Make sure uffd-wp bit dropped when fork */
+	if (pagemap_test_fork(true))
+		err("Detected stall uffd-wp bit in child");
+
+	/* Exclusive required or PAGEOUT won't work */
+	if (!(value & PM_MMAP_EXCLUSIVE))
+		err("multiple mapping detected: 0x%"PRIx64, value);
+
+	if (madvise(area_dst, test_pgsize, MADV_PAGEOUT))
+		err("madvise(MADV_PAGEOUT) failed");
+
+	/* Uffd-wp should persist even swapped out */
+	value = pagemap_read_vaddr(pagemap_fd, area_dst);
+	pagemap_check_wp(value, true);
+	/* Make sure uffd-wp bit dropped when fork */
+	if (pagemap_test_fork(false))
+		err("Detected stall uffd-wp bit in child");
+
+	/* Unprotect; this tests swap pte modifications */
+	wp_range(uffd, (uint64_t)area_dst, page_size, false);
+	value = pagemap_read_vaddr(pagemap_fd, area_dst);
+	pagemap_check_wp(value, false);
+
+	/* Fault in the page from disk */
+	*area_dst = 2;
+	value = pagemap_read_vaddr(pagemap_fd, area_dst);
+	pagemap_check_wp(value, false);
+
+	close(pagemap_fd);
+	close(uffd);
+	printf("done\n");
+}
+
 static int userfaultfd_stress(void)
 {
 	void *area;
@@ -1341,6 +1479,22 @@ static int userfaultfd_stress(void)
 	}
 
 	close(uffd);
+
+	if (test_type == TEST_ANON) {
+		/*
+		 * shmem/hugetlb won't be able to run since they have different
+		 * behavior on fork() (file-backed memory normally drops ptes
+		 * directly when fork), meanwhile the pagemap test will verify
+		 * pgtable entry of fork()ed child.
+		 */
+		userfaultfd_pagemap_test(page_size);
+		/*
+		 * Hard-code for x86_64 for now for 2M THP, as x86_64 is
+		 * currently the only one that supports uffd-wp
+		 */
+		userfaultfd_pagemap_test(page_size * 512);
+	}
+
 	return userfaultfd_zeropage_test() || userfaultfd_sig_test()
 		|| userfaultfd_events_test() || userfaultfd_minor_test();
 }
_

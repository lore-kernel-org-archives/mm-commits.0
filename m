Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF5DC433ED
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 04:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C99E61421
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 04:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhEIELh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 00:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229491AbhEIELb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 May 2021 00:11:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 129BF61421;
        Sun,  9 May 2021 04:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620533427;
        bh=5NQBSyCMEux4JYTuArAyHO2a7gk65sn0tG3fNji54SI=;
        h=Date:From:To:Subject:From;
        b=E0FNR5f2zyeo4ajVobWRmGbr8tIEIPPS6HWYks8lpSn2xkTrIJSXePtkjCPkmdKyG
         gYEFgy6Y1CHT/d27r0MyXDBeV5ijH1700ynXYixEowXmo2bwCxiclvrvS6WHPcMjS5
         2YzxW/MBMrscENAQj3NctgafpZ5xrV60CNN2BlGg=
Date:   Sat, 08 May 2021 21:10:26 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, almasrymina@google.com,
        axelrasmussen@google.com, bgeffon@google.com, dgilbert@redhat.com,
        hughd@google.com, jglisse@redhat.com, joe@perches.com,
        kirill@shutemov.name, lokeshgidra@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        oupton@google.com, peterx@redhat.com, rppt@linux.vnet.ibm.com,
        sfr@canb.auug.org.au, shli@fb.com, shuah@kernel.org,
        viro@zeniv.linux.org.uk, wangqing@vivo.com
Subject:  + userfaultfd-selftests-add-pagemap-uffd-wp-test.patch
 added to -mm tree
Message-ID: <20210509041026.SB5s966Ul%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: add pagemap uffd-wp test
has been added to the -mm tree.  Its filename is
     userfaultfd-selftests-add-pagemap-uffd-wp-test.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftests-add-pagemap-uffd-wp-test.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftests-add-pagemap-uffd-wp-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-f_seal_future_write.patch
mm-hugetlb-fix-cow-where-page-writtable-in-child.patch
mm-gup_benchmark-support-threading.patch
userfaultfd-selftests-use-user-mode-only.patch
userfaultfd-selftests-remove-the-time-check-on-delayed-uffd.patch
userfaultfd-selftests-dropping-verify-check-in-locking_thread.patch
userfaultfd-selftests-only-dump-counts-if-mode-enabled.patch
userfaultfd-selftests-unify-error-handling.patch
mm-thp-simplify-copying-of-huge-zero-page-pmd-when-fork.patch
mm-userfaultfd-fix-uffd-wp-special-cases-for-fork.patch
mm-userfaultfd-fix-a-few-thp-pmd-missing-uffd-wp-bit.patch
mm-userfaultfd-fail-uffd-wp-registeration-if-not-supported.patch
mm-pagemap-export-uffd-wp-protection-information.patch
userfaultfd-selftests-add-pagemap-uffd-wp-test.patch


From: akpm@linux-foundation.org
Subject: +
 userfaultfd-selftest-test-uffdio_zeropage-on-all-memory-types.patch added
 to -mm tree
Date: Wed, 04 Jan 2017 16:54:44 -0800
Message-ID: <586d9954.+QWvB9Q/QJZ9u48T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36194 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932445AbdAEAya (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 19:54:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: selftest: test UFFDIO_ZEROPAGE on all memory types
has been added to the -mm tree.  Its filename is
     userfaultfd-selftest-test-uffdio_zeropage-on-all-memory-types.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftest-test-uffdio_zeropage-on-all-memory-types.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftest-test-uffdio_zeropage-on-all-memory-types.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: selftest: test UFFDIO_ZEROPAGE on all memory types

This will verify -EINVAL is returned with hugetlbfs/shmem and it'll do
a functional test of UFFDIO_ZEROPAGE on anonymous memory.

Link: http://lkml.kernel.org/r/20161216144821.5183-42-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   82 ++++++++++++++++++++-
 1 file changed, 81 insertions(+), 1 deletion(-)

diff -puN tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-test-uffdio_zeropage-on-all-memory-types tools/testing/selftests/vm/userfaultfd.c
--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-test-uffdio_zeropage-on-all-memory-types
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -625,6 +625,86 @@ static int faulting_process(void)
 	return 0;
 }
 
+static int uffdio_zeropage(int ufd, unsigned long offset)
+{
+	struct uffdio_zeropage uffdio_zeropage;
+	int ret;
+	unsigned long has_zeropage = EXPECTED_IOCTLS & (1 << _UFFDIO_ZEROPAGE);
+
+	if (offset >= nr_pages * page_size)
+		fprintf(stderr, "unexpected offset %lu\n",
+			offset), exit(1);
+	uffdio_zeropage.range.start = (unsigned long) area_dst + offset;
+	uffdio_zeropage.range.len = page_size;
+	uffdio_zeropage.mode = 0;
+	ret = ioctl(ufd, UFFDIO_ZEROPAGE, &uffdio_zeropage);
+	if (ret) {
+		/* real retval in ufdio_zeropage.zeropage */
+		if (has_zeropage) {
+			if (uffdio_zeropage.zeropage == -EEXIST)
+				fprintf(stderr, "UFFDIO_ZEROPAGE -EEXIST\n"),
+					exit(1);
+			else
+				fprintf(stderr, "UFFDIO_ZEROPAGE error %Ld\n",
+					uffdio_zeropage.zeropage), exit(1);
+		} else {
+			if (uffdio_zeropage.zeropage != -EINVAL)
+				fprintf(stderr,
+					"UFFDIO_ZEROPAGE not -EINVAL %Ld\n",
+					uffdio_zeropage.zeropage), exit(1);
+		}
+	} else if (has_zeropage) {
+		if (uffdio_zeropage.zeropage != page_size) {
+			fprintf(stderr, "UFFDIO_ZEROPAGE unexpected %Ld\n",
+				uffdio_zeropage.zeropage), exit(1);
+		} else
+			return 1;
+	} else {
+		fprintf(stderr,
+			"UFFDIO_ZEROPAGE succeeded %Ld\n",
+			uffdio_zeropage.zeropage), exit(1);
+	}
+
+	return 0;
+}
+
+/* exercise UFFDIO_ZEROPAGE */
+static int userfaultfd_zeropage_test(void)
+{
+	struct uffdio_register uffdio_register;
+	unsigned long expected_ioctls;
+
+	printf("testing UFFDIO_ZEROPAGE: ");
+	fflush(stdout);
+
+	if (release_pages(area_dst))
+		return 1;
+
+	if (userfaultfd_open(0) < 0)
+		return 1;
+	uffdio_register.range.start = (unsigned long) area_dst;
+	uffdio_register.range.len = nr_pages * page_size;
+	uffdio_register.mode = UFFDIO_REGISTER_MODE_MISSING;
+	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
+		fprintf(stderr, "register failure\n"), exit(1);
+
+	expected_ioctls = EXPECTED_IOCTLS;
+	if ((uffdio_register.ioctls & expected_ioctls) !=
+	    expected_ioctls)
+		fprintf(stderr,
+			"unexpected missing ioctl for anon memory\n"),
+			exit(1);
+
+	if (uffdio_zeropage(uffd, 0)) {
+		if (my_bcmp(area_dst, zeropage, page_size))
+			fprintf(stderr, "zeropage is not zero\n"), exit(1);
+	}
+
+	close(uffd);
+	printf("done.\n");
+	return 0;
+}
+
 static int userfaultfd_events_test(void)
 {
 	struct uffdio_register uffdio_register;
@@ -853,7 +933,7 @@ static int userfaultfd_stress(void)
 		return err;
 
 	close(uffd);
-	return userfaultfd_events_test();
+	return userfaultfd_zeropage_test() || userfaultfd_events_test();
 }
 
 #ifndef HUGETLB_TEST
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-document-_ior-_iow.patch
userfaultfd-correct-comment-about-uffd_feature_pagefault_flag_wp.patch
userfaultfd-convert-bug-to-warn_on_once.patch
userfaultfd-use-vma_is_anonymous.patch
userfaultfd-non-cooperative-report-all-available-features-to-userland.patch
userfaultfd-non-cooperative-add-fork-event-build-warning-fix.patch
userfaultfd-non-cooperative-optimize-mremap_userfaultfd_complete.patch
userfaultfd-non-cooperative-avoid-madv_dontneed-race-condition.patch
userfaultfd-non-cooperative-wake-userfaults-after-uffdio_unregister.patch
userfaultfd-hugetlbfs-gup-support-vm_fault_retry.patch
userfaultfd-hugetlbfs-uffd_feature_missing_hugetlbfs.patch
userfaultfd-shmem-add-tlbflushh-header-for-microblaze.patch
userfaultfd-shmem-lock-the-page-before-adding-it-to-pagecache.patch
userfaultfd-shmem-avoid-leaking-blocks-and-used-blocks-in-uffdio_copy.patch
userfaultfd-hugetlbfs-uffd_feature_missing_shmem.patch
userfaultfd-selftest-test-uffdio_zeropage-on-all-memory-types.patch
mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock.patch


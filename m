From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-selftest-exercise-eexist-only-in-background-transfer.patch
 removed from -mm tree
Date: Mon, 16 Oct 2017 12:55:33 -0700
Message-ID: <20171016195533.j38PBZNzN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55546 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755750AbdJPTze (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2017 15:55:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dgilbert@redhat.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com, shuah@kernel.org, xemul@virtuozzo.com


The patch titled
     Subject: userfaultfd: selftest: exercise -EEXIST only in background transfer
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftest-exercise-eexist-only-in-background-transfer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: selftest: exercise -EEXIST only in background transfer

I was stress testing some backports and with high load, after some time,
the latest version of the selftest showed some false positive in
connection with the uffdio_copy_retry.  This seems to fix it while still
exercising -EEXIST in the background transfer once in a while.

The fork child will quit after the last UFFDIO_COPY is run, so a repeated
UFFDIO_COPY may not return -EEXIST.  This change restricts the -EEXIST
stress to the background transfer where the memory can't go away from
under it.

Also updated uffdio_zeropage, so the interface is consistent.

Link: http://lkml.kernel.org/r/20171004171541.1495-2-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   25 ++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff -puN tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-exercise-eexist-only-in-background-transfer tools/testing/selftests/vm/userfaultfd.c
--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-exercise-eexist-only-in-background-transfer
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -397,7 +397,7 @@ static void retry_copy_page(int ufd, str
 	}
 }
 
-static int copy_page(int ufd, unsigned long offset)
+static int __copy_page(int ufd, unsigned long offset, bool retry)
 {
 	struct uffdio_copy uffdio_copy;
 
@@ -418,7 +418,7 @@ static int copy_page(int ufd, unsigned l
 		fprintf(stderr, "UFFDIO_COPY unexpected copy %Ld\n",
 			uffdio_copy.copy), exit(1);
 	} else {
-		if (test_uffdio_copy_eexist) {
+		if (test_uffdio_copy_eexist && retry) {
 			test_uffdio_copy_eexist = false;
 			retry_copy_page(ufd, &uffdio_copy, offset);
 		}
@@ -427,6 +427,16 @@ static int copy_page(int ufd, unsigned l
 	return 0;
 }
 
+static int copy_page_retry(int ufd, unsigned long offset)
+{
+	return __copy_page(ufd, offset, true);
+}
+
+static int copy_page(int ufd, unsigned long offset)
+{
+	return __copy_page(ufd, offset, false);
+}
+
 static void *uffd_poll_thread(void *arg)
 {
 	unsigned long cpu = (unsigned long) arg;
@@ -544,7 +554,7 @@ static void *background_thread(void *arg
 	for (page_nr = cpu * nr_pages_per_cpu;
 	     page_nr < (cpu+1) * nr_pages_per_cpu;
 	     page_nr++)
-		copy_page(uffd, page_nr * page_size);
+		copy_page_retry(uffd, page_nr * page_size);
 
 	return NULL;
 }
@@ -779,7 +789,7 @@ static void retry_uffdio_zeropage(int uf
 	}
 }
 
-static int uffdio_zeropage(int ufd, unsigned long offset)
+static int __uffdio_zeropage(int ufd, unsigned long offset, bool retry)
 {
 	struct uffdio_zeropage uffdio_zeropage;
 	int ret;
@@ -814,7 +824,7 @@ static int uffdio_zeropage(int ufd, unsi
 			fprintf(stderr, "UFFDIO_ZEROPAGE unexpected %Ld\n",
 				uffdio_zeropage.zeropage), exit(1);
 		} else {
-			if (test_uffdio_zeropage_eexist) {
+			if (test_uffdio_zeropage_eexist && retry) {
 				test_uffdio_zeropage_eexist = false;
 				retry_uffdio_zeropage(ufd, &uffdio_zeropage,
 						      offset);
@@ -830,6 +840,11 @@ static int uffdio_zeropage(int ufd, unsi
 	return 0;
 }
 
+static int uffdio_zeropage(int ufd, unsigned long offset)
+{
+	return __uffdio_zeropage(ufd, offset, false);
+}
+
 /* exercise UFFDIO_ZEROPAGE */
 static int userfaultfd_zeropage_test(void)
 {
_

Patches currently in -mm which might be from aarcange@redhat.com are



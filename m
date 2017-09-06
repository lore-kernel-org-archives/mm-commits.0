From: akpm@linux-foundation.org
Subject: [folded-merged]
 userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch removed from -mm tree
Date: Wed, 06 Sep 2017 16:07:37 -0700
Message-ID: <59b07fb9.DSCgpVFndsetV0ut%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47434 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752270AbdIFXHj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:07:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.perevalov@samsung.com, aarcange@redhat.com, dgilbert@redhat.com, maxime.coquelin@redhat.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch

This patch was dropped because it was folded into userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix

fix uffdio_zeropage(), per Mike Kravetz

Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Alexey Perevalov <a.perevalov@samsung.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Maxime Coquelin <maxime.coquelin@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix tools/testing/selftests/vm/userfaultfd.c
--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -813,13 +813,14 @@ static int uffdio_zeropage(int ufd, unsi
 		if (uffdio_zeropage.zeropage != page_size) {
 			fprintf(stderr, "UFFDIO_ZEROPAGE unexpected %Ld\n",
 				uffdio_zeropage.zeropage), exit(1);
-		} else
+		} else {
 			if (test_uffdio_zeropage_eexist) {
 				test_uffdio_zeropage_eexist = false;
 				retry_uffdio_zeropage(ufd, &uffdio_zeropage,
 						      offset);
 			}
 			return 1;
+		}
 	} else {
 		fprintf(stderr,
 			"UFFDIO_ZEROPAGE succeeded %Ld\n",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist.patch
mm-swap-add-swap-readahead-hit-statistics-fix.patch
swap-choose-swap-device-according-to-numa-node-v2-fix.patch
mmfork-introduce-madv_wipeonfork-fix.patch


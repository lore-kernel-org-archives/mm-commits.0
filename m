Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB9AC433B4
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 05:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94F6961165
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 05:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbhDIFHg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 01:07:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233276AbhDIFHO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 01:07:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C96A61178;
        Fri,  9 Apr 2021 05:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617944821;
        bh=x9ZA2UlRzgj2GAX9PrmGX5S9DENir1yjYcGqTNtLTME=;
        h=Date:From:To:Subject:From;
        b=C4YjhnbwhBqyTYLRMK8Hd4W6+9MBg7sAb+CqTEbuPvmjR8kNgZOxl0We9iOcC6Y82
         r9MsJLj917dTg/GD8gl4WWOfS00VP+mwLnhr8CVrS+BmdTXeAGV5kQ+wcUXsNxK2ZC
         Up3hXUbO8mQg2/glFcyIIRDEGo+SxWaJ4xZwRI4c=
Date:   Thu, 08 Apr 2021 22:07:01 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, axelrasmussen@google.com,
        mm-commits@vger.kernel.org, nadav.amit@gmail.com, peterx@redhat.com
Subject:  [to-be-updated]
 userfaultfd-selftests-dropping-verify-check-in-locking_thread.patch removed
 from -mm tree
Message-ID: <20210409050701.K9KZa_4ch%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: drop VERIFY check in locking_thread
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftests-dropping-verify-check-in-locking_thread.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: userfaultfd/selftests: drop VERIFY check in locking_thread

It tries to check against all zeros and looped for quite a few times. 
However after that we'll verify the same page with count_verify, while
count_verify can never be zero.  So it means if it's a zero page we'll
detect it anyways with below code.

There's yet another place we conditionally check the fault flag - just do
it unconditionally.

Link: https://lkml.kernel.org/r/20210310004511.51996-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   55 ---------------------
 1 file changed, 1 insertion(+), 54 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-dropping-verify-check-in-locking_thread
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -616,58 +616,6 @@ static void *locking_thread(void *arg)
 		} else
 			page_nr += 1;
 		page_nr %= nr_pages;
-
-		if (bounces & BOUNCE_VERIFY) {
-			count = *area_count(area_dst, page_nr);
-			if (!count) {
-				fprintf(stderr,
-					"page_nr %lu wrong count %Lu %Lu\n",
-					page_nr, count,
-					count_verify[page_nr]);
-				exit(1);
-			}
-
-
-			/*
-			 * We can't use bcmp (or memcmp) because that
-			 * returns 0 erroneously if the memory is
-			 * changing under it (even if the end of the
-			 * page is never changing and always
-			 * different).
-			 */
-#if 1
-			if (!my_bcmp(area_dst + page_nr * page_size, zeropage,
-				     page_size)) {
-				fprintf(stderr,
-					"my_bcmp page_nr %lu wrong count %Lu %Lu\n",
-					page_nr, count, count_verify[page_nr]);
-				exit(1);
-			}
-#else
-			unsigned long loops;
-
-			loops = 0;
-			/* uncomment the below line to test with mutex */
-			/* pthread_mutex_lock(area_mutex(area_dst, page_nr)); */
-			while (!bcmp(area_dst + page_nr * page_size, zeropage,
-				     page_size)) {
-				loops += 1;
-				if (loops > 10)
-					break;
-			}
-			/* uncomment below line to test with mutex */
-			/* pthread_mutex_unlock(area_mutex(area_dst, page_nr)); */
-			if (loops) {
-				fprintf(stderr,
-					"page_nr %lu all zero thread %lu %p %lu\n",
-					page_nr, cpu, area_dst + page_nr * page_size,
-					loops);
-				if (loops > 10)
-					exit(1);
-			}
-#endif
-		}
-
 		pthread_mutex_lock(area_mutex(area_dst, page_nr));
 		count = *area_count(area_dst, page_nr);
 		if (count != count_verify[page_nr]) {
@@ -799,8 +747,7 @@ static void uffd_handle_page_fault(struc
 		stats->minor_faults++;
 	} else {
 		/* Missing page faults */
-		if (bounces & BOUNCE_VERIFY &&
-		    msg->arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_WRITE) {
+		if (msg->arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_WRITE) {
 			fprintf(stderr, "unexpected write fault\n");
 			exit(1);
 		}
_

Patches currently in -mm which might be from peterx@redhat.com are

hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share.patch
hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share-fix.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled-fix.patch
mm-hugetlb-move-flush_hugetlb_tlb_range-into-hugetlbh.patch
hugetlb-userfaultfd-unshare-all-pmds-for-hugetlbfs-when-register-wp.patch
userfaultfd-add-minor-fault-registration-mode-fix.patch
userfaultfd-selftests-only-dump-counts-if-mode-enabled.patch
userfaultfd-selftests-unify-error-handling.patch


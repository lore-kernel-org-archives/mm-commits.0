Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5C55C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9402E61C87
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:17:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbhGFTUH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:20:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231833AbhGFTUH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:20:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C24BB61C91;
        Tue,  6 Jul 2021 19:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599048;
        bh=OCdUKbbDzzwOCWWYQB04Cmjh66hbBR7E/bcN6lJEpJU=;
        h=Date:From:To:Subject:From;
        b=pU95JYZfxm7yo6gzWMWdY/U4kntTji9Tz5GQ/UVa4FYzbDXhGwmxxCmIyUbz6DA5n
         +UMPHdo+O7Q5fvP/PC3kIOfzjefxETImUuAsT2oG/PDZvSXt6zEwrMyY2o2wfJjM9R
         nTu0heiVOffs8jL3FIEwy9nfy5vgWHy9yAomXuzU=
Date:   Tue, 06 Jul 2021 12:17:27 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, almasrymina@google.com,
        axelrasmussen@google.com, bgeffon@google.com, dgilbert@redhat.com,
        hughd@google.com, jglisse@redhat.com, joe@perches.com,
        kirill@shutemov.name, lokeshgidra@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        oupton@google.com, peterx@redhat.com, rppt@linux.vnet.ibm.com,
        sfr@canb.auug.org.au, shli@fb.com, shuah@kernel.org,
        viro@zeniv.linux.org.uk, wangqing@vivo.com
Subject:  [merged]
 userfaultfd-selftests-dropping-verify-check-in-locking_thread.patch removed
 from -mm tree
Message-ID: <20210706191727.N43IHLEPQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: dropping VERIFY check in locking_thread
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftests-dropping-verify-check-in-locking_thread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: userfaultfd/selftests: dropping VERIFY check in locking_thread

It tries to check against all zeros and looped for quite a few times. 
However after that we'll verify the same page with count_verify, while
count_verify can never be zero.  So it means if it's a zero page we'll
detect it anyways with below code.

There's yet another place we conditionally check the fault flag - just do
it unconditionally.

Link: https://lkml.kernel.org/r/20210412232753.1012412-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
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

 tools/testing/selftests/vm/userfaultfd.c |   55 ---------------------
 1 file changed, 1 insertion(+), 54 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-dropping-verify-check-in-locking_thread
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -430,58 +430,6 @@ static void *locking_thread(void *arg)
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
@@ -613,8 +561,7 @@ static void uffd_handle_page_fault(struc
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



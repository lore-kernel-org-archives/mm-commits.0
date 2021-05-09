Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A797C433B4
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 04:10:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC1D56142D
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 04:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbhEIELE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 00:11:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229585AbhEIELC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 May 2021 00:11:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 131FF613FA;
        Sun,  9 May 2021 04:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620533399;
        bh=8ObyEW6yGEt206dYX/GYSZtBdRf1vXYBEF4iCK4F1lI=;
        h=Date:From:To:Subject:From;
        b=xupLHSSUlPij/7IRFrgjVfusb30CaH19WlRRs97FgjPEAPM419V2Lqv+IInMFuQPa
         6MI1L7T/awbWPolMmBn1QFzBltyCy9UbV0i1dMGTGMuCrpvYmUDdRUYb9sOgTxJYWJ
         U6NgAKuoqrYt6ys9Y1gRVpn04KpsRc1ySZmJPF/o=
Date:   Sat, 08 May 2021 21:09:58 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, almasrymina@google.com,
        axelrasmussen@google.com, bgeffon@google.com, dgilbert@redhat.com,
        hughd@google.com, jglisse@redhat.com, joe@perches.com,
        kirill@shutemov.name, lokeshgidra@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        oupton@google.com, peterx@redhat.com, rppt@linux.vnet.ibm.com,
        sfr@canb.auug.org.au, shli@fb.com, shuah@kernel.org,
        viro@zeniv.linux.org.uk, wangqing@vivo.com
Subject:  +
 userfaultfd-selftests-remove-the-time-check-on-delayed-uffd.patch added to
 -mm tree
Message-ID: <20210509040958.emeAN3ynW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: remove the time() check on delayed uffd
has been added to the -mm tree.  Its filename is
     userfaultfd-selftests-remove-the-time-check-on-delayed-uffd.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftests-remove-the-time-check-on-delayed-uffd.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftests-remove-the-time-check-on-delayed-uffd.patch

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
Subject: userfaultfd/selftests: remove the time() check on delayed uffd

There seems to have no guarantee that time() will return the same for the
two calls even if there's no delay, e.g.  when a fault is accidentally
crossing the changing of a second.  Meanwhile, this message is also not
helping that much since delay could happen with a lot of reasons, e.g.,
schedule latency of resolving thread.  It may not mean an issue with uffd.

Neither do I saw this error triggered either in the past runs.  Even if it
triggers, it'll be drown in all the rest of test logs.  Remove it.

Link: https://lkml.kernel.org/r/20210412232753.1012412-3-peterx@redhat.com
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

 tools/testing/selftests/vm/userfaultfd.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-remove-the-time-check-on-delayed-uffd
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -395,7 +395,6 @@ static void *locking_thread(void *arg)
 	unsigned long long count;
 	char randstate[64];
 	unsigned int seed;
-	time_t start;
 
 	if (bounces & BOUNCE_RANDOM) {
 		seed = (unsigned int) time(NULL) - bounces;
@@ -432,7 +431,6 @@ static void *locking_thread(void *arg)
 			page_nr += 1;
 		page_nr %= nr_pages;
 
-		start = time(NULL);
 		if (bounces & BOUNCE_VERIFY) {
 			count = *area_count(area_dst, page_nr);
 			if (!count) {
@@ -495,12 +493,6 @@ static void *locking_thread(void *arg)
 		count++;
 		*area_count(area_dst, page_nr) = count_verify[page_nr] = count;
 		pthread_mutex_unlock(area_mutex(area_dst, page_nr));
-
-		if (time(NULL) - start > 1)
-			fprintf(stderr,
-				"userfault too slow %ld "
-				"possible false positive with overcommit\n",
-				time(NULL) - start);
 	}
 
 	return NULL;
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


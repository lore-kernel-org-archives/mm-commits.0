Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B5F4C433B4
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 22:26:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F717611B0
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 22:26:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236588AbhERW1W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 May 2021 18:27:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232020AbhERW1V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 May 2021 18:27:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E735C60FE6;
        Tue, 18 May 2021 22:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621376762;
        bh=BOLVGYJQHgD1GGydmHtI2dHKRai+WNkWRuEtqp/YXA8=;
        h=Date:From:To:Subject:From;
        b=b1trbN5VDTJC3nIRvbvitt190zm+Dvbvz56pk9u0T3wBJl74J0JWZK2KzuFZgcx78
         53AVuZD0a5PON9YI61vGAVdqGr0e2s5QgUNDEomQgzU4zkIkYH9hc2D6aVsL9BDmBS
         Kmfrbq1sBmeOWyEDKsB0/N5tLVrkpQehygKpw7dI=
Date:   Tue, 18 May 2021 15:26:01 -0700
From:   akpm@linux-foundation.org
To:     axelrasmussen@google.com, mm-commits@vger.kernel.org,
        peterx@redhat.com
Subject:  +
 userfaultfd-selftests-reinitialize-test-context-in-each-test-fix.patch
 added to -mm tree
Message-ID: <20210518222601.UhrKjvyhi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd-selftests-reinitialize-test-context-in-each-test-fix
has been added to the -mm tree.  Its filename is
     userfaultfd-selftests-reinitialize-test-context-in-each-test-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftests-reinitialize-test-context-in-each-test-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftests-reinitialize-test-context-in-each-test-fix.patch

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
Subject: userfaultfd-selftests-reinitialize-test-context-in-each-test-fix

fix conflict between this patch and the uffd pagemap series

Link: https://lkml.kernel.org/r/YKQqKrl+/cQ1utrb@t490s
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-reinitialize-test-context-in-each-test-fix
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -1326,7 +1326,7 @@ static void userfaultfd_pagemap_test(uns
 	/* Flush so it doesn't flush twice in parent/child later */
 	fflush(stdout);
 
-	uffd_test_ops->release_pages(area_dst);
+	uffd_test_ctx_init(0);
 
 	if (test_pgsize > page_size) {
 		/* This is a thp test */
@@ -1338,9 +1338,6 @@ static void userfaultfd_pagemap_test(uns
 			err("madvise(MADV_NOHUGEPAGE) failed");
 	}
 
-	if (userfaultfd_open(0))
-		err("userfaultfd_open");
-
 	uffdio_register.range.start = (unsigned long) area_dst;
 	uffdio_register.range.len = nr_pages * page_size;
 	uffdio_register.mode = UFFDIO_REGISTER_MODE_WP;
@@ -1383,7 +1380,6 @@ static void userfaultfd_pagemap_test(uns
 	pagemap_check_wp(value, false);
 
 	close(pagemap_fd);
-	close(uffd);
 	printf("done\n");
 }
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-gup_benchmark-support-threading.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-fix.patch
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
userfaultfd-selftests-reinitialize-test-context-in-each-test-fix.patch


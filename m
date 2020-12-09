Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21B76C4167B
	for <mm-commits@archiver.kernel.org>; Wed,  9 Dec 2020 00:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E86C823B6B
	for <mm-commits@archiver.kernel.org>; Wed,  9 Dec 2020 00:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgLIAoK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Dec 2020 19:44:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:55654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730326AbgLIAoK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 8 Dec 2020 19:44:10 -0500
Date:   Tue, 08 Dec 2020 16:43:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607474600;
        bh=cuIH6lxPb6DrzlmpOJORZQtp+kDUntPD+nCoa7YeLKk=;
        h=From:To:Subject:From;
        b=G/v45LRISpc4q19uMgtplevAOadxAjaRj8zIaCkxH/jsuKWBsr3NaxxkhLGu/ZUsK
         R1OB6Pft1I+7fDFUjFrZra16waN4htiWQLBWAekfskru3l1erZN99KOy2KXuofyxj3
         QSV/Ipl6Dq7vdnZ5WzNulXs4k9T/QLN7mRmLYgVc=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com,
        aarcange@redhat.com, peterx@redhat.com
Subject:  +
 userfaultfd-selftests-fix-retval-check-for-userfaultfd_open.patch added to
 -mm tree
Message-ID: <20201209004319.WT-Wa%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: fix retval check for userfaultfd_open()
has been added to the -mm tree.  Its filename is
     userfaultfd-selftests-fix-retval-check-for-userfaultfd_open.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftests-fix-retval-check-for-userfaultfd_open.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftests-fix-retval-check-for-userfaultfd_open.patch

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
Subject: userfaultfd/selftests: fix retval check for userfaultfd_open()

userfaultfd_open() returns 1 for errors rather than negatives.  Fix it on
all the callers so when UFFDIO_API failed the test will bail out.

Link: https://lkml.kernel.org/r/20201208024709.7701-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-fix-retval-check-for-userfaultfd_open
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -1029,7 +1029,7 @@ static int userfaultfd_zeropage_test(voi
 	if (uffd_test_ops->release_pages(area_dst))
 		return 1;
 
-	if (userfaultfd_open(0) < 0)
+	if (userfaultfd_open(0))
 		return 1;
 	uffdio_register.range.start = (unsigned long) area_dst;
 	uffdio_register.range.len = nr_pages * page_size;
@@ -1079,7 +1079,7 @@ static int userfaultfd_events_test(void)
 
 	features = UFFD_FEATURE_EVENT_FORK | UFFD_FEATURE_EVENT_REMAP |
 		UFFD_FEATURE_EVENT_REMOVE;
-	if (userfaultfd_open(features) < 0)
+	if (userfaultfd_open(features))
 		return 1;
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 
@@ -1151,7 +1151,7 @@ static int userfaultfd_sig_test(void)
 		return 1;
 
 	features = UFFD_FEATURE_EVENT_FORK|UFFD_FEATURE_SIGBUS;
-	if (userfaultfd_open(features) < 0)
+	if (userfaultfd_open(features))
 		return 1;
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 
@@ -1231,7 +1231,7 @@ static int userfaultfd_stress(void)
 	if (!area_dst)
 		return 1;
 
-	if (userfaultfd_open(0) < 0)
+	if (userfaultfd_open(0))
 		return 1;
 
 	count_verify = malloc(nr_pages * sizeof(unsigned long long));
_

Patches currently in -mm which might be from peterx@redhat.com are

userfaultfd-selftests-always-dump-something-in-modes.patch
userfaultfd-selftests-fix-retval-check-for-userfaultfd_open.patch
userfaultfd-selftests-hint-the-test-runner-on-required-privilege.patch


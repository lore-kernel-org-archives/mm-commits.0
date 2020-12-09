Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6740C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Dec 2020 00:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2C2A23AA8
	for <mm-commits@archiver.kernel.org>; Wed,  9 Dec 2020 00:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730243AbgLIAoE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Dec 2020 19:44:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:55692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbgLIAoD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 8 Dec 2020 19:44:03 -0500
Date:   Tue, 08 Dec 2020 16:43:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607474603;
        bh=LPw8XF/jMhxcNS9PKKlSl6fCGJQFVUZjWHd36mAAYe8=;
        h=From:To:Subject:From;
        b=G4TZZkWV4YYntQTvgVsGDvk4o9eu5HFtPLInpgsKxoh5caUbc3ukwyA+Mfb0j6rj4
         DRzDJqhtY491f2qBX6wh7z8x1fhVblOnaYSuLjed23p3EeD6JS7wOMbqorowdj855h
         KAasKw2iIpnoNfFrZp2PaBOR3UzyUR3sazMp7fsU=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com,
        aarcange@redhat.com, peterx@redhat.com
Subject:  +
 userfaultfd-selftests-hint-the-test-runner-on-required-privilege.patch added
 to -mm tree
Message-ID: <20201209004322.yn4E7%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: hint the test runner on required privilege
has been added to the -mm tree.  Its filename is
     userfaultfd-selftests-hint-the-test-runner-on-required-privilege.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftests-hint-the-test-runner-on-required-privilege.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftests-hint-the-test-runner-on-required-privilege.patch

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
Subject: userfaultfd/selftests: hint the test runner on required privilege

Now userfaultfd test program requires either root or ptrace privilege due
to the signal/event tests.  When UFFDIO_API failed, hint the test runner
about this fact verbosely.

Link: https://lkml.kernel.org/r/20201208024709.7701-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-hint-the-test-runner-on-required-privilege
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -794,7 +794,8 @@ static int userfaultfd_open(int features
 	uffdio_api.api = UFFD_API;
 	uffdio_api.features = features;
 	if (ioctl(uffd, UFFDIO_API, &uffdio_api)) {
-		fprintf(stderr, "UFFDIO_API\n");
+		fprintf(stderr, "UFFDIO_API failed.\nPlease make sure to "
+			"run with either root or ptrace capability.\n");
 		return 1;
 	}
 	if (uffdio_api.api != UFFD_API) {
_

Patches currently in -mm which might be from peterx@redhat.com are

userfaultfd-selftests-always-dump-something-in-modes.patch
userfaultfd-selftests-fix-retval-check-for-userfaultfd_open.patch
userfaultfd-selftests-hint-the-test-runner-on-required-privilege.patch


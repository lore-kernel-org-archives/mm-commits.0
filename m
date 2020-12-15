Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A82FCC4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D71C22D05
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgLPAAZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:34570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730127AbgLOX1t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:27:49 -0500
Date:   Tue, 15 Dec 2020 15:24:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074652;
        bh=EZ1wVB+A8JUMGDKwU5GQLIQvqNo3VzLqwLTm7zcIirc=;
        h=From:To:Subject:From;
        b=toySUYyoqeMss1Kmt5xo4BhbCHy9cmSimyIjSQFh8/wKgifC1hHBoZJ2IQvwODdnj
         bmTgN9p/YAMFXQHX29wif9n2zHSYLR1OZO9Tn/gmYLYoJNR6NblzKy8KN2NQa3CEeT
         MOY21SAPYTrhLbr60Sri7hLrQkV6Vu5Zi4m4zjio=
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, mm-commits@vger.kernel.org, peterx@redhat.com,
        rppt@linux.vnet.ibm.com
Subject:  [merged]
 userfaultfd-selftests-hint-the-test-runner-on-required-privilege.patch
 removed from -mm tree
Message-ID: <20201215232412.9CYooqMyb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: hint the test runner on required privilege
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftests-hint-the-test-runner-on-required-privilege.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



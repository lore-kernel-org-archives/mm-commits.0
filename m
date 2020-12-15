Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86C01C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6184E223C8
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbgLODPj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:15:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:42832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727688AbgLODOt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:14:49 -0500
Date:   Mon, 14 Dec 2020 19:14:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608002049;
        bh=u7TzzMQBDwwpI7MWC0iskNj6ZmvXup5OdBQzSGEWpfI=;
        h=From:To:Subject:In-Reply-To:From;
        b=cvkl6+f1CFubgK9F2ogf9ySjfBiTpIcjfZzeiZRdfUjkuanv8rZOWlUFvlry54hqp
         pw/sWxJ00Eba0Hh5Vu83tWNeFD1sgcCeq23Ih2KEZDgEwPzEhiQ9r+KyQjiFDGoVdt
         8SFn1FbweEyyX3boGtKbOhDeZqsMN22sgv8ODY4Y=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org
Subject:  [patch 184/200] userfaultfd/selftests: hint the test
 runner on required privilege
Message-ID: <20201215031408.sg3WTH3UE%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

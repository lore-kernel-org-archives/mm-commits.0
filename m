Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1434C4743C
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 04:27:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DB3C6052B
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 04:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhFWE3d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Jun 2021 00:29:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhFWE3d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Jun 2021 00:29:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACD516135A;
        Wed, 23 Jun 2021 04:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624422435;
        bh=5h8g0hua6Ei1g37J4o5nZpV4YjoQxpiNvDBVxuEm9Bo=;
        h=Date:From:To:Subject:From;
        b=DHs7ivbzsvZ5E10xJvMX4wZA1+1xsKu6XwbowCWpZbIEo9h/pXhS6RuBuvo1hhkSU
         P8BJ2HeKdZoO1o0La/HjRtft+5VwVosYiKTdgZw0GvhSkdYgM/UliXRTYVM/GOGgm+
         LDL07UdwgYMs34F/c1CuObS6zeT1I1L4PMVavd1E=
Date:   Tue, 22 Jun 2021 21:27:15 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, dan.carpenter@oracle.com,
        mm-commits@vger.kernel.org, peterx@redhat.com
Subject:  + mm-device-exclusive-memory-access-fix.patch added to
 -mm tree
Message-ID: <20210623042715.GGD2wqfX4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: fix signedness bug in make_device_exclusive_range()
has been added to the -mm tree.  Its filename is
     mm-device-exclusive-memory-access-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-device-exclusive-memory-access-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-device-exclusive-memory-access-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: mm/rmap: fix signedness bug in make_device_exclusive_range()

The get_user_pages_remote() function returns a long type, but we are using
"unsigned long i;" as the list iterator.  If "npages" is -ENOMEM, the
comparison "i < npages" is type promoted and "npages" becomes a very high
positive value.  The loop will then iterate until the kernel crashes.

There are two ways to fix this.  Declare "i" as a long type or add an
explicit check for get_user_pages_remote() error returns.  Either approach
will work so let's do both.

Link: https://lkml.kernel.org/r/YNIz5NVnZ5GiZ3u1@mwanda
Fixes: fa1e686e5f53 ("mm: device exclusive memory access")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/rmap.c~mm-device-exclusive-memory-access-fix
+++ a/mm/rmap.c
@@ -2187,11 +2187,14 @@ int make_device_exclusive_range(struct m
 				void *owner)
 {
 	long npages = (end - start) >> PAGE_SHIFT;
-	unsigned long i;
+	long i;
 
 	npages = get_user_pages_remote(mm, start, npages,
 				       FOLL_GET | FOLL_WRITE | FOLL_SPLIT_PMD,
 				       pages, NULL, NULL);
+	if (npages < 0)
+		return npages;
+
 	for (i = 0; i < npages; i++, start += PAGE_SIZE) {
 		if (!trylock_page(pages[i])) {
 			put_page(pages[i]);
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

ocfs2-fix-snprintf-checking.patch
mm-thp-refactor-numa-fault-handling-fix.patch
mm-device-exclusive-memory-access-fix.patch


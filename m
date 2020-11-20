Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 594A6C6379D
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 23:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03AC72242A
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 23:54:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qrA8lGXP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbgKTXyj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Nov 2020 18:54:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:53688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgKTXyj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Nov 2020 18:54:39 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEB94223B0;
        Fri, 20 Nov 2020 23:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605916477;
        bh=SZkH6JzUPjJlaATchqwUrNBjcalfo5Tf2/7dLVwfjR8=;
        h=Date:From:To:Subject:From;
        b=qrA8lGXPo0tIa0iFhX0lmIG0icPJjSVxzeBX61N7XVpnKiD1WP7ihnh58ByUNvL/U
         wQ6sCMdRGJTuvWNN5Tkj8O8BqUDtZpQEQuU4N0bRe2GEi6KiqGmkhRuynk+Xt6Sjdh
         K02EXNQRL28hH6+kPIwUQA85Wl3hlgjTDwmj9YDo=
Date:   Fri, 20 Nov 2020 15:54:36 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de
Subject:  + mmhugetlb-remove-unneded-initialization.patch added to
 -mm tree
Message-ID: <20201120235436.cnYNEMzhX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hugetlb: remove unneded initialization
has been added to the -mm tree.  Its filename is
     mmhugetlb-remove-unneded-initialization.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhugetlb-remove-unneded-initialization.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhugetlb-remove-unneded-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hugetlb: remove unneded initialization

hugetlb_add_hstate initializes nr_huge_pages and free_huge_pages to 0, but
since hstates[] is a global variable, all its fields are defined to 0
already.

Link: https://lkml.kernel.org/r/20201119112141.6452-1-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/hugetlb.c~mmhugetlb-remove-unneded-initialization
+++ a/mm/hugetlb.c
@@ -3197,8 +3197,6 @@ void __init hugetlb_add_hstate(unsigned
 	h = &hstates[hugetlb_max_hstate++];
 	h->order = order;
 	h->mask = ~((1ULL << (order + PAGE_SHIFT)) - 1);
-	h->nr_huge_pages = 0;
-	h->free_huge_pages = 0;
 	for (i = 0; i < MAX_NUMNODES; ++i)
 		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
 	INIT_LIST_HEAD(&h->hugepage_activelist);
_

Patches currently in -mm which might be from osalvador@suse.de are

mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists-for-hugetlb.patch
mmhwpoison-drop-unneeded-pcplist-draining.patch
mmhugetlb-remove-unneded-initialization.patch


Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6762C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 20:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86489207DE
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 20:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597869182;
	bh=hPYeHFy8jEm2+elPJdkqMJnSmtYq2u0lL0pQ9xkwFEY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=aSffFPPzP8HGp+hoMfMmKR7K8/xCJq59Egc0cucOYJpzJrRzjQcYwinFNM5tVsbtB
	 nza7oBcA1IIO/4ktepQMcegaT6KMUpJjJ7yWK4SdEpRIJBYbLkDxlPCJkPcTTGnVBT
	 Kpo521Df/Hv6+N+lP+8f6qhoBPeR86wmmfC3dbHU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgHSUdC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 16:33:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726689AbgHSUdB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 16:33:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD217207DA;
        Wed, 19 Aug 2020 20:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597869179;
        bh=hPYeHFy8jEm2+elPJdkqMJnSmtYq2u0lL0pQ9xkwFEY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vyT++EKIOD81rim81A7hxwUJWQgmTjI9rJ+fyNckmJG290TNP3ZZclLXnLST8Mk7l
         NLH+H7BRz/TjwfOAqF88+WyGPTWGfFF5zZn6JfqXE4zXLmqXKEnD0HYiXHvvQn0E/s
         mHfxtNefg2OB+qry3sJQN2eTAejn1j4/LiFR2O0o=
Date:   Wed, 19 Aug 2020 13:32:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     cai@lca.pw, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  +
 mm-dump_page-rename-head_mapcount-head_compound_mapcount.patch added to -mm
 tree
Message-ID: <20200819203258.hzbX1vX6C%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, dump_page: rename head_mapcount() --> head_compound_mapcount()
has been added to the -mm tree.  Its filename is
     mm-dump_page-rename-head_mapcount-head_compound_mapcount.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-dump_page-rename-head_mapcount-head_compound_mapcount.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-dump_page-rename-head_mapcount-head_compound_mapcount.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm, dump_page: rename head_mapcount() --> head_compound_mapcount()

Rename head_pincount() --> head_compound_pincount().  These names are more
accurate (or less misleading) than the original ones.

Link: https://lkml.kernel.org/r/20200807183358.105097-1-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    8 ++++----
 mm/debug.c         |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/mm.h~mm-dump_page-rename-head_mapcount-head_compound_mapcount
+++ a/include/linux/mm.h
@@ -776,7 +776,7 @@ static inline void *kvcalloc(size_t n, s
 extern void kvfree(const void *addr);
 extern void kvfree_sensitive(const void *addr, size_t len);
 
-static inline int head_mapcount(struct page *head)
+static inline int head_compound_mapcount(struct page *head)
 {
 	return atomic_read(compound_mapcount_ptr(head)) + 1;
 }
@@ -790,7 +790,7 @@ static inline int compound_mapcount(stru
 {
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
 	page = compound_head(page);
-	return head_mapcount(page);
+	return head_compound_mapcount(page);
 }
 
 /*
@@ -903,7 +903,7 @@ static inline bool hpage_pincount_availa
 	return PageCompound(page) && compound_order(page) > 1;
 }
 
-static inline int head_pincount(struct page *head)
+static inline int head_compound_pincount(struct page *head)
 {
 	return atomic_read(compound_pincount_ptr(head));
 }
@@ -912,7 +912,7 @@ static inline int compound_pincount(stru
 {
 	VM_BUG_ON_PAGE(!hpage_pincount_available(page), page);
 	page = compound_head(page);
-	return head_pincount(page);
+	return head_compound_pincount(page);
 }
 
 static inline void set_compound_order(struct page *page, unsigned int order)
--- a/mm/debug.c~mm-dump_page-rename-head_mapcount-head_compound_mapcount
+++ a/mm/debug.c
@@ -102,12 +102,12 @@ void __dump_page(struct page *page, cons
 		if (hpage_pincount_available(page)) {
 			pr_warn("head:%p order:%u compound_mapcount:%d compound_pincount:%d\n",
 					head, compound_order(head),
-					head_mapcount(head),
-					head_pincount(head));
+					head_compound_mapcount(head),
+					head_compound_pincount(head));
 		} else {
 			pr_warn("head:%p order:%u compound_mapcount:%d\n",
 					head, compound_order(head),
-					head_mapcount(head));
+					head_compound_mapcount(head));
 		}
 	}
 	if (PageKsm(page))
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-dump_page-rename-head_mapcount-head_compound_mapcount.patch


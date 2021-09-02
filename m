Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7541C43217
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5B42610A2
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347855AbhIBVzA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:55:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347834AbhIBVzA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:55:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC562610A1;
        Thu,  2 Sep 2021 21:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619641;
        bh=02wFzcaC2UpjSQA0uE2887G1VqFD8TWTrZD4W1u3ZRY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=TPIDlR+V/1/uZKr/10Wb8MHX/BhRspUDi9bwOxAlyVfj/TiuTkWybMSf/IFV4QLjO
         mdNE7GDJl2LjGQVGYeKEA4jrtmvxb4L1yuTWJZqQ5SfEO6cR/LXu12MaZSKWabHqmK
         ti1WrzvBV9feCRbsRev3GOnIOz0mzb/RiYUCdWYk=
Date:   Thu, 02 Sep 2021 14:54:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
        davem@davemloft.net, david@redhat.com, dfeng@redhat.com,
        emunson@mgebm.net, eparis@redhat.com, hch@lst.de,
        jhubbard@nvidia.com, jmorris@namei.org, linux-mm@kvack.org,
        mgorman@suse.de, michaelc@cs.wisc.edu, mm-commits@vger.kernel.org,
        msalter@redhat.com, neilb@suse.de, riel@redhat.com,
        sebastian@breakpoint.cc, torvalds@linux-foundation.org,
        Trond.Myklebust@netapp.com
Subject:  [patch 077/212] mm: delete unused get_kernel_page()
Message-ID: <20210902215400.MKqSo06km%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>
Subject: mm: delete unused get_kernel_page()

get_kernel_page() was added in 2012 by [1].  It was used for a while for
NFS, but then in 2014, a refactoring [2] removed all callers, and it has
apparently not been used since.

Remove get_kernel_page() because it has no callers.

[1] commit 18022c5d8627 ("mm: add get_kernel_page[s] for pinning of
    kernel addresses for I/O")
[2] commit 91f79c43d1b5 ("new helper: iov_iter_get_pages_alloc()")

Link: https://lkml.kernel.org/r/20210729221847.1165665-1-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Neil Brown <neilb@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Xiaotian Feng <dfeng@redhat.com>
Cc: Mark Salter <msalter@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 mm/swap.c          |   22 ----------------------
 2 files changed, 23 deletions(-)

--- a/include/linux/mm.h~mm-delete-unused-get_kernel_page
+++ a/include/linux/mm.h
@@ -1839,7 +1839,6 @@ int __account_locked_vm(struct mm_struct
 struct kvec;
 int get_kernel_pages(const struct kvec *iov, int nr_pages, int write,
 			struct page **pages);
-int get_kernel_page(unsigned long start, int write, struct page **pages);
 struct page *get_dump_page(unsigned long addr);
 
 extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
--- a/mm/swap.c~mm-delete-unused-get_kernel_page
+++ a/mm/swap.c
@@ -179,28 +179,6 @@ int get_kernel_pages(const struct kvec *
 }
 EXPORT_SYMBOL_GPL(get_kernel_pages);
 
-/*
- * get_kernel_page() - pin a kernel page in memory
- * @start:	starting kernel address
- * @write:	pinning for read/write, currently ignored
- * @pages:	array that receives pointer to the page pinned.
- *		Must be at least nr_segs long.
- *
- * Returns 1 if page is pinned. If the page was not pinned, returns
- * -errno. The page returned must be released with a put_page() call
- * when it is finished with.
- */
-int get_kernel_page(unsigned long start, int write, struct page **pages)
-{
-	const struct kvec kiov = {
-		.iov_base = (void *)start,
-		.iov_len = PAGE_SIZE
-	};
-
-	return get_kernel_pages(&kiov, 1, write, pages);
-}
-EXPORT_SYMBOL_GPL(get_kernel_page);
-
 static void pagevec_lru_move_fn(struct pagevec *pvec,
 	void (*move_fn)(struct page *page, struct lruvec *lruvec))
 {
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B14C4338F
	for <mm-commits@archiver.kernel.org>; Thu, 29 Jul 2021 22:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 285B4604D7
	for <mm-commits@archiver.kernel.org>; Thu, 29 Jul 2021 22:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhG2WeR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Jul 2021 18:34:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229707AbhG2WeQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 29 Jul 2021 18:34:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2F8E60F46;
        Thu, 29 Jul 2021 22:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627598053;
        bh=DPvMyhlwgM4/kKV/pYEvgJ7opt5owB/b8K1OGxEXB7w=;
        h=Date:From:To:Subject:From;
        b=WRIIWi6qG8chFO7eLCzEeGYObJ6F7l/fz8O8cqnOx+9jCQetsIMsagxvSPUuvmTuQ
         xaWqA7rG1yHW8bQ+CG/XeARUTl8uepEhTdFrM99hEWeKyvEiBjm8R7D+KJPmz9YocJ
         cDHUpznK9d4eBc4NOycF/qfbv/kbo/A4uWnWlk2E=
Date:   Thu, 29 Jul 2021 15:34:10 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, Trond.Myklebust@netapp.com,
        sebastian@breakpoint.cc, riel@redhat.com, neilb@suse.de,
        msalter@redhat.com, michaelc@cs.wisc.edu, mgorman@suse.de,
        jmorris@namei.org, hch@infradead.org, eparis@redhat.com,
        emunson@mgebm.net, dfeng@redhat.com, davem@davemloft.net,
        a.p.zijlstra@chello.nl, jhubbard@nvidia.com
Subject:  + mm-delete-unused-get_kernel_page.patch added to -mm tree
Message-ID: <20210729223410.LIVGO%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: delete unused get_kernel_page()
has been added to the -mm tree.  Its filename is
     mm-delete-unused-get_kernel_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-delete-unused-get_kernel_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-delete-unused-get_kernel_page.patch

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
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
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
@@ -1815,7 +1815,6 @@ int __account_locked_vm(struct mm_struct
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

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-delete-unused-get_kernel_page.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF748C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 22:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABD05610FB
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 22:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhJRWSc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Oct 2021 18:18:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233609AbhJRWSb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 Oct 2021 18:18:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C63396115A;
        Mon, 18 Oct 2021 22:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634595380;
        bh=FCtV4rn/6sadmJF0aTEsgk1hqjFn5VJOJwh/dNESo0o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=06d1jAX3902/IuyPNfCxU6SPQtwy8OF01SxN+Z3ppN3usmdi7twPBIXt7YFfrBgS/
         nrMIWkUxIEG4dsdaw3JhfcXqACHGYocti+lLK0qiEsfx+gBwI284FIFvgF0ARn90a7
         O5HucgCY3m+4GAT7tZCaKdbBJXADXNNsjvPAvVeA=
Date:   Mon, 18 Oct 2021 15:16:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, hdanton@sina.com,
        hughd@google.com, kirill.shutemov@linux.intel.com,
        linux-mm@kvack.org, m.szyprowski@samsung.com,
        mm-commits@vger.kernel.org, oleg@redhat.com, riel@surriel.com,
        sfoon.kim@samsung.com, shy828301@gmail.com, songliubraving@fb.com,
        torvalds@linux-foundation.org, william.kucharski@oracle.com,
        willy@infradead.org
Subject:  [patch 18/19] mm/thp: decrease nr_thps in file's mapping
 on THP split
Message-ID: <20211018221619.39ukJuTKQ%akpm@linux-foundation.org>
In-Reply-To: <20211018151438.f2246e2656c041b6753a8bdd@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: mm/thp: decrease nr_thps in file's mapping on THP split

Decrease nr_thps counter in file's mapping to ensure that the page cache
won't be dropped excessively on file write access if page has been
already split.

I've tried a test scenario, where one runs a big binary, kernel remaps it
with THPs, then one forces THP split with
/sys/kernel/debug/split_huge_pages.  During any further open of that
binary with O_RDWR or O_WRITEONLY kernel drops page cache for it, because
of non-zero thps counter.

Link: https://lkml.kernel.org/r/20211012120237.2600-1-m.szyprowski@samsung.com
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: 09d91cda0e82 ("mm,thp: avoid writes to file with THP in pagecache")
Fixes: 06d3eff62d9d ("mm/thp: fix node page state in split_huge_page_to_list()")
Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: <sfoon.kim@samsung.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-thp-decrease-nr_thps-in-files-mapping-on-thp-split
+++ a/mm/huge_memory.c
@@ -2700,12 +2700,14 @@ int split_huge_page_to_list(struct page
 		if (mapping) {
 			int nr = thp_nr_pages(head);
 
-			if (PageSwapBacked(head))
+			if (PageSwapBacked(head)) {
 				__mod_lruvec_page_state(head, NR_SHMEM_THPS,
 							-nr);
-			else
+			} else {
 				__mod_lruvec_page_state(head, NR_FILE_THPS,
 							-nr);
+				filemap_nr_thps_dec(mapping);
+			}
 		}
 
 		__split_huge_page(page, list, end);
_

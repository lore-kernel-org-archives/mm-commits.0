Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E9A1C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 18:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56EA7610E5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 18:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234983AbhJSSmE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Oct 2021 14:42:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234991AbhJSSmA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Oct 2021 14:42:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBD386128B;
        Tue, 19 Oct 2021 18:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634668787;
        bh=0+AcOk9JgA37M7KqHC2qc8ZMZmSnkNHHgOSQfGiww/I=;
        h=Date:From:To:Subject:From;
        b=E8RBxOv70Pmu/tGqeDPJodyR148aQMAGQT31+fJ/xpU+5Y1UsEEx9V6kliK57b6Hf
         wLKdoAXTL5PMePWzryMFdYcXOLIkrXGwxRu2oYpZxUYGU+fao4OhuV+oe3JjOf/Nnf
         yfVjLcEQ45aJxRSFJ/kHUeVgHGvyJCSL6zevY+g0=
Date:   Tue, 19 Oct 2021 11:39:46 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, hdanton@sina.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, m.szyprowski@samsung.com,
        mm-commits@vger.kernel.org, oleg@redhat.com, riel@surriel.com,
        sfoon.kim@samsung.com, shy828301@gmail.com, songliubraving@fb.com,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [merged]
 mm-thp-decrease-nr_thps-in-files-mapping-on-thp-split.patch removed from
 -mm tree
Message-ID: <20211019183946.ZezFUS-84%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: decrease nr_thps in file's mapping on THP split
has been removed from the -mm tree.  Its filename was
     mm-thp-decrease-nr_thps-in-files-mapping-on-thp-split.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from m.szyprowski@samsung.com are



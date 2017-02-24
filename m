From: akpm@linux-foundation.org
Subject: [patch 089/124] mm: do not access page->mapping directly on
 page_endio
Date: Fri, 24 Feb 2017 14:59:59 -0800
Message-ID: <58b0baef.VQvJojC4/dGeAwHY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38874 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751676AbdBXXAB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 18:00:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, minchan@kernel.org, mhocko@suse.com, stable@vger.kernel.org, willy@infradead.org

From: Minchan Kim <minchan@kernel.org>
Subject: mm: do not access page->mapping directly on page_endio

With rw_page, page_endio is used for completing IO on a page and it
propagates write error to the address space if the IO fails.  The
problem is it accesses page->mapping directly which might be okay for
file-backed pages but it shouldn't for anonymous page.  Otherwise, it
can corrupt one of field from anon_vma under us and system goes panic
randomly.

swap_writepage
  bdev_writepage
    ops->rw_page

I encountered the BUG during developing new zram feature and it was
really hard to figure it out because it made random crash, somtime
mmap_sem lockdep, sometime other places where places never related to
zram/zsmalloc, and not reproducible with some configuration.

When I consider how that bug is subtle and people do fast-swap test
with brd, it's worth to add stable mark, I think.

Fixes: dd6bd0d9c7db ("swap: use bdev_read_page() / bdev_write_page()")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/filemap.c~mm-do-not-access-page-mapping-directly-on-page_endio mm/filemap.c
--- a/mm/filemap.c~mm-do-not-access-page-mapping-directly-on-page_endio
+++ a/mm/filemap.c
@@ -1008,9 +1008,12 @@ void page_endio(struct page *page, bool
 		unlock_page(page);
 	} else {
 		if (err) {
+			struct address_space *mapping;
+
 			SetPageError(page);
-			if (page->mapping)
-				mapping_set_error(page->mapping, err);
+			mapping = page_mapping(page);
+			if (mapping)
+				mapping_set_error(mapping, err);
 		}
 		end_page_writeback(page);
 	}
_

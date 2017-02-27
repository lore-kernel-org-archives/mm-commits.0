From: akpm@linux-foundation.org
Subject: [merged]
 mm-do-not-access-page-mapping-directly-on-page_endio.patch removed from -mm tree
Date: Mon, 27 Feb 2017 12:28:06 -0800
Message-ID: <58b48bd6.aaUGwrLa5GcPtCQ9%akpm__27324.3611366071$1488227378$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60478 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751995AbdB0U2S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:28:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mhocko@suse.com, stable@vger.kernel.org, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not access page->mapping directly on page_endio
has been removed from the -mm tree.  Its filename was
     mm-do-not-access-page-mapping-directly-on-page_endio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from minchan@kernel.org are



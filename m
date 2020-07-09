From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-handle-page-mapping-better-in-dump_page.patch added
 to -mm tree
Date: Thu, 09 Jul 2020 16:09:20 -0700
Message-ID: <20200709230920.Wdvrron7U%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbgGIXJW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jul 2020 19:09:22 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhubbard@nvidia.com, kirill@shutemov.name, mm-commits@vger.kernel.org, rppt@linux.ibm.com, vbabka@suse.cz, william.kucharski@oracle.com, willy@infradead.org


The patch titled
     Subject: mm/debug: handle page->mapping better in dump_page
has been added to the -mm tree.  Its filename is
     mm-handle-page-mapping-better-in-dump_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-handle-page-mapping-better-in-dump_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-handle-page-mapping-better-in-dump_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/debug: handle page->mapping better in dump_page

Patch series "Improvements for dump_page()", v2.

Here's a sample dump of a pagecache tail page with all of the patches
applied:

page:000000006d1c49ca refcount:6 mapcount:0 mapping:00000000136b8d90 index:0x109 pfn:0x6c645
head:000000008bd38076 order:2 compound_mapcount:0 compound_pincount:0
aops:xfs_address_space_operations ino:800042 dentry name:"fd"
flags: 0x4000000000012014(uptodate|lru|private|head)
raw: 4000000000000000 ffffd46ac1b19101 ffffffff00000202 dead000000000004
raw: 0000000000000001 0000000000000000 00000000ffffffff 0000000000000000
head: 4000000000012014 ffffd46ac1b1bbc8 ffffd46ac1b1bc08 ffff91976f659560
head: 0000000000000108 ffff919773220680 00000006ffffffff 0000000000000000
page dumped because: testing


This patch (of 6):

If we can't call page_mapping() to get the page mapping, handle the
anon/ksm/movable bits correctly.

Link: http://lkml.kernel.org/r/20200709202117.7216-1-willy@infradead.org
Link: http://lkml.kernel.org/r/20200709202117.7216-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/debug.c~mm-handle-page-mapping-better-in-dump_page
+++ a/mm/debug.c
@@ -70,7 +70,12 @@ void __dump_page(struct page *page, cons
 
 	if (page < head || (page >= head + MAX_ORDER_NR_PAGES)) {
 		/* Corrupt page, cannot call page_mapping */
-		mapping = page->mapping;
+		unsigned long tmp = (unsigned long)page->mapping;
+
+		if (tmp & PAGE_MAPPING_ANON)
+			mapping = NULL;
+		else
+			mapping = (void *)(tmp & ~PAGE_MAPPING_FLAGS);
 		head = page;
 		compound = false;
 	} else {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-handle-page-mapping-better-in-dump_page.patch
mm-dump-compound-page-information-on-a-second-line.patch
mm-print-head-flags-in-dump_page.patch
mm-switch-dump_page-to-get_kernel_nofault.patch
mm-print-the-inode-number-in-dump_page.patch
mm-print-hashed-address-of-struct-page.patch
vmalloc-convert-to-xarray.patch
mm-store-compound_nr-as-well-as-compound_order.patch
mm-move-page-flags-include-to-top-of-file.patch
mm-add-thp_order.patch
mm-add-thp_size.patch
mm-replace-hpage_nr_pages-with-thp_nr_pages.patch
mm-add-thp_head.patch
mm-introduce-offset_in_thp.patch

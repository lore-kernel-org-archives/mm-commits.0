From: akpm@linux-foundation.org
Subject: [patch 06/20] mm: avoid endless recursion in dump_page()
Date: Mon, 19 Sep 2016 15:12:15 -0700
Message-ID: <57e062bf.PMiqzLOtb2MtbK51%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53427 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751032AbcISWMQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Sep 2016 18:12:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: avoid endless recursion in dump_page()

dump_page() uses page_mapcount() to get mapcount of the page.
page_mapcount() has VM_BUG_ON_PAGE(PageSlab(page)) as mapcount doesn't
make sense for slab pages and the field in struct page used for other
information.

It leads to recursion if dump_page() called for slub page and DEBUG_VM
is enabled:

dump_page() -> page_mapcount() -> VM_BUG_ON_PAGE() -> dump_page -> ...

Let's avoid calling page_mapcount() for slab pages in dump_page().

Link: http://lkml.kernel.org/r/20160908082137.131076-1-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/debug.c~mm-avoid-endless-recursion-in-dump_page mm/debug.c
--- a/mm/debug.c~mm-avoid-endless-recursion-in-dump_page
+++ a/mm/debug.c
@@ -42,9 +42,11 @@ const struct trace_print_flags vmaflag_n
 
 void __dump_page(struct page *page, const char *reason)
 {
+	int mapcount = PageSlab(page) ? 0 : page_mapcount(page);
+
 	pr_emerg("page:%p count:%d mapcount:%d mapping:%p index:%#lx",
-		  page, page_ref_count(page), page_mapcount(page),
-		  page->mapping, page->index);
+		  page, page_ref_count(page), mapcount,
+		  page->mapping, page_to_pgoff(page));
 	if (PageCompound(page))
 		pr_cont(" compound_mapcount: %d", compound_mapcount(page));
 	pr_cont("\n");
_

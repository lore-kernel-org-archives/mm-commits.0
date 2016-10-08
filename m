From: akpm@linux-foundation.org
Subject: [patch 096/127] mm: clarify why we avoid page_mapcount() for slab pages in dump_page()
Date: Fri, 07 Oct 2016 17:01:40 -0700
Message-ID: <57f83764.tUrayJrsrrlNWZlI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39475 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932764AbcJHABl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:01:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, vbabka@suse.cz

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: clarify why we avoid page_mapcount() for slab pages in dump_page()

Let's add comment on why we skip page_mapcount() for sl[aou]b pages.

Link: http://lkml.kernel.org/r/20160922105532.GB24593@node
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/debug.c~mm-clarify-why-we-avoid-page_mapcount-for-slab-pages-in-dump_page mm/debug.c
--- a/mm/debug.c~mm-clarify-why-we-avoid-page_mapcount-for-slab-pages-in-dump_page
+++ a/mm/debug.c
@@ -42,6 +42,11 @@ const struct trace_print_flags vmaflag_n
 
 void __dump_page(struct page *page, const char *reason)
 {
+	/*
+	 * Avoid VM_BUG_ON() in page_mapcount().
+	 * page->_mapcount space in struct page is used by sl[aou]b pages to
+	 * encode own info.
+	 */
 	int mapcount = PageSlab(page) ? 0 : page_mapcount(page);
 
 	pr_emerg("page:%p count:%d mapcount:%d mapping:%p index:%#lx",
_

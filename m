From: akpm@linux-foundation.org
Subject: [merged]
 mm-clarify-why-we-avoid-page_mapcount-for-slab-pages-in-dump_page.patch
 removed from -mm tree
Date: Mon, 10 Oct 2016 15:46:23 -0700
Message-ID: <57fc1a3f.vqN6B1b9M7bdItnq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37255 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752183AbcJJWqY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:46:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clarify why we avoid page_mapcount() for slab pages in dump_page()
has been removed from the -mm tree.  Its filename was
     mm-clarify-why-we-avoid-page_mapcount-for-slab-pages-in-dump_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are



From: akpm@linux-foundation.org
Subject: +
 mm-clarify-why-we-avoid-page_mapcount-for-slab-pages-in-dump_page.patch
 added to -mm tree
Date: Tue, 27 Sep 2016 14:59:22 -0700
Message-ID: <57eaebba.OP0SkCiiRfhCLj0X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47254 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752466AbcI0V7X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 27 Sep 2016 17:59:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clarify why we avoid page_mapcount() for slab pages in dump_page()
has been added to the -mm tree.  Its filename is
     mm-clarify-why-we-avoid-page_mapcount-for-slab-pages-in-dump_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-clarify-why-we-avoid-page_mapcount-for-slab-pages-in-dump_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-clarify-why-we-avoid-page_mapcount-for-slab-pages-in-dump_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-clarify-why-we-avoid-page_mapcount-for-slab-pages-in-dump_page.patch


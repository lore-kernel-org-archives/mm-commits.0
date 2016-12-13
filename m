From: akpm@linux-foundation.org
Subject: [patch 080/123] mm, debug: print raw struct page data in
 __dump_page()
Date: Mon, 12 Dec 2016 16:44:35 -0800
Message-ID: <584f4473.0u2Psug1COKbUy01%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41582 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932282AbcLMAog (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:44:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vbabka@suse.cz, aryabinin@virtuozzo.com, kirill.shutemov@linux.intel.com

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, debug: print raw struct page data in __dump_page()

__dump_page() is used when a page metadata inconsistency is detected,
either by standard runtime checks, or extra checks in CONFIG_DEBUG_VM
builds.  It prints some of the relevant metadata, but not the whole struct
page, which is based on unions and interpretation is dependent on the
context.

This means that sometimes e.g.  a VM_BUG_ON_PAGE() checks certain field,
which is however not printed by __dump_page() and the resulting bug report
may then lack clues that could help in determining the root cause.  This
patch solves the problem by simply printing the whole struct page word by
word, so no part is missing, but the interpretation of the data is left to
developers.  This is similar to e.g.  x86_64 raw stack dumps.

Example output:

 page:ffffea00000475c0 count:1 mapcount:0 mapping:          (null) index:0x0
 flags: 0x100000000000400(reserved)
 raw: 0100000000000400 0000000000000000 0000000000000000 00000001ffffffff
 raw: ffffea00000475e0 ffffea00000475e0 0000000000000000 0000000000000000
 page dumped because: VM_BUG_ON_PAGE(1)

[aryabinin@virtuozzo.com: suggested print_hex_dump()]
Link: http://lkml.kernel.org/r/2ff83214-70fe-741e-bf05-fe4a4073ec3e@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/debug.c~mm-debug-print-raw-struct-page-data-in-__dump_page mm/debug.c
--- a/mm/debug.c~mm-debug-print-raw-struct-page-data-in-__dump_page
+++ a/mm/debug.c
@@ -59,6 +59,10 @@ void __dump_page(struct page *page, cons
 
 	pr_emerg("flags: %#lx(%pGp)\n", page->flags, &page->flags);
 
+	print_hex_dump(KERN_ALERT, "raw: ", DUMP_PREFIX_NONE, 32,
+			sizeof(unsigned long), page,
+			sizeof(struct page), false);
+
 	if (reason)
 		pr_alert("page dumped because: %s\n", reason);
 
_

From: akpm@linux-foundation.org
Subject: [patch 18/51] mm: meminit: mark init_reserved_page as __meminit
Date: Tue, 03 Oct 2017 16:15:10 -0700
Message-ID: <59d419fe.HjSTfEbgrvfumO7i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58548 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXPL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:15:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, arnd@arndb.de, mgorman@techsingularity.net

From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: meminit: mark init_reserved_page as __meminit

The function is called from __meminit context and calls other __meminit
functions but isn't it self mark as such today:

WARNING: vmlinux.o(.text.unlikely+0x4516): Section mismatch in reference from the function init_reserved_page() to the function .meminit.text:early_pfn_to_nid()
The function init_reserved_page() references
the function __meminit early_pfn_to_nid().
This is often because init_reserved_page lacks a __meminit
annotation or the annotation of early_pfn_to_nid is wrong.

On most compilers, we don't notice this because the function gets inlined
all the time.  Adding __meminit here fixes the harmless warning for the
old versions and is generally the correct annotation.

Link: http://lkml.kernel.org/r/20170915193149.901180-1-arnd@arndb.de
Fixes: 7e18adb4f80b ("mm: meminit: initialise remaining struct pages in parallel with kswapd")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-meminit-mark-init_reserved_page-as-__meminit mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-mark-init_reserved_page-as-__meminit
+++ a/mm/page_alloc.c
@@ -1190,7 +1190,7 @@ static void __meminit __init_single_pfn(
 }
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
-static void init_reserved_page(unsigned long pfn)
+static void __meminit init_reserved_page(unsigned long pfn)
 {
 	pg_data_t *pgdat;
 	int nid, zid;
_

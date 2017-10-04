From: akpm@linux-foundation.org
Subject: [merged]
 mm-meminit-mark-init_reserved_page-as-__meminit.patch removed from -mm tree
Date: Wed, 04 Oct 2017 12:40:43 -0700
Message-ID: <20171004194043.Z_ejXYSKj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33454 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdJDTko (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 15:40:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: meminit: mark init_reserved_page as __meminit
has been removed from the -mm tree.  Its filename was
     mm-meminit-mark-init_reserved_page-as-__meminit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from arnd@arndb.de are

of-provide-of_n_addrsize_cells-wrappers-for-config_of.patch
iopoll-avoid-wint-in-bool-context-warning.patch
pcmcia-badge4-avoid-unused-function-warning.patch


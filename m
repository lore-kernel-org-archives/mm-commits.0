From: akpm@linux-foundation.org
Subject: + mm-meminit-mark-init_reserved_page-as-__meminit.patch added to
 -mm tree
Date: Fri, 15 Sep 2017 12:35:23 -0700
Message-ID: <59bc2b7b.BTo7DNNYgDIsY/Q/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60790 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751623AbdIOTfY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2017 15:35:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: meminit: mark init_reserved_page as __meminit
has been added to the -mm tree.  Its filename is
     mm-meminit-mark-init_reserved_page-as-__meminit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-meminit-mark-init_reserved_page-as-__meminit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-meminit-mark-init_reserved_page-as-__meminit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-meminit-mark-init_reserved_page-as-__meminit.patch
iopoll-avoid-wint-in-bool-context-warning.patch


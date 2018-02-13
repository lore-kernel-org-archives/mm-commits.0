From: akpm@linux-foundation.org
Subject: + mm-initialize-pages-on-demand-during-boot-fix2.patch added to
 -mm tree
Date: Mon, 12 Feb 2018 16:22:11 -0800
Message-ID: <5a822fb3.ntF/kXEoitQS551Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52234 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932792AbeBMAWM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Feb 2018 19:22:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-initialize-pages-on-demand-during-boot-fix2
has been added to the -mm tree.  Its filename is
     mm-initialize-pages-on-demand-during-boot-fix2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-initialize-pages-on-demand-during-boot-fix2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-initialize-pages-on-demand-during-boot-fix2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: mm-initialize-pages-on-demand-during-boot-fix2

fix min() type mismatch warning

Link: http://lkml.kernel.org/r/20180212164543.26592-1-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-initialize-pages-on-demand-during-boot-fix2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-initialize-pages-on-demand-during-boot-fix2
+++ a/mm/page_alloc.c
@@ -6341,8 +6341,8 @@ void __paginginit free_area_init_node(in
 	 * We start only with one section of pages, more pages are added as
 	 * needed until the rest of deferred pages are initialized.
 	 */
-	pgdat->static_init_pgcnt = min(PAGES_PER_SECTION,
-				       pgdat->node_spanned_pages);
+	pgdat->static_init_pgcnt = min_t(unsigned long, PAGES_PER_SECTION,
+					 pgdat->node_spanned_pages);
 	pgdat->first_deferred_pfn = ULONG_MAX;
 #endif
 	free_area_init_core(pgdat);
_

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

mm-initialize-pages-on-demand-during-boot.patch
mm-initialize-pages-on-demand-during-boot-fix2.patch
sparc64-ng4-memset-32-bits-overflow.patch


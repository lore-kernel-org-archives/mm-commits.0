From: akpm@linux-foundation.org
Subject: + fix-print-order-in-show_free_areas.patch added to -mm tree
Date: Mon, 03 Apr 2017 15:11:17 -0700
Message-ID: <58e2c885.fYYyNuCxKh7sHx78%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53294 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751883AbdDCWLS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2017 18:11:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apolyakov@beget.ru, apolyakov@beget.com, mgorman@techsingularity.net, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mmpage_alloc.c: fix print order in show_free_areas()
has been added to the -mm tree.  Its filename is
     fix-print-order-in-show_free_areas.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fix-print-order-in-show_free_areas.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fix-print-order-in-show_free_areas.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Polakov <apolyakov@beget.ru>
Subject: mmpage_alloc.c: fix print order in show_free_areas()

Fixes: 11fb998986a72a ("mm: move most file-based accounting to the node")
Link: http://lkml.kernel.org/r/1490377730.30219.2.camel@beget.ru
Signed-off-by: Alexander Polyakov <apolyakov@beget.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~fix-print-order-in-show_free_areas mm/page_alloc.c
--- a/mm/page_alloc.c~fix-print-order-in-show_free_areas
+++ a/mm/page_alloc.c
@@ -4519,13 +4519,13 @@ void show_free_areas(unsigned int filter
 			K(node_page_state(pgdat, NR_FILE_MAPPED)),
 			K(node_page_state(pgdat, NR_FILE_DIRTY)),
 			K(node_page_state(pgdat, NR_WRITEBACK)),
+			K(node_page_state(pgdat, NR_SHMEM)),
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 			K(node_page_state(pgdat, NR_SHMEM_THPS) * HPAGE_PMD_NR),
 			K(node_page_state(pgdat, NR_SHMEM_PMDMAPPED)
 					* HPAGE_PMD_NR),
 			K(node_page_state(pgdat, NR_ANON_THPS) * HPAGE_PMD_NR),
 #endif
-			K(node_page_state(pgdat, NR_SHMEM)),
 			K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
 			K(node_page_state(pgdat, NR_UNSTABLE_NFS)),
 			node_page_state(pgdat, NR_PAGES_SCANNED),
_

Patches currently in -mm which might be from apolyakov@beget.ru are

fix-print-order-in-show_free_areas.patch


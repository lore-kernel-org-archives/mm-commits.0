From: akpm@linux-foundation.org
Subject: + mm-swapc-not-necessary-to-export-__pagevec_lru_add.patch
 added to -mm tree
Date: Wed, 19 Feb 2020 16:08:56 -0800
Message-ID: <20200220000856.csvQR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbgBTAI5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Feb 2020 19:08:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org, richardw.yang@linux.intel.com


The patch titled
     Subject: mm/swap.c: not necessary to export __pagevec_lru_add()
has been added to the -mm tree.  Its filename is
     mm-swapc-not-necessary-to-export-__pagevec_lru_add.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swapc-not-necessary-to-export-__pagevec_lru_add.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swapc-not-necessary-to-export-__pagevec_lru_add.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: mm/swap.c: not necessary to export __pagevec_lru_add()

__pagevec_lru_add() is only used in mm directory now.

Remove the export symbol.

Link: http://lkml.kernel.org/r/20200126011436.22979-1-richardw.yang@linux.intel.com
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/swap.c~mm-swapc-not-necessary-to-export-__pagevec_lru_add
+++ a/mm/swap.c
@@ -986,7 +986,6 @@ void __pagevec_lru_add(struct pagevec *p
 {
 	pagevec_lru_move_fn(pvec, __pagevec_lru_add_fn, NULL);
 }
-EXPORT_SYMBOL(__pagevec_lru_add);
 
 /**
  * pagevec_lookup_entries - gang pagecache lookup
_

Patches currently in -mm which might be from richardw.yang@linux.intel.com are

mm-sparsemem-pfn_to_page-is-not-valid-yet-on-sparsemem.patch
mm-swapc-not-necessary-to-export-__pagevec_lru_add.patch
mm-sparsemem-get-address-to-page-struct-instead-of-address-to-pfn.patch
mm-vmscanc-remove-cpu-online-notification-for-now.patch
mm-migratec-no-need-to-check-for-i-start-in-do_pages_move.patch
mm-migratec-wrap-do_move_pages_to_node-and-store_status.patch
mm-migratec-check-pagelist-in-move_pages_and_store_status.patch
mm-migratec-unify-not-queued-for-migration-handling-in-do_pages_move.patch

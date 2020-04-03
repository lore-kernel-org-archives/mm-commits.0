From: akpm@linux-foundation.org
Subject: [merged]
 mm-swapc-not-necessary-to-export-__pagevec_lru_add.patch removed from -mm
 tree
Date: Fri, 03 Apr 2020 13:37:05 -0700
Message-ID: <20200403203705.Cu-bNQICx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUhG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:37:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com


The patch titled
     Subject: mm/swap.c: not necessary to export __pagevec_lru_add()
has been removed from the -mm tree.  Its filename was
     mm-swapc-not-necessary-to-export-__pagevec_lru_add.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-migratec-no-need-to-check-for-i-start-in-do_pages_move.patch
mm-migratec-wrap-do_move_pages_to_node-and-store_status.patch
mm-migratec-check-pagelist-in-move_pages_and_store_status.patch
mm-migratec-unify-not-queued-for-migration-handling-in-do_pages_move.patch

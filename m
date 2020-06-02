From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 061/128] mm/swapfile.c: offset is only used when
 there is more slots
Date: Tue, 02 Jun 2020 13:13:30 -0700
Message-ID: <20200602201330.JsXE9UVzG%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726223AbgFBUNb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 16:13:31 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, tim.c.chen@linux.intel.com, torvalds@linux-foundation.org

From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/swapfile.c: offset is only used when there is more slots

scan_swap_map_slots() is used to iterate swap_map[] array for an available
swap entry.  While after several optimizations, e.g.  for ssd case, the
logic of this function is a little not easy to catch.

This patchset tries to clean up the logic a little:

  * shows the ssd/non-ssd case is handled mutually exclusively
  * remove some unnecessary goto for ssd case


This patch (of 3):

When si->cluster_nr is zero, function would reach done and return.  The
increased offset would not be used any more.  This means we can move the
offset increment into the if clause.

This brings a further code cleanup possibility.

Link: http://lkml.kernel.org/r/20200328060520.31449-1-richard.weiyang@gmail.com
Link: http://lkml.kernel.org/r/20200328060520.31449-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-offset-is-only-used-when-there-is-more-slots
+++ a/mm/swapfile.c
@@ -874,11 +874,9 @@ checks:
 		else
 			goto done;
 	}
-	/* non-ssd case */
-	++offset;
 
 	/* non-ssd case, still more slots in cluster? */
-	if (si->cluster_nr && !si->swap_map[offset]) {
+	if (si->cluster_nr && !si->swap_map[++offset]) {
 		--si->cluster_nr;
 		goto checks;
 	}
_

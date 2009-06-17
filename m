From: akpm@linux-foundation.org
Subject: [merged] mm-setup_per_zone_inactive_ratio-fix-comment-and-make-it-__init.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:35:05 -0700
Message-ID: <200906171835.n5HIZ5v3001104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756525AbZFQSfc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:35:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, minchan.kim@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: setup_per_zone_inactive_ratio - fix comment and make it __init
has been removed from the -mm tree.  Its filename was
     mm-setup_per_zone_inactive_ratio-fix-comment-and-make-it-__init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: setup_per_zone_inactive_ratio - fix comment and make it __init
From: Cyrill Gorcunov <gorcunov@openvz.org>

The caller of setup_per_zone_inactive_ratio is an __init function.  There
is no need to keep the callee after it completed as well.  Also fix a
comment.

Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-setup_per_zone_inactive_ratio-fix-comment-and-make-it-__init mm/page_alloc.c
--- a/mm/page_alloc.c~mm-setup_per_zone_inactive_ratio-fix-comment-and-make-it-__init
+++ a/mm/page_alloc.c
@@ -4440,8 +4440,6 @@ void setup_per_zone_pages_min(void)
 }
 
 /**
- * setup_per_zone_inactive_ratio - called when min_free_kbytes changes.
- *
  * The inactive anon list should be small enough that the VM never has to
  * do too much work, but large enough that each inactive page has a chance
  * to be referenced again before it is swapped out.
@@ -4462,7 +4460,7 @@ void setup_per_zone_pages_min(void)
  *    1TB     101        10GB
  *   10TB     320        32GB
  */
-static void setup_per_zone_inactive_ratio(void)
+static void __init setup_per_zone_inactive_ratio(void)
 {
 	struct zone *zone;
 
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
proc-vmcore-use-kzalloc-in-get_new_element.patch


From: akpm@linux-foundation.org
Subject: + mm-setup_per_zone_inactive_ratio-fix-comment-and-make-it-__init.patch added to -mm tree
Date: Wed, 06 May 2009 13:57:13 -0700
Message-ID: <200905062057.n46KvD8j017308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60630 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757348AbZEFVAa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2009 17:00:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, minchan.kim@gmail.com, rientjes@google.com


The patch titled
     mm: setup_per_zone_inactive_ratio - fix comment and make it __init
has been added to the -mm tree.  Its filename is
     mm-setup_per_zone_inactive_ratio-fix-comment-and-make-it-__init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -4534,8 +4534,6 @@ void setup_per_zone_pages_min(void)
 }
 
 /**
- * setup_per_zone_inactive_ratio - called when min_free_kbytes changes.
- *
  * The inactive anon list should be small enough that the VM never has to
  * do too much work, but large enough that each inactive page has a chance
  * to be referenced again before it is swapped out.
@@ -4556,7 +4554,7 @@ void setup_per_zone_pages_min(void)
  *    1TB     101        10GB
  *   10TB     320        32GB
  */
-static void setup_per_zone_inactive_ratio(void)
+static void __init setup_per_zone_inactive_ratio(void)
 {
 	struct zone *zone;
 
_

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
mm-setup_per_zone_inactive_ratio-do-not-call-for-int_sqrt-if-not-needed.patch
mm-setup_per_zone_inactive_ratio-fix-comment-and-make-it-__init.patch


From: akpm@linux-foundation.org
Subject: + mm-remove-unused-zone_idx-variable-from-set_migratetype_isolate.patch added to -mm tree
Date: Wed, 30 Mar 2011 12:51:48 -0700
Message-ID: <201103301951.p2UJpmGi004055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755737Ab1C3TwX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Mar 2011 15:52:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sergey.senozhatsky@gmail.com, cl@linux.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm: remove unused zone_idx variable from set_migratetype_isolate
has been added to the -mm tree.  Its filename is
     mm-remove-unused-zone_idx-variable-from-set_migratetype_isolate.patch

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
Subject: mm: remove unused zone_idx variable from set_migratetype_isolate
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/page_alloc.c~mm-remove-unused-zone_idx-variable-from-set_migratetype_isolate mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-unused-zone_idx-variable-from-set_migratetype_isolate
+++ a/mm/page_alloc.c
@@ -5474,10 +5474,8 @@ int set_migratetype_isolate(struct page 
 	struct memory_isolate_notify arg;
 	int notifier_ret;
 	int ret = -EBUSY;
-	int zone_idx;
 
 	zone = page_zone(page);
-	zone_idx = zone_idx(zone);
 
 	spin_lock_irqsave(&zone->lock, flags);
 
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

mm-remove-unused-zone_idx-variable-from-set_migratetype_isolate.patch


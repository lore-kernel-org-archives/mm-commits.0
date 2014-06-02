From: akpm@linux-foundation.org
Subject: + mm-page-writebackc-remove-outdated-comment.patch added to -mm
 tree
Date: Mon, 02 Jun 2014 13:53:16 -0700
Message-ID: <538ce43c.DAGLPJNq/bAyi7A2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41252 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaFBUxR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2014 16:53:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hannes@cmpxchg.org, nasa4836@gmail.com

Subject: + mm-page-writebackc-remove-outdated-comment.patch added to -mm tree
To: nasa4836@gmail.com,hannes@cmpxchg.org
From: akpm@linux-foundation.org
Date: Mon, 02 Jun 2014 13:53:16 -0700


The patch titled
     Subject: mm/page-writeback.c: remove outdated comment
has been added to the -mm tree.  Its filename is
     mm-page-writebackc-remove-outdated-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page-writebackc-remove-outdated-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page-writebackc-remove-outdated-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jianyu Zhan <nasa4836@gmail.com>
Subject: mm/page-writeback.c: remove outdated comment

There is an orphaned prehistoric comment , which used to be against
get_dirty_limits(), the dawn of global_dirtyable_memory().

Back then, the implementation of get_dirty_limits() is complicated and
full of magic numbers, so this comment is necessary.  But we now use the
clear and neat global_dirtyable_memory(), which renders this comment
ambiguous and useless.  Remove it.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   18 ------------------
 1 file changed, 18 deletions(-)

diff -puN mm/page-writeback.c~mm-page-writebackc-remove-outdated-comment mm/page-writeback.c
--- a/mm/page-writeback.c~mm-page-writebackc-remove-outdated-comment
+++ a/mm/page-writeback.c
@@ -156,24 +156,6 @@ static unsigned long writeout_period_tim
 #define VM_COMPLETIONS_PERIOD_LEN (3*HZ)
 
 /*
- * Work out the current dirty-memory clamping and background writeout
- * thresholds.
- *
- * The main aim here is to lower them aggressively if there is a lot of mapped
- * memory around.  To avoid stressing page reclaim with lots of unreclaimable
- * pages.  It is better to clamp down on writers than to start swapping, and
- * performing lots of scanning.
- *
- * We only allow 1/2 of the currently-unmapped memory to be dirtied.
- *
- * We don't permit the clamping level to fall below 5% - that is getting rather
- * excessive.
- *
- * We make sure that the background writeout level is below the adjusted
- * clamping level.
- */

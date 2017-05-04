From: akpm@linux-foundation.org
Subject: [merged] writeback-use-setup_deferrable_timer.patch
 removed from -mm tree
Date: Thu, 04 May 2017 12:09:31 -0700
Message-ID: <20170504190931.HdJtf35r6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50896 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756440AbdEDTJd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:09:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback.c: use setup_deferrable_timer
has been removed from the -mm tree.  Its filename was
     writeback-use-setup_deferrable_timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geliang Tang <geliangtang@gmail.com>
Subject: mm/page-writeback.c: use setup_deferrable_timer

Use setup_deferrable_timer() instead of init_timer_deferrable() to
simplify the code.

Link: http://lkml.kernel.org/r/e8e3d4280a34facbc007346f31df833cec28801e.1488070291.git.geliangtang@gmail.com
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/page-writeback.c~writeback-use-setup_deferrable_timer mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-use-setup_deferrable_timer
+++ a/mm/page-writeback.c
@@ -650,9 +650,8 @@ int wb_domain_init(struct wb_domain *dom
 
 	spin_lock_init(&dom->lock);
 
-	init_timer_deferrable(&dom->period_timer);
-	dom->period_timer.function = writeout_period;
-	dom->period_timer.data = (unsigned long)dom;
+	setup_deferrable_timer(&dom->period_timer, writeout_period,
+			       (unsigned long)dom);
 
 	dom->dirty_limit_tstamp = jiffies;
 
_

Patches currently in -mm which might be from geliangtang@gmail.com are



From: akpm@linux-foundation.org
Subject: + writeback-use-setup_deferrable_timer.patch added to -mm tree
Date: Tue, 28 Feb 2017 16:18:52 -0800
Message-ID: <58b6136c.s8uap3apN4tszWJH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33304 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751645AbdCABq3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 20:46:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback.c: use setup_deferrable_timer
has been added to the -mm tree.  Its filename is
     writeback-use-setup_deferrable_timer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/writeback-use-setup_deferrable_timer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/writeback-use-setup_deferrable_timer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -649,9 +649,8 @@ int wb_domain_init(struct wb_domain *dom
 
 	spin_lock_init(&dom->lock);
 
-	init_timer_deferrable(&dom->period_timer);
-	dom->period_timer.function = writeout_period;
-	dom->period_timer.data = (unsigned long)dom;
+	setup_deferrable_timer(&dom->period_timer, writeout_period,
+			       (unsigned long)dom);
 
 	dom->dirty_limit_tstamp = jiffies;
 
_

Patches currently in -mm which might be from geliangtang@gmail.com are

writeback-use-setup_deferrable_timer.patch


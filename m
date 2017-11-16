From: akpm@linux-foundation.org
Subject: [patch 094/131] mm/page-writeback.c: convert timers to use
 timer_setup()
Date: Wed, 15 Nov 2017 17:37:04 -0800
Message-ID: <20171116013704.V_hHX08sd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40156 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933052AbdKPBhG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:37:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, jack@suse.cz, jlayton@redhat.com, keescook@chromium.org, mawilcox@microsoft.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vdavydov.dev@gmail.com

From: Kees Cook <keescook@chromium.org>
Subject: mm/page-writeback.c: convert timers to use timer_setup()

In preparation for unconditionally passing the struct timer_list pointer
to all timer callbacks, switch to using the new timer_setup() and
from_timer() to pass the timer pointer explicitly.

Link: http://lkml.kernel.org/r/20171016225913.GA99214@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/page-writeback.c~writeback-convert-timers-to-use-timer_setup mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-convert-timers-to-use-timer_setup
+++ a/mm/page-writeback.c
@@ -628,9 +628,9 @@ EXPORT_SYMBOL_GPL(wb_writeout_inc);
  * On idle system, we can be called long after we scheduled because we use
  * deferred timers so count with missed periods.
  */
-static void writeout_period(unsigned long t)
+static void writeout_period(struct timer_list *t)
 {
-	struct wb_domain *dom = (void *)t;
+	struct wb_domain *dom = from_timer(dom, t, period_timer);
 	int miss_periods = (jiffies - dom->period_time) /
 						 VM_COMPLETIONS_PERIOD_LEN;
 
@@ -653,8 +653,7 @@ int wb_domain_init(struct wb_domain *dom
 
 	spin_lock_init(&dom->lock);
 
-	setup_deferrable_timer(&dom->period_timer, writeout_period,
-			       (unsigned long)dom);
+	timer_setup(&dom->period_timer, writeout_period, TIMER_DEFERRABLE);
 
 	dom->dirty_limit_tstamp = jiffies;
 
_

From: akpm@linux-foundation.org
Subject: + writeback-convert-timers-to-use-timer_setup.patch added to -mm
 tree
Date: Mon, 16 Oct 2017 16:24:47 -0700
Message-ID: <59e53fbf.5mmssaSnOAHd9E+S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46824 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932791AbdJPXYt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2017 19:24:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, hannes@cmpxchg.org, jack@suse.cz, jlayton@redhat.com, mawilcox@microsoft.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback.c: convert timers to use timer_setup()
has been added to the -mm tree.  Its filename is
     writeback-convert-timers-to-use-timer_setup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/writeback-convert-timers-to-use-timer_setup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/writeback-convert-timers-to-use-timer_setup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mm/page-writeback.c: convert timers to use timer_setup()

In preparation for unconditionally passing the struct timer_list pointer
to all timer callbacks, switch to using the new timer_setup() and
from_timer() to pass the timer pointer explicitly.

Link: http://lkml.kernel.org/r/20171016225913.GA99214@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Jan Kara <jack@suse.cz>
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

Patches currently in -mm which might be from keescook@chromium.org are

writeback-convert-timers-to-use-timer_setup.patch
sh-boot-add-static-stack-protector-to-pre-kernel.patch
makefile-move-stackprotector-availability-out-of-kconfig.patch
makefile-introduce-config_cc_stackprotector_auto.patch
makefile-introduce-config_cc_stackprotector_auto-fix.patch
makefile-introduce-config_cc_stackprotector_auto-fix-2.patch
makefile-introduce-config_cc_stackprotector_auto-fix-3.patch


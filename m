From: akpm@linux-foundation.org
Subject: + exitstats-obey-this-comment.patch added to -mm tree
Date: Thu, 23 Apr 2015 14:47:41 -0700
Message-ID: <5539687d.AEUr/81o59Af/u8a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030908AbbDWVrm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Apr 2015 17:47:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, mhocko@suse.cz, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit,stats: /* obey this comment */
has been added to the -mm tree.  Its filename is
     exitstats-obey-this-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exitstats-obey-this-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exitstats-obey-this-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: exit,stats: /* obey this comment */

There is a helpful comment in do_exit() that states we sync the mm's RSS
info before statistics gathering.

The function that does the statistics gathering is called right above that
comment.

Change the code to obey the comment.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~exitstats-obey-this-comment kernel/exit.c
--- a/kernel/exit.c~exitstats-obey-this-comment
+++ a/kernel/exit.c
@@ -711,10 +711,10 @@ void do_exit(long code)
 			current->comm, task_pid_nr(current),
 			preempt_count());
 
-	acct_update_integrals(tsk);
 	/* sync mm's RSS info before statistics gathering */
 	if (tsk->mm)
 		sync_mm_rss(tsk->mm);
+	acct_update_integrals(tsk);
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
 		hrtimer_cancel(&tsk->signal->real_timer);
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
exitstats-obey-this-comment.patch
do_shared_fault-check-that-mmap_sem-is-held.patch


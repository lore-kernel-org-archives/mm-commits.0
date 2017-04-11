From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-remove-debug_guardpage_minorder-test-in-warn_alloc.patch
 added to -mm tree
Date: Tue, 11 Apr 2017 14:29:59 -0700
Message-ID: <58ed4ad7.uhr8TY40N1Ry8aOX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38850 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753741AbdDKVaF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2017 17:30:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, aarcange@redhat.com, cl@linux-foundation.org, mgorman@suse.de, mhocko@kernel.org, penberg@cs.helsinki.fi, rjw@sisk.pl, sgruszka@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: remove debug_guardpage_minorder() test in warn_alloc()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-remove-debug_guardpage_minorder-test-in-warn_alloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-remove-debug_guardpage_minorder-test-in-warn_alloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-remove-debug_guardpage_minorder-test-in-warn_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm, page_alloc: remove debug_guardpage_minorder() test in warn_alloc()

We are using warn_alloc() for reporting both allocation failures and
allocation stalls.  If we add debug_guardpage_minorder=1 parameter, all
allocation failure and allocation stall reports become pointless like
below.  (Below output would be an OOM livelock where all __GFP_FS
allocations got stuck at too_many_isolated() in shrink_inactive_list()
waiting for kswapd, kswapd is waiting for !__GFP_FS allocations, and all
!__GFP_FS allocations did not get stuck at too_many_isolated() in
shrink_inactive_list() but are unable to invoke the OOM killer.)

===
[    0.000000] Linux version 4.11.0-rc6-next-20170410 (root@ccsecurity) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-11) (GCC) ) #578 SMP Mon Apr 10 23:08:53 JST 2017
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-4.11.0-rc6-next-20170410 (...snipped...) debug_guardpage_minorder=1
(...snipped...)
[    0.000000] Setting debug_guardpage_minorder to 1
(...snipped...)
[   99.064207] Out of memory: Kill process 3097 (a.out) score 999 or sacrifice child
[   99.066488] Killed process 3097 (a.out) total-vm:14408kB, anon-rss:84kB, file-rss:36kB, shmem-rss:0kB
[   99.180378] oom_reaper: reaped process 3097 (a.out), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[  128.310487] warn_alloc: 266 callbacks suppressed
[  133.445395] warn_alloc: 74 callbacks suppressed
[  138.517471] warn_alloc: 300 callbacks suppressed
[  143.537630] warn_alloc: 34 callbacks suppressed
[  148.610773] warn_alloc: 277 callbacks suppressed
[  153.630652] warn_alloc: 70 callbacks suppressed
[  158.639891] warn_alloc: 217 callbacks suppressed
[  163.687727] warn_alloc: 120 callbacks suppressed
[  168.709610] warn_alloc: 252 callbacks suppressed
[  173.714659] warn_alloc: 103 callbacks suppressed
[  178.730858] warn_alloc: 248 callbacks suppressed
[  183.797587] warn_alloc: 82 callbacks suppressed
[  188.825250] warn_alloc: 238 callbacks suppressed
[  193.832834] warn_alloc: 102 callbacks suppressed
[  198.876409] warn_alloc: 259 callbacks suppressed
[  203.940073] warn_alloc: 102 callbacks suppressed
[  207.620979] sysrq: SysRq : Resetting
===

c0a32fc5a2e470d0 ("mm: more intensive memory corruption debugging")
changed to check debug_guardpage_minorder() > 0 when reporting allocation
failures.  But the patch description seems to lack why we want to check
it.  Let's remove that check so that administrators can get some clue by
allowing warn_alloc() to report e.g.  GFP_NOFS | __GFP_NOWARN allocations
are stalling.

Link: http://lkml.kernel.org/r/1491910035-4231-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-remove-debug_guardpage_minorder-test-in-warn_alloc mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-remove-debug_guardpage_minorder-test-in-warn_alloc
+++ a/mm/page_alloc.c
@@ -3161,8 +3161,7 @@ void warn_alloc(gfp_t gfp_mask, nodemask
 	static DEFINE_RATELIMIT_STATE(nopage_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
 
-	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs) ||
-	    debug_guardpage_minorder() > 0)
+	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs))
 		return;
 
 	pr_warn("%s: ", current->comm);
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

mm-page_alloc-remove-debug_guardpage_minorder-test-in-warn_alloc.patch
locking-hung_task-defer-showing-held-locks.patch
fs-remove-set-but-not-checked-aop_flag_uninterruptible-flag.patch


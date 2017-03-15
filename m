From: akpm@linux-foundation.org
Subject: + sched-out-of-line-__update_load_avg.patch added to -mm tree
Date: Wed, 15 Mar 2017 14:49:17 -0700
Message-ID: <58c9b6dd.XtK/OX/gd2LaCafa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54564 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753319AbdCOVtT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2017 17:49:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, mingo@elte.hu, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sched/fair.c: uninline __update_load_avg()
has been added to the -mm tree.  Its filename is
     sched-out-of-line-__update_load_avg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sched-out-of-line-__update_load_avg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sched-out-of-line-__update_load_avg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: kernel/sched/fair.c: uninline __update_load_avg()

This is a very complex function, which is called in multiple places.  It
is unlikely that inlining or not inlining it makes any difference for its
run time.

This saves around 13k text in my kernel

   text    data     bss     dec     hex filename
9083992 5367600 11116544        25568136        1862388 vmlinux-before-load-avg
9070166 5367600 11116544        25554310        185ed86 vmlinux-load-avg

Link: http://lkml.kernel.org/r/20170315021431.13107-4-andi@firstfloor.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched/fair.c~sched-out-of-line-__update_load_avg kernel/sched/fair.c
--- a/kernel/sched/fair.c~sched-out-of-line-__update_load_avg
+++ a/kernel/sched/fair.c
@@ -2848,7 +2848,7 @@ static u32 __compute_runnable_contrib(u6
  *   load_avg = u_0` + y*(u_0 + u_1*y + u_2*y^2 + ... )
  *            = u_0 + u_1*y + u_2*y^2 + ... [re-labeling u_i --> u_{i+1}]
  */
-static __always_inline int
+static int
 __update_load_avg(u64 now, int cpu, struct sched_avg *sa,
 		  unsigned long weight, int running, struct cfs_rq *cfs_rq)
 {
_

Patches currently in -mm which might be from ak@linux.intel.com are

trace-move-trace_seq_overflowed-out-of-line.patch
sched-out-of-line-__update_load_avg.patch
kref-remove-warn_on-for-null-release-functions.patch
out-of-line-dma_alloc-free_attrs.patch
megasas-remove-expensive-inline-from-megasas_return_cmd.patch
remove-expensive-warn_on-in-pagefault_disabled_dec.patch


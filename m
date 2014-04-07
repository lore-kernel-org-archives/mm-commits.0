From: akpm@linux-foundation.org
Subject: +
 lib-percpu_counterc-fix-bad-percpu-counter-state-during-suspend.patch added to -mm tree
Date: Mon, 07 Apr 2014 12:35:15 -0700
Message-ID: <5342fdf3.oLdPBQhuNW66I8Ya%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38915 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbaDGTfQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 15:35:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, lersek@redhat.com, axboe@kernel.dk, axboe@fb.com

Subject: + lib-percpu_counterc-fix-bad-percpu-counter-state-during-suspend.patch added to -mm tree
To: axboe@fb.com,axboe@kernel.dk,lersek@redhat.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 12:35:15 -0700


The patch titled
     Subject: lib/percpu_counter.c: fix bad percpu counter state during suspend
has been added to the -mm tree.  Its filename is
     lib-percpu_counterc-fix-bad-percpu-counter-state-during-suspend.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-percpu_counterc-fix-bad-percpu-counter-state-during-suspend.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-percpu_counterc-fix-bad-percpu-counter-state-during-suspend.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jens Axboe <axboe@fb.com>
Subject: lib/percpu_counter.c: fix bad percpu counter state during suspend

I got a bug report yesterday from Laszlo Ersek in which he states that his
kvm instance fails to suspend.  Laszlo bisected it down to this commit:

commit 1cf7e9c68fe84248174e998922b39e508375e7c1
  Author: Jens Axboe <axboe@kernel.dk>
  Date:   Fri Nov 1 10:52:52 2013 -0600

      virtio_blk: blk-mq support

where virtio-blk is converted to use the blk-mq infrastructure.  After
digging a bit, it became clear that the issue was with the queue drain. 
blk-mq tracks queue usage in a percpu counter, which is incremented on
request alloc and decremented when the request is freed.  The initial hunt
was for an inconsistency in blk-mq, but everything seemed fine.  In fact,
the counter only returned crazy values when suspend was in progress.  When
a CPU is unplugged, the percpu counters merges that CPU state with the
general state.  blk-mq takes care to register a hotcpu notifier with the
appropriate priority, so we know it runs after the percpu counter
notifier.  However, the percpu counter notifier only merges the state when
the CPU is fully gone.  This leaves a state transition where the CPU going
away is no longer in the online mask, yet it still holds private values. 
This means that in this state, percpu_counter_sum() returns invalid
results, and the suspend then hangs waiting for abs(dead-cpu-value)
requests to complete which of course will never happen.

Fix this by clearing the state earlier, so we never have a case where the
CPU isn't in online mask but still holds private state.  This bug has been
there since forever, I guess we don't have a lot of users where percpu
counters needs to be reliable during the suspend cycle.

Signed-off-by: Jens Axboe <axboe@fb.com>
Reported-by: Laszlo Ersek <lersek@redhat.com>
Tested-by: Laszlo Ersek <lersek@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu_counter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/percpu_counter.c~lib-percpu_counterc-fix-bad-percpu-counter-state-during-suspend lib/percpu_counter.c
--- a/lib/percpu_counter.c~lib-percpu_counterc-fix-bad-percpu-counter-state-during-suspend
+++ a/lib/percpu_counter.c
@@ -169,7 +169,7 @@ static int percpu_counter_hotcpu_callbac
 	struct percpu_counter *fbc;
 
 	compute_batch_value();
-	if (action != CPU_DEAD)
+	if (action != CPU_DEAD && action != CPU_DEAD_FROZEN)
 		return NOTIFY_OK;
 
 	cpu = (unsigned long)hcpu;
_

Patches currently in -mm which might be from axboe@fb.com are

origin.patch
lib-percpu_counterc-fix-bad-percpu-counter-state-during-suspend.patch


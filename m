From: akpm@linux-foundation.org
Subject: +
 drivers-dma-pl330c-fix-locking-in-pl330_free_chan_resources.patch added to
 -mm tree
Date: Wed, 26 Jun 2013 12:05:24 -0700
Message-ID: <51cb3b74.WvoN6WnFoV0houOa%akpm__26780.5419433445$1372273540$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3FZTFZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jun 2013 15:05:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vinod.koul@linux.intel.com, t.figa@samsung.com, stable@vger.kernel.org, kyungmin.park@samsung.com, jassisinghbrar@gmail.com, b.zolnierkie@samsung.com

Subject: + drivers-dma-pl330c-fix-locking-in-pl330_free_chan_resources.patch added to -mm tree
To: b.zolnierkie@samsung.com,jassisinghbrar@gmail.com,kyungmin.park@samsung.com,stable@vger.kernel.org,t.figa@samsung.com,vinod.koul@linux.intel.com
From: akpm@linux-foundation.org
Date: Wed, 26 Jun 2013 12:05:24 -0700


The patch titled
     Subject: drivers/dma/pl330.c: fix locking in pl330_free_chan_resources()
has been added to the -mm tree.  Its filename is
     drivers-dma-pl330c-fix-locking-in-pl330_free_chan_resources.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: drivers/dma/pl330.c: fix locking in pl330_free_chan_resources()

tasklet_kill() may sleep so call it before taking pch->lock.

Fixes following lockup:

[  345.470000] BUG: scheduling while atomic: cat/2383/0x00000002
[  345.470000] Modules linked in:
[  345.470000] [<c0015858>] (unwind_backtrace+0x0/0xfc) from [<c004d980>] (__schedule_bug+0x4c/0x58)
[  345.470000] [<c004d980>] (__schedule_bug+0x4c/0x58) from [<c0360b6c>] (__schedule+0x690/0x6e0)
[  345.470000] [<c0360b6c>] (__schedule+0x690/0x6e0) from [<c004f2b4>] (sys_sched_yield+0x70/0x78)
[  345.470000] [<c004f2b4>] (sys_sched_yield+0x70/0x78) from [<c002acec>] (tasklet_kill+0x34/0x8c)
[  345.470000] [<c002acec>] (tasklet_kill+0x34/0x8c) from [<c01da4cc>] (pl330_free_chan_resources+0x24/0x88)
[  345.470000] [<c01da4cc>] (pl330_free_chan_resources+0x24/0x88) from [<c01d81f4>] (dma_chan_put+0x4c/0x50)
[  345.470000] [<c01d81f4>] (dma_chan_put+0x4c/0x50) from [<c01d82c0>] (dma_release_channel+0x28/0x98)
[...]
[  368.335000] BUG: spinlock lockup suspected on CPU#0, swapper/0/0
[  368.340000]  lock: 0xe52aa04c, .magic: dead4ead, .owner: cat/2383, .owner_cpu: 1
[  368.350000] [<c0015858>] (unwind_backtrace+0x0/0xfc) from [<c01b3d78>] (do_raw_spin_lock+0x194/0x204)
[  368.360000] [<c01b3d78>] (do_raw_spin_lock+0x194/0x204) from [<c0361adc>] (_raw_spin_lock_irqsave+0x20/0x28)
[  368.365000] [<c0361adc>] (_raw_spin_lock_irqsave+0x20/0x28) from [<c01da80c>] (pl330_tasklet+0x2c/0x5a8)
[  368.375000] [<c01da80c>] (pl330_tasklet+0x2c/0x5a8) from [<c002ac04>] (tasklet_action+0xfc/0x114)
[  368.385000] [<c002ac04>] (tasklet_action+0xfc/0x114) from [<c002b204>] (__do_softirq+0xe4/0x19c)
[  368.395000] [<c002b204>] (__do_softirq+0xe4/0x19c) from [<c002b398>] (irq_exit+0x98/0x9c)
[  368.405000] [<c002b398>] (irq_exit+0x98/0x9c) from [<c0013ebc>] (handle_IPI+0x124/0x16c)
[  368.410000] [<c0013ebc>] (handle_IPI+0x124/0x16c) from [<c000857c>] (gic_handle_irq+0x64/0x68)
[  368.420000] [<c000857c>] (gic_handle_irq+0x64/0x68) from [<c000e740>] (__irq_svc+0x40/0x70)
[  368.430000] Exception stack(0xc04a3f00 to 0xc04a3f48)
[  368.435000] 3f00: c04a3f48 00000000 6f9e23e8 00000050 c07492c8 c04a3f48 00000000 c04ccc88
[  368.440000] 3f20: 6f9dbac3 00000050 6f9e23e8 00000050 3b9aca00 c04a3f48 c005cfa4 c02946d4
[  368.450000] 3f40: 60000013 ffffffff
[  368.455000] [<c000e740>] (__irq_svc+0x40/0x70) from [<c02946d4>] (cpuidle_wrap_enter+0x4c/0xa0)
[  368.460000] [<c02946d4>] (cpuidle_wrap_enter+0x4c/0xa0) from [<c02940dc>] (cpuidle_enter_state+0x18/0x68)
[  368.470000] [<c02940dc>] (cpuidle_enter_state+0x18/0x68) from [<c02948e0>] (cpuidle_idle_call+0xac/0xe0)
[  368.480000] [<c02948e0>] (cpuidle_idle_call+0xac/0xe0) from [<c00102f8>] (cpu_idle+0xac/0xf0)
[  368.490000] [<c00102f8>] (cpu_idle+0xac/0xf0) from [<c04796a0>] (start_kernel+0x28c/0x294)

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/pl330.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/dma/pl330.c~drivers-dma-pl330c-fix-locking-in-pl330_free_chan_resources drivers/dma/pl330.c
--- a/drivers/dma/pl330.c~drivers-dma-pl330c-fix-locking-in-pl330_free_chan_resources
+++ a/drivers/dma/pl330.c
@@ -2485,10 +2485,10 @@ static void pl330_free_chan_resources(st
 	struct dma_pl330_chan *pch = to_pchan(chan);
 	unsigned long flags;
 
-	spin_lock_irqsave(&pch->lock, flags);

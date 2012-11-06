From: akpm@linux-foundation.org
Subject: + tasklet-ignore-disabled-tasklet-in-tasklet_action-v2.patch added to -mm tree
Date: Tue, 06 Nov 2012 12:18:51 -0800
Message-ID: <20121106201852.39C4C100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:42912 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2KFUSx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2012 15:18:53 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so89023vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Nov 2012 12:18:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xtfeng@gmail.com, dannyfeng@tencent.com, eric.dumazet@gmail.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Subject: tasklet: ignore disabled tasklet in tasklet_action v2
has been added to the -mm tree.  Its filename is
     tasklet-ignore-disabled-tasklet-in-tasklet_action-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xiaotian Feng <xtfeng@gmail.com>
Subject: tasklet: ignore disabled tasklet in tasklet_action v2

v2 changes:
  - clear TASKLET_STATE_HI bit in tasklet_schedule
  - remove tasklet_hi_enable() as it is exactly the same as tasklet_enable()

Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/jme.c |   16 ++++++++--------
 include/linux/interrupt.h  |    6 ------
 kernel/softirq.c           |    1 +
 3 files changed, 9 insertions(+), 14 deletions(-)

diff -puN drivers/net/ethernet/jme.c~tasklet-ignore-disabled-tasklet-in-tasklet_action-v2 drivers/net/ethernet/jme.c
--- a/drivers/net/ethernet/jme.c~tasklet-ignore-disabled-tasklet-in-tasklet_action-v2
+++ a/drivers/net/ethernet/jme.c
@@ -1364,8 +1364,8 @@ err_out_free_rx_resources:
 	jme_free_rx_resources(jme);
 out_enable_tasklet:
 	tasklet_enable(&jme->txclean_task);
-	tasklet_hi_enable(&jme->rxclean_task);
-	tasklet_hi_enable(&jme->rxempty_task);
+	tasklet_enable(&jme->rxclean_task);
+	tasklet_enable(&jme->rxempty_task);
 out:
 	atomic_inc(&jme->link_changing);
 }
@@ -1862,8 +1862,8 @@ jme_open(struct net_device *netdev)
 
 	tasklet_enable(&jme->linkch_task);
 	tasklet_enable(&jme->txclean_task);
-	tasklet_hi_enable(&jme->rxclean_task);
-	tasklet_hi_enable(&jme->rxempty_task);
+	tasklet_enable(&jme->rxclean_task);
+	tasklet_enable(&jme->rxempty_task);
 
 	rc = jme_request_irq(jme);
 	if (rc)
@@ -2375,8 +2375,8 @@ static inline void jme_resume_rx(struct 
 	if (test_bit(JME_FLAG_POLL, &jme->flags)) {
 		JME_NAPI_ENABLE(jme);
 	} else {
-		tasklet_hi_enable(&jme->rxclean_task);
-		tasklet_hi_enable(&jme->rxempty_task);
+		tasklet_enable(&jme->rxclean_task);
+		tasklet_enable(&jme->rxempty_task);
 	}
 	dpi->cur		= PCC_P1;
 	dpi->attempt		= PCC_P1;
@@ -3276,8 +3276,8 @@ jme_suspend(struct device *dev)
 	}
 
 	tasklet_enable(&jme->txclean_task);
-	tasklet_hi_enable(&jme->rxclean_task);
-	tasklet_hi_enable(&jme->rxempty_task);
+	tasklet_enable(&jme->rxclean_task);
+	tasklet_enable(&jme->rxempty_task);
 
 	jme_powersave_phy(jme);
 
diff -puN include/linux/interrupt.h~tasklet-ignore-disabled-tasklet-in-tasklet_action-v2 include/linux/interrupt.h
--- a/include/linux/interrupt.h~tasklet-ignore-disabled-tasklet-in-tasklet_action-v2
+++ a/include/linux/interrupt.h
@@ -604,12 +604,6 @@ static inline void tasklet_enable(struct
 	}
 }
 
-static inline void tasklet_hi_enable(struct tasklet_struct *t)
-{
-	smp_mb__before_atomic_dec();
-	atomic_dec(&t->count);
-}

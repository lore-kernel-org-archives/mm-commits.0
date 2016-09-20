From: akpm@linux-foundation.org
Subject: + softirq-fix-tasklet_kill-and-its-users.patch added to -mm tree
Date: Tue, 20 Sep 2016 14:55:13 -0700
Message-ID: <57e1b041.zRoBcsxStpPQoyeo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51390 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752126AbcITVzO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Sep 2016 17:55:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ssantosh@kernel.org, davem@davemloft.net, giovanni.cabiddu@intel.com, gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, isdn@linux-pingi.de, mingo@elte.hu, pebolle@tiscali.nl, peterz@infradead.org, salvatore.benedetto@intel.com, tadeusz.struk@intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: softirq: fix tasklet_kill() and its users
has been added to the -mm tree.  Its filename is
     softirq-fix-tasklet_kill-and-its-users.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/softirq-fix-tasklet_kill-and-its-users.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/softirq-fix-tasklet_kill-and-its-users.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Santosh Shilimkar <ssantosh@kernel.org>
Subject: softirq: fix tasklet_kill() and its users

Semantically the expectation from the tasklet init/kill API should be as
below.

tasklet_init() == Init and Enable scheduling
tasklet_kill() == Disable scheduling and Destroy

The tasklet_init() API exibits the above behavior but tasklet_kill() does
not.  The tasklet handler can still get scheduled and run even after
tasklet_kill().

There are 2, 3 places where drivers are working around this issue by
calling tasklet_disable() which will add a usecount and thereby preventing
the handlers from being called.

tasklet_enable/tasklet_disable is a pair API and they are expected to be
used together.  Usage of tasklet_disable() *just* to work around tasklet
scheduling after a kill is probably not the correct and intended use of
the API.  We also happen to see similar issues where in the shutdown path
the tasklet_handler is getting called even after the tasklet_kill().

We fix this by ensuring that tasklet_kill() does the right thing and
thereby ensures that the tasklet handler won't run after tasklet_kil()
with a very simple change.  The patch fixes the tasklet code and also
removes a few driver workarounds.

Link: http://lkml.kernel.org/r/1472089950-2724-1-git-send-email-ssantosh@kernel.org
Signed-off-by: Santosh Shilimkar <ssantosh@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: Salvatore Benedetto <salvatore.benedetto@intel.com>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/crypto/qat/qat_common/adf_isr.c    |    1 -
 drivers/crypto/qat/qat_common/adf_sriov.c  |    1 -
 drivers/crypto/qat/qat_common/adf_vf_isr.c |    2 --
 drivers/isdn/gigaset/interface.c           |    1 -
 kernel/softirq.c                           |    7 ++++---
 5 files changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/crypto/qat/qat_common/adf_isr.c~softirq-fix-tasklet_kill-and-its-users drivers/crypto/qat/qat_common/adf_isr.c
--- a/drivers/crypto/qat/qat_common/adf_isr.c~softirq-fix-tasklet_kill-and-its-users
+++ a/drivers/crypto/qat/qat_common/adf_isr.c
@@ -296,7 +296,6 @@ static void adf_cleanup_bh(struct adf_ac
 	int i;
 
 	for (i = 0; i < hw_data->num_banks; i++) {
-		tasklet_disable(&priv_data->banks[i].resp_handler);
 		tasklet_kill(&priv_data->banks[i].resp_handler);
 	}
 }
diff -puN drivers/crypto/qat/qat_common/adf_sriov.c~softirq-fix-tasklet_kill-and-its-users drivers/crypto/qat/qat_common/adf_sriov.c
--- a/drivers/crypto/qat/qat_common/adf_sriov.c~softirq-fix-tasklet_kill-and-its-users
+++ a/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -204,7 +204,6 @@ void adf_disable_sriov(struct adf_accel_
 	}
 
 	for (i = 0, vf = accel_dev->pf.vf_info; i < totalvfs; i++, vf++) {
-		tasklet_disable(&vf->vf2pf_bh_tasklet);
 		tasklet_kill(&vf->vf2pf_bh_tasklet);
 		mutex_destroy(&vf->pf2vf_lock);
 	}
diff -puN drivers/crypto/qat/qat_common/adf_vf_isr.c~softirq-fix-tasklet_kill-and-its-users drivers/crypto/qat/qat_common/adf_vf_isr.c
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c~softirq-fix-tasklet_kill-and-its-users
+++ a/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -191,7 +191,6 @@ static int adf_setup_pf2vf_bh(struct adf
 
 static void adf_cleanup_pf2vf_bh(struct adf_accel_dev *accel_dev)
 {
-	tasklet_disable(&accel_dev->vf.pf2vf_bh_tasklet);
 	tasklet_kill(&accel_dev->vf.pf2vf_bh_tasklet);
 	mutex_destroy(&accel_dev->vf.vf2pf_lock);
 }
@@ -268,7 +267,6 @@ static void adf_cleanup_bh(struct adf_ac
 {
 	struct adf_etr_data *priv_data = accel_dev->transport;
 
-	tasklet_disable(&priv_data->banks[0].resp_handler);
 	tasklet_kill(&priv_data->banks[0].resp_handler);
 }
 
diff -puN drivers/isdn/gigaset/interface.c~softirq-fix-tasklet_kill-and-its-users drivers/isdn/gigaset/interface.c
--- a/drivers/isdn/gigaset/interface.c~softirq-fix-tasklet_kill-and-its-users
+++ a/drivers/isdn/gigaset/interface.c
@@ -524,7 +524,6 @@ void gigaset_if_free(struct cardstate *c
 	if (!drv->have_tty)
 		return;
 
-	tasklet_disable(&cs->if_wake_tasklet);
 	tasklet_kill(&cs->if_wake_tasklet);
 	cs->tty_dev = NULL;
 	tty_unregister_device(drv->tty, cs->minor_index);
diff -puN kernel/softirq.c~softirq-fix-tasklet_kill-and-its-users kernel/softirq.c
--- a/kernel/softirq.c~softirq-fix-tasklet_kill-and-its-users
+++ a/kernel/softirq.c
@@ -498,7 +498,7 @@ static void tasklet_action(struct softir
 		list = list->next;
 
 		if (tasklet_trylock(t)) {
-			if (!atomic_read(&t->count)) {
+			if (atomic_read(&t->count) == 1) {
 				if (!test_and_clear_bit(TASKLET_STATE_SCHED,
 							&t->state))
 					BUG();
@@ -534,7 +534,7 @@ static void tasklet_hi_action(struct sof
 		list = list->next;
 
 		if (tasklet_trylock(t)) {
-			if (!atomic_read(&t->count)) {
+			if (atomic_read(&t->count) == 1) {
 				if (!test_and_clear_bit(TASKLET_STATE_SCHED,
 							&t->state))
 					BUG();
@@ -559,7 +559,7 @@ void tasklet_init(struct tasklet_struct
 {
 	t->next = NULL;
 	t->state = 0;
-	atomic_set(&t->count, 0);
+	atomic_set(&t->count, 1);
 	t->func = func;
 	t->data = data;
 }
@@ -576,6 +576,7 @@ void tasklet_kill(struct tasklet_struct
 		} while (test_bit(TASKLET_STATE_SCHED, &t->state));
 	}
 	tasklet_unlock_wait(t);
+	atomic_dec(&t->count);
 	clear_bit(TASKLET_STATE_SCHED, &t->state);
 }
 EXPORT_SYMBOL(tasklet_kill);
_

Patches currently in -mm which might be from ssantosh@kernel.org are

softirq-fix-tasklet_kill-and-its-users.patch


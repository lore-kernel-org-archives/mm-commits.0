From: akpm@linux-foundation.org
Subject: + kernel-smpc-remove-priv-of-call_single_data.patch added to -mm tree
Date: Tue, 23 Apr 2013 15:44:07 -0700
Message-ID: <20130423224407.774A831C0AC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:54325 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab3DWWoI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Apr 2013 18:44:08 -0400
Received: by mail-vb0-f73.google.com with SMTP id p13so21767vbe.2
        for <mm-commits@vger.kernel.org>; Tue, 23 Apr 2013 15:44:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lig.fnst@cn.fujitsu.com, a.p.zijlstra@chello.nl, mingo@elte.hu, oleg@redhat.com


The patch titled
     Subject: kernel/smp.c: remove 'priv' of call_single_data
has been added to the -mm tree.  Its filename is
     kernel-smpc-remove-priv-of-call_single_data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: liguang <lig.fnst@cn.fujitsu.com>
Subject: kernel/smp.c: remove 'priv' of call_single_data

The 'priv' field is redundant; we can pass data via 'info'.

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |    1 -
 kernel/softirq.c    |    6 ++----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff -puN include/linux/smp.h~kernel-smpc-remove-priv-of-call_single_data include/linux/smp.h
--- a/include/linux/smp.h~kernel-smpc-remove-priv-of-call_single_data
+++ a/include/linux/smp.h
@@ -20,7 +20,6 @@ struct call_single_data {
 	smp_call_func_t func;
 	void *info;
 	u16 flags;
-	u16 priv;
 };
 
 /* total number of cpus in this system (may exceed NR_CPUS) */
diff -puN kernel/softirq.c~kernel-smpc-remove-priv-of-call_single_data kernel/softirq.c
--- a/kernel/softirq.c~kernel-smpc-remove-priv-of-call_single_data
+++ a/kernel/softirq.c
@@ -620,8 +620,7 @@ static void remote_softirq_receive(void
 	unsigned long flags;
 	int softirq;
 
-	softirq = cp->priv;
-
+	softirq = *(int *)cp->info;
 	local_irq_save(flags);
 	__local_trigger(cp, softirq);
 	local_irq_restore(flags);
@@ -631,9 +630,8 @@ static int __try_remote_softirq(struct c
 {
 	if (cpu_online(cpu)) {
 		cp->func = remote_softirq_receive;
-		cp->info = cp;
+		cp->info = &softirq;
 		cp->flags = 0;
-		cp->priv = softirq;
 
 		__smp_call_function_single(cpu, cp, 0);
 		return 0;
_

Patches currently in -mm which might be from lig.fnst@cn.fujitsu.com are

linux-next.patch
kernel-smpc-use-=-for-csd_lock.patch
kernel-smpc-remove-priv-of-call_single_data.patch
semaphore-give-an-unlikely-for-downs-timeout.patch
semaphore-boolize-semaphore_waiters-up.patch


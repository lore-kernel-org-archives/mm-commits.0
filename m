From: akpm@linux-foundation.org
Subject: + execute-tasklets-in-the-same-order-they-were-queued.patch added to -mm tree
Date: Tue, 12 Feb 2008 14:20:44 -0800
Message-ID: <200802122220.m1CMKitr025368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36817 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752475AbYBLWVM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 17:21:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olof@lixom.net, davem@davemloft.net, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Execute tasklets in the same order they were queued
has been added to the -mm tree.  Its filename is
     execute-tasklets-in-the-same-order-they-were-queued.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Execute tasklets in the same order they were queued
From: Olof Johansson <olof@lixom.net>

I noticed this when looking at an openswan issue.  Openswan (ab?)uses the
tasklet API to defer processing of packets in some situations, with one
packet per tasklet_action().  I started noticing sequences of
backwards-ordered sequence numbers coming over the wire, since new tasklets
are always queued at the head of the list but processed sequentially.

Convert it to instead append new entries to the tail of the list.  As an
extra bonus, the splicing code in takeover_tasklets() no longer has to
iterate over the list.

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softirq.c |   63 +++++++++++++++++++++++++++++----------------
 1 file changed, 41 insertions(+), 22 deletions(-)

diff -puN kernel/softirq.c~execute-tasklets-in-the-same-order-they-were-queued kernel/softirq.c
--- a/kernel/softirq.c~execute-tasklets-in-the-same-order-they-were-queued
+++ a/kernel/softirq.c
@@ -356,7 +356,8 @@ void open_softirq(int nr, void (*action)
 /* Tasklets */
 struct tasklet_head
 {
-	struct tasklet_struct *list;
+	struct tasklet_struct *head;
+	struct tasklet_struct **tail;
 };
 
 /* Some compilers disobey section attribute on statics when not
@@ -369,8 +370,9 @@ void __tasklet_schedule(struct tasklet_s
 	unsigned long flags;
 
 	local_irq_save(flags);
-	t->next = __get_cpu_var(tasklet_vec).list;
-	__get_cpu_var(tasklet_vec).list = t;
+	t->next = NULL;
+	*__get_cpu_var(tasklet_vec).tail = t;
+	__get_cpu_var(tasklet_vec).tail = &(t->next);
 	raise_softirq_irqoff(TASKLET_SOFTIRQ);
 	local_irq_restore(flags);
 }
@@ -382,8 +384,9 @@ void __tasklet_hi_schedule(struct taskle
 	unsigned long flags;
 
 	local_irq_save(flags);
-	t->next = __get_cpu_var(tasklet_hi_vec).list;
-	__get_cpu_var(tasklet_hi_vec).list = t;
+	t->next = NULL;
+	*__get_cpu_var(tasklet_hi_vec).tail = t;
+	__get_cpu_var(tasklet_hi_vec).tail = &(t->next);
 	raise_softirq_irqoff(HI_SOFTIRQ);
 	local_irq_restore(flags);
 }
@@ -395,8 +398,9 @@ static void tasklet_action(struct softir
 	struct tasklet_struct *list;
 
 	local_irq_disable();
-	list = __get_cpu_var(tasklet_vec).list;
-	__get_cpu_var(tasklet_vec).list = NULL;
+	list = __get_cpu_var(tasklet_vec).head;
+	__get_cpu_var(tasklet_vec).head = NULL;
+	__get_cpu_var(tasklet_vec).tail = &__get_cpu_var(tasklet_vec).head;
 	local_irq_enable();
 
 	while (list) {
@@ -416,8 +420,9 @@ static void tasklet_action(struct softir
 		}
 
 		local_irq_disable();
-		t->next = __get_cpu_var(tasklet_vec).list;
-		__get_cpu_var(tasklet_vec).list = t;
+		t->next = NULL;
+		*__get_cpu_var(tasklet_vec).tail = t;
+		__get_cpu_var(tasklet_vec).tail = &(t->next);
 		__raise_softirq_irqoff(TASKLET_SOFTIRQ);
 		local_irq_enable();
 	}
@@ -428,8 +433,9 @@ static void tasklet_hi_action(struct sof
 	struct tasklet_struct *list;
 
 	local_irq_disable();
-	list = __get_cpu_var(tasklet_hi_vec).list;
-	__get_cpu_var(tasklet_hi_vec).list = NULL;
+	list = __get_cpu_var(tasklet_hi_vec).head;
+	__get_cpu_var(tasklet_hi_vec).head = NULL;
+	__get_cpu_var(tasklet_hi_vec).tail = &__get_cpu_var(tasklet_hi_vec).head;
 	local_irq_enable();
 
 	while (list) {
@@ -449,8 +455,9 @@ static void tasklet_hi_action(struct sof
 		}
 
 		local_irq_disable();
-		t->next = __get_cpu_var(tasklet_hi_vec).list;
-		__get_cpu_var(tasklet_hi_vec).list = t;
+		t->next = NULL;
+		*__get_cpu_var(tasklet_hi_vec).tail = t;
+		__get_cpu_var(tasklet_hi_vec).tail = &(t->next);
 		__raise_softirq_irqoff(HI_SOFTIRQ);
 		local_irq_enable();
 	}
@@ -487,6 +494,15 @@ EXPORT_SYMBOL(tasklet_kill);
 
 void __init softirq_init(void)
 {
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		per_cpu(tasklet_vec, cpu).tail =
+			&per_cpu(tasklet_vec, cpu).head;
+		per_cpu(tasklet_hi_vec, cpu).tail =
+			&per_cpu(tasklet_hi_vec, cpu).head;
+	}
+
 	open_softirq(TASKLET_SOFTIRQ, tasklet_action, NULL);
 	open_softirq(HI_SOFTIRQ, tasklet_hi_action, NULL);
 }
@@ -555,9 +571,12 @@ void tasklet_kill_immediate(struct taskl
 		return;
 
 	/* CPU is dead, so no lock needed. */
-	for (i = &per_cpu(tasklet_vec, cpu).list; *i; i = &(*i)->next) {
+	for (i = &per_cpu(tasklet_vec, cpu).head; *i; i = &(*i)->next) {
 		if (*i == t) {
 			*i = t->next;
+			/* If this was the tail element, move the tail ptr */
+			if (*i == NULL)
+				per_cpu(tasklet_vec, cpu).tail = i;
 			return;
 		}
 	}
@@ -566,20 +585,20 @@ void tasklet_kill_immediate(struct taskl
 
 static void takeover_tasklets(unsigned int cpu)
 {
-	struct tasklet_struct **i;
-
 	/* CPU is dead, so no lock needed. */
 	local_irq_disable();
 
 	/* Find end, append list for that CPU. */
-	for (i = &__get_cpu_var(tasklet_vec).list; *i; i = &(*i)->next);
-	*i = per_cpu(tasklet_vec, cpu).list;
-	per_cpu(tasklet_vec, cpu).list = NULL;
+	*__get_cpu_var(tasklet_vec).tail = per_cpu(tasklet_vec, cpu).head;
+	__get_cpu_var(tasklet_vec).tail = per_cpu(tasklet_vec, cpu).tail;
+	per_cpu(tasklet_vec, cpu).head = NULL;
+	per_cpu(tasklet_vec, cpu).tail = &per_cpu(tasklet_vec, cpu).head;
 	raise_softirq_irqoff(TASKLET_SOFTIRQ);
 
-	for (i = &__get_cpu_var(tasklet_hi_vec).list; *i; i = &(*i)->next);
-	*i = per_cpu(tasklet_hi_vec, cpu).list;
-	per_cpu(tasklet_hi_vec, cpu).list = NULL;
+	*__get_cpu_var(tasklet_hi_vec).tail = per_cpu(tasklet_hi_vec, cpu).head;
+	__get_cpu_var(tasklet_hi_vec).tail = per_cpu(tasklet_hi_vec, cpu).tail;
+	per_cpu(tasklet_hi_vec, cpu).head = NULL;
+	per_cpu(tasklet_hi_vec, cpu).tail = &per_cpu(tasklet_hi_vec, cpu).head;
 	raise_softirq_irqoff(HI_SOFTIRQ);
 
 	local_irq_enable();
_

Patches currently in -mm which might be from olof@lixom.net are

origin.patch
execute-tasklets-in-the-same-order-they-were-queued.patch
mlx4-fix-build-break.patch

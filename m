From: akpm@linux-foundation.org
Subject: + posix-cpu-timers-initialize-new_itimer-itcpufiring.patch added to -mm tree
Date: Wed, 30 Sep 2009 13:23:34 -0700
Message-ID: <200909302023.n8UKNYxE011143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751899AbZI3UYw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 16:24:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sgruszka@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, oleg@redhat.com, tglx@linutronix.de


The patch titled
     posix-cpu-timers: initialize new_itimer->it.cpu.firing
has been added to the -mm tree.  Its filename is
     posix-cpu-timers-initialize-new_itimer-itcpufiring.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: posix-cpu-timers: initialize new_itimer->it.cpu.firing
From: Stanislaw Gruszka <sgruszka@redhat.com>

In case when posix_cpu_timer_create() is called from sys_timer_create()
it.cpu.firing field of struct k_itimer is uninitialized.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-cpu-timers.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/posix-cpu-timers.c~posix-cpu-timers-initialize-new_itimer-itcpufiring kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~posix-cpu-timers-initialize-new_itimer-itcpufiring
+++ a/kernel/posix-cpu-timers.c
@@ -398,6 +398,7 @@ int posix_cpu_timer_create(struct k_itim
 	INIT_LIST_HEAD(&new_timer->it.cpu.entry);
 	new_timer->it.cpu.incr.sched = 0;
 	new_timer->it.cpu.expires.sched = 0;
+	new_timer->it.cpu.firing = 0;
 
 	read_lock(&tasklist_lock);
 	if (CPUCLOCK_PERTHREAD(new_timer->it_clock)) {
_

Patches currently in -mm which might be from sgruszka@redhat.com are

itimers-fix-racy-writes-to-cpu_itimer-fields.patch
posix-cpu-timers-initialize-new_itimer-itcpufiring.patch


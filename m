From: akpm@linux-foundation.org
Subject: + markers-use-synchronize_sched.patch added to -mm tree
Date: Tue, 01 Apr 2008 13:30:22 -0700
Message-ID: <200804012030.m31KUM0X011775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758157AbYDAUfn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 16:35:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, paulmck@linux.vnet.ibm.com


The patch titled
     markers: use synchronize_sched()
has been added to the -mm tree.  Its filename is
     markers-use-synchronize_sched.patch

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
Subject: markers: use synchronize_sched()
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Use synchronize_sched before calling call_rcu in CONFIG_PREEMPT_RCU until we
have call_rcu_sched and rcu_barrier_sched in mainline.  It will slow down the
marker operations in CONFIG_PREEMPT_RCU, but it fixes the current race against
the preempt_disable/enable() protected code paths.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/marker.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN kernel/marker.c~markers-use-synchronize_sched kernel/marker.c
--- a/kernel/marker.c~markers-use-synchronize_sched
+++ a/kernel/marker.c
@@ -671,6 +671,9 @@ int marker_probe_register(const char *na
 	entry->rcu_pending = 1;
 	/* write rcu_pending before calling the RCU callback */
 	smp_wmb();
+#ifdef CONFIG_PREEMPT_RCU
+	synchronize_sched();	/* Until we have the call_rcu_sched() */
+#endif
 	call_rcu(&entry->rcu, free_old_closure);
 end:
 	mutex_unlock(&markers_mutex);
@@ -714,6 +717,9 @@ int marker_probe_unregister(const char *
 	entry->rcu_pending = 1;
 	/* write rcu_pending before calling the RCU callback */
 	smp_wmb();
+#ifdef CONFIG_PREEMPT_RCU
+	synchronize_sched();	/* Until we have the call_rcu_sched() */
+#endif
 	call_rcu(&entry->rcu, free_old_closure);
 	remove_marker(name);	/* Ignore busy error message */
 	ret = 0;
@@ -792,6 +798,9 @@ int marker_probe_unregister_private_data
 	entry->rcu_pending = 1;
 	/* write rcu_pending before calling the RCU callback */
 	smp_wmb();
+#ifdef CONFIG_PREEMPT_RCU
+	synchronize_sched();	/* Until we have the call_rcu_sched() */
+#endif
 	call_rcu(&entry->rcu, free_old_closure);
 	remove_marker(entry->name);	/* Ignore busy error message */
 end:
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

markers-use-synchronize_sched.patch
make-marker_debug-static.patch


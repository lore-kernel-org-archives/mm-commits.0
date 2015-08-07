From: akpm@linux-foundation.org
Subject: [merged] kthread-export-kthread-functions.patch removed from -mm
 tree
Date: Fri, 07 Aug 2015 12:03:17 -0700
Message-ID: <55c500f5.obl1oVzrKpodaL1Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41532 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946135AbbHGTDS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2015 15:03:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david.kershner@unisys.com, mingo@kernel.org, nhorman@tuxdriver.com, richard.weinberger@gmail.com, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kthread: export kthread functions
has been removed from the -mm tree.  Its filename was
     kthread-export-kthread-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Kershner <david.kershner@unisys.com>
Subject: kthread: export kthread functions

The s-Par visornic driver, currently in staging, processes a queue being
serviced by the an s-Par service partition.  We can get a message that
something has happened with the Service Partition, when that happens, we
must not access the channel until we get a message that the service
partition is back again.

The visornic driver has a thread for processing the channel, when we get
the message, we need to be able to park the thread and then resume it when
the problem clears.

We can do this with kthread_park and unpark but they are not exported from
the kernel, this patch exports the needed functions.

Signed-off-by: David Kershner <david.kershner@unisys.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/kthread.c~kthread-export-kthread-functions kernel/kthread.c
--- a/kernel/kthread.c~kthread-export-kthread-functions
+++ a/kernel/kthread.c
@@ -97,6 +97,7 @@ bool kthread_should_park(void)
 {
 	return test_bit(KTHREAD_SHOULD_PARK, &to_kthread(current)->flags);
 }
+EXPORT_SYMBOL_GPL(kthread_should_park);
 
 /**
  * kthread_freezable_should_stop - should this freezable kthread return now?
@@ -171,6 +172,7 @@ void kthread_parkme(void)
 {
 	__kthread_parkme(to_kthread(current));
 }
+EXPORT_SYMBOL_GPL(kthread_parkme);
 
 static int kthread(void *_create)
 {
@@ -411,6 +413,7 @@ void kthread_unpark(struct task_struct *
 	if (kthread)
 		__kthread_unpark(k, kthread);
 }
+EXPORT_SYMBOL_GPL(kthread_unpark);
 
 /**
  * kthread_park - park a thread created by kthread_create().
@@ -441,6 +444,7 @@ int kthread_park(struct task_struct *k)
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(kthread_park);
 
 /**
  * kthread_stop - stop a thread created by kthread_create().
_

Patches currently in -mm which might be from david.kershner@unisys.com are

origin.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: +
 cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v2.patch added to -mm tree
Date: Tue, 10 Jun 2014 15:28:58 -0700
Message-ID: <539786aa.D1JS4UU/mMX5o3iE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40619 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaFJW27 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jun 2014 18:28:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterz@infradead.org, oleg@redhat.com, srivatsa.bhat@linux.vnet.ibm.com

Subject: + cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v2.patch added to -mm tree
To: srivatsa.bhat@linux.vnet.ibm.com,oleg@redhat.com,peterz@infradead.org
From: akpm@linux-foundation.org
Date: Tue, 10 Jun 2014 15:28:58 -0700


The patch titled
     Subject: CPU hotplug, smp: Execute any pending IPI callbacks before CPU offline
has been added to the -mm tree.  Its filename is
     cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: CPU hotplug, smp: Execute any pending IPI callbacks before CPU offline

Changes in v2:

* Modified the changelog to make it more accurate and easy to understand,
  based on feedback by Peter Zijlstra.
* Replaced the term "IPI functions" with "IPI callbacks" in the code
  comments.
* Absolutely no changes in the code.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/smp.c~cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v2 kernel/smp.c
--- a/kernel/smp.c~cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v2
+++ a/kernel/smp.c
@@ -212,10 +212,10 @@ void generic_smp_call_function_single_in
  *
  * Flush any pending smp-call-function callbacks queued on this CPU. This is
  * invoked by the generic IPI handler, as well as by a CPU about to go offline,
- * to ensure that all pending IPI functions are run before it goes completely
+ * to ensure that all pending IPI callbacks are run before it goes completely
  * offline.
  *
- * Loop through the call_single_queue and run all the queued functions.
+ * Loop through the call_single_queue and run all the queued callbacks.
  * Must be called with interrupts disabled.
  */
 static void flush_smp_call_function_queue(bool warn_cpu_offline)
_

Patches currently in -mm which might be from srivatsa.bhat@linux.vnet.ibm.com are

origin.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v2.patch
linux-next.patch


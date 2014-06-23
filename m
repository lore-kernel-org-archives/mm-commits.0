From: akpm@linux-foundation.org
Subject: [folded-merged]
 cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v2.patch removed from -mm tree
Date: Mon, 23 Jun 2014 13:08:42 -0700
Message-ID: <53a8894a.AOsLoaRqHVct6OEf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaFWUIn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 16:08:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterz@infradead.org, oleg@redhat.com, srivatsa.bhat@linux.vnet.ibm.com


The patch titled
     Subject: CPU hotplug, smp: Execute any pending IPI callbacks before CPU offline
has been removed from the -mm tree.  Its filename was
     cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v2.patch

This patch was dropped because it was folded into cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch

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

cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v3.patch


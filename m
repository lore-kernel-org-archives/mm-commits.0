From: akpm@linux-foundation.org
Subject: [merged]
 kernel-irq-use-cpumask_available-for-check-of-cpumask-variable.patch
 removed from -mm tree
Date: Wed, 19 Apr 2017 13:41:39 -0700
Message-ID: <20170419204139.dMncA3bi_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47952 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765605AbdDSUlk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Apr 2017 16:41:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghackmann@google.com, grundler@chromium.org, md@google.com, mka@chromium.org, mm-commits@vger.kernel.org, rusty@rustcorp.com.au, tglx@linutronix.de


The patch titled
     Subject: kernel/irq/manage.c: use cpumask_available() for check of cpumask variable
has been removed from the -mm tree.  Its filename was
     kernel-irq-use-cpumask_available-for-check-of-cpumask-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthias Kaehlcke <mka@chromium.org>
Subject: kernel/irq/manage.c: use cpumask_available() for check of cpumask variable

This fixes the following clang warning when CONFIG_CPUMASK_OFFSTACK=y:

kernel/irq/manage.c:839:28: error: address of array
'desc->irq_common_data.affinity' will always evaluate to 'true'
[-Werror,-Wpointer-bool-conversion]

Link: http://lkml.kernel.org/r/20170412182030.83657-2-mka@chromium.org
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Grant Grundler <grundler@chromium.org>
Cc: Greg Hackmann <ghackmann@google.com>
Cc: Michael Davidson <md@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/irq/manage.c~kernel-irq-use-cpumask_available-for-check-of-cpumask-variable kernel/irq/manage.c
--- a/kernel/irq/manage.c~kernel-irq-use-cpumask_available-for-check-of-cpumask-variable
+++ a/kernel/irq/manage.c
@@ -852,7 +852,7 @@ irq_thread_check_affinity(struct irq_des
 	 * This code is triggered unconditionally. Check the affinity
 	 * mask pointer. For CPU_MASK_OFFSTACK=n this is optimized out.
 	 */
-	if (desc->irq_common_data.affinity)
+	if (cpumask_available(desc->irq_common_data.affinity))
 		cpumask_copy(mask, desc->irq_common_data.affinity);
 	else
 		valid = false;
_

Patches currently in -mm which might be from mka@chromium.org are

jiffiesh-declare-jiffies-and-jiffies_64-with-____cacheline_aligned_in_smp.patch


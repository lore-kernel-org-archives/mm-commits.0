From: akpm@linux-foundation.org
Subject: +
 kernel-irq-use-cpumask_available-for-check-of-cpumask-variable.patch added
 to -mm tree
Date: Wed, 12 Apr 2017 12:36:13 -0700
Message-ID: <58ee81ad.7ByV7pDl2xNJQIXj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48850 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754445AbdDLTgO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2017 15:36:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mka@chromium.org, ghackmann@google.com, grundler@chromium.org, md@google.com, rusty@rustcorp.com.au, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/irq/manage.c: use cpumask_available() for check of cpumask variable
has been added to the -mm tree.  Its filename is
     kernel-irq-use-cpumask_available-for-check-of-cpumask-variable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-irq-use-cpumask_available-for-check-of-cpumask-variable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-irq-use-cpumask_available-for-check-of-cpumask-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
cpumask-add-helper-cpumask_available.patch
kernel-irq-use-cpumask_available-for-check-of-cpumask-variable.patch


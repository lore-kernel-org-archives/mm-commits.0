From: akpm@linux-foundation.org
Subject: [merged]
 nfit-use-init_completion-in-acpi_nfit_flush_probe.patch removed from -mm
 tree
Date: Thu, 31 Aug 2017 12:59:08 -0700
Message-ID: <20170831195908.y_NibyjAt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37874 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbdHaT7K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Aug 2017 15:59:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, boqun.feng@gmail.com, byungchul.park@lge.com, dan.j.williams@intel.com, mingo@kernel.org, mm-commits@vger.kernel.org, npiggin@gmail.com, peterz@infradead.org, rjw@rjwysocki.net, tglx@linutronix.de, walken@google.com


The patch titled
     Subject: drivers/acpi/nfit/core.c: fix the abuse of COMPLETION_INITIALIZER_ONSTACK()
has been removed from the -mm tree.  Its filename was
     nfit-use-init_completion-in-acpi_nfit_flush_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Boqun Feng <boqun.feng@gmail.com>
Subject: drivers/acpi/nfit/core.c: fix the abuse of COMPLETION_INITIALIZER_ONSTACK()

Patch series "completion: Reduce stack usage caused by
COMPLETION_INITIALIZER_ONSTACK()".

With LOCKDEP_CROSSRELEASE and LOCKDEP_COMPLETIONS introduced, the growth
in kernel stack usage of several functions were reported:

	https://marc.info/?l=linux-kernel&m=150270063231284&w=2

The root cause of this is in COMPLETION_INITIALIZER_ONSTACK(), we use

	({init_completion(&work); work})

which will create a temporary object when returned.  However this
temporary object is unnecessary.  And this patch fixes it by making the
statement expression in COMPLETION_INITIALIZER_ONSTACK() return a pointer
rather than a whole structure.  This will reduce the stack usage even if
!LOCKDEP.

However, such a change does make one COMPLETION_INITIALIZER_ONSTACK()
callsite invalid, so we fix this first via converting to
init_completion().


This patch (of 2):

COMPLETION_INITIALIZER_ONSTACK() is supposed to used as an initializer, in
other words, it should only be used in assignment expressions or compound
literals.  So the usage in drivers/acpi/nfit/core.c:

	COMPLETION_INITIALIZER_ONSTACK(flush.cmp);

is inappropriate.

Besides, this usage could also break compilations for another fix to
reduce stack sizes caused by COMPLETION_INITIALIZER_ONSTACK(), because
that fix changes COMPLETION_INITIALIZER_ONSTACK() from rvalue to lvalue,
and usage as above will report error:

	drivers/acpi/nfit/core.c: In function 'acpi_nfit_flush_probe':
	include/linux/completion.h:77:3: error: value computed is not used [-Werror=unused-value]
	  (*({ init_completion(&work); &work; }))

This patch fixes this by replacing COMPLETION_INITIALIZER_ONSTACK() with
init_completion() in acpi_nfit_flush_probe(), which does the same
initialization without any other problem.

Link: http://lkml.kernel.org/r/20170823152542.5150-2-boqun.feng@gmail.com
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Michel Lespinasse <walken@google.com>
Cc: Byungchul Park <byungchul.park@lge.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/nfit/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/nfit/core.c~nfit-use-init_completion-in-acpi_nfit_flush_probe drivers/acpi/nfit/core.c
--- a/drivers/acpi/nfit/core.c~nfit-use-init_completion-in-acpi_nfit_flush_probe
+++ a/drivers/acpi/nfit/core.c
@@ -2884,7 +2884,7 @@ static int acpi_nfit_flush_probe(struct
 	 * need to be interruptible while waiting.
 	 */
 	INIT_WORK_ONSTACK(&flush.work, flush_probe);
-	COMPLETION_INITIALIZER_ONSTACK(flush.cmp);
+	init_completion(&flush.cmp);
 	queue_work(nfit_wq, &flush.work);
 	mutex_unlock(&acpi_desc->init_mutex);
 
_

Patches currently in -mm which might be from boqun.feng@gmail.com are



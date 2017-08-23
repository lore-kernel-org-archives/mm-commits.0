From: akpm@linux-foundation.org
Subject: + nfit-use-init_completion-in-acpi_nfit_flush_probe.patch added
 to -mm tree
Date: Wed, 23 Aug 2017 15:04:41 -0700
Message-ID: <599dfbf9.o0ITZEg6T8uD4CIC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44212 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbdHWWEn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Aug 2017 18:04:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: boqun.feng@gmail.com, arnd@arndb.de, byungchul.park@lge.com, dan.j.williams@intel.com, mingo@kernel.org, npiggin@gmail.com, peterz@infradead.org, rjw@rjwysocki.net, tglx@linutronix.de, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/acpi/nfit/core.c: use init_completion() in acpi_nfit_flush_probe()
has been added to the -mm tree.  Its filename is
     nfit-use-init_completion-in-acpi_nfit_flush_probe.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nfit-use-init_completion-in-acpi_nfit_flush_probe.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nfit-use-init_completion-in-acpi_nfit_flush_probe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Boqun Feng <boqun.feng@gmail.com>
Subject: drivers/acpi/nfit/core.c: use init_completion() in acpi_nfit_flush_probe()

Patch series "completion: Reduce stack usage caused by
COMPLETION_INITIALIZER_ONSTACK()".

With LOCKDEP_CROSSRELEASE and LOCKDEP_COMPLETIONS introduced, the growth
in kernel stack usage of several functions were reported:

	https://marc.info/?l=linux-kernel&m=150270063231284&w=2

The root cause of this is in COMPLETION_INITIALIZER_ONSTACK(), we use

	({init_completion(&work); work})

, which will create a temporary object when returned. However this
temporary object is unnecessary. And this patch fixes it by making the
statement expression in COMPLETION_INITIALIZER_ONSTACK() return a
pointer rather than a whole structure. This will reduce the stack usage
even if !LOCKDEP.

However, such a change does make one COMPLETION_INITIALIZER_ONSTACK()
callsite invalid, so we fix this first via converting to
init_completion().


This patch (of 2):

There is no need to use COMPLETION_INITIALIZER_ONSTACK() in
acpi_nfit_flush_probe(), replace it with init_completion().

Link: http://lkml.kernel.org/r/20170823152542.5150-2-boqun.feng@gmail.com
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Michel Lespinasse <walken@google.com>
Cc: Byungchul Park <byungchul.park@lge.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
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

nfit-use-init_completion-in-acpi_nfit_flush_probe.patch
completion-avoid-unnecessary-stack-allocation-for-completion_initializer_onstack.patch


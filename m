From: akpm@linux-foundation.org
Subject: + acpi-fix-bogus-preemption-logic.patch added to -mm tree
Date: Fri, 18 Jun 2010 13:02:08 -0700
Message-ID: <201006182002.o5IK29sG020448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757738Ab0FRUCS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 16:02:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, lenb@kernel.org


The patch titled
     acpi: fix bogus preemption logic
has been added to the -mm tree.  Its filename is
     acpi-fix-bogus-preemption-logic.patch

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
Subject: acpi: fix bogus preemption logic
From: Thomas Gleixner <tglx@linutronix.de>

The ACPI_PREEMPTION_POINT() logic was introduced in commit 8bd108d
(ACPICA: add preemption point after each opcode parse).  The follow up
commits abe1dfab6, 138d15692, c084ca70 tried to fix the preemption logic
back and forth, but nobody noticed that the usage of
in_atomic_preempt_off() in that context is wrong.

The check which guards the call of cond_resched() is:

    if (!in_atomic_preempt_off() && !irqs_disabled())

in_atomic_preempt_off() is not intended for general use as the comment
above the macro definition clearly says:

 * Check whether we were atomic before we did preempt_disable():
 * (used by the scheduler, *after* releasing the kernel lock)

On a CONFIG_PREEMPT=n kernel the usage of in_atomic_preempt_off() works by
accident, but with CONFIG_PREEMPT=y it's just broken.

The whole purpose of the ACPI_PREEMPTION_POINT() is to reduce the latency
on a CONFIG_PREEMPT=n kernel, so make ACPI_PREEMPTION_POINT() depend on
CONFIG_PREEMPT=n and remove the in_atomic_preempt_off() check.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/acpi/platform/aclinux.h |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN include/acpi/platform/aclinux.h~acpi-fix-bogus-preemption-logic include/acpi/platform/aclinux.h
--- a/include/acpi/platform/aclinux.h~acpi-fix-bogus-preemption-logic
+++ a/include/acpi/platform/aclinux.h
@@ -148,13 +148,17 @@ static inline void *acpi_os_acquire_obje
 #define ACPI_ALLOCATE_ZEROED(a) acpi_os_allocate_zeroed(a)
 #define ACPI_FREE(a)            kfree(a)
 
-/* Used within ACPICA to show where it is safe to preempt execution */
-#include <linux/hardirq.h>
+#ifndef CONFIG_PREEMPT
+/*
+ * Used within ACPICA to show where it is safe to preempt execution
+ * when CONFIG_PREEMPT=n
+ */
 #define ACPI_PREEMPTION_POINT() \
 	do { \
-		if (!in_atomic_preempt_off() && !irqs_disabled()) \
+		if (!irqs_disabled()) \
 			cond_resched(); \
 	} while (0)
+#endif
 
 #endif /* __KERNEL__ */
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

linux-next.patch
x86-i8259-only-register-sysdev-for-real-pic.patch
x86-proper-init-of-memtype-subtree_max_end.patch
acpi-fix-bogus-preemption-logic.patch
x86-rwsem-stay-on-fast-path-when-count0-in-__up_write.patch
x86-rwsem-minor-cleanups.patch
x86-mm-create-symbolic-index-into-address_markers-array.patch
hpet-factor-timer-allocate-from-open.patch
posix_timer-move-copy_to_usercreated_timer_id-down-in-timer_create.patch
kmap_atomic-make-kunmap_atomic-harder-to-misuse.patch
alpha-add-performance-monitor-interrupt-counter.patch
alpha-add-wrperfmonh-header-file-to-aid-use-of-wrperfmon-palcall.patch
alpha-implement-hw-performance-events-on-the-ev67-and-later-cpus.patch
kernelh-add-hw_err-printk-prefix-for-hardware-error-logging.patch
x86-use-hw_err-in-mce-handler.patch
rwsem-fully-separate-code-pathes-to-wake-writers-vs-readers.patch
rwsem-lighter-active-count-checks-when-waking-up-readers.patch
rwsem-let-rwsem_waiting_bias-represent-any-number-of-waiting-threads.patch
rwsem-wake-queued-readers-when-writer-blocks-on-active-read-lock.patch
rwsem-smaller-wrappers-around-rwsem_down_failed_common.patch
timerc-fix-kernel-doc-warning.patch
time-kill-off-config_generic_time.patch


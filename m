From: akpm@linux-foundation.org
Subject: + perfctr_watchdog-do-not-bug_on-when-msr-is-unknown.patch added to -mm tree
Date: Sat, 28 Jul 2007 23:48:05 -0700
Message-ID: <200707290648.l6T6m5QX012322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58546 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759661AbXG2Gsa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:48:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eranian@hpl.hp.com, ak@suse.de


The patch titled
     perfctr_watchdog: do not BUG_ON() when MSR is unknown
has been added to the -mm tree.  Its filename is
     perfctr_watchdog-do-not-bug_on-when-msr-is-unknown.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: perfctr_watchdog: do not BUG_ON() when MSR is unknown
From: Stephane Eranian <eranian@hpl.hp.com>

Here is a small patch to change the behavior of the PMU msr allocator
to avoid BUG_ON() when the MSR is unknwon. Instead, it now returns
ok, which means "I do not manage". The current allocator is not
yet managing the full set of PMU registers (e.g., GLOBAL_* on Core 2).

Signed-off-by: Stephane Eranian <eranian@hpl.hp.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/perfctr-watchdog.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN arch/i386/kernel/cpu/perfctr-watchdog.c~perfctr_watchdog-do-not-bug_on-when-msr-is-unknown arch/i386/kernel/cpu/perfctr-watchdog.c
--- a/arch/i386/kernel/cpu/perfctr-watchdog.c~perfctr_watchdog-do-not-bug_on-when-msr-is-unknown
+++ a/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -120,7 +120,9 @@ int reserve_perfctr_nmi(unsigned int msr
 	unsigned int counter;
 
 	counter = nmi_perfctr_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+	/* register not managed by the allocator? */
+	if (counter > NMI_MAX_COUNTER_BITS)
+		return 1;
 
 	if (!test_and_set_bit(counter, perfctr_nmi_owner))
 		return 1;
@@ -132,7 +134,9 @@ void release_perfctr_nmi(unsigned int ms
 	unsigned int counter;
 
 	counter = nmi_perfctr_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+	/* register not managed by the allocator? */
+	if (counter > NMI_MAX_COUNTER_BITS)
+		return;
 
 	clear_bit(counter, perfctr_nmi_owner);
 }
@@ -142,7 +146,9 @@ int reserve_evntsel_nmi(unsigned int msr
 	unsigned int counter;
 
 	counter = nmi_evntsel_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+	/* register not managed by the allocator? */
+	if (counter > NMI_MAX_COUNTER_BITS)
+		return 1;
 
 	if (!test_and_set_bit(counter, evntsel_nmi_owner))
 		return 1;
@@ -154,7 +160,9 @@ void release_evntsel_nmi(unsigned int ms
 	unsigned int counter;
 
 	counter = nmi_evntsel_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+	/* register not managed by the allocator? */
+	if (counter > NMI_MAX_COUNTER_BITS)
+		return;
 
 	clear_bit(counter, evntsel_nmi_owner);
 }
_

Patches currently in -mm which might be from eranian@hpl.hp.com are

make-oprofile-call-shutdown-only-once-per-session.patch
perfctr_watchdog-do-not-bug_on-when-msr-is-unknown.patch
remove-unused-tif_notify_resume-flag.patch

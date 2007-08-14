From: akpm@linux-foundation.org
Subject: - perfctr_watchdog-do-not-bug_on-when-msr-is-unknown.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:15:00 -0700
Message-ID: <200708141915.l7EJF00M016673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53691 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932591AbXHNTU4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:20:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eranian@hpl.hp.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     perfctr_watchdog: do not BUG_ON() when MSR is unknown
has been removed from the -mm tree.  Its filename was
     perfctr_watchdog-do-not-bug_on-when-msr-is-unknown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 files changed, 12 insertions(+), 4 deletions(-)

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

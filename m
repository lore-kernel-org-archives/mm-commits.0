From: akpm@linux-foundation.org
Subject: - pm-x86-remove-obsolete-pm-definitions-from-nmi-header.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:02:03 -0700
Message-ID: <200806232102.m5NL23Om016043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759586AbYFWVCc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:02:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     pm: x86: remove obsolete PM definitions from NMI header
has been removed from the -mm tree.  Its filename was
     pm-x86-remove-obsolete-pm-definitions-from-nmi-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm: x86: remove obsolete PM definitions from NMI header
From: Rafael J. Wysocki <rjw@sisk.pl>

Remove obsolete and no longer used PM-related definitions from
include/asm-x86/nmi.h .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/nmi.h |   21 ---------------------
 1 file changed, 21 deletions(-)

diff -puN include/asm-x86/nmi.h~pm-x86-remove-obsolete-pm-definitions-from-nmi-header include/asm-x86/nmi.h
--- a/include/asm-x86/nmi.h~pm-x86-remove-obsolete-pm-definitions-from-nmi-header
+++ a/include/asm-x86/nmi.h
@@ -15,27 +15,6 @@
  */
 int do_nmi_callback(struct pt_regs *regs, int cpu);
 
-#ifdef CONFIG_PM
-
-/** Replace the PM callback routine for NMI. */
-struct pm_dev *set_nmi_pm_callback(pm_callback callback);
-
-/** Unset the PM callback routine back to the default. */
-void unset_nmi_pm_callback(struct pm_dev *dev);
-
-#else
-
-static inline struct pm_dev *set_nmi_pm_callback(pm_callback callback)
-{
-	return 0;
-}
-
-static inline void unset_nmi_pm_callback(struct pm_dev *dev)
-{
-}
-
-#endif /* CONFIG_PM */

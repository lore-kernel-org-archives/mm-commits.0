Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4923F076E
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816289; cv=none; b=O01UpoOSalWr18vHEG+u79AOx1eiTy1io/JYNyHQrhKhf8L/GG4I3Dmb/pe7u6WP1Du858mieq9p8IqCO3ZZXcROeG52G0MgqRiIZlX+7YEihZBxNRHD+uGq8fSsy2MK/BqVOs0C9rw6KW6YS6Xjor6Fw0m5keZRkaraIYi+RmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816289; c=relaxed/simple;
	bh=ggF8sXFQy0CACoSDFza5RZRA0PjSME5Y7oyii9woIiE=;
	h=Date:To:From:Subject:Message-Id; b=FsAloqSYDkzkwb/x33NJ81TetGkg9u2o1Pv41jdS1Hf3d4iDE/hhzFE2+9KUNSgfu5j2ImdlGzjCHsDl7I1sriUVCdNvhNhHBCmbmFnzuKCK+N4ssvbimhorSvNBbQo2O4/Pde225j76fVL8iIhr2DMWcq/1rGnB/h7u/7NjoKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GWCmXLfR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GWCmXLfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B4B1F00A3A;
	Tue,  4 Aug 2026 04:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816288;
	bh=uw2Novjdv3H8M40IaOESgWXgaDKdlX0PvGILhN8XZG8=;
	h=Date:To:From:Subject;
	b=GWCmXLfR6XdpQIhSNSiQnnrGqLtAg/1ErrsGTkH22O/OYwwuQLreQlVj+2l2IldCu
	 0MtNn65QGiNESVtaVMevQMDuS0bceXNiZt3UkS42Q2NcgzGvBZ+bD1Al+nte3gqIEa
	 4LzcDdwlLT1ihj3Qcbt1tlHlj5U7AkgLRG+IUu44=
Date: Mon, 03 Aug 2026 21:04:47 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,dianders@chromium.org,edcr1790@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-softlockup-fix-softlockup-typos.patch removed from -mm tree
Message-Id: <20260804040448.52B4B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog/softlockup: fix softlockup typos
has been removed from the -mm tree.  Its filename was
     watchdog-softlockup-fix-softlockup-typos.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Matthew Chen <edcr1790@gmail.com>
Subject: watchdog/softlockup: fix softlockup typos
Date: Tue, 16 Jun 2026 01:45:57 +0800

Fix misspellings of "softlockup" in the watchdog enabled bit definitions
and related comments.  Also fix a nearby "successful" typo.

No functional change.

Link: https://lore.kernel.org/20260615174557.1836562-1-edcr1790@gmail.com
Signed-off-by: Matthew Chen <edcr1790@gmail.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h |    4 ++--
 kernel/watchdog.c   |   16 ++++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/include/linux/nmi.h~watchdog-softlockup-fix-softlockup-typos
+++ a/include/linux/nmi.h
@@ -77,9 +77,9 @@ static inline void reset_hung_task_detec
  * detectors are 'suspended' while 'watchdog_thresh' is equal zero.
  */
 #define WATCHDOG_HARDLOCKUP_ENABLED_BIT  0
-#define WATCHDOG_SOFTOCKUP_ENABLED_BIT   1
+#define WATCHDOG_SOFTLOCKUP_ENABLED_BIT  1
 #define WATCHDOG_HARDLOCKUP_ENABLED     (1 << WATCHDOG_HARDLOCKUP_ENABLED_BIT)
-#define WATCHDOG_SOFTOCKUP_ENABLED      (1 << WATCHDOG_SOFTOCKUP_ENABLED_BIT)
+#define WATCHDOG_SOFTLOCKUP_ENABLED     (1 << WATCHDOG_SOFTLOCKUP_ENABLED_BIT)
 
 #if defined(CONFIG_HARDLOCKUP_DETECTOR)
 extern void hardlockup_detector_disable(void);
--- a/kernel/watchdog.c~watchdog-softlockup-fix-softlockup-typos
+++ a/kernel/watchdog.c
@@ -359,14 +359,14 @@ static void lockup_detector_update_enabl
 	if (watchdog_hardlockup_available && watchdog_hardlockup_user_enabled)
 		watchdog_enabled |= WATCHDOG_HARDLOCKUP_ENABLED;
 	if (watchdog_softlockup_user_enabled)
-		watchdog_enabled |= WATCHDOG_SOFTOCKUP_ENABLED;
+		watchdog_enabled |= WATCHDOG_SOFTLOCKUP_ENABLED;
 }
 
 #ifdef CONFIG_SOFTLOCKUP_DETECTOR
 
 /*
- * Delay the soflockup report when running a known slow code.
- * It does _not_ affect the timestamp of the last successdul reschedule.
+ * Delay the softlockup report when running a known slow code.
+ * It does _not_ affect the timestamp of the last successful reschedule.
  */
 #define SOFTLOCKUP_DELAY_REPORT	ULONG_MAX
 
@@ -742,7 +742,7 @@ static int is_softlockup(unsigned long t
 			 unsigned long period_ts,
 			 unsigned long now)
 {
-	if ((watchdog_enabled & WATCHDOG_SOFTOCKUP_ENABLED) && watchdog_thresh) {
+	if ((watchdog_enabled & WATCHDOG_SOFTLOCKUP_ENABLED) && watchdog_thresh) {
 		/*
 		 * If period_ts has not been updated during a sample_period, then
 		 * in the subsequent few sample_periods, period_ts might also not
@@ -1098,11 +1098,11 @@ static void proc_watchdog_update(bool th
  * caller             | table->data points to            | 'which'
  * -------------------|----------------------------------|-------------------------------
  * proc_watchdog      | watchdog_user_enabled            | WATCHDOG_HARDLOCKUP_ENABLED |
- *                    |                                  | WATCHDOG_SOFTOCKUP_ENABLED
+ *                    |                                  | WATCHDOG_SOFTLOCKUP_ENABLED
  * -------------------|----------------------------------|-------------------------------
  * proc_nmi_watchdog  | watchdog_hardlockup_user_enabled | WATCHDOG_HARDLOCKUP_ENABLED
  * -------------------|----------------------------------|-------------------------------
- * proc_soft_watchdog | watchdog_softlockup_user_enabled | WATCHDOG_SOFTOCKUP_ENABLED
+ * proc_soft_watchdog | watchdog_softlockup_user_enabled | WATCHDOG_SOFTLOCKUP_ENABLED
  */
 static int proc_watchdog_common(int which, const struct ctl_table *table, int write,
 				void *buffer, size_t *lenp, loff_t *ppos)
@@ -1136,7 +1136,7 @@ static int proc_watchdog(const struct ct
 			 void *buffer, size_t *lenp, loff_t *ppos)
 {
 	return proc_watchdog_common(WATCHDOG_HARDLOCKUP_ENABLED |
-				    WATCHDOG_SOFTOCKUP_ENABLED,
+				    WATCHDOG_SOFTLOCKUP_ENABLED,
 				    table, write, buffer, lenp, ppos);
 }
 
@@ -1159,7 +1159,7 @@ static int proc_nmi_watchdog(const struc
 static int proc_soft_watchdog(const struct ctl_table *table, int write,
 			      void *buffer, size_t *lenp, loff_t *ppos)
 {
-	return proc_watchdog_common(WATCHDOG_SOFTOCKUP_ENABLED,
+	return proc_watchdog_common(WATCHDOG_SOFTLOCKUP_ENABLED,
 				    table, write, buffer, lenp, ppos);
 }
 #endif
_

Patches currently in -mm which might be from edcr1790@gmail.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A924E2E8DE3
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 05:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782363666; cv=none; b=ErWMv2r9rtbTbV2LVBTt947szz1ic1/qy/vbLnYfo1+fZWZYYG3BpL6hrUvvje1gW+bFAFMt5ociKFX6s0G6oVY0tSH4GbhjR5IpqKN38Txl7bg1FAjxsBEz3F+pPMrmcrxidqw4cmBBPk7KF5JGq6AepiWwNK6VsyZYJ5QqyoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782363666; c=relaxed/simple;
	bh=aUauKyB283MlcQc/EP9C6rr083inOwP6hQphZcfNxuU=;
	h=Date:To:From:Subject:Message-Id; b=gOMyn9jA+EZ1H+k1m8cP2a+ZR6MKhTZJFVh8zTJu3cNU1roa5LbYhtVFQEh12XNLZWXVRXQDdGDwvWxX1ErLI85prczWe9HlrMmpswR2bP7+Q93gvxvE9q2FPjTvD0zK4BffP9OHpXETkN9mTMnpwhMSgJ5AE0Wr22UaBJAmFb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o731Xj/+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o731Xj/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E5D1F00A3A;
	Thu, 25 Jun 2026 05:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782363665;
	bh=nGdz9N9TWoxfhAi6yZTwO2aUGC6/DkJyvI8EuGOfbTQ=;
	h=Date:To:From:Subject;
	b=o731Xj/+6Ek6hOGPbROQvvq5vaVWWTeVmKdhe6iM/5Nh4sNJjKpR11XS7x/GEO3mv
	 2KX5VEak5lpepS1tjWuAwygqU63GlBt1X0ED+y782u4er5xCooraFFnla74gh2uJSO
	 Te/iiJ+r5PvBVsxPoVDpCUcV80gfzIU/z2a1qRbI=
Date: Wed, 24 Jun 2026 22:01:04 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,dianders@chromium.org,edcr1790@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-softlockup-fix-softlockup-typos.patch added to mm-nonmm-unstable branch
Message-Id: <20260625050105.26E5D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog/softlockup: fix softlockup typos
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-softlockup-fix-softlockup-typos.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-softlockup-fix-softlockup-typos.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

watchdog-softlockup-fix-softlockup-typos.patch


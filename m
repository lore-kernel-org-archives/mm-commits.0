From: akpm@linux-foundation.org
Subject: - round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:08:55 -0700
Message-ID: <200707192008.l6JK8tKR020518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35135 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759984AbXGSUQU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, ak@suse.de, thockin@hockin.org, mm-commits@vger.kernel.org


The patch titled
     round_jiffies() for i386 and x86-64 non-critical/corrected MCE polling
has been removed from the -mm tree.  Its filename was
     round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: round_jiffies() for i386 and x86-64 non-critical/corrected MCE polling
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

This helps to reduce the frequency at which the CPU must be taken out of a
lower-power state.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Acked-by: Tim Hockin <thockin@hockin.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mcheck/non-fatal.c |    4 ++--
 arch/x86_64/kernel/mce.c                |    9 ++++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff -puN arch/i386/kernel/cpu/mcheck/non-fatal.c~round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling arch/i386/kernel/cpu/mcheck/non-fatal.c
--- a/arch/i386/kernel/cpu/mcheck/non-fatal.c~round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling
+++ a/arch/i386/kernel/cpu/mcheck/non-fatal.c
@@ -57,7 +57,7 @@ static DECLARE_DELAYED_WORK(mce_work, mc
 static void mce_work_fn(struct work_struct *work)
 { 
 	on_each_cpu(mce_checkregs, NULL, 1, 1);
-	schedule_delayed_work(&mce_work, MCE_RATE);
+	schedule_delayed_work(&mce_work, round_jiffies_relative(MCE_RATE));
 } 
 
 static int __init init_nonfatal_mce_checker(void)
@@ -82,7 +82,7 @@ static int __init init_nonfatal_mce_chec
 	/*
 	 * Check for non-fatal errors every MCE_RATE s
 	 */
-	schedule_delayed_work(&mce_work, MCE_RATE);
+	schedule_delayed_work(&mce_work, round_jiffies_relative(MCE_RATE));
 	printk(KERN_INFO "Machine check exception polling timer started.\n");
 	return 0;
 }
diff -puN arch/x86_64/kernel/mce.c~round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling arch/x86_64/kernel/mce.c
--- a/arch/x86_64/kernel/mce.c~round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling
+++ a/arch/x86_64/kernel/mce.c
@@ -375,7 +375,8 @@ static void mcheck_timer(struct work_str
 	if (mce_notify_user()) {
 		next_interval = max(next_interval/2, HZ/100);
 	} else {
-		next_interval = min(next_interval*2, check_interval*HZ);
+		next_interval = min(next_interval*2,
+				(int)round_jiffies_relative(check_interval*HZ));
 	}
 
 	schedule_delayed_work(&mcheck_work, next_interval);
@@ -441,7 +442,8 @@ static __init int periodic_mcheck_init(v
 { 
 	next_interval = check_interval * HZ;
 	if (next_interval)
-		schedule_delayed_work(&mcheck_work, next_interval);
+		schedule_delayed_work(&mcheck_work,
+				      round_jiffies_relative(next_interval));
 	idle_notifier_register(&mce_idle_notifier);
 	return 0;
 } 
@@ -733,7 +735,8 @@ static void mce_restart(void) 
 	on_each_cpu(mce_init, NULL, 1, 1);       
 	next_interval = check_interval * HZ;
 	if (next_interval)
-		schedule_delayed_work(&mcheck_work, next_interval);
+		schedule_delayed_work(&mcheck_work,
+				      round_jiffies_relative(next_interval));
 }
 
 static struct sysdev_class mce_sysclass = {
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

origin.patch
git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
x86_64-block-irq-balancing-for-timer.patch

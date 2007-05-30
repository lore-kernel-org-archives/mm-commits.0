From: akpm@linux-foundation.org
Subject: + make-mce-polling-timers-1-sec-jiffy-aligned.patch added to -mm tree
Date: Wed, 30 May 2007 11:01:09 -0700
Message-ID: <200705301801.l4UI19ql001203@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670AbXE3SBU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 14:01:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, ak@suse.de, thockin@hockin.org


The patch titled
     Make mce polling timers 1 sec jiffy aligned
has been added to the -mm tree.  Its filename is
     make-mce-polling-timers-1-sec-jiffy-aligned.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make mce polling timers 1 sec jiffy aligned
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

round_jiffies() for i386 and x86-64 non-critical/corrected MCE polling.

This helps to reduce the frequency at which the CPU must be taken out of a
lower-power state.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Tim Hockin <thockin@hockin.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mcheck/non-fatal.c |    4 ++--
 arch/x86_64/kernel/mce.c                |    9 ++++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff -puN arch/i386/kernel/cpu/mcheck/non-fatal.c~make-mce-polling-timers-1-sec-jiffy-aligned arch/i386/kernel/cpu/mcheck/non-fatal.c
--- a/arch/i386/kernel/cpu/mcheck/non-fatal.c~make-mce-polling-timers-1-sec-jiffy-aligned
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
diff -puN arch/x86_64/kernel/mce.c~make-mce-polling-timers-1-sec-jiffy-aligned arch/x86_64/kernel/mce.c
--- a/arch/x86_64/kernel/mce.c~make-mce-polling-timers-1-sec-jiffy-aligned
+++ a/arch/x86_64/kernel/mce.c
@@ -378,7 +378,8 @@ static void mcheck_timer(struct work_str
 		next_interval = min(next_interval*2, check_interval*HZ);
 	}
 
-	schedule_delayed_work(&mcheck_work, next_interval);
+	schedule_delayed_work(&mcheck_work,
+			      round_jiffies_relative(next_interval));
 }
 
 /*
@@ -441,7 +442,8 @@ static __init int periodic_mcheck_init(v
 { 
 	next_interval = check_interval * HZ;
 	if (next_interval)
-		schedule_delayed_work(&mcheck_work, next_interval);
+		schedule_delayed_work(&mcheck_work,
+				round_jiffies_relative(next_interval));
 	idle_notifier_register(&mce_idle_notifier);
 	return 0;
 } 
@@ -731,7 +733,8 @@ static void mce_restart(void) 
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

make-usb-autosuspend-timer-1-sec-jiffy-aligned.patch
make-mce-polling-timers-1-sec-jiffy-aligned.patch

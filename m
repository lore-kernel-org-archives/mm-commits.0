From: akpm@linux-foundation.org
Subject: [merged] kernel-profilec-convert-printk-to-pr_foo.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:36:22 -0700
Message-ID: <53960cb6.SV/+6rwMnj/iiJ/Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54179 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbaFITgX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:36:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paul.gortmaker@windriver.com, fabf@skynet.be

Subject: [merged] kernel-profilec-convert-printk-to-pr_foo.patch removed from -mm tree
To: fabf@skynet.be,paul.gortmaker@windriver.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:36:22 -0700


The patch titled
     Subject: kernel/profile.c: convert printk to pr_foo()
has been removed from the -mm tree.  Its filename was
     kernel-profilec-convert-printk-to-pr_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: kernel/profile.c: convert printk to pr_foo()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/profile.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN kernel/profile.c~kernel-profilec-convert-printk-to-pr_foo kernel/profile.c
--- a/kernel/profile.c~kernel-profilec-convert-printk-to-pr_foo
+++ a/kernel/profile.c
@@ -64,12 +64,10 @@ int profile_setup(char *str)
 			str += strlen(sleepstr) + 1;
 		if (get_option(&str, &par))
 			prof_shift = par;
-		printk(KERN_INFO
-			"kernel sleep profiling enabled (shift: %ld)\n",
+		pr_info("kernel sleep profiling enabled (shift: %ld)\n",
 			prof_shift);
 #else
-		printk(KERN_WARNING
-			"kernel sleep profiling requires CONFIG_SCHEDSTATS\n");
+		pr_warn("kernel sleep profiling requires CONFIG_SCHEDSTATS\n");
 #endif /* CONFIG_SCHEDSTATS */
 	} else if (!strncmp(str, schedstr, strlen(schedstr))) {
 		prof_on = SCHED_PROFILING;
@@ -77,8 +75,7 @@ int profile_setup(char *str)
 			str += strlen(schedstr) + 1;
 		if (get_option(&str, &par))
 			prof_shift = par;
-		printk(KERN_INFO
-			"kernel schedule profiling enabled (shift: %ld)\n",
+		pr_info("kernel schedule profiling enabled (shift: %ld)\n",
 			prof_shift);
 	} else if (!strncmp(str, kvmstr, strlen(kvmstr))) {
 		prof_on = KVM_PROFILING;
@@ -86,13 +83,12 @@ int profile_setup(char *str)
 			str += strlen(kvmstr) + 1;
 		if (get_option(&str, &par))
 			prof_shift = par;
-		printk(KERN_INFO
-			"kernel KVM profiling enabled (shift: %ld)\n",
+		pr_info("kernel KVM profiling enabled (shift: %ld)\n",
 			prof_shift);
 	} else if (get_option(&str, &par)) {
 		prof_shift = par;
 		prof_on = CPU_PROFILING;
-		printk(KERN_INFO "kernel profiling enabled (shift: %ld)\n",
+		pr_info("kernel profiling enabled (shift: %ld)\n",
 			prof_shift);
 	}
 	return 1;
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch


From: akpm@linux-foundation.org
Subject: + sched-make-scheduler-sysfs-attributes-sysdev-class-devices.patch added to -mm tree
Date: Tue, 29 Jul 2008 21:05:04 -0700
Message-ID: <200807300405.m6U4541W006052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818AbYG3EFt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 00:05:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, drzeus-list@drzeus.cx, gregkh@suse.de, mingo@elte.hu


The patch titled
     sched: make scheduler sysfs attributes sysdev class devices
has been added to the -mm tree.  Its filename is
     sched-make-scheduler-sysfs-attributes-sysdev-class-devices.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sched: make scheduler sysfs attributes sysdev class devices
From: Andi Kleen <andi@firstfloor.org>

They are really class devices, but were incorrectly declared.  This
leads to crashes with the recent changes that makes non normal sysdevs
use a different prototype.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN kernel/sched.c~sched-make-scheduler-sysfs-attributes-sysdev-class-devices kernel/sched.c
--- a/kernel/sched.c~sched-make-scheduler-sysfs-attributes-sysdev-class-devices
+++ a/kernel/sched.c
@@ -7660,34 +7660,34 @@ static ssize_t sched_power_savings_store
 }
 
 #ifdef CONFIG_SCHED_MC
-static ssize_t sched_mc_power_savings_show(struct sys_device *dev,
-				struct sysdev_attribute *attr, char *page)
+static ssize_t sched_mc_power_savings_show(struct sysdev_class *class,
+					   char *page)
 {
 	return sprintf(page, "%u\n", sched_mc_power_savings);
 }
-static ssize_t sched_mc_power_savings_store(struct sys_device *dev,
-					    struct sysdev_attribute *attr,
+static ssize_t sched_mc_power_savings_store(struct sysdev_class *class,
 					    const char *buf, size_t count)
 {
 	return sched_power_savings_store(buf, count, 0);
 }
-static SYSDEV_ATTR(sched_mc_power_savings, 0644, sched_mc_power_savings_show,
-		   sched_mc_power_savings_store);
+static SYSDEV_CLASS_ATTR(sched_mc_power_savings, 0644, 
+			 sched_mc_power_savings_show,
+		         sched_mc_power_savings_store);
 #endif
 
 #ifdef CONFIG_SCHED_SMT
-static ssize_t sched_smt_power_savings_show(struct sys_device *dev,
-				struct sysdev_attribute *attr, char *page)
+static ssize_t sched_smt_power_savings_show(struct sysdev_class *dev,
+					    char *page)
 {
 	return sprintf(page, "%u\n", sched_smt_power_savings);
 }
-static ssize_t sched_smt_power_savings_store(struct sys_device *dev,
-					     struct sysdev_attribute *attr,
+static ssize_t sched_smt_power_savings_store(struct sysdev_class *dev,
 					     const char *buf, size_t count)
 {
 	return sched_power_savings_store(buf, count, 1);
 }
-static SYSDEV_ATTR(sched_smt_power_savings, 0644, sched_smt_power_savings_show,
+static SYSDEV_CLASS_ATTR(sched_smt_power_savings, 0644, 
+		   sched_smt_power_savings_show,
 		   sched_smt_power_savings_store);
 #endif
 
_

Patches currently in -mm which might be from andi@firstfloor.org are

cpufreq-acpi-only-call-_ppc-after-cpufreq-acpi-init-funcs-got-called-already.patch
acpi-cpufreq-cleanup-move-bailing-out-of-function-before-locking-the-mutex.patch
vfs-increase-pseudo-filesystem-block-size-to-page_size.patch
linux-next.patch
acpi-add-checking-for-null-early-param.patch
acpi-compal-laptop-use-rfkill-switch-subsystem.patch
sched-make-scheduler-sysfs-attributes-sysdev-class-devices.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
profile-likely-unlikely-macros.patch


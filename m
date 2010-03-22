From: akpm@linux-foundation.org
Subject: + x86-convert-cpu-notifier-to-return-encapsulate-errno-value.patch added to -mm tree
Date: Mon, 22 Mar 2010 14:49:09 -0700
Message-ID: <201003222149.o2MLnASD029428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756554Ab0CVVt3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 17:49:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de


The patch titled
     x86: convert cpu notifier to return encapsulate errno value
has been added to the -mm tree.  Its filename is
     x86-convert-cpu-notifier-to-return-encapsulate-errno-value.patch

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
Subject: x86: convert cpu notifier to return encapsulate errno value
From: Akinobu Mita <akinobu.mita@gmail.com>

By the previous modification, the cpu notifier can return encapsulate
errno value.  This converts the cpu notifiers for msr, cpuid, and
therm_throt.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +-
 arch/x86/kernel/cpuid.c                  |    2 +-
 arch/x86/kernel/msr.c                    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/kernel/cpu/mcheck/therm_throt.c~x86-convert-cpu-notifier-to-return-encapsulate-errno-value arch/x86/kernel/cpu/mcheck/therm_throt.c
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c~x86-convert-cpu-notifier-to-return-encapsulate-errno-value
+++ a/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -190,7 +190,7 @@ thermal_throttle_cpu_callback(struct not
 		mutex_unlock(&therm_cpu_lock);
 		break;
 	}
-	return err ? NOTIFY_BAD : NOTIFY_OK;
+	return notifier_from_errno(err);
 }
 
 static struct notifier_block thermal_throttle_cpu_notifier __cpuinitdata =
diff -puN arch/x86/kernel/cpuid.c~x86-convert-cpu-notifier-to-return-encapsulate-errno-value arch/x86/kernel/cpuid.c
--- a/arch/x86/kernel/cpuid.c~x86-convert-cpu-notifier-to-return-encapsulate-errno-value
+++ a/arch/x86/kernel/cpuid.c
@@ -169,7 +169,7 @@ static int __cpuinit cpuid_class_cpu_cal
 		cpuid_device_destroy(cpu);
 		break;
 	}
-	return err ? NOTIFY_BAD : NOTIFY_OK;
+	return notifier_from_errno(err);
 }
 
 static struct notifier_block __refdata cpuid_class_cpu_notifier =
diff -puN arch/x86/kernel/msr.c~x86-convert-cpu-notifier-to-return-encapsulate-errno-value arch/x86/kernel/msr.c
--- a/arch/x86/kernel/msr.c~x86-convert-cpu-notifier-to-return-encapsulate-errno-value
+++ a/arch/x86/kernel/msr.c
@@ -229,7 +229,7 @@ static int __cpuinit msr_class_cpu_callb
 		msr_device_destroy(cpu);
 		break;
 	}
-	return err ? NOTIFY_BAD : NOTIFY_OK;
+	return notifier_from_errno(err);
 }
 
 static struct notifier_block __refdata msr_class_cpu_notifier = {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

intel-iommu-use-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
cpu-hotplug-introduce-cpu_notify-__cpu_notify-cpu_notify_nofail.patch
cpu-hotplug-return-better-errno-on-cpu-hotplug-failure.patch
notifier-change-notifier_from_errno0-to-return-notify_ok.patch
x86-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
topology-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
kernel-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
slab-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
iucv-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
ehca-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
s390-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
md-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
fault-injection-add-cpu-notifier-error-injection-module.patch
bitops-remove-temporary-for_each_bit.patch


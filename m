From: akpm@linux-foundation.org
Subject: + kvm-ensure-hard-lockup-detection-is-disabled-by-default.patch
 added to -mm tree
Date: Wed, 13 Aug 2014 15:28:49 -0700
Message-ID: <53ebe6a1.DfQ04o38yGfTR8bt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:60450 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbaHMW2u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Aug 2014 18:28:50 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so131635pab.3
        for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2014 15:28:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, drjones@redhat.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kvm: ensure hard lockup detection is disabled by default
has been added to the -mm tree.  Its filename is
     kvm-ensure-hard-lockup-detection-is-disabled-by-default.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kvm-ensure-hard-lockup-detection-is-disabled-by-default.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kvm-ensure-hard-lockup-detection-is-disabled-by-default.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ulrich Obergfell <uobergfe@redhat.com>
Subject: kvm: ensure hard lockup detection is disabled by default

Use watchdog_enable_hardlockup_detector() to set hard lockup detection's
default value to false.  It's risky to run this detection in a guest, as
false positives are easy to trigger, especially if the host is
overcommitted.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/kvm.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN arch/x86/kernel/kvm.c~kvm-ensure-hard-lockup-detection-is-disabled-by-default arch/x86/kernel/kvm.c
--- a/arch/x86/kernel/kvm.c~kvm-ensure-hard-lockup-detection-is-disabled-by-default
+++ a/arch/x86/kernel/kvm.c
@@ -35,6 +35,7 @@
 #include <linux/slab.h>
 #include <linux/kprobes.h>
 #include <linux/debugfs.h>
+#include <linux/nmi.h>
 #include <asm/timer.h>
 #include <asm/cpu.h>
 #include <asm/traps.h>
@@ -499,6 +500,13 @@ void __init kvm_guest_init(void)
 #else
 	kvm_guest_cpu_init();
 #endif
+
+	/*
+	 * Hard lockup detection is enabled by default. Disable it, as guests
+	 * can get false positives too easily, for example if the host is
+	 * overcommitted.
+	 */
+	watchdog_enable_hardlockup_detector(false);
 }
 
 static noinline uint32_t __kvm_cpuid_base(void)
_

Patches currently in -mm which might be from uobergfe@redhat.com are

watchdog-fix-print-once-on-enable.patch
watchdog-control-hard-lockup-detection-default.patch
kvm-ensure-hard-lockup-detection-is-disabled-by-default.patch


From: akpm@linux-foundation.org
Subject: [merged]
 kvm-ensure-hard-lockup-detection-is-disabled-by-default.patch removed from
 -mm tree
Date: Tue, 14 Oct 2014 11:23:10 -0700
Message-ID: <543d6a0e.l61yh3GbCJuGxBCt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbaJNSXJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:23:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, drjones@redhat.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kvm: ensure hard lockup detection is disabled by default
has been removed from the -mm tree.  Its filename was
     kvm-ensure-hard-lockup-detection-is-disabled-by-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch


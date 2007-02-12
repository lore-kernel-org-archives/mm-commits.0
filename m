From: akpm@linux-foundation.org
Subject: - hotplug-allow-modules-to-use-the-cpu-hotplug-notifiers.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:48:59 -0800
Message-ID: <200702122248.l1CMmxtc014072@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45619 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030334AbXBLWtR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:49:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, oleg@tv-sign.ru, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     hotplug: Allow modules to use the cpu hotplug notifiers even if !CONFIG_HOTPLUG_CPU
has been removed from the -mm tree.  Its filename was
     hotplug-allow-modules-to-use-the-cpu-hotplug-notifiers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hotplug: Allow modules to use the cpu hotplug notifiers even if !CONFIG_HOTPLUG_CPU
From: Avi Kivity <avi@qumranet.com>

The following patchset allows a host with running virtual machines to be
suspended and, on at least a subset of the machines tested, resumed.  Note
that this is orthogonal to suspending and resuming an individual guest to a
file.

A side effect of implementing suspend/resume is that cpu hotplug is now
supported.  This should please the owners of big iron.


This patch:

KVM wants the cpu hotplug notifications, both for cpu hotplug itself, but more
commonly for host suspend/resume.

In order to avoid extensive #ifdefs, provide stubs when CONFIG_CPU_HOTPLUG is
not defined.

In all, we have four cases:

- UP: register and unregister stubbed out
- SMP+hotplug: full register and unregister
- SMP, no hotplug, core: register as __init, unregister stubbed
      (cpus are brought up during core initialization)
- SMP, no hotplug, module: register and unregister stubbed out
      (cpus cannot be brought up during module lifetime)

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu.h |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN include/linux/cpu.h~hotplug-allow-modules-to-use-the-cpu-hotplug-notifiers include/linux/cpu.h
--- a/include/linux/cpu.h~hotplug-allow-modules-to-use-the-cpu-hotplug-notifiers
+++ a/include/linux/cpu.h
@@ -49,10 +49,20 @@ struct notifier_block;
 
 #ifdef CONFIG_SMP
 /* Need to know about CPUs going up/down? */
-extern int register_cpu_notifier(struct notifier_block *nb);
 #ifdef CONFIG_HOTPLUG_CPU
+extern int register_cpu_notifier(struct notifier_block *nb);
 extern void unregister_cpu_notifier(struct notifier_block *nb);
 #else
+
+#ifndef MODULE
+extern int register_cpu_notifier(struct notifier_block *nb);
+#else
+static inline int register_cpu_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+#endif
+
 static inline void unregister_cpu_notifier(struct notifier_block *nb)
 {
 }
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch

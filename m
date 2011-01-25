From: akpm@linux-foundation.org
Subject: [merged] intel_idle-fix-section-mismatch.patch removed from -mm tree
Date: Tue, 25 Jan 2011 12:18:14 -0800
Message-ID: <201101252018.p0PKIEi5005697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752101Ab1AYUSz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Jan 2011 15:18:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, lenb@kernel.org, stefanr@s5r6.in-berlin.de, mm-commits@vger.kernel.org


The patch titled
     intel_idle: fix section mismatch
has been removed from the -mm tree.  Its filename was
     intel_idle-fix-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: intel_idle: fix section mismatch
From: Shaohua Li <shaohua.li@intel.com>

WARNING: drivers/idle/built-in.o(.text+0x112): Section mismatch in reference from the function intel_idle_probe() to the variable .cpuinit.data:setup_broadcast_notifier
The function intel_idle_probe() references
the variable __cpuinitdata setup_broadcast_notifier.
This is often because intel_idle_probe lacks a __cpuinitdata
annotation or the annotation of setup_broadcast_notifier is wrong.

WARNING: drivers/idle/built-in.o(.exit.text+0x2d): Section mismatch in reference from the function intel_idle_exit() to the variable .cpuinit.data:setup_broadcast_notifier
The function __exit intel_idle_exit() references
a variable __cpuinitdata setup_broadcast_notifier.
This is often seen when error handling in the exit function
uses functionality in the init path.
The fix is often to remove the __cpuinitdata annotation of
setup_broadcast_notifier so it may be used outside an init section.

Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/idle/intel_idle.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/idle/intel_idle.c~intel_idle-fix-section-mismatch drivers/idle/intel_idle.c
--- a/drivers/idle/intel_idle.c~intel_idle-fix-section-mismatch
+++ a/drivers/idle/intel_idle.c
@@ -274,7 +274,7 @@ static void __setup_broadcast_timer(void
 	clockevents_notify(reason, &cpu);
 }
 
-static int __cpuinit setup_broadcast_cpuhp_notify(struct notifier_block *n,
+static int setup_broadcast_cpuhp_notify(struct notifier_block *n,
 		unsigned long action, void *hcpu)
 {
 	int hotcpu = (unsigned long)hcpu;
@@ -292,7 +292,7 @@ static int __cpuinit setup_broadcast_cpu
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata setup_broadcast_notifier = {
+static struct notifier_block setup_broadcast_notifier = {
 	.notifier_call = setup_broadcast_cpuhp_notify,
 };
 
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
fs-ioctlc-remove-unnecessary-variable.patch


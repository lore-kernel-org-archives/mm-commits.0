From: akpm@linux-foundation.org
Subject: + intel_idle-fix-section-mismatch.patch added to -mm tree
Date: Mon, 24 Jan 2011 14:50:22 -0800
Message-ID: <201101242250.p0OMoMQF015645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344Ab1AXWvW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Jan 2011 17:51:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, lenb@kernel.org, stefanr@s5r6.in-berlin.de


The patch titled
     intel_idle: fix section mismatch
has been added to the -mm tree.  Its filename is
     intel_idle-fix-section-mismatch.patch

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

intel_idle-fix-section-mismatch.patch
fs-ioctlc-remove-unnecessary-variable.patch


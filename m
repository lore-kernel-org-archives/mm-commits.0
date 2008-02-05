From: akpm@linux-foundation.org
Subject: - ia64-remove-dead-code.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:39:15 -0800
Message-ID: <200802052238.m15Mcu3I012996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35980 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762291AbYBEWlN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: remove dead code
has been removed from the -mm tree.  Its filename was
     ia64-remove-dead-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64: remove dead code
From: "Jan Beulich" <jbeulich@novell.com>

Neither __cpu_down() nor __cpu_die() are being referenced without
CONFIG_HOTPLUG_CPU.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/smpboot.c |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN arch/ia64/kernel/smpboot.c~ia64-remove-dead-code arch/ia64/kernel/smpboot.c
--- a/arch/ia64/kernel/smpboot.c~ia64-remove-dead-code
+++ a/arch/ia64/kernel/smpboot.c
@@ -767,17 +767,6 @@ void __cpu_die(unsigned int cpu)
 	}
  	printk(KERN_ERR "CPU %u didn't die...\n", cpu);
 }
-#else /* !CONFIG_HOTPLUG_CPU */
-int __cpu_disable(void)
-{
-	return -ENOSYS;
-}
-
-void __cpu_die(unsigned int cpu)
-{
-	/* We said "no" in __cpu_disable */
-	BUG();
-}
 #endif /* CONFIG_HOTPLUG_CPU */
 
 void
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
git-acpi.patch
constify-tables-in-kernel-sysctl_checkc.patch
constify-tables-in-kernel-sysctl_checkc-fix.patch

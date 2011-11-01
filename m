From: akpm@linux-foundation.org
Subject: [merged] printk-add-console_suspend-module-parameter.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:14:21 -0700
Message-ID: <201111012114.pA1LELC3014685@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29814 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVOX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:14:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yanmin_zhang@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: add console_suspend module parameter
has been removed from the -mm tree.  Its filename was
     printk-add-console_suspend-module-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: printk: add console_suspend module parameter

We are enabling some power features on medfield.  To test suspend-2-RAM
conveniently, we need turn on/off console_suspend_enabled frequently.

Add a module parameter, so users could change it by:
/sys/module/printk/parameters/console_suspend

Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    5 +++++
 kernel/printk.c                     |    4 ++++
 2 files changed, 9 insertions(+)

diff -puN Documentation/kernel-parameters.txt~printk-add-console_suspend-module-parameter Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~printk-add-console_suspend-module-parameter
+++ a/Documentation/kernel-parameters.txt
@@ -1669,6 +1669,11 @@ bytes respectively. Such letter suffixes
 			debugging driver suspend/resume hooks).  This may
 			not work reliably with all consoles, but is known
 			to work with serial and VGA consoles.
+			To facilitate more flexible debugging, we also add
+			console_suspend, a printk module parameter to control
+			it. Users could use console_suspend (usually
+			/sys/module/printk/parameters/console_suspend) to
+			turn on/off it dynamically.
 
 	noaliencache	[MM, NUMA, SLAB] Disables the allocation of alien
 			caches in the slab allocator.  Saves per-node memory,
diff -puN kernel/printk.c~printk-add-console_suspend-module-parameter kernel/printk.c
--- a/kernel/printk.c~printk-add-console_suspend-module-parameter
+++ a/kernel/printk.c
@@ -1111,6 +1111,10 @@ static int __init console_suspend_disabl
 	return 1;
 }
 __setup("no_console_suspend", console_suspend_disable);
+module_param_named(console_suspend, console_suspend_enabled,
+		bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(console_suspend, "suspend console during suspend"
+	" and hibernate operations");
 
 /**
  * suspend_console - suspend the console subsystem
_

Patches currently in -mm which might be from yanmin_zhang@linux.intel.com are

origin.patch


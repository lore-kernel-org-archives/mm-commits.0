From: akpm@linux-foundation.org
Subject: [merged] printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:14:18 -0700
Message-ID: <201111012114.pA1LEInB032034@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29805 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVOW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:14:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yanmin_zhang@linux.intel.com, yanmin.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: add module parameter ignore_loglevel to control ignore_loglevel
has been removed from the -mm tree.  Its filename was
     printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: printk: add module parameter ignore_loglevel to control ignore_loglevel

We are enabling some power features on medfield.  To test suspend-2-RAM
conveniently, we need turn on/off ignore_loglevel frequently without
rebooting.

Add a module parameter, so users can change it by:
/sys/module/printk/parameters/ignore_loglevel

Signed-off-by: Yanmin Zhang <yanmin.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    3 +++
 kernel/printk.c                     |    3 +++
 2 files changed, 6 insertions(+)

diff -puN Documentation/kernel-parameters.txt~printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel
+++ a/Documentation/kernel-parameters.txt
@@ -973,6 +973,9 @@ bytes respectively. Such letter suffixes
 	ignore_loglevel	[KNL]
 			Ignore loglevel setting - this will print /all/
 			kernel messages to the console. Useful for debugging.
+			We also add it as printk module parameter, so users
+			could change it dynamically, usually by
+			/sys/module/printk/parameters/ignore_loglevel.
 
 	ihash_entries=	[KNL]
 			Set number of hash buckets for inode cache.
diff -puN kernel/printk.c~printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel kernel/printk.c
--- a/kernel/printk.c~printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel
+++ a/kernel/printk.c
@@ -532,6 +532,9 @@ static int __init ignore_loglevel_setup(
 }
 
 early_param("ignore_loglevel", ignore_loglevel_setup);
+module_param_named(ignore_loglevel, ignore_loglevel, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(ignore_loglevel, "ignore loglevel setting, to"
+	"print all kernel messages to the console.");
 
 /*
  * Write out chars from start to end - 1 inclusive
_

Patches currently in -mm which might be from yanmin_zhang@linux.intel.com are

origin.patch


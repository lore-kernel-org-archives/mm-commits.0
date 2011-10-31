From: akpm@linux-foundation.org
Subject: [folded] printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel-fix.patch removed from -mm tree
Date: Mon, 31 Oct 2011 16:50:27 -0700
Message-ID: <201110312350.p9VNoRt1007108@wpaz37.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:43333 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab1JaXuc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2011 19:50:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yanmin_zhang@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: add ignore_loglevel as module parameter
has been removed from the -mm tree.  Its filename was
     printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel-fix.patch

This patch was dropped because it was folded into printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: printk: add ignore_loglevel as module parameter

We are enabling some power features on medfield.  To test suspend-2-RAM
conveniently, we need turn on/off ignore_loglevel frequently without
rebooting.

Add a module parameter, so users could change it by:
/sys/module/printk/parameters/ignore_loglevel

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    3 +++
 kernel/printk.c                     |    2 ++
 2 files changed, 5 insertions(+)

diff -puN Documentation/kernel-parameters.txt~printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel-fix Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel-fix
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
diff -puN kernel/printk.c~printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel-fix kernel/printk.c
--- a/kernel/printk.c~printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel-fix
+++ a/kernel/printk.c
@@ -533,6 +533,8 @@ static int __init ignore_loglevel_setup(
 
 early_param("ignore_loglevel", ignore_loglevel_setup);
 module_param_named(ignore_loglevel, ignore_loglevel, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(ignore_loglevel, "ignore loglevel setting, to"
+	"print all kernel messages to the console.");
 
 /*
  * Write out chars from start to end - 1 inclusive
_

Patches currently in -mm which might be from yanmin_zhang@linux.intel.com are

printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel.patch
printk-add-console_suspend-module-parameter.patch


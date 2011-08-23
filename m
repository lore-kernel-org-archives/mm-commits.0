From: akpm@linux-foundation.org
Subject: + printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel-fix.patch added to -mm tree
Date: Tue, 23 Aug 2011 13:38:19 -0700
Message-ID: <201108232038.p7NKcJhI005230@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755878Ab1HWUiU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Aug 2011 16:38:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yanmin_zhang@linux.intel.com


The patch titled
     printk: add ignore_loglevel as module parameter
has been added to the -mm tree.  Its filename is
     printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel-fix.patch

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
Subject: printk: add ignore_loglevel as module parameter
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>

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
printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel-fix.patch


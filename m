From: akpm@linux-foundation.org
Subject: [merged] sysctl-extern-cleanup-module.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:05:05 -0400
Message-ID: <201003150705.o2F75cqN017104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54240 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759745Ab0COHFo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:05:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     sysctl extern cleanup: module
has been removed from the -mm tree.  Its filename was
     sysctl-extern-cleanup-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl extern cleanup: module
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be moved to their own header file,
and then include them in relavant .c files.

Move modprobe_path extern declaration to linux/kmod.h
Move modules_disabled extern declaration to linux/module.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmod.h   |    1 +
 include/linux/module.h |    1 +
 kernel/sysctl.c        |    4 ----
 3 files changed, 2 insertions(+), 4 deletions(-)

diff -puN include/linux/kmod.h~sysctl-extern-cleanup-module include/linux/kmod.h
--- a/include/linux/kmod.h~sysctl-extern-cleanup-module
+++ a/include/linux/kmod.h
@@ -27,6 +27,7 @@
 #define KMOD_PATH_LEN 256
 
 #ifdef CONFIG_MODULES
+extern char modprobe_path[]; /* for sysctl */
 /* modprobe exit status on success, -ve on error.  Return value
  * usually useless though. */
 extern int __request_module(bool wait, const char *name, ...) \
diff -puN include/linux/module.h~sysctl-extern-cleanup-module include/linux/module.h
--- a/include/linux/module.h~sysctl-extern-cleanup-module
+++ a/include/linux/module.h
@@ -175,6 +175,7 @@ struct notifier_block;
 
 #ifdef CONFIG_MODULES
 
+extern int modules_disabled; /* for sysctl */
 /* Get/put a kernel symbol (calls must be symmetric) */
 void *__symbol_get(const char *symbol);
 void *__symbol_get_gpl(const char *symbol);
diff -puN kernel/sysctl.c~sysctl-extern-cleanup-module kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-extern-cleanup-module
+++ a/kernel/sysctl.c
@@ -111,10 +111,6 @@ static int min_percpu_pagelist_fract = 8
 
 static int ngroups_max = NGROUPS_MAX;
 
-#ifdef CONFIG_MODULES
-extern char modprobe_path[];
-extern int modules_disabled;
-#endif
 #ifdef CONFIG_CHR_DEV_SG
 extern int sg_big_buff;
 #endif
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
linux-next.patch


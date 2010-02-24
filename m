From: akpm@linux-foundation.org
Subject: + sysctl-extern-cleanup-module.patch added to -mm tree
Date: Wed, 24 Feb 2010 12:19:48 -0800
Message-ID: <201002242019.o1OKJmoE018209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758020Ab0BXUWB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 15:22:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, rusty@rustcorp.com.au


The patch titled
     sysctl extern cleanup: module
has been added to the -mm tree.  Its filename is
     sysctl-extern-cleanup-module.patch

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
Subject: sysctl extern cleanup: module
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be move to their own head file, and
then include them in relavant .c files.

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
@@ -28,6 +28,7 @@
 #define KMOD_PATH_LEN 256
 
 #ifdef CONFIG_MODULES
+extern char *modprobe_path; /* for sysctl */
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
@@ -108,10 +108,6 @@ static int min_percpu_pagelist_fract = 8
 
 static int ngroups_max = NGROUPS_MAX;
 
-#ifdef CONFIG_MODULES
-extern char *modprobe_path;
-extern int modules_disabled;
-#endif
 #ifdef CONFIG_CHR_DEV_SG
 extern int sg_big_buff;
 #endif
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

linux-next.patch
sysctl-extern-cleanup-c_a_d.patch
sysctl-extern-cleanup-signal.patch
sysctl-extern-cleanup-binfmts.patch
sysctl-extern-cleanup-pid.patch
sysctl-extern-cleanup-mm.patch
sysctl-extern-cleanup-compat.patch
sysctl-extern-cleanup-latencytop.patch
sysctl-extern-cleanup-file-nr.patch
sysctl-extern-cleanup-rcu.patch
sysctl-extern-cleanup-block-iopoll.patch
sysctl-extern-cleanup-module.patch
sysctl-extern-cleanup-sg.patch
sysctl-extern-cleanup-acct.patch
sysctl-extern-cleanup-rtmutex.patch
sysctl-extern-cleanup-lockdep.patch
sysctl-extern-cleanup-poll.patch
sysctl-extern-cleanup-inotify.patch


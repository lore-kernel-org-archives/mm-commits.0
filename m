From: akpm@linux-foundation.org
Subject: + sysctl-extern-cleanup-block-iopoll.patch added to -mm tree
Date: Wed, 24 Feb 2010 12:19:46 -0800
Message-ID: <201002242019.o1OKJk6C018204@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757985Ab0BXUUU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 15:20:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, jens.axboe@oracle.com


The patch titled
     sysctl extern cleanup: block iopoll
has been added to the -mm tree.  Its filename is
     sysctl-extern-cleanup-block-iopoll.patch

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
Subject: sysctl extern cleanup: block iopoll
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be move to their own head file, and
then include them in relavant .c files.

blk_iopoll_enabled declared in linux/blk-iopoll.h, remove the declaration
in sysctl.c, include the head file instead.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/sysctl.c~sysctl-extern-cleanup-block-iopoll kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-extern-cleanup-block-iopoll
+++ a/kernel/sysctl.c
@@ -60,6 +60,9 @@
 #include <linux/compat.h>
 #include <linux/latencytop.h>
 #include <linux/file.h>
+#ifdef CONFIG_BLOCK
+#include <linux/blk-iopoll.h>
+#endif
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -79,9 +82,6 @@
 
 /* External variables not in a header file. */
 extern int max_threads;
-#ifdef CONFIG_BLOCK
-extern int blk_iopoll_enabled;
-#endif
 
 /* Constants used for minimum and  maximum */
 #ifdef CONFIG_DETECT_SOFTLOCKUP
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


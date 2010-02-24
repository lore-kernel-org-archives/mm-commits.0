From: akpm@linux-foundation.org
Subject: + sysctl-extern-cleanup-sg.patch added to -mm tree
Date: Wed, 24 Feb 2010 12:19:50 -0800
Message-ID: <201002242019.o1OKJoeJ018213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758022Ab0BXUWD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 15:22:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, James.Bottomley@HansenPartnership.com, dgilbert@interlog.com


The patch titled
     sysctl extern cleanup: sg
has been added to the -mm tree.  Its filename is
     sysctl-extern-cleanup-sg.patch

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
Subject: sysctl extern cleanup: sg
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be move to their own head file, and
then include them in relavant .c files.

Move sg_big_buff extern declaration to scsi/sg.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/scsi/sg.h |    3 +++
 kernel/sysctl.c   |    7 +++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff -puN include/scsi/sg.h~sysctl-extern-cleanup-sg include/scsi/sg.h
--- a/include/scsi/sg.h~sysctl-extern-cleanup-sg
+++ a/include/scsi/sg.h
@@ -70,6 +70,9 @@ Major new features in SG 3.x driver (cf 
  (for the lk 2.2 series).
 */
 
+#ifdef __KERNEL__
+extern int sg_big_buff; /* for sysctl */
+#endif
 
 /* New interface introduced in the 3.x SG drivers follows */
 
diff -puN kernel/sysctl.c~sysctl-extern-cleanup-sg kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-extern-cleanup-sg
+++ a/kernel/sysctl.c
@@ -63,6 +63,9 @@
 #ifdef CONFIG_BLOCK
 #include <linux/blk-iopoll.h>
 #endif
+#ifdef CONFIG_CHR_DEV_SG
+#include <scsi/sg.h>
+#endif
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -108,10 +111,6 @@ static int min_percpu_pagelist_fract = 8
 
 static int ngroups_max = NGROUPS_MAX;
 
-#ifdef CONFIG_CHR_DEV_SG
-extern int sg_big_buff;
-#endif
-
 #ifdef CONFIG_SPARC
 #include <asm/system.h>
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


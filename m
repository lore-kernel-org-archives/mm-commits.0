From: akpm@linux-foundation.org
Subject: [merged] sysctl-extern-cleanup-sg.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:05:08 -0400
Message-ID: <201003150705.o2F75fqd017107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933035Ab0COHFv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:05:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, James.Bottomley@HansenPartnership.com, dgilbert@interlog.com, mm-commits@vger.kernel.org


The patch titled
     sysctl extern cleanup: sg
has been removed from the -mm tree.  Its filename was
     sysctl-extern-cleanup-sg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl extern cleanup: sg
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be moved to their own header file,
and then include them in relavant .c files.

Move sg_big_buff extern declaration to scsi/sg.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Acked-by: Doug Gilbert <dgilbert@interlog.com>
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
@@ -69,6 +69,9 @@
 #include <asm/stacktrace.h>
 #include <asm/io.h>
 #endif
+#ifdef CONFIG_CHR_DEV_SG
+#include <scsi/sg.h>
+#endif
 
 
 #if defined(CONFIG_SYSCTL)
@@ -111,10 +114,6 @@ static int min_percpu_pagelist_fract = 8
 
 static int ngroups_max = NGROUPS_MAX;
 
-#ifdef CONFIG_CHR_DEV_SG
-extern int sg_big_buff;
-#endif

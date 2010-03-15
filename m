From: akpm@linux-foundation.org
Subject: [to-be-updated] sysctl-extern-cleanup-block-iopoll.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:50:12 -0400
Message-ID: <201003150650.o2F6ojHU015808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758806Ab0COGuv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:50:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     sysctl extern cleanup: block iopoll
has been removed from the -mm tree.  Its filename was
     sysctl-extern-cleanup-block-iopoll.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl extern cleanup: block iopoll
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be moved to their own header file,
and then include them in relavant .c files.

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
@@ -39,6 +39,9 @@
 #include <linux/highuid.h>
 #include <linux/pid.h>
 #include <linux/writeback.h>
+#ifdef CONFIG_BLOCK
+#include <linux/blk-iopoll.h>
+#endif
 #include <linux/ratelimit.h>
 #include <linux/latencytop.h>
 #include <linux/hugetlb.h>
@@ -82,9 +85,6 @@ extern int percpu_pagelist_fraction;
 #ifndef CONFIG_MMU
 extern int sysctl_nr_trim_pages;
 #endif
-#ifdef CONFIG_BLOCK
-extern int blk_iopoll_enabled;
-#endif
 
 /* Constants used for minimum and  maximum */
 #ifdef CONFIG_DETECT_SOFTLOCKUP
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
sysctl-extern-cleanup-block-iopoll.patch
linux-next.patch


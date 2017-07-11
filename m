From: akpm@linux-foundation.org
Subject: [merged] fs-proc-switch-to-ida_simple_get-remove.patch
 removed from -mm tree
Date: Tue, 11 Jul 2017 12:25:49 -0700
Message-ID: <20170711192549.kL0YsZHIK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48274 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932627AbdGKTZu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:25:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hkallweit1@gmail.com, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs/proc/generic.c: switch to ida_simple_get/remove
has been removed from the -mm tree.  Its filename was
     fs-proc-switch-to-ida_simple_get-remove.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: fs/proc/generic.c: switch to ida_simple_get/remove

The code can be much simplified by switching to ida_simple_get/remove.

Link: http://lkml.kernel.org/r/8d1cc9f7-5115-c9dc-028e-c0770b6bfe1f@gmail.com
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   34 ++++++++--------------------------
 1 file changed, 8 insertions(+), 26 deletions(-)

diff -puN fs/proc/generic.c~fs-proc-switch-to-ida_simple_get-remove fs/proc/generic.c
--- a/fs/proc/generic.c~fs-proc-switch-to-ida_simple_get-remove
+++ a/fs/proc/generic.c
@@ -180,7 +180,6 @@ static int xlate_proc_name(const char *n
 }
 
 static DEFINE_IDA(proc_inum_ida);
-static DEFINE_SPINLOCK(proc_inum_lock); /* protects the above */
 
 #define PROC_DYNAMIC_FIRST 0xF0000000U
 
@@ -190,37 +189,20 @@ static DEFINE_SPINLOCK(proc_inum_lock);
  */
 int proc_alloc_inum(unsigned int *inum)
 {
-	unsigned int i;
-	int error;
+	int i;
 
-retry:
-	if (!ida_pre_get(&proc_inum_ida, GFP_KERNEL))
-		return -ENOMEM;
-
-	spin_lock_irq(&proc_inum_lock);
-	error = ida_get_new(&proc_inum_ida, &i);
-	spin_unlock_irq(&proc_inum_lock);
-	if (error == -EAGAIN)
-		goto retry;
-	else if (error)
-		return error;
-
-	if (i > UINT_MAX - PROC_DYNAMIC_FIRST) {
-		spin_lock_irq(&proc_inum_lock);
-		ida_remove(&proc_inum_ida, i);
-		spin_unlock_irq(&proc_inum_lock);
-		return -ENOSPC;
-	}
-	*inum = PROC_DYNAMIC_FIRST + i;
+	i = ida_simple_get(&proc_inum_ida, 0, UINT_MAX - PROC_DYNAMIC_FIRST + 1,
+			   GFP_KERNEL);
+	if (i < 0)
+		return i;
+
+	*inum = PROC_DYNAMIC_FIRST + (unsigned int)i;
 	return 0;
 }
 
 void proc_free_inum(unsigned int inum)
 {
-	unsigned long flags;
-	spin_lock_irqsave(&proc_inum_lock, flags);
-	ida_remove(&proc_inum_ida, inum - PROC_DYNAMIC_FIRST);
-	spin_unlock_irqrestore(&proc_inum_lock, flags);
+	ida_simple_remove(&proc_inum_ida, inum - PROC_DYNAMIC_FIRST);
 }
 
 /*
_

Patches currently in -mm which might be from hkallweit1@gmail.com are



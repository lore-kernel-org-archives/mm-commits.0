From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-lkdtmc-fix-race-when-crashpoint-is-hit-multiple-times-before-checking-count.patch removed from -mm tree
Date: Tue, 28 Jun 2011 13:42:34 -0700
Message-ID: <201106282042.p5SKgGuZ002991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733Ab1F1Uma (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 16:42:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johunt@akamai.com, ankita@in.ibm.com, stable@kernel.org, tdhimant@akamai.com, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/lkdtm.c: fix race when crashpoint is hit multiple times before checking count
has been removed from the -mm tree.  Its filename was
     drivers-misc-lkdtmc-fix-race-when-crashpoint-is-hit-multiple-times-before-checking-count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/lkdtm.c: fix race when crashpoint is hit multiple times before checking count
From: Josh Hunt <johunt@akamai.com>

We observed the crash point count going negative in cases where the crash
point is hit multiple times before the check of "count == 0" is done. 
Because of this we never call lkdtm_do_action().  This patch just adds a
spinlock to protect count.

Reported-by: Tapan Dhimant <tdhimant@akamai.com>
Signed-off-by: Josh Hunt <johunt@akamai.com>
Acked-by: Ankita Garg <ankita@in.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lkdtm.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/misc/lkdtm.c~drivers-misc-lkdtmc-fix-race-when-crashpoint-is-hit-multiple-times-before-checking-count drivers/misc/lkdtm.c
--- a/drivers/misc/lkdtm.c~drivers-misc-lkdtmc-fix-race-when-crashpoint-is-hit-multiple-times-before-checking-count
+++ a/drivers/misc/lkdtm.c
@@ -120,6 +120,7 @@ static int recur_count = REC_NUM_DEFAULT
 static enum cname cpoint = CN_INVALID;
 static enum ctype cptype = CT_NONE;
 static int count = DEFAULT_COUNT;
+static DEFINE_SPINLOCK(count_lock);
 
 module_param(recur_count, int, 0644);
 MODULE_PARM_DESC(recur_count, " Recursion level for the stack overflow test, "\
@@ -230,11 +231,14 @@ static const char *cp_name_to_str(enum c
 static int lkdtm_parse_commandline(void)
 {
 	int i;
+	unsigned long flags;
 
 	if (cpoint_count < 1 || recur_count < 1)
 		return -EINVAL;
 
+	spin_lock_irqsave(&count_lock, flags);
 	count = cpoint_count;
+	spin_unlock_irqrestore(&count_lock, flags);
 
 	/* No special parameters */
 	if (!cpoint_type && !cpoint_name)
@@ -349,6 +353,9 @@ static void lkdtm_do_action(enum ctype w
 
 static void lkdtm_handler(void)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&count_lock, flags);
 	count--;
 	printk(KERN_INFO "lkdtm: Crash point %s of type %s hit, trigger in %d rounds\n",
 			cp_name_to_str(cpoint), cp_type_to_str(cptype), count);
@@ -357,6 +364,7 @@ static void lkdtm_handler(void)
 		lkdtm_do_action(cptype);
 		count = cpoint_count;
 	}
+	spin_unlock_irqrestore(&count_lock, flags);
 }
 
 static int lkdtm_register_cpoint(enum cname which)
_

Patches currently in -mm which might be from johunt@akamai.com are



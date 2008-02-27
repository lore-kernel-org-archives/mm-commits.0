From: akpm@linux-foundation.org
Subject: - printk-fix-possible-printk-overrun.patch removed from -mm tree
Date: Wed, 27 Feb 2008 14:16:28 -0800
Message-ID: <200802272216.m1RMGSsw000718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759444AbYB0WQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 17:16:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     printk: fix possible printk overrun
has been removed from the -mm tree.  Its filename was
     printk-fix-possible-printk-overrun.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk: fix possible printk overrun
From: Tejun Heo <htejun@gmail.com>

printk recursion detection prepends message to printk_buf and offsets
printk_buf when actual message is printed but it forgets to trim buffer
length accordingly. This can result in overrun in extreme cases. Fix it.

[ mingo@elte.hu:

  bug was introduced by me via:

   commit 32a76006683f7b28ae3cc491da37716e002f198e
   Author: Ingo Molnar <mingo@elte.hu>
   Date:   Fri Jan 25 21:07:58 2008 +0100

       printk: make printk more robust by not allowing recursion
]

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk.c~printk-fix-possible-printk-overrun kernel/printk.c
--- a/kernel/printk.c~printk-fix-possible-printk-overrun
+++ a/kernel/printk.c
@@ -666,7 +666,7 @@ asmlinkage int vprintk(const char *fmt, 
 	}
 	/* Emit the output into the temporary buffer */
 	printed_len += vscnprintf(printk_buf + printed_len,
-				  sizeof(printk_buf), fmt, args);
+				  sizeof(printk_buf) - printed_len, fmt, args);
 
 	/*
 	 * Copy the output into log_buf.  If the caller didn't provide
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
git-sched.patch
scsi-fix-cd-burning-regression.patch

From: akpm@linux-foundation.org
Subject: [merged] printk-change-recursion_bug-type-to-bool.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 12:15:34 -0800
Message-ID: <569e9966.+dDYbcfA+Ba4bXom%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44693 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933224AbcASUPe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:15:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: change recursion_bug type to bool
has been removed from the -mm tree.  Its filename was
     printk-change-recursion_bug-type-to-bool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: printk: change recursion_bug type to bool

`recursion_bug' is used as recursion_bug toggle, so make it `bool'.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/printk/printk.c~printk-change-recursion_bug-type-to-bool kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-change-recursion_bug-type-to-bool
+++ a/kernel/printk/printk.c
@@ -1661,7 +1661,7 @@ asmlinkage int vprintk_emit(int facility
 			    const char *dict, size_t dictlen,
 			    const char *fmt, va_list args)
 {
-	static int recursion_bug;
+	static bool recursion_bug;
 	static char textbuf[LOG_LINE_MAX];
 	char *text = textbuf;
 	size_t text_len = 0;
@@ -1697,7 +1697,7 @@ asmlinkage int vprintk_emit(int facility
 		 * it can be printed at the next appropriate moment:
 		 */
 		if (!oops_in_progress && !lockdep_recursing(current)) {
-			recursion_bug = 1;
+			recursion_bug = true;
 			local_irq_restore(flags);
 			return 0;
 		}
@@ -1712,7 +1712,7 @@ asmlinkage int vprintk_emit(int facility
 		static const char recursion_msg[] =
 			"BUG: recent printk recursion!";
 
-		recursion_bug = 0;
+		recursion_bug = false;
 		/* emit KERN_CRIT message */
 		printed_len += log_store(0, 2, LOG_PREFIX|LOG_NEWLINE, 0,
 					 NULL, 0, recursion_msg,
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are



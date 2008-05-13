From: akpm@linux-foundation.org
Subject: - init-dont-loose-initcall-code-returned-v2.patch removed from -mm tree
Date: Tue, 13 May 2008 14:33:50 -0700
Message-ID: <200805132133.m4DLXo2H000855@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762113AbYEMVdw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:33:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     init: don't lose initcall return values
has been removed from the -mm tree.  Its filename was
     init-dont-loose-initcall-code-returned-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init: don't lose initcall return values
From: Cyrill Gorcunov <gorcunov@gmail.com>

There is an ability to lose an initcall return value if it happened with irq
disabled or imbalanced preemption (and if we debug initcall).

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN init/main.c~init-dont-loose-initcall-code-returned-v2 init/main.c
--- a/init/main.c~init-dont-loose-initcall-code-returned-v2
+++ a/init/main.c
@@ -702,7 +702,6 @@ static void __init do_initcalls(void)
 
 	for (call = __initcall_start; call < __initcall_end; call++) {
 		ktime_t t0, t1, delta;
-		char *msg = NULL;
 		char msgbuf[40];
 		int result;
 
@@ -724,22 +723,23 @@ static void __init do_initcalls(void)
 				(unsigned long long) delta.tv64 >> 20);
 		}
 
-		if (result && result != -ENODEV && initcall_debug) {
-			sprintf(msgbuf, "error code %d", result);
-			msg = msgbuf;
-		}
+		msgbuf[0] = 0;
+
+		if (result && result != -ENODEV && initcall_debug)
+			sprintf(msgbuf, "error code %d ", result);
+
 		if (preempt_count() != count) {
-			msg = "preemption imbalance";
+			strncat(msgbuf, "preemption imbalance ", sizeof(msgbuf));
 			preempt_count() = count;
 		}
 		if (irqs_disabled()) {
-			msg = "disabled interrupts";
+			strncat(msgbuf, "disabled interrupts ", sizeof(msgbuf));
 			local_irq_enable();
 		}
-		if (msg) {
+		if (msgbuf[0]) {
 			print_fn_descriptor_symbol(KERN_WARNING "initcall %s()",
 					(unsigned long) *call);
-			printk(" returned with %s\n", msg);
+			printk(" returned with %s\n", msgbuf);
 		}
 	}
 
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
module-loading-elf-handling-use-selfmag-instead-of-numeric-constant.patch


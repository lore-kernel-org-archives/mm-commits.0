From: akpm@linux-foundation.org
Subject: + init-dont-loose-initcall-code-returned-v2.patch added to -mm tree
Date: Wed, 07 May 2008 13:29:36 -0700
Message-ID: <200805072029.m47KTa7L015049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089AbYEGU3i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 16:29:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com


The patch titled
     init: don't lose initcall return values
has been added to the -mm tree.  Its filename is
     init-dont-loose-initcall-code-returned-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
uml-use-page_size-in-linker-scripts.patch
init-dont-loose-initcall-code-returned-v2.patch
linux-next.patch
git-cifs.patch
mips-elf-handling-use-selfmag-instead-of-numeric-constant.patch
module-loading-elf-handling-use-selfmag-instead-of-numeric-constant.patch


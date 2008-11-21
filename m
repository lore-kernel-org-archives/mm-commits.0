From: akpm@linux-foundation.org
Subject: + init-mainc-use-ktime-accessor-function-in-initcall_debug-code.patch added to -mm tree
Date: Fri, 21 Nov 2008 14:08:59 -0800
Message-ID: <200811212208.mALM8xpl014798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668AbYKUWJT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 17:09:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will.newton@gmail.com, mingo@elte.hu, tglx@linutronix.de, tim.bird@am.sony.com


The patch titled
     init/main.c: use ktime accessor function in initcall_debug code.
has been added to the -mm tree.  Its filename is
     init-mainc-use-ktime-accessor-function-in-initcall_debug-code.patch

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
Subject: init/main.c: use ktime accessor function in initcall_debug code.
From: "Will Newton" <will.newton@gmail.com>

The initcall_debug code access the tv64 member of ktime.  This won't work
correctly for large deltas on platforms that don't use the scalar ktime
implementation.

Signed-off-by: Will Newton <will.newton@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Tim Bird <tim.bird@am.sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/main.c~init-mainc-use-ktime-accessor-function-in-initcall_debug-code init/main.c
--- a/init/main.c~init-mainc-use-ktime-accessor-function-in-initcall_debug-code
+++ a/init/main.c
@@ -743,7 +743,7 @@ int do_one_initcall(initcall_t fn)
 	if (initcall_debug) {
 		it.rettime = ktime_get();
 		delta = ktime_sub(it.rettime, it.calltime);
-		it.duration = (unsigned long long) delta.tv64 >> 10;
+		it.duration = (unsigned long long) ktime_to_ns(delta) >> 10;
 		printk("initcall %pF returned %d after %Ld usecs\n", fn,
 			it.result, it.duration);
 		trace_boot(&it, fn);
_

Patches currently in -mm which might be from will.newton@gmail.com are

drivers-char-tty_ioc-avoid-panic-when-no-console-is-configured.patch
init-mainc-use-ktime-accessor-function-in-initcall_debug-code.patch


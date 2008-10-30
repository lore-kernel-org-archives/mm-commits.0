From: akpm@linux-foundation.org
Subject: + oops-handling-ensure-that-any-oops-is-flushed-to-the-mtdoops-console.patch added to -mm tree
Date: Thu, 30 Oct 2008 13:17:42 -0700
Message-ID: <200810302017.m9UKHg8f021180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755647AbYJ3UTU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 16:19:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viktor.rosendahl@nokia.com, alan@lxorguk.ukuu.org.uk, dwmw2@infradead.org, mingo@elte.hu


The patch titled
     oops handling: ensure that any oops is flushed to the mtdoops console
has been added to the -mm tree.  Its filename is
     oops-handling-ensure-that-any-oops-is-flushed-to-the-mtdoops-console.patch

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
Subject: oops handling: ensure that any oops is flushed to the mtdoops console
From: Viktor Rosendahl <viktor.rosendahl@nokia.com>

This used to work unpatched with older kernels, during the development
phase of mtdoops.  Before commit e3e8a75d2acfc61ebf25524666a0a2c6abb0620c
a space was printed with console_loglevel set to 15, which probably
flushed the oops message as a side effect.

This is another patch from the Nokia N810 kernel.

Signed-off-by: Viktor Rosendahl <viktor.rosendahl@nokia.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bust_spinlocks.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN lib/bust_spinlocks.c~oops-handling-ensure-that-any-oops-is-flushed-to-the-mtdoops-console lib/bust_spinlocks.c
--- a/lib/bust_spinlocks.c~oops-handling-ensure-that-any-oops-is-flushed-to-the-mtdoops-console
+++ a/lib/bust_spinlocks.c
@@ -12,6 +12,7 @@
 #include <linux/tty.h>
 #include <linux/wait.h>
 #include <linux/vt_kern.h>
+#include <linux/console.h>
 
 
 void __attribute__((weak)) bust_spinlocks(int yes)
@@ -22,6 +23,7 @@ void __attribute__((weak)) bust_spinlock
 #ifdef CONFIG_VT
 		unblank_screen();
 #endif
+		console_unblank();
 		if (--oops_in_progress == 0)
 			wake_up_klogd();
 	}
_

Patches currently in -mm which might be from viktor.rosendahl@nokia.com are

oops-handling-ensure-that-any-oops-is-flushed-to-the-mtdoops-console.patch
oops-handling-ensure-that-any-oops-is-flushed-to-the-mtdoops-console-fix.patch


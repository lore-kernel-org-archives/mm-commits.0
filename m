From: akpm@linux-foundation.org
Subject: + always-print-panic-message-on-current-console.patch added to -mm tree
Date: Mon, 12 Oct 2009 15:57:38 -0700
Message-ID: <200910122257.n9CMvdRs004005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757452AbZJLW6z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Oct 2009 18:58:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bernhard@bwalle.de, alan@lxorguk.ukuu.org.uk, mingo@elte.hu


The patch titled
     panic: always print panic message on current console
has been added to the -mm tree.  Its filename is
     always-print-panic-message-on-current-console.patch

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
Subject: panic: always print panic message on current console
From: Bernhard Walle <bernhard@bwalle.de>

The kernel offers with TIOCL_GETKMSGREDIRECT ioctl() the possibility to
redirect the kernel messages to a specific console.

However, since it's not possible to switch to the kernel message console
after a panic(), it would be nice if the kernel would print the panic
message on the current console.

Signed-off-by: Bernhard Walle <bernhard@bwalle.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN kernel/panic.c~always-print-panic-message-on-current-console kernel/panic.c
--- a/kernel/panic.c~always-print-panic-message-on-current-console
+++ a/kernel/panic.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/nmi.h>
 #include <linux/dmi.h>
+#include <linux/vt.h>
 
 int panic_on_oops;
 static unsigned long tainted_mask;
@@ -65,6 +66,9 @@ NORET_TYPE void panic(const char * fmt, 
 	 */
 	preempt_disable();
 
+	/* don't redirect the panic message to some hidden console */
+	vt_kmsg_redirect(0);
+
 	bust_spinlocks(1);
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
_

Patches currently in -mm which might be from bernhard@bwalle.de are

vt-introduce-and-use-vt_kmsg_redirect-function.patch
always-print-panic-message-on-current-console.patch


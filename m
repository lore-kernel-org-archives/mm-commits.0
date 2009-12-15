From: akpm@linux-foundation.org
Subject: [nacked] always-print-panic-message-on-current-console.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:43:52 -0800
Message-ID: <200912152143.nBFLhq3S014604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759303AbZLOVo3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:44:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bernhard@bwalle.de, alan@lxorguk.ukuu.org.uk, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     panic: always print panic message on current console
has been removed from the -mm tree.  Its filename was
     always-print-panic-message-on-current-console.patch

This patch was dropped because it was nacked

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

 kernel/panic.c |    4 ++++
 1 file changed, 4 insertions(+)

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

origin.patch
always-print-panic-message-on-current-console.patch


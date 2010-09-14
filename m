From: akpm@linux-foundation.org
Subject: + hvc_console-fix-dropping-of-characters-when-output-byte-channel-is-full.patch added to -mm tree
Date: Tue, 14 Sep 2010 12:17:36 -0700
Message-ID: <201009141917.o8EJHaWW013296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754727Ab0INTRw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Sep 2010 15:17:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: timur@freescale.com, amit.shah@redhat.com, benh@kernel.crashing.org, galak@gate.crashing.org, gregkh@suse.de


The patch titled
     hvc_console: fix dropping of characters when output byte channel is full
has been added to the -mm tree.  Its filename is
     hvc_console-fix-dropping-of-characters-when-output-byte-channel-is-full.patch

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
Subject: hvc_console: fix dropping of characters when output byte channel is full
From: Timur Tabi <timur@freescale.com>

hvc_console_print() calls the HVC client driver's put_chars() callback to
write some characters to the console.  If the callback returns 0, that
indicates that no characters were written (perhaps the output buffer is
full), but hvc_console_print() treats that as an error and discards the
rest of the buffer.

So change hvc_console_print() to just loop and call put_chars() again if it
returns a 0 return code.

This change makes hvc_console_print() behave more like hvc_push(), which
does check for a 0 return code and re-schedules itself.

Signed-off-by: Timur Tabi <timur@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Amit Shah <amit.shah@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hvc_console.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff -puN drivers/char/hvc_console.c~hvc_console-fix-dropping-of-characters-when-output-byte-channel-is-full drivers/char/hvc_console.c
--- a/drivers/char/hvc_console.c~hvc_console-fix-dropping-of-characters-when-output-byte-channel-is-full
+++ a/drivers/char/hvc_console.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2001 Paul Mackerras <paulus@au.ibm.com>, IBM
  * Copyright (C) 2004 Benjamin Herrenschmidt <benh@kernel.crashing.org>, IBM Corp.
  * Copyright (C) 2004 IBM Corporation
+ * Copyright 2009 Freescale Semiconductor, Inc.
  *
  * Additional Author(s):
  *  Ryan S. Arnold <rsa@us.ibm.com>
@@ -141,6 +142,7 @@ static void hvc_console_print(struct con
 	char c[N_OUTBUF] __ALIGNED__;
 	unsigned i = 0, n = 0;
 	int r, donecr = 0, index = co->index;
+	unsigned int timeout = 1000000; /* Keep trying for up to one second */
 
 	/* Console access attempt outside of acceptable console range. */
 	if (index >= MAX_NR_HVC_CONSOLES)
@@ -152,6 +154,10 @@ static void hvc_console_print(struct con
 
 	while (count > 0 || i > 0) {
 		if (count > 0 && i < sizeof(c)) {
+			/* If the local buffer (c) is not full, then copy some
+			 * bytes from the input buffer to it. We stop when the
+			 * local buffer is full. \n is converted to \r\n.
+			 */
 			if (b[n] == '\n' && !donecr) {
 				c[i++] = '\r';
 				donecr = 1;
@@ -162,14 +168,25 @@ static void hvc_console_print(struct con
 			}
 		} else {
 			r = cons_ops[index]->put_chars(vtermnos[index], c, i);
-			if (r <= 0) {
+			if (r < 0) {
 				/* throw away chars on error */
 				i = 0;
 			} else if (r > 0) {
 				i -= r;
 				if (i > 0)
 					memmove(c, c+r, i);
+			} else {
+				/* If r == 0, then the client driver didn't do
+				 * anything, so wait 1us and try again.  If we
+				 * time out, then just exit.
+				 */
+				if (!--timeout)
+					return;
+				udelay(1);
+				continue;
 			}
+			/* Reset the timeout */
+			timeout = 1000000;
 		}
 	}
 }
_

Patches currently in -mm which might be from timur@freescale.com are

linux-next.patch
hvc_console-fix-dropping-of-characters-when-output-byte-channel-is-full.patch


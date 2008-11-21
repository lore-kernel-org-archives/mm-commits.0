From: akpm@linux-foundation.org
Subject: + drivers-char-tty_ioc-avoid-panic-when-no-console-is-configured.patch added to -mm tree
Date: Fri, 21 Nov 2008 14:06:37 -0800
Message-ID: <200811212206.mALM6bSJ013580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668AbYKUWGk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 17:06:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will.newton@gmail.com


The patch titled
     drivers/char/tty_io.c: avoid panic when no console is configured
has been added to the -mm tree.  Its filename is
     drivers-char-tty_ioc-avoid-panic-when-no-console-is-configured.patch

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
Subject: drivers/char/tty_io.c: avoid panic when no console is configured
From: "Will Newton" <will.newton@gmail.com>

When no console is configured tty_open tries to call kref_get on a NULL
pointer, return ENODEV instead.

Signed-off-by: Will Newton <will.newton@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN drivers/char/tty_io.c~drivers-char-tty_ioc-avoid-panic-when-no-console-is-configured drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~drivers-char-tty_ioc-avoid-panic-when-no-console-is-configured
+++ a/drivers/char/tty_io.c
@@ -1793,12 +1793,15 @@ retry_open:
 	}
 #endif
 	if (device == MKDEV(TTYAUX_MAJOR, 1)) {
-		driver = tty_driver_kref_get(console_device(&index));
-		if (driver) {
-			/* Don't let /dev/console block */
-			filp->f_flags |= O_NONBLOCK;
-			noctty = 1;
-			goto got_driver;
+		struct tty_driver *console_driver = console_device(&index);
+		if (console_driver) {
+			driver = tty_driver_kref_get(console_driver);
+			if (driver) {
+				/* Don't let /dev/console block */
+				filp->f_flags |= O_NONBLOCK;
+				noctty = 1;
+				goto got_driver;
+			}
 		}
 		mutex_unlock(&tty_mutex);
 		return -ENODEV;
_

Patches currently in -mm which might be from will.newton@gmail.com are

drivers-char-tty_ioc-avoid-panic-when-no-console-is-configured.patch


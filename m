From: akpm@linux-foundation.org
Subject: - drivers-char-tty_ioc-avoid-panic-when-no-console-is-configured.patch removed from -mm tree
Date: Wed, 26 Nov 2008 12:46:30 -0800
Message-ID: <200811262046.mAQKkUtJ010803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752810AbYKZU4w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 15:56:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.newton@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char/tty_io.c: avoid panic when no console is configured
has been removed from the -mm tree.  Its filename was
     drivers-char-tty_ioc-avoid-panic-when-no-console-is-configured.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1795,12 +1795,15 @@ retry_open:
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

linux-next.patch


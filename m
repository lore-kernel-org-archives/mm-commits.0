From: akpm@linux-foundation.org
Subject: - sn_console-section-mismatch-warning.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:59:56 -0700
Message-ID: <200707162059.l6GKxuLh002466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60134 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756353AbXGPVGf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:06:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jes@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sn_console section mismatch warning
has been removed from the -mm tree.  Its filename was
     sn_console-section-mismatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sn_console section mismatch warning
From: Jes Sorensen <jes@sgi.com>

Do not mark sn_sal_console_setup as __init since it's referenced from
non init data structures.

Signed-off-by: Jes Sorensen <jes@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/sn_console.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/serial/sn_console.c~sn_console-section-mismatch-warning drivers/serial/sn_console.c
--- a/drivers/serial/sn_console.c~sn_console-section-mismatch-warning
+++ a/drivers/serial/sn_console.c
@@ -759,7 +759,7 @@ static void __init sn_sal_switch_to_inte
  */
 
 static void sn_sal_console_write(struct console *, const char *, unsigned);
-static int __init sn_sal_console_setup(struct console *, char *);
+static int sn_sal_console_setup(struct console *, char *);
 static struct uart_driver sal_console_uart;
 extern struct tty_driver *uart_console_device(struct console *, int *);
 
@@ -1006,7 +1006,7 @@ sn_sal_console_write(struct console *co,
  * here so providing it is easier.
  *
  */
-static int __init sn_sal_console_setup(struct console *co, char *options)
+static int sn_sal_console_setup(struct console *co, char *options)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from jes@sgi.com are

origin.patch
mbcs-remove-lots-of-global-symbols.patch

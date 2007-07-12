From: akpm@linux-foundation.org
Subject: + sn_console-section-mismatch-warning.patch added to -mm tree
Date: Wed, 11 Jul 2007 17:38:12 -0700
Message-ID: <200707120038.l6C0cC1V030494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44098 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935284AbXGLAiV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jul 2007 20:38:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jes@sgi.com


The patch titled
     sn_console section mismatch warning
has been added to the -mm tree.  Its filename is
     sn_console-section-mismatch-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sn_console section mismatch warning
From: Jes Sorensen <jes@sgi.com>

Do not mark sn_sal_console_setup as __init since it's referenced from
non init data structures.

Signed-off-by: Jes Sorensen <jes@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/sn_console.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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

mspec_mmap-dont-set-vm_locked.patch
sn_console-section-mismatch-warning.patch

From: akpm@linux-foundation.org
Subject: [merged] char-synclink-remove-unnecessary-checks.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:28:51 -0800
Message-ID: <201001212128.o0LLSpmN030761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755352Ab0AUV3A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:29:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, alan@linux.intel.com, gregkh@suse.de, paulkf@microgate.com, mm-commits@vger.kernel.org


The patch titled
     Char: synclink, remove unnecessary checks
has been removed from the -mm tree.  Its filename was
     char-synclink-remove-unnecessary-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: synclink, remove unnecessary checks
From: Jiri Slaby <jslaby@suse.cz>

Stanse found a potential null dereference in mgsl_put_char and mgsl_write.
 There is a check for tty being NULL, but it is dereferenced earlier.

Actually, tty cannot be NULL in .write and .put_char, so remove the tests.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/synclink.c~char-synclink-remove-unnecessary-checks drivers/char/synclink.c
--- a/drivers/char/synclink.c~char-synclink-remove-unnecessary-checks
+++ a/drivers/char/synclink.c
@@ -2031,7 +2031,7 @@ static int mgsl_put_char(struct tty_stru
 	if (mgsl_paranoia_check(info, tty->name, "mgsl_put_char"))
 		return 0;
 
-	if (!tty || !info->xmit_buf)
+	if (!info->xmit_buf)
 		return 0;
 
 	spin_lock_irqsave(&info->irq_spinlock, flags);
@@ -2121,7 +2121,7 @@ static int mgsl_write(struct tty_struct 
 	if (mgsl_paranoia_check(info, tty->name, "mgsl_write"))
 		goto cleanup;
 
-	if (!tty || !info->xmit_buf)
+	if (!info->xmit_buf)
 		goto cleanup;
 
 	if ( info->params.mode == MGSL_MODE_HDLC ||
_

Patches currently in -mm which might be from jslaby@suse.cz are

origin.patch
linux-next.patch
infiniband-use-rlimit-helpers.patch
mm-use-rlimit-helpers.patch
fs-use-rlimit-helpers.patch
ipc-use-rlimit-helpers.patch


From: akpm@linux-foundation.org
Subject: [merged] char-cyclades-fix-compiler-warning.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:33:40 -0800
Message-ID: <200912292133.nBTLXeaA008719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752846AbZL2Vdr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:33:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@novell.com, akpm@linux-foundation.org, alan@linux.intel.com, gregkh@suse.de, jirislaby@gmail.com, linux@linux.site, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, fix compiler warning
has been removed from the -mm tree.  Its filename was
     char-cyclades-fix-compiler-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: cyclades, fix compiler warning
From: Jiri Slaby <jslaby@novell.com>

With gcc 4.0.2:
drivers/char/cyclades.c: In function 'cyy_interrupt':
drivers/char/cyclades.c:581: warning: 'info' may be used uninitialized in this function

introduced by

: commit 3aeea5b92210083c7cffd4f08a0bb141d3f2d574
: Author:     Jiri Slaby <jirislaby@gmail.com>
: AuthorDate: Sat Sep 19 13:13:16 2009 -0700
: Commit:     Live-CD User <linux@linux.site>
: CommitDate: Sat Sep 19 13:13:16 2009 -0700
:
:    cyclades: introduce cyy_readb/writeb

In fact the true branch which uses uninitialized 'info' can never
happen because chip is always less than ->nchips and channel is
always less than 4 which we alloc.

So behave similar to rx handling and remove the test completely.

I wonder why gcc 4.4.1 doesn't spit a word.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Jiri Slaby <jslaby@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-fix-compiler-warning drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-fix-compiler-warning
+++ a/drivers/char/cyclades.c
@@ -598,12 +598,6 @@ static void cyy_chip_tx(struct cyclades_
 	save_car = readb(base_addr + (CyCAR << index));
 	cy_writeb(base_addr + (CyCAR << index), save_xir);
 
-	/* validate the port# (as configured and open) */
-	if (channel + chip * 4 >= cinfo->nports) {
-		cy_writeb(base_addr + (CySRER << index),
-			  readb(base_addr + (CySRER << index)) & ~CyTxRdy);
-		goto end;
-	}
 	info = &cinfo->ports[channel + chip * 4];
 	tty = tty_port_tty_get(&info->port);
 	if (tty == NULL) {
_

Patches currently in -mm which might be from jslaby@novell.com are

linux-next.patch


From: akpm@linux-foundation.org
Subject: + char-cyclades-fix-compiler-warning.patch added to -mm tree
Date: Fri, 20 Nov 2009 15:46:29 -0800
Message-ID: <200911202346.nAKNkUhg012115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753669AbZKTXqa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 18:46:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@novell.com, akpm@linux-foundation.org, alan@linux.intel.com, gregkh@suse.de, jirislaby@gmail.com, linux@linux.site


The patch titled
     Char: cyclades, fix compiler warning
has been added to the -mm tree.  Its filename is
     char-cyclades-fix-compiler-warning.patch

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

 drivers/char/cyclades.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-fix-compiler-warning drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-fix-compiler-warning
+++ a/drivers/char/cyclades.c
@@ -595,14 +595,8 @@ static void cyy_chip_tx(struct cyclades_
 	channel = save_xir & CyIRChannel;
 	save_car = readb(base_addr + (CyCAR << index));
 	cy_writeb(base_addr + (CyCAR << index), save_xir);
-	info = &cinfo->ports[channel + chip * 4];
 
-	/* validate the port# (as configured and open) */
-	if (channel + chip * 4 >= cinfo->nports) {
-		cy_writeb(base_addr + (CySRER << index),
-			  readb(base_addr + (CySRER << index)) & ~CyTxRdy);
-		goto end;
-	}
+	info = &cinfo->ports[channel + chip * 4];
 	tty = tty_port_tty_get(&info->port);
 	if (tty == NULL) {
 		cyy_writeb(info, CySRER, cyy_readb(info, CySRER) & ~CyTxRdy);
_

Patches currently in -mm which might be from jslaby@novell.com are

char-cyclades-fix-compiler-warning.patch


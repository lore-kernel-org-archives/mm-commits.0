From: akpm@linux-foundation.org
Subject: + serial8250-ratelimit-too-much-work-error.patch added to -mm tree
Date: Mon, 04 Oct 2010 14:43:13 -0700
Message-ID: <201010042143.o94LhDPU017315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152Ab0JDVnt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 17:43:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dsd@laptop.org, alan@linux.intel.com, greg@kroah.com


The patch titled
     serial8250: ratelimit "too much work" error
has been added to the -mm tree.  Its filename is
     serial8250-ratelimit-too-much-work-error.patch

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
Subject: serial8250: ratelimit "too much work" error
From: Daniel Drake <dsd@laptop.org>

Running a serial console, if too many kernel messages are generated within
a short time causing a lot of serial I/O, the 8250 driver will generate
another kernel message reporting this, which just adds to the I/O. It has
a cascading effect and quickly results the system being brought to its knees
by a flood of "too much work" messages.

Ratelimit the error message to avoid this.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Alan Cox <alan@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/serial/8250.c~serial8250-ratelimit-too-much-work-error drivers/serial/8250.c
--- a/drivers/serial/8250.c~serial8250-ratelimit-too-much-work-error
+++ a/drivers/serial/8250.c
@@ -1606,8 +1606,9 @@ static irqreturn_t serial8250_interrupt(
 
 		if (l == i->head && pass_counter++ > PASS_LIMIT) {
 			/* If we hit this, we're dead. */
-			printk(KERN_ERR "serial8250: too much work for "
-				"irq%d\n", irq);
+			if (printk_ratelimit())
+				printk(KERN_ERR "serial8250: too much work for "
+					"irq%d\n", irq);
 			break;
 		}
 	} while (l != end);
_

Patches currently in -mm which might be from dsd@laptop.org are

linux-next.patch
serial8250-ratelimit-too-much-work-error.patch


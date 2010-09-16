From: akpm@linux-foundation.org
Subject: + drivers-serial-serial_corec-prevent-reading-uninitialized-stack-memory.patch added to -mm tree
Date: Thu, 16 Sep 2010 14:01:56 -0700
Message-ID: <201009162101.o8GL1uat013318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754037Ab0IPVCG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Sep 2010 17:02:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drosenberg@vsecurity.com, alan@lxorguk.ukuu.org.uk, dan.j.rosenberg@gmail.com, greg@kroah.com


The patch titled
     drivers/serial/serial_core.c: prevent reading uninitialized stack memory
has been added to the -mm tree.  Its filename is
     drivers-serial-serial_corec-prevent-reading-uninitialized-stack-memory.patch

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
Subject: drivers/serial/serial_core.c: prevent reading uninitialized stack memory
From: Dan Rosenberg <drosenberg@vsecurity.com>

The TIOCGICOUNT device ioctl allows unprivileged users to read
uninitialized stack memory, because the "reserved" member of the
serial_icounter_struct struct declared on the stack is not altered or
zeroed before being copied back to the user.  This patch takes care of it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/serial/serial_core.c~drivers-serial-serial_corec-prevent-reading-uninitialized-stack-memory drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~drivers-serial-serial_corec-prevent-reading-uninitialized-stack-memory
+++ a/drivers/serial/serial_core.c
@@ -1081,6 +1081,8 @@ static int uart_get_count(struct uart_st
 	struct uart_icount cnow;
 	struct uart_port *uport = state->uart_port;
 
+	memset(&icount, 0, sizeof(struct serial_icounter_struct));
+
 	spin_lock_irq(&uport->lock);
 	memcpy(&cnow, &uport->icount, sizeof(struct uart_icount));
 	spin_unlock_irq(&uport->lock);
_

Patches currently in -mm which might be from drosenberg@vsecurity.com are

linux-next.patch
drivers-serial-serial_corec-prevent-reading-uninitialized-stack-memory.patch


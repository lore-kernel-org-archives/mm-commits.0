From: akpm@linux-foundation.org
Subject: + drivers-net-usb-hsoc-prevent-reading-uninitialized-memory.patch added to -mm tree
Date: Thu, 16 Sep 2010 14:07:50 -0700
Message-ID: <201009162107.o8GL7oMI013670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517Ab0IPVIc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Sep 2010 17:08:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drosenberg@vsecurity.com, dan.j.rosenberg@gmail.com, greg@kroah.com, j.dumon@option.com


The patch titled
     drivers/net/usb/hso.c: prevent reading uninitialized memory
has been added to the -mm tree.  Its filename is
     drivers-net-usb-hsoc-prevent-reading-uninitialized-memory.patch

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
Subject: drivers/net/usb/hso.c: prevent reading uninitialized memory
From: Dan Rosenberg <drosenberg@vsecurity.com>

The TIOCGICOUNT device ioctl allows unprivileged users to read
uninitialized stack memory, because the "reserved" member of the
serial_icounter_struct struct declared on the stack in hso_get_count() is
not altered or zeroed before being copied back to the user.  This patch
takes care of it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Cc: Jan Dumon <j.dumon@option.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/hso.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/net/usb/hso.c~drivers-net-usb-hsoc-prevent-reading-uninitialized-memory drivers/net/usb/hso.c
--- a/drivers/net/usb/hso.c~drivers-net-usb-hsoc-prevent-reading-uninitialized-memory
+++ a/drivers/net/usb/hso.c
@@ -1643,6 +1643,8 @@ static int hso_get_count(struct hso_seri
 	struct uart_icount cnow;
 	struct hso_tiocmget  *tiocmget = serial->tiocmget;
 
+	memset(&icount, 0, sizeof(struct serial_icounter_struct));
+
 	if (!tiocmget)
 		 return -ENOENT;
 	spin_lock_irq(&serial->serial_lock);
_

Patches currently in -mm which might be from drosenberg@vsecurity.com are

linux-next.patch
drivers-serial-serial_corec-prevent-reading-uninitialized-stack-memory.patch
drivers-net-usb-hsoc-prevent-reading-uninitialized-memory.patch
drivers-video-sis-sis_mainc-prevent-reading-uninitialized-stack-memory.patch
drivers-char-amiserialc-prevent-reading-uninitialized-stack-memory.patch
drivers-char-nozomic-prevent-reading-uninitialized-stack-memory.patch


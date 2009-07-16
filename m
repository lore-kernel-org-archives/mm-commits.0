From: akpm@linux-foundation.org
Subject: [merged] char-nozomi-fix-tty-refcounting-bug.patch removed from -mm tree
Date: Thu, 16 Jul 2009 12:25:33 -0700
Message-ID: <200907161925.n6GJPXhA016812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933097AbZGPT0F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Jul 2009 15:26:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: nozomi, fix tty refcounting bug
has been removed from the -mm tree.  Its filename was
     char-nozomi-fix-tty-refcounting-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: nozomi, fix tty refcounting bug
From: Jiri Slaby <jirislaby@gmail.com>

Don't forget to drop a tty refererence on fail paths in receive_data().

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/nozomi.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/char/nozomi.c~char-nozomi-fix-tty-refcounting-bug drivers/char/nozomi.c
--- a/drivers/char/nozomi.c~char-nozomi-fix-tty-refcounting-bug
+++ a/drivers/char/nozomi.c
@@ -828,7 +828,7 @@ static int receive_data(enum port_type i
 	struct port *port = &dc->port[index];
 	void __iomem *addr = port->dl_addr[port->toggle_dl];
 	struct tty_struct *tty = tty_port_tty_get(&port->port);
-	int i;
+	int i, ret;
 
 	if (unlikely(!tty)) {
 		DBG1("tty not open for port: %d?", index);
@@ -844,12 +844,14 @@ static int receive_data(enum port_type i
 
 		/* disable interrupt in downlink... */
 		disable_transmit_dl(index, dc);
-		return 0;
+		ret = 0;
+		goto put;
 	}
 
 	if (unlikely(size == 0)) {
 		dev_err(&dc->pdev->dev, "size == 0?\n");
-		return 1;
+		ret = 1;
+		goto put;
 	}
 
 	tty_buffer_request_room(tty, size);
@@ -871,8 +873,10 @@ static int receive_data(enum port_type i
 	}
 
 	set_bit(index, &dc->flip);
+	ret = 1;
+put:
 	tty_kref_put(tty);
-	return 1;
+	return ret;
 }
 
 /* Debug for interrupts */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
toshiba_acpi-return-on-a-fail-path.patch
mtd-sst25l-fix-lock-imbalance.patch
isdn-hisax-fix-lock-imbalance.patch
icom-converting-space-to-tabs.patch
reiser4.patch


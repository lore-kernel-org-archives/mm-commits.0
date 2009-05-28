From: akpm@linux-foundation.org
Subject: + serial-8250_gsc-fix-printk-format-warning.patch added to -mm tree
Date: Wed, 27 May 2009 22:47:10 -0700
Message-ID: <200905280547.n4S5lAZb007759@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755427AbZE1Frj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 01:47:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.beregalov@gmail.com, alan@lxorguk.ukuu.org.uk, kyle@mcmartin.ca


The patch titled
     serial: 8250_gsc: fix printk format error
has been added to the -mm tree.  Its filename is
     serial-8250_gsc-fix-printk-format-warning.patch

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
Subject: serial: 8250_gsc: fix printk format error
From: Alexander Beregalov <a.beregalov@gmail.com>

drivers/serial/8250_gsc.c:44: warning: format '%lx' expects type
'long unsigned int', but argument 2 has type 'resource_size_t'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_gsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/8250_gsc.c~serial-8250_gsc-fix-printk-format-warning drivers/serial/8250_gsc.c
--- a/drivers/serial/8250_gsc.c~serial-8250_gsc-fix-printk-format-warning
+++ a/drivers/serial/8250_gsc.c
@@ -41,7 +41,7 @@ static int __init serial_init_chip(struc
 			printk(KERN_INFO
 				"Serial: device 0x%lx not configured.\n"
 				"Enable support for Wax, Lasi, Asp or Dino.\n",
-				dev->hpa.start);
+				(unsigned long)dev->hpa.start);
 		return -ENODEV;
 	}
 
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

parport_gsc-fix-printk-format-error.patch
linux-next.patch
serial-8250_gsc-fix-printk-format-warning.patch


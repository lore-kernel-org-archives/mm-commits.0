From: akpm@linux-foundation.org
Subject: + parport_gsc-fix-printk-format-error.patch added to -mm tree
Date: Wed, 27 May 2009 22:45:28 -0700
Message-ID: <200905280545.n4S5jSaN006555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833AbZE1Fp3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 01:45:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.beregalov@gmail.com


The patch titled
     parport_gsc: fix printk format error
has been added to the -mm tree.  Its filename is
     parport_gsc-fix-printk-format-error.patch

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
Subject: parport_gsc: fix printk format error
From: Alexander Beregalov <a.beregalov@gmail.com>

drivers/parport/parport_gsc.c:356: warning: format '%lx' expects type
'long unsigned int', but argument 2 has type 'resource_size_t'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_gsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/parport/parport_gsc.c~parport_gsc-fix-printk-format-error drivers/parport/parport_gsc.c
--- a/drivers/parport/parport_gsc.c~parport_gsc-fix-printk-format-error
+++ a/drivers/parport/parport_gsc.c
@@ -353,7 +353,7 @@ static int __devinit parport_init_chip(s
 
 	if (!dev->irq) {
 		printk(KERN_WARNING "IRQ not found for parallel device at 0x%lx\n",
-			dev->hpa.start);
+			(unsigned long)dev->hpa.start);
 		return -ENODEV;
 	}
 
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

parport_gsc-fix-printk-format-error.patch
linux-next.patch


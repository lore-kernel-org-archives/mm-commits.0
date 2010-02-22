From: akpm@linux-foundation.org
Subject: + cpm_uart-use-resource_size.patch added to -mm tree
Date: Mon, 22 Feb 2010 13:00:55 -0800
Message-ID: <201002222100.o1ML0t7F022830@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754414Ab0BVVBl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Feb 2010 16:01:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tklauser@distanz.ch, alan@lxorguk.ukuu.org.uk, galak@gate.crashing.org, greg@kroah.com


The patch titled
     cpm_uart: use resource_size()
has been added to the -mm tree.  Its filename is
     cpm_uart-use-resource_size.patch

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
Subject: cpm_uart: use resource_size()
From: Tobias Klauser <tklauser@distanz.ch>

Use the resource_size function instead of manually calculating the
resource size.  This reduces the chance of introducing off-by-one errors.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/cpm_uart/cpm_uart_cpm2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/serial/cpm_uart/cpm_uart_cpm2.c~cpm_uart-use-resource_size drivers/serial/cpm_uart/cpm_uart_cpm2.c
--- a/drivers/serial/cpm_uart/cpm_uart_cpm2.c~cpm_uart-use-resource_size
+++ a/drivers/serial/cpm_uart/cpm_uart_cpm2.c
@@ -61,7 +61,7 @@ void __iomem *cpm_uart_map_pram(struct u
 	void __iomem *pram;
 	unsigned long offset;
 	struct resource res;
-	unsigned long len;
+	resource_size_t len;
 
 	/* Don't remap parameter RAM if it has already been initialized
 	 * during console setup.
@@ -74,7 +74,7 @@ void __iomem *cpm_uart_map_pram(struct u
 	if (of_address_to_resource(np, 1, &res))
 		return NULL;
 
-	len = 1 + res.end - res.start;
+	len = resource_size(&res);
 	pram = ioremap(res.start, len);
 	if (!pram)
 		return NULL;
_

Patches currently in -mm which might be from tklauser@distanz.ch are

linux-next.patch
cpm_uart-use-resource_size.patch
rtc-twl-storage-class-should-be-before-const-qualifier.patch


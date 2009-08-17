From: akpm@linux-foundation.org
Subject: + drivers-char-rio-rioctrlc-off-by-one-error-in-rioctrlc.patch added to -mm tree
Date: Mon, 17 Aug 2009 15:28:36 -0700
Message-ID: <200908172228.n7HMSa32008844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751182AbZHQW2p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 18:28:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com


The patch titled
     drivers/char/rio/rioctrl.c: off by one error in rioctrl.c
has been added to the -mm tree.  Its filename is
     drivers-char-rio-rioctrlc-off-by-one-error-in-rioctrlc.patch

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
Subject: drivers/char/rio/rioctrl.c: off by one error in rioctrl.c
From: Dan Carpenter <error27@gmail.com>

If DownLoad.ProductCode == MAX_PRODUCT, that would be a problem when we do
RIOBootTable[DownLoad.ProductCode] a couple lines down.

Found by smatch (http://repo.or.cz/w/smatch.git).

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rio/rioctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/rio/rioctrl.c~drivers-char-rio-rioctrlc-off-by-one-error-in-rioctrlc drivers/char/rio/rioctrl.c
--- a/drivers/char/rio/rioctrl.c~drivers-char-rio-rioctrlc-off-by-one-error-in-rioctrlc
+++ a/drivers/char/rio/rioctrl.c
@@ -873,7 +873,7 @@ int riocontrol(struct rio_info *p, dev_t
 		/*
 		 ** It is important that the product code is an unsigned object!
 		 */
-		if (DownLoad.ProductCode > MAX_PRODUCT) {
+		if (DownLoad.ProductCode >= MAX_PRODUCT) {
 			rio_dprintk(RIO_DEBUG_CTRL, "RIO_DOWNLOAD: Bad product code %d passed\n", DownLoad.ProductCode);
 			p->RIOError.Error = NO_SUCH_PRODUCT;
 			return -ENXIO;
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch
drivers-char-rio-rioctrlc-off-by-one-error-in-rioctrlc.patch


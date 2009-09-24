From: akpm@linux-foundation.org
Subject: [merged] drivers-char-rio-rioctrlc-off-by-one-error-in-rioctrlc.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:36:21 -0700
Message-ID: <200909241936.n8OJaLL0002353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754454AbZIXTgq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:36:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char/rio/rioctrl.c: off by one error in rioctrl.c
has been removed from the -mm tree.  Its filename was
     drivers-char-rio-rioctrlc-off-by-one-error-in-rioctrlc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
misdn-fix-reversed-if-in-st_own_ctrl.patch


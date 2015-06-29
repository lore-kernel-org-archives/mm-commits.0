From: akpm@linux-foundation.org
Subject: [merged] altera-stapl-remove-extraneous-kern_info-prefix.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:47:14 -0700
Message-ID: <5591aed2.60qjyPRnl4FnFoXf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50850 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbbF2UrU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:47:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, linux@rasmusvillemoes.dk, liplianin@netup.ru, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/misc/altera-stapl/altera.c: remove extraneous KERN_INFO prefix
has been removed from the -mm tree.  Its filename was
     altera-stapl-remove-extraneous-kern_info-prefix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: drivers/misc/altera-stapl/altera.c: remove extraneous KERN_INFO prefix

The KERN_INFO prefix is being prepended to KERN_DEBUG when using the
dprink macro, Remove it as it is extraneous since we are printing the
message out as debug via dprintk().

Fixes smatch warning:

drivers/misc/altera-stapl/altera.c:2454 altera_init()
   warn: KERN_* level not at start of string

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Igor M. Liplianin <liplianin@netup.ru>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/altera-stapl/altera.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/altera-stapl/altera.c~altera-stapl-remove-extraneous-kern_info-prefix drivers/misc/altera-stapl/altera.c
--- a/drivers/misc/altera-stapl/altera.c~altera-stapl-remove-extraneous-kern_info-prefix
+++ a/drivers/misc/altera-stapl/altera.c
@@ -2451,7 +2451,7 @@ int altera_init(struct altera_config *co
 
 	astate->config = config;
 	if (!astate->config->jtag_io) {
-		dprintk(KERN_INFO "%s: using byteblaster!\n", __func__);
+		dprintk("%s: using byteblaster!\n", __func__);
 		astate->config->jtag_io = netup_jtag_io_lpt;
 	}
 
_

Patches currently in -mm which might be from colin.king@canonical.com are

origin.patch
linux-next.patch


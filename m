From: akpm@linux-foundation.org
Subject: + altera-stapl-remove-extraneous-kern_info-prefix.patch added to
 -mm tree
Date: Tue, 16 Jun 2015 15:23:41 -0700
Message-ID: <5580a1ed.qbH8qkWiBELVzE6G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbbFPWXm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jun 2015 18:23:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, linux@rasmusvillemoes.dk, liplianin@netup.ru, mchehab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/misc/altera-stapl/altera.c: remove extraneous KERN_INFO prefix
has been added to the -mm tree.  Its filename is
     altera-stapl-remove-extraneous-kern_info-prefix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/altera-stapl-remove-extraneous-kern_info-prefix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/altera-stapl-remove-extraneous-kern_info-prefix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
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

altera-stapl-remove-extraneous-kern_info-prefix.patch
linux-next.patch


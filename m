From: akpm@osdl.org
Subject: + net-ifb-error-path-loop-fix.patch added to -mm tree
Date: Tue, 02 Jan 2007 15:02:47 -0800
Message-ID: <200701022302.l02N2mQ9000440@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41913 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932919AbXABXD0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 18:03:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, jeff@garzik.org


The patch titled
     net: ifb error path loop fix
has been added to the -mm tree.  Its filename is
     net-ifb-error-path-loop-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: net: ifb error path loop fix
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

On error we should start freeing resources at [i-1] not [i-2].

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/ifb.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/net/ifb.c~net-ifb-error-path-loop-fix drivers/net/ifb.c
--- a/drivers/net/ifb.c~net-ifb-error-path-loop-fix
+++ a/drivers/net/ifb.c
@@ -271,8 +271,7 @@ static int __init ifb_init_module(void)
 	for (i = 0; i < numifbs && !err; i++)
 		err = ifb_init_one(i);
 	if (err) {
-		i--;
-		while (--i >= 0)
+		while (i--)
 			ifb_free_one(i);
 	}
 
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

ppc-cs4218_tdm-remove-extra-brace.patch
mips-dbg_io-stray-brackets-fix.patch
git-mtd.patch
net-ifb-error-path-loop-fix.patch
scsi-sic7xxx-stray-bracket-fix.patch
scsi-53c7xx-brackets-fix.patch

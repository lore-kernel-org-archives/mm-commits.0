From: akpm@osdl.org
Subject: - net-ifb-error-path-loop-fix.patch removed from -mm tree
Date: Tue, 30 Jan 2007 13:47:39 -0800
Message-ID: <200701302147.l0ULldTA030195@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51983 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbXA3Vrt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 16:47:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     net: ifb error path loop fix
has been removed from the -mm tree.  Its filename was
     net-ifb-error-path-loop-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-alsa.patch
git-powerpc.patch
ppc-cs4218_tdm-remove-extra-brace.patch
git-dvb.patch
mips-dbg_io-stray-brackets-fix.patch
scsi-sic7xxx-stray-bracket-fix.patch
scsi-53c7xx-brackets-fix.patch

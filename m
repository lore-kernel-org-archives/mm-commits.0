From: akpm@linux-foundation.org
Subject: + pcmcia-3c574_cs-fix-shadow-variable-warning.patch added to -mm tree
Date: Tue, 18 Dec 2007 15:52:44 -0800
Message-ID: <200712182352.lBINqiBP028290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48585 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754144AbXLRXx0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 18:53:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ricknu-0@student.ltu.se, alan@redhat.com


The patch titled
     pcmcia/3c574_cs: fix 'shadow variable' warning
has been added to the -mm tree.  Its filename is
     pcmcia-3c574_cs-fix-shadow-variable-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pcmcia/3c574_cs: fix 'shadow variable' warning
From: Richard Knutsson <ricknu-0@student.ltu.se>

Fixing:
  CHECK   drivers/net/pcmcia/3c574_cs.c
drivers/net/pcmcia/3c574_cs.c:695:7: warning: symbol 'i' shadows an earlier one
drivers/net/pcmcia/3c574_cs.c:636:6: originally declared here

Signed-off-by: Richard Knutson <ricknu-0@student.ltu.se>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/pcmcia/3c574_cs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/pcmcia/3c574_cs.c~pcmcia-3c574_cs-fix-shadow-variable-warning drivers/net/pcmcia/3c574_cs.c
--- a/drivers/net/pcmcia/3c574_cs.c~pcmcia-3c574_cs-fix-shadow-variable-warning
+++ a/drivers/net/pcmcia/3c574_cs.c
@@ -693,7 +693,7 @@ static void tc574_reset(struct net_devic
 	mdio_write(ioaddr, lp->phys, 4, lp->advertising);
 	if (!auto_polarity) {
 		/* works for TDK 78Q2120 series MII's */
-		int i = mdio_read(ioaddr, lp->phys, 16) | 0x20;
+		i = mdio_read(ioaddr, lp->phys, 16) | 0x20;
 		mdio_write(ioaddr, lp->phys, 16, i);
 	}
 
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

origin.patch
kernel-compliment-va_copy-with-va_end.patch
git-dvb.patch
pcmcia-3c574_cs-fix-dubious-bitfield-warning.patch
pcmcia-3c574_cs-fix-shadow-variable-warning.patch
pcmcia-axnet_cs-make-functions-static.patch
pcmcia-axnet_cs-make-use-of-max-instead-of-handcrafted-one.patch
pcmcia-fmvj18x_cs-fix-shadow-variable-warning.patch
pcmcia-pcnet_cs-fix-shadow-variable-warning.patch
mm-mmap-remove-sparse-warning-null-as-0.patch
dio-array_size-cleanup-update.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
reiserfs-complement-va_start-with-va_end.patch
kernel-paramsc-remove-sparse-warning-different-signedness.patch

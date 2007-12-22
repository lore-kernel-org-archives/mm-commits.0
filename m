From: akpm@linux-foundation.org
Subject: - ppc-fix-missed-increment-on-device-interface-counter.patch removed from -mm tree
Date: Sat, 22 Dec 2007 00:21:07 -0800
Message-ID: <200712220821.lBM8L7D2024390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60659 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922AbXLVIVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 03:21:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, benh@kernel.crashing.org, galak@gate.crashing.org, olof@lixom.net, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     PPC: fix missed increment on device interface counter
has been removed from the -mm tree.  Its filename was
     ppc-fix-missed-increment-on-device-interface-counter.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: PPC: fix missed increment on device interface counter
From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch adds simple increment on device interface counter
(it seems to be accidently missed)

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Olof Johansson <olof@lixom.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pasemi/electra_ide.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/powerpc/platforms/pasemi/electra_ide.c~ppc-fix-missed-increment-on-device-interface-counter arch/powerpc/platforms/pasemi/electra_ide.c
--- a/arch/powerpc/platforms/pasemi/electra_ide.c~ppc-fix-missed-increment-on-device-interface-counter
+++ a/arch/powerpc/platforms/pasemi/electra_ide.c
@@ -40,9 +40,8 @@ static int __devinit electra_ide_init(vo
 	int i;
 
 	np = of_find_compatible_node(NULL, "ide", "electra-ide");
-	i = 0;
 
-	while (np && i < MAX_IFS) {
+	for (i = 0; np && i < MAX_IFS; i++) {
 		memset(r, 0, sizeof(r));
 
 		/* pata_platform wants two address ranges: one for the base registers,
_

Patches currently in -mm which might be from gorcunov@gmail.com are

git-powerpc.patch
ppc-fix-missed-increment-on-device-interface-counter.patch
net-mac80211-fix-inappropriate-memory-freeing.patch
git-x86.patch

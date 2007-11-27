From: akpm@linux-foundation.org
Subject: + ppc-fix-missed-increment-on-device-interface-counter.patch added to -mm tree
Date: Mon, 26 Nov 2007 20:21:48 -0800
Message-ID: <200711270421.lAR4LlBX026599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55446 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754753AbXK0EWA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 23:22:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, benh@kernel.crashing.org, galak@gate.crashing.org, olof@lixom.net, paulus@samba.org


The patch titled
     PPC: fix missed increment on device interface counter
has been added to the -mm tree.  Its filename is
     ppc-fix-missed-increment-on-device-interface-counter.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 arch/powerpc/platforms/pasemi/electra_ide.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/platforms/pasemi/electra_ide.c~ppc-fix-missed-increment-on-device-interface-counter arch/powerpc/platforms/pasemi/electra_ide.c
--- a/arch/powerpc/platforms/pasemi/electra_ide.c~ppc-fix-missed-increment-on-device-interface-counter
+++ a/arch/powerpc/platforms/pasemi/electra_ide.c
@@ -42,7 +42,7 @@ static int __devinit electra_ide_init(vo
 	np = of_find_compatible_node(NULL, "ide", "electra-ide");
 	i = 0;
 
-	while (np && i < MAX_IFS) {
+	while (np && i++ < MAX_IFS) {
 		memset(r, 0, sizeof(r));
 
 		/* pata_platform wants two address ranges: one for the base registers,
_

Patches currently in -mm which might be from gorcunov@gmail.com are

git-powerpc.patch
ppc-fix-missed-increment-on-device-interface-counter.patch
git-sparc64.patch
git-x86.patch

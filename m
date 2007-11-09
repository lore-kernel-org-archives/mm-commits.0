From: akpm@linux-foundation.org
Subject: + powerpc-fix-typo-ifdef-ifndef.patch added to -mm tree
Date: Thu, 08 Nov 2007 20:05:30 -0800
Message-ID: <200711090405.lA945Vpb028562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55493 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753511AbXKIEFq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 23:05:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jochen@scram.de, benh@kernel.crashing.org, jeff@garzik.org, paulus@samba.org


The patch titled
     powerpc: fix typo #ifdef -> #ifndef
has been added to the -mm tree.  Its filename is
     powerpc-fix-typo-ifdef-ifndef.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: powerpc: fix typo #ifdef -> #ifndef
From: Jochen Friedrich <jochen@scram.de>

fpi->cp_command should be overwritten only if CONFIG_PPC_CPM_NEW_BINDING
is NOT set. Otherwise it is already set from the device tree.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/fs_enet/mac-scc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/fs_enet/mac-scc.c~powerpc-fix-typo-ifdef-ifndef drivers/net/fs_enet/mac-scc.c
--- a/drivers/net/fs_enet/mac-scc.c~powerpc-fix-typo-ifdef-ifndef
+++ a/drivers/net/fs_enet/mac-scc.c
@@ -158,7 +158,7 @@ static int setup_data(struct net_device 
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
 
-#ifdef CONFIG_PPC_CPM_NEW_BINDING
+#ifndef CONFIG_PPC_CPM_NEW_BINDING
 	struct fs_platform_info *fpi = fep->fpi;
 
 	fep->scc.idx = fs_get_scc_index(fpi->fs_no);
_

Patches currently in -mm which might be from jochen@scram.de are

powerpc-kill-non-existent-symbols-from-ksyms-and-commproch.patch
powerpc-fs_enet-select-phylib-as-the-driver-needs-it.patch
powerpc-fix-typo-ifdef-ifndef.patch

From: akpm@linux-foundation.org
Subject: - powerpc-fix-typo-ifdef-ifndef.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:38:59 -0800
Message-ID: <200712172338.lBHNcxr9008082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49559 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754567AbXLQXjM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 18:39:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jochen@scram.de, benh@kernel.crashing.org, jeff@garzik.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: fix typo #ifdef -> #ifndef
has been removed from the -mm tree.  Its filename was
     powerpc-fix-typo-ifdef-ifndef.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
powerpc-add-support-for-porta-and-portb-odr-registers.patch
dio-fix-kernel-doc-notation.patch

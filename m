From: akpm@linux-foundation.org
Subject: - powerpc-add-fixed-phy-support-for-fs_enet.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:48:26 -0800
Message-ID: <200801290148.m0T1mQN8027350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40529 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756173AbYA2B7f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:59:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jochen@scram.de, benh@kernel.crashing.org, jeff@garzik.org, paulus@samba.org, vitb@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: add fixed-phy support for fs_enet
has been removed from the -mm tree.  Its filename was
     powerpc-add-fixed-phy-support-for-fs_enet.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: add fixed-phy support for fs_enet
From: Jochen Friedrich <jochen@scram.de>

Add support to use the fixed-link property of an ethernet node to fs_enet
for the CONFIG_PPC_CPM_NEW_BINDING case.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Vitaly Bordug <vitb@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/fs_enet/fs_enet-main.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/net/fs_enet/fs_enet-main.c~powerpc-add-fixed-phy-support-for-fs_enet drivers/net/fs_enet/fs_enet-main.c
--- a/drivers/net/fs_enet/fs_enet-main.c~powerpc-add-fixed-phy-support-for-fs_enet
+++ a/drivers/net/fs_enet/fs_enet-main.c
@@ -1178,8 +1178,15 @@ static int __devinit find_phy(struct dev
 	struct device_node *phynode, *mdionode;
 	struct resource res;
 	int ret = 0, len;
+	const u32 *data;
+
+	data  = of_get_property(np, "fixed-link", NULL);
+	if (data) {
+		snprintf(fpi->bus_id, 16, PHY_ID_FMT, 0, *data);
+		return 0;
+	}
 
-	const u32 *data = of_get_property(np, "phy-handle", &len);
+	data = of_get_property(np, "phy-handle", &len);
 	if (!data || len != 4)
 		return -EINVAL;
 
_

Patches currently in -mm which might be from jochen@scram.de are

git-powerpc.patch
dio-fix-kernel-doc-notation.patch

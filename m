From: akpm@linux-foundation.org
Subject: - r8169-fix-missing-loop-variable-increment.patch removed from -mm tree
Date: Tue, 15 Jan 2008 17:40:08 -0800
Message-ID: <200801160140.m0G1e8Tm014088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57896 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756229AbYAPBt2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:49:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: romieu@fr.zoreil.com, citizen_lee@thecus.com, davem@davemloft.net, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     r8169: fix missing loop variable increment
has been removed from the -mm tree.  Its filename was
     r8169-fix-missing-loop-variable-increment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r8169: fix missing loop variable increment
From: Francois Romieu <romieu@fr.zoreil.com>

Spotted-by: Citizen Lee <citizen_lee@thecus.com>
Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/r8169.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/r8169.c~r8169-fix-missing-loop-variable-increment drivers/net/r8169.c
--- a/drivers/net/r8169.c~r8169-fix-missing-loop-variable-increment
+++ a/drivers/net/r8169.c
@@ -2002,7 +2002,7 @@ static void rtl8169_set_magic_reg(void _
 	u32 clk;
 
 	clk = RTL_R8(Config2) & PCI_Clock_66MHz;
-	for (i = 0; i < ARRAY_SIZE(cfg2_info); i++) {
+	for (i = 0; i < ARRAY_SIZE(cfg2_info); i++, p++) {
 		if ((p->mac_version == mac_version) && (p->clk == clk)) {
 			RTL_W32(0x7c, p->val);
 			break;
_

Patches currently in -mm which might be from romieu@fr.zoreil.com are

origin.patch
git-netdev-all.patch

From: akpm@linux-foundation.org
Subject: + r8169-fix-missing-loop-variable-increment.patch added to -mm tree
Date: Wed, 09 Jan 2008 21:24:12 -0800
Message-ID: <200801100523.m0A5NqjH006617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39206 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751035AbYAJFYT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 00:24:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: romieu@fr.zoreil.com, citizen_lee@thecus.com, davem@davemloft.net, jeff@garzik.org


The patch titled
     r8169: fix missing loop variable increment
has been added to the -mm tree.  Its filename is
     r8169-fix-missing-loop-variable-increment.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-netdev-all.patch
r8169-fix-missing-loop-variable-increment.patch

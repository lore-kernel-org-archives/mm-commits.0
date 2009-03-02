From: akpm@linux-foundation.org
Subject: [merged] bluetooth-bt3c-eliminate-a-sparse-warning.patch removed from -mm tree
Date: Mon, 02 Mar 2009 11:23:32 -0800
Message-ID: <200903021923.n22JNWEX014427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948AbZCBTYX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 14:24:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre@bitwigglers.org, hidave.darkstar@gmail.com, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     bluetooth/bt3c: eliminate a sparse warning
has been removed from the -mm tree.  Its filename was
     bluetooth-bt3c-eliminate-a-sparse-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bluetooth/bt3c: eliminate a sparse warning
From: Andre Haupt <andre@bitwigglers.org>

This eliminates a sparse warning that symbol 'stat' shadows an earlier one.

Signed-off-by: Andre Haupt <andre@bitwigglers.org>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/bt3c_cs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/bluetooth/bt3c_cs.c~bluetooth-bt3c-eliminate-a-sparse-warning drivers/bluetooth/bt3c_cs.c
--- a/drivers/bluetooth/bt3c_cs.c~bluetooth-bt3c-eliminate-a-sparse-warning
+++ a/drivers/bluetooth/bt3c_cs.c
@@ -359,9 +359,9 @@ static irqreturn_t bt3c_interrupt(int ir
 			BT_ERR("Very strange (stat=0x%04x)", stat);
 		} else if ((stat & 0xff) != 0xff) {
 			if (stat & 0x0020) {
-				int stat = bt3c_read(iobase, 0x7002) & 0x10;
+				int status = bt3c_read(iobase, 0x7002) & 0x10;
 				BT_INFO("%s: Antenna %s", info->hdev->name,
-							stat ? "out" : "in");
+							status ? "out" : "in");
 			}
 			if (stat & 0x0001)
 				bt3c_receive(info);
_

Patches currently in -mm which might be from andre@bitwigglers.org are

linux-next.patch


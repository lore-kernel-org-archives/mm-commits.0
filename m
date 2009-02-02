From: akpm@linux-foundation.org
Subject: + bluetooth-bt3c-eliminate-a-sparse-warning.patch added to -mm tree
Date: Mon, 02 Feb 2009 14:45:11 -0800
Message-ID: <200902022245.n12MjB1X007357@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753707AbZBBWps (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 17:45:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre@bitwigglers.org, hidave.darkstar@gmail.com, marcel@holtmann.org


The patch titled
     bluetooth/bt3c: eliminate a sparse warning
has been added to the -mm tree.  Its filename is
     bluetooth-bt3c-eliminate-a-sparse-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
bluetooth-bt3c-eliminate-a-sparse-warning.patch


From: akpm@linux-foundation.org
Subject: [merged] hid-fix-the-support-for-apple-mini-aluminium-keyboard.patch removed from -mm tree
Date: Thu, 30 Apr 2009 11:44:22 -0700
Message-ID: <200904301844.n3UIiMLx002434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757300AbZD3SrC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Apr 2009 14:47:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uli@spamt.net, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     hid: fix the support for apple mini aluminium keyboard
has been removed from the -mm tree.  Its filename was
     hid-fix-the-support-for-apple-mini-aluminium-keyboard.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hid: fix the support for apple mini aluminium keyboard
From: Ulrich Dangel <uli@spamt.net>

Quirks for the apple mini keyboard was recently added but keyboard was
recognized as a powerbook keyboard.  Adjusted boundary to the lowest
product id for the apple mini keyboard to get the right translation.

Signed-off-by: Ulrich Dangel <uli@spamt.net>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/hid-apple.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hid/hid-apple.c~hid-fix-the-support-for-apple-mini-aluminium-keyboard drivers/hid/hid-apple.c
--- a/drivers/hid/hid-apple.c~hid-fix-the-support-for-apple-mini-aluminium-keyboard
+++ a/drivers/hid/hid-apple.c
@@ -151,7 +151,7 @@ static int hidinput_apple_event(struct h
 	if (fnmode) {
 		int do_translate;
 
-		trans = apple_find_translation((hid->product < 0x220 ||
+		trans = apple_find_translation((hid->product < 0x21d ||
 					hid->product >= 0x300) ?
 					powerbook_fn_keys : apple_fn_keys,
 					usage->code);
_

Patches currently in -mm which might be from uli@spamt.net are

linux-next.patch
input-mouse-alpsc-handle-touchpoints-buttons-correctly.patch


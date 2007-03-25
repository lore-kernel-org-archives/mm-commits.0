From: akpm@linux-foundation.org
Subject: + isdn-fix-bchannel_bh-call-from-isar_bh.patch added to -mm tree
Date: Sun, 25 Mar 2007 00:32:48 -0800
Message-ID: <200703250832.l2P8WmJE023829@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36270 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933222AbXCYIc6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 04:32:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz, kkeil@suse.de


The patch titled
     ISDN: fix BChannel_bh() call from isar_bh()
has been added to the -mm tree.  Its filename is
     isdn-fix-bchannel_bh-call-from-isar_bh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ISDN: fix BChannel_bh() call from isar_bh()
From: Jiri Kosina <jkosina@suse.cz>

isar_bh() bh handler calls another (compatible) bh handler - BChannel_bh()
- but passes struct BCState* instead of struct work_struct*, which seems
wrong.

Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/isar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/hisax/isar.c~isdn-fix-bchannel_bh-call-from-isar_bh drivers/isdn/hisax/isar.c
--- a/drivers/isdn/hisax/isar.c~isdn-fix-bchannel_bh-call-from-isar_bh
+++ a/drivers/isdn/hisax/isar.c
@@ -440,7 +440,7 @@ isar_bh(struct work_struct *work)
 {
 	struct BCState *bcs = container_of(work, struct BCState, tqueue);
 
-	BChannel_bh(bcs);
+	BChannel_bh(work);
 	if (test_and_clear_bit(B_LL_NOCARRIER, &bcs->event))
 		ll_deliver_faxstat(bcs, ISDN_FAX_CLASS1_NOCARR);
 	if (test_and_clear_bit(B_LL_CONNECT, &bcs->event))
_

Patches currently in -mm which might be from jkosina@suse.cz are

isdn-fix-bchannel_bh-call-from-isar_bh.patch
git-hid.patch
bluetooth-hid-quirks-mightymouse-quirk.patch
git-ipwireless_cs.patch

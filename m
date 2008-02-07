From: akpm@linux-foundation.org
Subject: - fix-and-typo-in-eicons-addinfo.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:26:36 -0800
Message-ID: <200802070026.m170QHmF006884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34566 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935040AbYBGAoe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers/isdn/hardware/eicon/message.c fix 'and' typo in eicons' AddInfo()
has been removed from the -mm tree.  Its filename was
     fix-and-typo-in-eicons-addinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/isdn/hardware/eicon/message.c fix 'and' typo in eicons' AddInfo()
From: Roel Kluin <12o3l@tiscali.nl>

'!' has a higher priority than '&'.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/eicon/message.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/hardware/eicon/message.c~fix-and-typo-in-eicons-addinfo drivers/isdn/hardware/eicon/message.c
--- a/drivers/isdn/hardware/eicon/message.c~fix-and-typo-in-eicons-addinfo
+++ a/drivers/isdn/hardware/eicon/message.c
@@ -9027,7 +9027,7 @@ static byte AddInfo(byte   **add_i,
    /* facility is a nested structure */
    /* FTY can be more than once      */
 
-  if(esc_chi[0] && !(esc_chi[esc_chi[0]])&0x7f )
+	if (esc_chi[0] && !(esc_chi[esc_chi[0]] & 0x7f))
   {
     add_i[0] = (byte   *)"\x02\x02\x00"; /* use neither b nor d channel */
   }
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
git-alsa.patch
git-dvb.patch
git-mtd.patch
git-scsi-misc.patch

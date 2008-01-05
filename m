From: akpm@linux-foundation.org
Subject: + fix-and-typo-in-eicons-addinfo.patch added to -mm tree
Date: Fri, 04 Jan 2008 22:55:29 -0800
Message-ID: <200801050656.m056uFnt032664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34930 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751743AbYAEG4Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 5 Jan 2008 01:56:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, kkeil@suse.de


The patch titled
     drivers/isdn/hardware/eicon/message.c fix 'and' typo in eicons' AddInfo()
has been added to the -mm tree.  Its filename is
     fix-and-typo-in-eicons-addinfo.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-acpi.patch
git-dvb.patch
git-mips.patch
git-netdev-all.patch
m68k-balance-ioremap-and-iounmap-in-m68k-atari-hades-pcic.patch
sound-oss-tridentc-fix-incorrect-test-in-trident_ac97_set.patch
fix-and-typo-in-eicons-addinfo.patch

From: akpm@linux-foundation.org
Subject: + pch_phub-fix-mac-address-writing-issue-for-lapis-ml7831.patch added to -mm tree
Date: Mon, 14 Nov 2011 16:15:13 -0800
Message-ID: <201111150015.pAF0FE6J012100@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vw0-f74.google.com ([209.85.212.74]:48258 "EHLO
	mail-vw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab1KOAPQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2011 19:15:16 -0500
Received: by vws12 with SMTP id 12so851777vws.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2011 16:15:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomoya.rohm@gmail.com, alexander.stein@systec-electronic.com, denis@compulab.co.il, gregkh@suse.de, masa-korg@dsn.okisemi.com


The patch titled
     Subject: pch_phub: fix MAC address writing issue for LAPIS ML7831
has been added to the -mm tree.  Its filename is
     pch_phub-fix-mac-address-writing-issue-for-lapis-ml7831.patch

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
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: pch_phub: fix MAC address writing issue for LAPIS ML7831

ISSUE:
Using ML7831, MAC address writing doesn't work well.

CAUSE:
ML7831 and EG20T have the same register map for MAC address access.
However, this driver processes the writing the same as ML7223.
This is not true.
This driver must process the writing the same as EG20T.
This patch fixes the issue.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Denis Turischev <denis@compulab.co.il>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/pch_phub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/pch_phub.c~pch_phub-fix-mac-address-writing-issue-for-lapis-ml7831 drivers/misc/pch_phub.c
--- a/drivers/misc/pch_phub.c~pch_phub-fix-mac-address-writing-issue-for-lapis-ml7831
+++ a/drivers/misc/pch_phub.c
@@ -473,7 +473,7 @@ static int pch_phub_write_gbe_mac_addr(s
 	int retval;
 	int i;
 
-	if (chip->ioh_type == 1) /* EG20T */
+	if ((chip->ioh_type == 1) || (chip->ioh_type == 5)) /* EG20T or ML7831*/
 		retval = pch_phub_gbe_serial_rom_conf(chip);
 	else	/* ML7223 */
 		retval = pch_phub_gbe_serial_rom_conf_mp(chip);
_
Subject: Subject: pch_phub: fix MAC address writing issue for LAPIS ML7831

Patches currently in -mm which might be from tomoya.rohm@gmail.com are

pch_phub-improve-adeaddress-decode-enable-control.patch
pch_phub-fix-mac-address-writing-issue-for-lapis-ml7831.patch


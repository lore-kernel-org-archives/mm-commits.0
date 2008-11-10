From: akpm@linux-foundation.org
Subject: + aacraid-disable-dell-percraid-quirk-on-adaptec-2200s-and-2120s.patch added to -mm tree
Date: Mon, 10 Nov 2008 15:20:13 -0800
Message-ID: <200811102320.mAANKDMi009958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811AbYKJXVG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 18:21:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thenzl@redhat.com, James.Bottomley@HansenPartnership.com, dermoth@aei.ca, gernot.hillier@siemens.com, mark_salyzyn@adaptec.com, stable@kernel.org


The patch titled
     aacraid: disable Dell Percraid quirk on Adaptec 2200S and 2120S
has been added to the -mm tree.  Its filename is
     aacraid-disable-dell-percraid-quirk-on-adaptec-2200s-and-2120s.patch

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
Subject: aacraid: disable Dell Percraid quirk on Adaptec 2200S and 2120S
From: Tomas Henzl <thenzl@redhat.com>

A lot of 64bit machines with Adaptec 2200S and 2120S controllers don't
recognize SCSI disks any more with the patch "fix driver failure with Dell
PowerEdge Expandable RAID Controller 3/Di", but fail with tons of "aac_srb:
aac_fib_send failed with status: 8195" instead. This patch disables the
quirk introduced in the change cited above for those two controllers again.

Signed-off-by: Gernot Hillier <gernot.hillier@siemens.com>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Tested-by: Thomas Guyot-Sionnest <dermoth@aei.ca>
Cc: <stable@kernel.org>		[2.6.27.x, 2.6.26.x, 2.6.25.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/linit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/aacraid/linit.c~aacraid-disable-dell-percraid-quirk-on-adaptec-2200s-and-2120s drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c~aacraid-disable-dell-percraid-quirk-on-adaptec-2200s-and-2120s
+++ a/drivers/scsi/aacraid/linit.c
@@ -175,8 +175,8 @@ static struct aac_driver_ident aac_drive
 	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* PERC 3/Di (Boxster/PERC3DiB) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "catapult        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* catapult */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "tomcat          ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* tomcat */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Adaptec 2120S (Crusader) */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Adaptec 2200S (Vulcan) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG },		      /* Adaptec 2120S (Crusader) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG },		      /* Adaptec 2200S (Vulcan) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Adaptec 2200S (Vulcan-2m) */
 	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S220     ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Legend S220 (Legend Crusader) */
 	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S230     ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Legend S230 (Legend Vulcan) */
_

Patches currently in -mm which might be from thenzl@redhat.com are

aacraid-disable-dell-percraid-quirk-on-adaptec-2200s-and-2120s.patch


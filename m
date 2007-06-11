From: akpm@linux-foundation.org
Subject: + i4l-leak-in-eicon-idifuncc.patch added to -mm tree
Date: Mon, 11 Jun 2007 11:13:58 -0700
Message-ID: <200706111813.l5BIDwQ1025657@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49249 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322AbXFKSOO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 14:14:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: armin@melware.de, kkeil@suse.de, snakebyte@gmx.de


The patch titled
     i4l: leak in eicon/idifunc.c
has been added to the -mm tree.  Its filename is
     i4l-leak-in-eicon-idifuncc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i4l: leak in eicon/idifunc.c
From: Armin Schindler <armin@melware.de>

coverity spotted a possible leak in the idifunc.c file (bug id #1252), in
um_new_card(), if the diva_user_mode_idi_create_adapter() fails, we dont
free the memory allocated for card

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Acked-by: Armin Schindler <armin@melware.de>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/eicon/idifunc.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/isdn/hardware/eicon/idifunc.c~i4l-leak-in-eicon-idifuncc drivers/isdn/hardware/eicon/idifunc.c
--- a/drivers/isdn/hardware/eicon/idifunc.c~i4l-leak-in-eicon-idifuncc
+++ a/drivers/isdn/hardware/eicon/idifunc.c
@@ -106,6 +106,7 @@ static void um_new_card(DESCRIPTOR * d)
 	} else {
 		DBG_ERR(("could not create user mode idi card %d",
 			 adapter_nr));
+		diva_os_free(0, card);
 	}
 }
 
_

Patches currently in -mm which might be from armin@melware.de are

isdn-diva-fix-section-mismatch.patch
i4l-leak-in-eicon-idifuncc.patch

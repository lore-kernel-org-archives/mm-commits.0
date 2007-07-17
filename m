From: akpm@linux-foundation.org
Subject: - i4l-leak-in-eicon-idifuncc.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:03:50 -0700
Message-ID: <200707172303.l6HN3oE1011743@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59043 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935794AbXGQXQU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: armin@melware.de, kkeil@suse.de, snakebyte@gmx.de, mm-commits@vger.kernel.org


The patch titled
     i4l: leak in eicon/idifunc.c
has been removed from the -mm tree.  Its filename was
     i4l-leak-in-eicon-idifuncc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 1 insertion(+)

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

origin.patch

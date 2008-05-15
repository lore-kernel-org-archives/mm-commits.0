From: akpm@linux-foundation.org
Subject: + drivers-ata-pata_at32c-avoid-unnecessary-memset.patch added to -mm tree
Date: Thu, 15 May 2008 14:10:00 -0700
Message-ID: <200805152110.m4FLA0l2010705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754778AbYEOVKl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 17:10:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: christophe.jaillet@wanadoo.fr, haavard.skinnemoen@atmel.com, jeff@garzik.org


The patch titled
     drivers/ata/pata_at32.c: avoid unnecessary memset
has been added to the -mm tree.  Its filename is
     drivers-ata-pata_at32c-avoid-unnecessary-memset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/ata/pata_at32.c: avoid unnecessary memset
From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>

Remove an explicit memset(.., 0, ...) to a variable allocated with kzalloc
(i.e.  'info').

Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_at32.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/ata/pata_at32.c~drivers-ata-pata_at32c-avoid-unnecessary-memset drivers/ata/pata_at32.c
--- a/drivers/ata/pata_at32.c~drivers-ata-pata_at32c-avoid-unnecessary-memset
+++ a/drivers/ata/pata_at32.c
@@ -291,8 +291,6 @@ static int __init pata_at32_probe(struct
 	if (!info)
 		return -ENOMEM;
 
-	memset(info, 0, sizeof(struct at32_ide_info));

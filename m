From: akpm@linux-foundation.org
Subject: + infiniband-hw-nes-avoid-unnecessary-memset.patch added to -mm tree
Date: Thu, 15 May 2008 14:12:28 -0700
Message-ID: <200805152112.m4FLCS9Q010827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764440AbYEOVMc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 17:12:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: christophe.jaillet@wanadoo.fr, faisal@neteffect.com


The patch titled
     infiniband/hw/nes/: avoid unnecessary memset
has been added to the -mm tree.  Its filename is
     infiniband-hw-nes-avoid-unnecessary-memset.patch

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
Subject: infiniband/hw/nes/: avoid unnecessary memset
From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>

Remove an explicit memset(.., 0, ...) to a variable allocated with kzalloc
(i.e.  'listener').

Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Acked-by: Faisal Latif <faisal@neteffect.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/nes/nes_cm.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/infiniband/hw/nes/nes_cm.c~infiniband-hw-nes-avoid-unnecessary-memset drivers/infiniband/hw/nes/nes_cm.c
--- a/drivers/infiniband/hw/nes/nes_cm.c~infiniband-hw-nes-avoid-unnecessary-memset
+++ a/drivers/infiniband/hw/nes/nes_cm.c
@@ -1603,7 +1603,6 @@ static struct nes_cm_listener *mini_cm_l
 			return NULL;
 		}
 
-		memset(listener, 0, sizeof(struct nes_cm_listener));
 		listener->loc_addr = htonl(cm_info->loc_addr);
 		listener->loc_port = htons(cm_info->loc_port);
 		listener->reused_node = 0;
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

linux-next.patch
infiniband-hw-nes-avoid-unnecessary-memset.patch
drivers-ata-pata_at32c-avoid-unnecessary-memset.patch
accessrunner-avoid-unnecessary-memset.patch


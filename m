From: akpm@linux-foundation.org
Subject: + drivers-media-ir-ene_irc-fix-null-dereference.patch added to -mm tree
Date: Mon, 13 Sep 2010 16:23:43 -0700
Message-ID: <201009132323.o8DNNhgD027350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920Ab0IMXXz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Sep 2010 19:23:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, maximlevitsky@gmail.com, mchehab@redhat.com


The patch titled
     drivers/media/IR/ene_ir.c: fix NULL dereference
has been added to the -mm tree.  Its filename is
     drivers-media-ir-ene_irc-fix-null-dereference.patch

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
Subject: drivers/media/IR/ene_ir.c: fix NULL dereference
From: Jiri Slaby <jslaby@suse.cz>

When 'dev' allocation fails in ene_probe we jump to error label where we
dereference the 'dev'.  Fix it by jumping few lines below.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/IR/ene_ir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/media/IR/ene_ir.c~drivers-media-ir-ene_irc-fix-null-dereference drivers/media/IR/ene_ir.c
--- a/drivers/media/IR/ene_ir.c~drivers-media-ir-ene_irc-fix-null-dereference
+++ a/drivers/media/IR/ene_ir.c
@@ -785,7 +785,7 @@ static int ene_probe(struct pnp_dev *pnp
 	dev = kzalloc(sizeof(struct ene_device), GFP_KERNEL);
 
 	if (!input_dev || !ir_props || !dev)
-		goto error;
+		goto error1;
 
 	/* validate resources */
 	error = -ENODEV;
@@ -899,7 +899,7 @@ error:
 		free_irq(dev->irq, dev);
 	if (dev->hw_io)
 		release_region(dev->hw_io, ENE_MAX_IO);

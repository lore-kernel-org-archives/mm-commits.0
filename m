From: akpm@linux-foundation.org
Subject: + drivers-parport-use-kzalloc.patch added to -mm tree
Date: Thu, 09 May 2013 11:22:56 -0700
Message-ID: <20130509182256.64D2E31C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:55275 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3EISW5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 14:22:57 -0400
Received: by mail-gh0-f202.google.com with SMTP id g24so305821ghb.5
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 11:22:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gheorghiuandru@gmail.com


The patch titled
     Subject: drivers/parport/share.c: use kzalloc
has been added to the -mm tree.  Its filename is
     drivers-parport-use-kzalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: drivers/parport/share.c: use kzalloc

Replaced calls to kmalloc and memset with kzalloc.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/share.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/parport/share.c~drivers-parport-use-kzalloc drivers/parport/share.c
--- a/drivers/parport/share.c~drivers-parport-use-kzalloc
+++ a/drivers/parport/share.c
@@ -282,14 +282,13 @@ struct parport *parport_register_port(un
 	int device;
 	char *name;
 
-	tmp = kmalloc(sizeof(struct parport), GFP_KERNEL);
+	tmp = kzalloc(sizeof(struct parport), GFP_KERNEL);
 	if (!tmp) {
 		printk(KERN_WARNING "parport: memory squeeze\n");
 		return NULL;
 	}
 
 	/* Init our structure */
- 	memset(tmp, 0, sizeof(struct parport));
 	tmp->base = base;
 	tmp->irq = irq;
 	tmp->dma = dma;
_

Patches currently in -mm which might be from gheorghiuandru@gmail.com are

origin.patch
linux-next.patch
drivers-parport-use-kzalloc.patch


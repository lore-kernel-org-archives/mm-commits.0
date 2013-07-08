From: akpm@linux-foundation.org
Subject: [merged] drivers-parport-use-kzalloc.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:37:04 -0700
Message-ID: <51db14e0.h6xFPD4kC9xuDrhI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51749 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab3GHThE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:37:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gheorghiuandru@gmail.com

Subject: [merged] drivers-parport-use-kzalloc.patch removed from -mm tree
To: gheorghiuandru@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:37:04 -0700


The patch titled
     Subject: drivers/parport/share.c: use kzalloc
has been removed from the -mm tree.  Its filename was
     drivers-parport-use-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


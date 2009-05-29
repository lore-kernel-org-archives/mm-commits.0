From: akpm@linux-foundation.org
Subject: [merged] parport_gsc-fix-printk-format-error.patch removed from -mm tree
Date: Fri, 29 May 2009 11:43:07 -0700
Message-ID: <200905291843.n4TIh79o011416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751789AbZE2SvX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 May 2009 14:51:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.beregalov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     parport_gsc: fix printk format error
has been removed from the -mm tree.  Its filename was
     parport_gsc-fix-printk-format-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parport_gsc: fix printk format error
From: Alexander Beregalov <a.beregalov@gmail.com>

drivers/parport/parport_gsc.c:356: warning: format '%lx' expects type
'long unsigned int', but argument 2 has type 'resource_size_t'

[akpm@linux-foundation.org: fix it to handle u64's]
Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_gsc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/parport/parport_gsc.c~parport_gsc-fix-printk-format-error drivers/parport/parport_gsc.c
--- a/drivers/parport/parport_gsc.c~parport_gsc-fix-printk-format-error
+++ a/drivers/parport/parport_gsc.c
@@ -352,8 +352,8 @@ static int __devinit parport_init_chip(s
 	unsigned long port;
 
 	if (!dev->irq) {
-		printk(KERN_WARNING "IRQ not found for parallel device at 0x%lx\n",
-			dev->hpa.start);
+		printk(KERN_WARNING "IRQ not found for parallel device at 0x%llx\n",
+			(unsigned long long)dev->hpa.start);
 		return -ENODEV;
 	}
 
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

origin.patch
linux-next.patch


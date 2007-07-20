From: akpm@linux-foundation.org
Subject: + mtd-potential-leak-in-rfd_ftl_add_mtd.patch added to -mm tree
Date: Fri, 20 Jul 2007 11:55:25 -0700
Message-ID: <200707201855.l6KItPGH011065@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49301 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751813AbXGTTEV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 15:04:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fmalita@gmail.com, dwmw2@infradead.org


The patch titled
     MTD: potential leak in rfd_ftl_add_mtd
has been added to the -mm tree.  Its filename is
     mtd-potential-leak-in-rfd_ftl_add_mtd.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MTD: potential leak in rfd_ftl_add_mtd
From: Florin Malita <fmalita@gmail.com>

This fixes a leak in the !mtd->erasesize error path (Coverity 1765).

Signed-off-by: Florin Malita <fmalita@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/rfd_ftl.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/mtd/rfd_ftl.c~mtd-potential-leak-in-rfd_ftl_add_mtd drivers/mtd/rfd_ftl.c
--- a/drivers/mtd/rfd_ftl.c~mtd-potential-leak-in-rfd_ftl_add_mtd
+++ a/drivers/mtd/rfd_ftl.c
@@ -779,6 +779,7 @@ static void rfd_ftl_add_mtd(struct mtd_b
 	else {
 		if (!mtd->erasesize) {
 			printk(KERN_WARNING PREFIX "please provide block_size");
+			kfree(part);
 			return;
 		}
 		else
_

Patches currently in -mm which might be from fmalita@gmail.com are

origin.patch
mtd-potential-leak-in-rfd_ftl_add_mtd.patch

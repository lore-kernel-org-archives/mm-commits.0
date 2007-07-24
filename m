From: akpm@linux-foundation.org
Subject: - mtd-potential-leak-in-rfd_ftl_add_mtd.patch removed from -mm tree
Date: Mon, 23 Jul 2007 23:04:55 -0700
Message-ID: <200707240604.l6O64tSA031450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35844 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753891AbXGXGFF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 02:05:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fmalita@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     MTD: potential leak in rfd_ftl_add_mtd
has been removed from the -mm tree.  Its filename was
     mtd-potential-leak-in-rfd_ftl_add_mtd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-mtd.patch
git-ubi.patch

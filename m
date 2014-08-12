From: akpm@linux-foundation.org
Subject: [merged] synclink_gt-use-pci_zalloc_consistent.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:42:57 -0700
Message-ID: <53ea6e41.BnXff+ssmXqVD77Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:46356 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968AbaHLTm6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:42:58 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so1070133igi.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, gregkh@linuxfoundation.org, jslaby@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: synclink_gt: use pci_zalloc_consistent
has been removed from the -mm tree.  Its filename was
     synclink_gt-use-pci_zalloc_consistent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: synclink_gt: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/synclink_gt.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/tty/synclink_gt.c~synclink_gt-use-pci_zalloc_consistent drivers/tty/synclink_gt.c
--- a/drivers/tty/synclink_gt.c~synclink_gt-use-pci_zalloc_consistent
+++ a/drivers/tty/synclink_gt.c
@@ -3383,12 +3383,11 @@ static int alloc_desc(struct slgt_info *
 	unsigned int pbufs;
 
 	/* allocate memory to hold descriptor lists */
-	info->bufs = pci_alloc_consistent(info->pdev, DESC_LIST_SIZE, &info->bufs_dma_addr);
+	info->bufs = pci_zalloc_consistent(info->pdev, DESC_LIST_SIZE,
+					   &info->bufs_dma_addr);
 	if (info->bufs == NULL)
 		return -ENOMEM;
 
-	memset(info->bufs, 0, DESC_LIST_SIZE);

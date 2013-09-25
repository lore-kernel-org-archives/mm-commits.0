From: akpm@linux-foundation.org
Subject: [merged] cpqarray-fix-info-leak-in-ida_locked_ioctl.patch removed from -mm tree
Date: Wed, 25 Sep 2013 12:06:16 -0700
Message-ID: <52433428.PLThho1lUWKB+8D8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab3IYTGQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 15:06:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mike.miller@hp.com, dan.carpenter@oracle.com

Subject: [merged] cpqarray-fix-info-leak-in-ida_locked_ioctl.patch removed from -mm tree
To: dan.carpenter@oracle.com,mike.miller@hp.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 12:06:16 -0700


The patch titled
     Subject: cpqarray: fix info leak in ida_locked_ioctl()
has been removed from the -mm tree.  Its filename was
     cpqarray-fix-info-leak-in-ida_locked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: cpqarray: fix info leak in ida_locked_ioctl()

The pciinfo struct has a two byte hole after ->dev_fn so stack information
could be leaked to the user.

This was assigned CVE-2013-2147.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cpqarray.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/block/cpqarray.c~cpqarray-fix-info-leak-in-ida_locked_ioctl drivers/block/cpqarray.c
--- a/drivers/block/cpqarray.c~cpqarray-fix-info-leak-in-ida_locked_ioctl
+++ a/drivers/block/cpqarray.c
@@ -1193,6 +1193,7 @@ out_passthru:
 		ida_pci_info_struct pciinfo;
 
 		if (!arg) return -EINVAL;
+		memset(&pciinfo, 0, sizeof(pciinfo));
 		pciinfo.bus = host->pci_dev->bus->number;
 		pciinfo.dev_fn = host->pci_dev->devfn;
 		pciinfo.board_id = host->board_id;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch


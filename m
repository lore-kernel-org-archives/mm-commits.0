From: akpm@linux-foundation.org
Subject: + cpqarray-fix-info-leak-in-ida_locked_ioctl.patch added to -mm
 tree
Date: Fri, 20 Sep 2013 13:33:12 -0700
Message-ID: <523cb108.tWPiJ/mk0nr04NOS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab3ITUdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Sep 2013 16:33:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mike.miller@hp.com, dan.carpenter@oracle.com

Subject: + cpqarray-fix-info-leak-in-ida_locked_ioctl.patch added to -mm tree
To: dan.carpenter@oracle.com,mike.miller@hp.com
From: akpm@linux-foundation.org
Date: Fri, 20 Sep 2013 13:33:12 -0700


The patch titled
     Subject: cpqarray: fix info leak in ida_locked_ioctl()
has been added to the -mm tree.  Its filename is
     cpqarray-fix-info-leak-in-ida_locked_ioctl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cpqarray-fix-info-leak-in-ida_locked_ioctl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cpqarray-fix-info-leak-in-ida_locked_ioctl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
cpqarray-fix-info-leak-in-ida_locked_ioctl.patch
linux-next.patch


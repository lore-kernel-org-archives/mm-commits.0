From: akpm@linux-foundation.org
Subject: + pci_iomap_regions-error-handling-fix-was-re-2620-mm1.patch added to -mm tree
Date: Thu, 15 Feb 2007 15:50:39 -0800
Message-ID: <200702152350.l1FNodLB012686@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39196 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422727AbXBOXut (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 18:50:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deweerdt@free.fr, frederik.deweerdt@gmail.com, htejun@gmail.com, jeff@garzik.org, viro@zeniv.linux.org.uk


The patch titled
     pci_iomap_regions() error handling fix
has been added to the -mm tree.  Its filename is
     pci_iomap_regions-error-handling-fix-was-re-2620-mm1.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pci_iomap_regions() error handling fix
From: Frederik Deweerdt <deweerdt@free.fr>

It appears that the pcim_iomap_regions() function doesn't get the error
handling right. It BUGs early at boot with a backtrace along the lines of:

ahci_init
pci_register_driver
driver_register
[...]
ahci_init_one
pcim_iomap_region
pcim_iounmap

The following patch allows me to boot. Only the if(mask..) continue;
part fixes the problem actually, the gotos where changed so that we
don't try to unmap something we couldn't map anyway.

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/devres.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/devres.c~pci_iomap_regions-error-handling-fix-was-re-2620-mm1 lib/devres.c
--- a/lib/devres.c~pci_iomap_regions-error-handling-fix-was-re-2620-mm1
+++ a/lib/devres.c
@@ -274,21 +274,21 @@ int pcim_iomap_regions(struct pci_dev *p
 
 		rc = pci_request_region(pdev, i, name);
 		if (rc)
-			goto err_region;
+			goto err_inval;
 
 		rc = -ENOMEM;
 		if (!pcim_iomap(pdev, i, 0))
-			goto err_iomap;
+			goto err_region;
 	}
 
 	return 0;
 
- err_iomap:
-	pcim_iounmap(pdev, iomap[i]);
  err_region:
 	pci_release_region(pdev, i);
  err_inval:
 	while (--i >= 0) {
+		if (!(mask & (1 << i)))
+			continue;
 		pcim_iounmap(pdev, iomap[i]);
 		pci_release_region(pdev, i);
 	}
_

Patches currently in -mm which might be from deweerdt@free.fr are

origin.patch
pci_iomap_regions-error-handling-fix-was-re-2620-mm1.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
rcu-debug-trace-for-rcu.patch
reiser4-sb_sync_inodes-fix.patch

From: akpm@linux-foundation.org
Subject: + cciss-change-cmd_sg_listsg_chain_dma-type-to-dma_addr_t.patch added to -mm tree
Date: Fri, 20 Nov 2009 14:19:31 -0800
Message-ID: <200911202219.nAKMJVhI029661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753704AbZKTWTi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 17:19:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: achiang@hp.com, brace@beardog.cce.hp.com, jens.axboe@oracle.com, scameron@beardog.cce.hp.com


The patch titled
     cciss: change Cmd_sg_list.sg_chain_dma type to dma_addr_t
has been added to the -mm tree.  Its filename is
     cciss-change-cmd_sg_listsg_chain_dma-type-to-dma_addr_t.patch

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
Subject: cciss: change Cmd_sg_list.sg_chain_dma type to dma_addr_t
From: Alex Chiang <achiang@hp.com>

Fix regression in this linux-next patch:

: commit 5c07a311a80adb0138fc08e8279c60255d88d0b8
: Author: Don Brace <brace@beardog.cce.hp.com>
: Date:   Thu Nov 12 12:50:01 2009 -0600
: 
:     cciss: Add enhanced scatter-gather support.


It broke the ia64 build because of this hunk:

	--- a/drivers/block/cciss.h
	+++ b/drivers/block/cciss.h
	+struct Cmd_sg_list {
	+       SGDescriptor_struct     *sgchain;
	+       dma64_addr_t            sg_chain_dma;
	+       int                     chain_block_size;
	+};

The issue is that dma64_addr_t isn't #define'd on ia64.

The way that we're using Cmd_sg_list.sg_chain_dma is to hold an address
returned from pci_map_single().

	+               temp64.val = pci_map_single(h->pdev,
	+                                 h->cmd_sg_list[c->cmdindex]->sgchain,
	+                                 len, dir);
	+
	+               h->cmd_sg_list[c->cmdindex]->sg_chain_dma = temp64.val;

pci_map_single() returns a dma_addr_t too.

This code will still work even on a 32-bit x86 build, where dma_addr_t is
defined to be a u32 because it will simply be promoted to the __u64 that
temp64.val is defined as.

Thus, declaring Cmd_sg_list.sg_chain_dma as dma_addr_t is safe.

Signed-off-by: Alex Chiang <achiang@hp.com>
Cc: Don Brace <brace@beardog.cce.hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/cciss.h~cciss-change-cmd_sg_listsg_chain_dma-type-to-dma_addr_t drivers/block/cciss.h
--- a/drivers/block/cciss.h~cciss-change-cmd_sg_listsg_chain_dma-type-to-dma_addr_t
+++ a/drivers/block/cciss.h
@@ -57,7 +57,7 @@ typedef struct _drive_info_struct
 
 struct Cmd_sg_list {
 	SGDescriptor_struct	*sgchain;
-	dma64_addr_t		sg_chain_dma;
+	dma_addr_t		sg_chain_dma;
 	int			chain_block_size;
 };
 
_

Patches currently in -mm which might be from achiang@hp.com are

linux-next.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
cciss-change-cmd_sg_listsg_chain_dma-type-to-dma_addr_t.patch
page-types-learn-to-describe-flags-directly-from-command-line.patch
page-types-whitespace-alignment.patch
page-types-exit-early-when-invoked-with-d-describe.patch
mm-add-numa-node-symlink-for-memory-section-in-sysfs.patch
mm-refactor-register_cpu_under_node.patch
mm-refactor-unregister_cpu_under_node.patch
mm-add-numa-node-symlink-for-cpu-devices-in-sysfs.patch
documentation-abi-sys-devices-system-cpu-cpu-node.patch
mm-slab-allocate-memory-section-nodemask-for-large-systems.patch


From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?shmem-shmem=5Fcharge-verify-max=5Fblock-is-not-exceeded-b?=
 =?US-ASCII?Q?efore-inode-update.patch?= removed from -mm tree
Date: Thu, 07 Sep 2017 11:40:16 -0700
Message-ID: <20170907184016.pGSKzKHSi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57352 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755684AbdIGSkR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:40:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hillf.zj@alibaba-inc.com, hughd@google.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com, xemul@virtuozzo.com


The patch titled
     Subject: shmem: shmem_charge: verify max_block is not exceeded before inode update
has been removed from the -mm tree.  Its filename was
     shmem-shmem_charge-verify-max_block-is-not-exceeded-before-inode-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: shmem: shmem_charge: verify max_block is not exceeded before inode update

Patch series "userfaultfd: enable zeropage support for shmem".

These patches enable support for UFFDIO_ZEROPAGE for shared memory.

The first two patches are not strictly related to userfaultfd, they are
just minor refactoring to reduce amount of code duplication.


This patch (of 7):

Currently we update inode and shmem_inode_info before verifying that
used_blocks will not exceed max_blocks.  In case it will, we undo the
update.  Let's switch the order and move the verification of the blocks
count before the inode and shmem_inode_info update.

Link: http://lkml.kernel.org/r/1497939652-16528-2-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff -puN mm/shmem.c~shmem-shmem_charge-verify-max_block-is-not-exceeded-before-inode-update mm/shmem.c
--- a/mm/shmem.c~shmem-shmem_charge-verify-max_block-is-not-exceeded-before-inode-update
+++ a/mm/shmem.c
@@ -266,6 +266,14 @@ bool shmem_charge(struct inode *inode, l
 
 	if (shmem_acct_block(info->flags, pages))
 		return false;
+
+	if (sbinfo->max_blocks) {
+		if (percpu_counter_compare(&sbinfo->used_blocks,
+					   sbinfo->max_blocks - pages) > 0)
+			goto unacct;
+		percpu_counter_add(&sbinfo->used_blocks, pages);
+	}
+
 	spin_lock_irqsave(&info->lock, flags);
 	info->alloced += pages;
 	inode->i_blocks += pages * BLOCKS_PER_PAGE;
@@ -273,20 +281,11 @@ bool shmem_charge(struct inode *inode, l
 	spin_unlock_irqrestore(&info->lock, flags);
 	inode->i_mapping->nrpages += pages;
 
-	if (!sbinfo->max_blocks)
-		return true;
-	if (percpu_counter_compare(&sbinfo->used_blocks,
-				sbinfo->max_blocks - pages) > 0) {
-		inode->i_mapping->nrpages -= pages;
-		spin_lock_irqsave(&info->lock, flags);
-		info->alloced -= pages;
-		shmem_recalc_inode(inode);
-		spin_unlock_irqrestore(&info->lock, flags);
-		shmem_unacct_blocks(info->flags, pages);
-		return false;
-	}
-	percpu_counter_add(&sbinfo->used_blocks, pages);
 	return true;
+
+unacct:
+	shmem_unacct_blocks(info->flags, pages);
+	return false;
 }
 
 void shmem_uncharge(struct inode *inode, long pages)
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are



From: akpm@linux-foundation.org
Subject: [merged] tmpfs-distribute-interleave-better-across-nodes.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:19:09 -0700
Message-ID: <20120801201910.6B292200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:63387 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754952Ab2HAUTN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:19:13 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id r15so343932lag.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:19:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nzimmer@sgi.com, andi@firstfloor.org, cl@linux.com, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, npiggin@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: distribute interleave better across nodes
has been removed from the -mm tree.  Its filename was
     tmpfs-distribute-interleave-better-across-nodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nathan Zimmer <nzimmer@sgi.com>
Subject: tmpfs: distribute interleave better across nodes

When tmpfs has the interleave memory policy, it always starts allocating
for each file from node 0 at offset 0.  When there are many small files,
the lower nodes fill up disproportionately.

This patch spreads out node usage by starting files at nodes other than 0,
by using the inode number to bias the starting node for interleave.

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/shmem.c~tmpfs-distribute-interleave-better-across-nodes mm/shmem.c
--- a/mm/shmem.c~tmpfs-distribute-interleave-better-across-nodes
+++ a/mm/shmem.c
@@ -929,7 +929,8 @@ static struct page *shmem_swapin(swp_ent
 
 	/* Create a pseudo vma that just contains the policy */
 	pvma.vm_start = 0;
-	pvma.vm_pgoff = index;
+	/* Bias interleave by inode number to distribute better across nodes */
+	pvma.vm_pgoff = index + info->vfs_inode.i_ino;
 	pvma.vm_ops = NULL;
 	pvma.vm_policy = spol;
 	return swapin_readahead(swap, gfp, &pvma, 0);
@@ -942,7 +943,8 @@ static struct page *shmem_alloc_page(gfp
 
 	/* Create a pseudo vma that just contains the policy */
 	pvma.vm_start = 0;
-	pvma.vm_pgoff = index;
+	/* Bias interleave by inode number to distribute better across nodes */
+	pvma.vm_pgoff = index + info->vfs_inode.i_ino;
 	pvma.vm_ops = NULL;
 	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, index);
 
_

Patches currently in -mm which might be from nzimmer@sgi.com are

origin.patch


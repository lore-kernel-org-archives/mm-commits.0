From: akpm@linux-foundation.org
Subject: + tmpfs-distribute-interleave-better-across-nodes.patch added to -mm tree
Date: Wed, 25 Jul 2012 11:55:40 -0700
Message-ID: <20120725185540.C8F591E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:42703 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab2GYSzm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jul 2012 14:55:42 -0400
Received: by vbnl22 with SMTP id l22so121834vbn.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Jul 2012 11:55:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nzimmer@sgi.com, andi@firstfloor.org, cl@linux.com, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, npiggin@gmail.com, riel@redhat.com


The patch titled
     Subject: tmpfs: distribute interleave better across nodes
has been added to the -mm tree.  Its filename is
     tmpfs-distribute-interleave-better-across-nodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

diff -puN mm/shmem.c~tmpfs-interleave-the-starting-node-of-dev-shmem mm/shmem.c
--- a/mm/shmem.c~tmpfs-interleave-the-starting-node-of-dev-shmem
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
Subject: Subject: tmpfs: distribute interleave better across nodes

Patches currently in -mm which might be from nzimmer@sgi.com are

tmpfs-distribute-interleave-better-across-nodes.patch
shmem-provide-vm_ops-when-also-providing-a-mem-policy.patch


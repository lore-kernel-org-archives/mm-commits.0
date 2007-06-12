From: akpm@linux-foundation.org
Subject: + fix-get_policy-for-stacked-shared-memory-files.patch added to -mm tree
Date: Mon, 11 Jun 2007 21:30:32 -0700
Message-ID: <200706120430.l5C4UWrZ004238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51329 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755846AbXFLEar (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 00:30:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agl@us.ibm.com, ak@suse.de, bill.irwin@oracle.com, clameter@sgi.com, dean@arctic.org


The patch titled
     hugetlb: fix get_policy for stacked shared memory files
has been added to the -mm tree.  Its filename is
     fix-get_policy-for-stacked-shared-memory-files.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hugetlb: fix get_policy for stacked shared memory files
From: Adam Litke <agl@us.ibm.com>

Here's another breakage as a result of shared memory stacked files :(

The NUMA policy for a VMA is determined by checking the following (in the
order given):

1) vma->vm_ops->get_policy() (if defined)
2) vma->vm_policy (if defined)
3) task->mempolicy (if defined)
4) Fall back to default_policy

By switching to stacked files for shared memory, get_policy() is now always
set to shm_get_policy which is a wrapper function.  This causes us to stop
at step 1, which yields NULL for hugetlb instead of task->mempolicy which
was the previous (and correct) result.

This patch modifies the shm_get_policy() wrapper to maintain steps 1-3 for
the wrapped vm_ops.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Acked-by: William Irwin <bill.irwin@oracle.com>
Cc: dean gaudet <dean@arctic.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN ipc/shm.c~fix-get_policy-for-stacked-shared-memory-files ipc/shm.c
--- a/ipc/shm.c~fix-get_policy-for-stacked-shared-memory-files
+++ a/ipc/shm.c
@@ -254,8 +254,10 @@ struct mempolicy *shm_get_policy(struct 
 
 	if (sfd->vm_ops->get_policy)
 		pol = sfd->vm_ops->get_policy(vma, addr);
-	else
+	else if (vma->vm_policy)
 		pol = vma->vm_policy;
+	else
+		pol = current->mempolicy;
 	return pol;
 }
 #endif
_

Patches currently in -mm which might be from agl@us.ibm.com are

fix-get_policy-for-stacked-shared-memory-files.patch
convert-hugetlbfs-to-use-vm_ops-fault.patch
hugetlbfs-use-lib-parser-fix-docs.patch

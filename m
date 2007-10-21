From: akpm@linux-foundation.org
Subject: - memory-controller-memory-accounting-v7-fix-swapoff-breakage-however.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:48:44 -0700
Message-ID: <200710212348.l9LNmix0000737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53060 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753574AbXJUXzT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:55:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, balbir@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fix swapoff breakage; however...
has been removed from the -mm tree.  Its filename was
     memory-controller-memory-accounting-v7-fix-swapoff-breakage-however.patch

This patch was dropped because it was folded into memory-controller-memory-accounting-v7.patch

------------------------------------------------------
Subject: fix swapoff breakage; however...
From: Hugh Dickins <hugh@veritas.com>

rc4-mm1's memory-controller-memory-accounting-v7.patch broke swapoff:
it extended unuse_pte_range's boolean "found" return code to allow an
error return too; but ended up returning found (1) as an error.
Replace that by success (0) before it gets to the upper level.

More fundamentally, it looks like any cgroup brought over its limit in
unuse_pte will abort swapoff: that doesn't doesn't seem "contained" to me.
Maybe unuse_pte should just let cgroups go over their limits without
error?  Or swap should be counted along with RSS?  Needs reconsideration.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swapfile.c~memory-controller-memory-accounting-v7-fix-swapoff-breakage-however mm/swapfile.c
--- a/mm/swapfile.c~memory-controller-memory-accounting-v7-fix-swapoff-breakage-however
+++ a/mm/swapfile.c
@@ -642,7 +642,7 @@ static int unuse_mm(struct mm_struct *mm
 			break;
 	}
 	up_read(&mm->mmap_sem);
-	return ret;
+	return (ret < 0)? ret: 0;
 }
 
 /*
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
shmem-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
memory-controller-memory-accounting-v7.patch
memory-controller-memory-accounting-v7-fix-swapoff-breakage-however.patch
prio_tree-debugging-patch.patch

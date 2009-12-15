From: akpm@linux-foundation.org
Subject: [merged] rmap-move-the-out-to-a-more-proper-place.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:52:10 -0800
Message-ID: <200912152152.nBFLqAkN015174@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761180AbZLOVwn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:52:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie8@gmail.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     rmap: move label `out' to a better place
has been removed from the -mm tree.  Its filename was
     rmap-move-the-out-to-a-more-proper-place.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rmap: move label `out' to a better place
From: Huang Shijie <shijie8@gmail.com>

When the code jumps to the `out', `referenced' is still zero.  So there is
no need to check it.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/rmap.c~rmap-move-the-out-to-a-more-proper-place mm/rmap.c
--- a/mm/rmap.c~rmap-move-the-out-to-a-more-proper-place
+++ a/mm/rmap.c
@@ -388,9 +388,10 @@ static int page_referenced_one(struct pa
 out_unmap:
 	(*mapcount)--;
 	pte_unmap_unlock(pte, ptl);
-out:
+
 	if (referenced)
 		*vm_flags |= vma->vm_flags;
+out:
 	return referenced;
 }
 
_

Patches currently in -mm which might be from shijie8@gmail.com are

origin.patch


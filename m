From: akpm@linux-foundation.org
Subject: - slub-fix-atomic-usage-in-any_slab_objects.patch removed from -mm tree
Date: Fri, 09 May 2008 14:46:41 -0700
Message-ID: <200805092146.m49LkfsU027139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751747AbYEIV4S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:56:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, clameter@sgi.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     slub: fix atomic usage in any_slab_objects()
has been removed from the -mm tree.  Its filename was
     slub-fix-atomic-usage-in-any_slab_objects.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slub: fix atomic usage in any_slab_objects()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

any_slab_objects() does an atomic_read on an atomic_long_t, this
fixes it to use atomic_long_read instead.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-fix-atomic-usage-in-any_slab_objects mm/slub.c
--- a/mm/slub.c~slub-fix-atomic-usage-in-any_slab_objects
+++ a/mm/slub.c
@@ -3762,7 +3762,7 @@ static int any_slab_objects(struct kmem_
 		if (!n)
 			continue;
 
-		if (atomic_read(&n->total_objects))
+		if (atomic_long_read(&n->total_objects))
 			return 1;
 	}
 	return 0;
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
linux-next.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
aty128fb-test-below-0-on-unsigned-pll-post_divider.patch


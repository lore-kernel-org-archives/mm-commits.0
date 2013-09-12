From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-ac_bits_wanted-should-be-local_alloc_bits-when-returns-enospc.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:41:25 -0700
Message-ID: <523218e5.DrI0EmXix/GriCNQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab3ILTlZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:41:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, younger.liu@huawei.com

Subject: [merged] ocfs2-ac_bits_wanted-should-be-local_alloc_bits-when-returns-enospc.patch removed from -mm tree
To: younger.liu@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:41:25 -0700


The patch titled
     Subject: ocfs2: ac_bits_wanted should be local_alloc_bits when returns -ENOSPC
has been removed from the -mm tree.  Its filename was
     ocfs2-ac_bits_wanted-should-be-local_alloc_bits-when-returns-enospc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Younger Liu <younger.liu@huawei.com>
Subject: ocfs2: ac_bits_wanted should be local_alloc_bits when returns -ENOSPC

There is an issue in reserving and claiming space for localalloc, When
localalloc space is not enough, it would claim space from global_bitmap. 
And if there is not enough free space in global_bitmap, the size of
claiming space would set to half of orignal size and retry.

The issue is as follows: osb->local_alloc_bits is set to half of orignal
size in ocfs2_recalc_la_window(), but ac->ac_bits_wanted is set to
osb->local_alloc_default_bits which is not changed.  localalloc always
reserves and claims local_alloc_default_bits space and returns ENOSPC.

So, ac->ac_bits_wanted should be osb->local_alloc_bits which would be
changed.

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Jeff Liu <jeff.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/localalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/localalloc.c~ocfs2-ac_bits_wanted-should-be-local_alloc_bits-when-returns-enospc fs/ocfs2/localalloc.c
--- a/fs/ocfs2/localalloc.c~ocfs2-ac_bits_wanted-should-be-local_alloc_bits-when-returns-enospc
+++ a/fs/ocfs2/localalloc.c
@@ -1082,7 +1082,7 @@ static int ocfs2_local_alloc_reserve_for
 	}
 
 retry_enospc:
-	(*ac)->ac_bits_wanted = osb->local_alloc_default_bits;
+	(*ac)->ac_bits_wanted = osb->local_alloc_bits;
 	status = ocfs2_reserve_cluster_bitmap_bits(osb, *ac);
 	if (status == -ENOSPC) {
 		if (ocfs2_recalc_la_window(osb, OCFS2_LA_EVENT_ENOSPC) ==
@@ -1154,7 +1154,7 @@ retry_enospc:
 		    OCFS2_LA_DISABLED)
 			goto bail;
 
-		ac->ac_bits_wanted = osb->local_alloc_default_bits;
+		ac->ac_bits_wanted = osb->local_alloc_bits;
 		status = ocfs2_claim_clusters(handle, ac,
 					      osb->local_alloc_bits,
 					      &cluster_off,
_

Patches currently in -mm which might be from younger.liu@huawei.com are

origin.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
ocfs2-update-inode-size-after-zeronig-the-hole.patch


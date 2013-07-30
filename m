From: akpm@linux-foundation.org
Subject: +
 ocfs2-ac_bits_wanted-should-be-local_alloc_bits-when-returns-enospc.patch
 added to -mm tree
Date: Tue, 30 Jul 2013 13:57:23 -0700
Message-ID: <51f828b3.YV9hu9+B5PbtUm4L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925Ab3G3U5Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jul 2013 16:57:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, younger.liu@huawei.com

Subject: + ocfs2-ac_bits_wanted-should-be-local_alloc_bits-when-returns-enospc.patch added to -mm tree
To: younger.liu@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Tue, 30 Jul 2013 13:57:23 -0700


The patch titled
     Subject: ocfs2: ac_bits_wanted should be local_alloc_bits when returns -ENOSPC
has been added to the -mm tree.  Its filename is
     ocfs2-ac_bits_wanted-should-be-local_alloc_bits-when-returns-enospc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-ac_bits_wanted-should-be-local_alloc_bits-when-returns-enospc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-ac_bits_wanted-should-be-local_alloc_bits-when-returns-enospc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2.patch
ocfs2-update-inode-size-after-zeronig-the-hole.patch
ocfs2-lighten-up-allocate-transaction.patch
ocfs2-ac_bits_wanted-should-be-local_alloc_bits-when-returns-enospc.patch


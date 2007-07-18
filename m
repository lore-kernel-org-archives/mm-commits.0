From: akpm@linux-foundation.org
Subject: - dm-fix-memory-leak-in-dm_create_persistent-when-starting-metadata-update-thread-fails.patch removed from -mm tree
Date: Wed, 18 Jul 2007 11:51:54 -0700
Message-ID: <200707181851.l6IIptTN023621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34160 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759804AbXGRSwl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 14:52:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, agk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dm: fix memory leak in dm_create_persistent() when starting metadata update thread fails
has been removed from the -mm tree.  Its filename was
     dm-fix-memory-leak-in-dm_create_persistent-when-starting-metadata-update-thread-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dm: fix memory leak in dm_create_persistent() when starting metadata update thread fails
From: Jesper Juhl <jesper.juhl@gmail.com>

If, in dm_create_persistent(), the call to create_singlethread_workqueue()
fails then we'll return without freeing the memory allocated to 'ps', thus
leaking sizeof(struct pstore) bytes.  This patch fixes the leak.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com
Acked-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-exception-store.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/md/dm-exception-store.c~dm-fix-memory-leak-in-dm_create_persistent-when-starting-metadata-update-thread-fails drivers/md/dm-exception-store.c
--- a/drivers/md/dm-exception-store.c~dm-fix-memory-leak-in-dm_create_persistent-when-starting-metadata-update-thread-fails
+++ a/drivers/md/dm-exception-store.c
@@ -623,6 +623,7 @@ int dm_create_persistent(struct exceptio
 
 	ps->metadata_wq = create_singlethread_workqueue("ksnaphd");
 	if (!ps->metadata_wq) {
+		kfree(ps);
 		DMERR("couldn't start header metadata update thread");
 		return -ENOMEM;
 	}
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-mtd.patch
remove-unneeded-test-of-task-in-dump_trace.patch
git-xfs.patch

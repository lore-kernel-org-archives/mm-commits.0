From: akpm@linux-foundation.org
Subject: [merged] block-fix-improper-kobject-release-in-blk_integrity_unregister.patch removed from -mm tree
Date: Wed, 29 Jul 2009 12:35:27 -0700
Message-ID: <200907291935.n6TJZRev003686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753764AbZG2Tgj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 15:36:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dfeng@redhat.com, jens.axboe@oracle.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     block: fix improper kobject release in blk_integrity_unregister
has been removed from the -mm tree.  Its filename was
     block-fix-improper-kobject-release-in-blk_integrity_unregister.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: fix improper kobject release in blk_integrity_unregister
From: Xiaotian Feng <dfeng@redhat.com>

blk_integrity_unregister should use kobject_put to release the kobject,
otherwise after bi is freed, memory of bi->kobj->name is leaked.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-integrity.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN block/blk-integrity.c~block-fix-improper-kobject-release-in-blk_integrity_unregister block/blk-integrity.c
--- a/block/blk-integrity.c~block-fix-improper-kobject-release-in-blk_integrity_unregister
+++ a/block/blk-integrity.c
@@ -379,6 +379,7 @@ void blk_integrity_unregister(struct gen
 
 	kobject_uevent(&bi->kobj, KOBJ_REMOVE);
 	kobject_del(&bi->kobj);
+	kobject_put(&bi->kobj);
 	kmem_cache_free(integrity_cachep, bi);
 	disk->integrity = NULL;
 }
_

Patches currently in -mm which might be from dfeng@redhat.com are

origin.patch
linux-next.patch
cgroups-make-unlock-sequence-in-cgroup_get_sb-consistent.patch


From: akpm@linux-foundation.org
Subject: + block-fix-improper-kobject-release-in-blk_integrity_unregister.patch added to -mm tree
Date: Mon, 27 Jul 2009 14:46:35 -0700
Message-ID: <200907272146.n6RLkZvY001736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751704AbZG0VsO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jul 2009 17:48:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dfeng@redhat.com, jens.axboe@oracle.com, tj@kernel.org


The patch titled
     block: fix improper kobject release in blk_integrity_unregister
has been added to the -mm tree.  Its filename is
     block-fix-improper-kobject-release-in-blk_integrity_unregister.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
block-fix-improper-kobject-release-in-blk_integrity_unregister.patch
cgroups-make-unlock-sequence-in-cgroup_get_sb-consistent.patch


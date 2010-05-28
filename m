From: akpm@linux-foundation.org
Subject: + block-bd_start_claiming-fix-module-refcount.patch added to -mm tree
Date: Fri, 28 May 2010 14:35:37 -0700
Message-ID: <201005282135.o4SLZbGT015891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759199Ab0E1Vfp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 May 2010 17:35:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, jens.axboe@oracle.com, tj@kernel.org


The patch titled
     block: bd_start_claiming fix module refcount
has been added to the -mm tree.  Its filename is
     block-bd_start_claiming-fix-module-refcount.patch

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
Subject: block: bd_start_claiming fix module refcount
From: Nick Piggin <npiggin@suse.de>

bd_start_claiming has an unbalanced module_put introduced in 6b4517a79.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/block_dev.c~block-bd_start_claiming-fix-module-refcount fs/block_dev.c
--- a/fs/block_dev.c~block-bd_start_claiming-fix-module-refcount
+++ a/fs/block_dev.c
@@ -734,6 +734,7 @@ static struct block_device *bd_start_cla
 		return ERR_PTR(-ENXIO);
 
 	whole = bdget_disk(disk, 0);
+	module_put(disk->fops->owner);
 	put_disk(disk);
 	if (!whole)
 		return ERR_PTR(-ENOMEM);
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
block-bd_start_claiming-fix-module-refcount.patch
block-bd_start_claiming-cleanup.patch
fs-splicec-fix-mapping_gfp_mask-usage.patch
reiser4.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523C32DAFB4
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 02:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765851608; cv=none; b=Yp4Ewu+gu4VABfb1vGLK8C8G9a6Uy2p3X6lyPC1gyFz7U3eo1YFMWiMcXu+UvSGngIDOeRai2ccyTsuV++hMdJGbWYMBfu83kXVsP/jkyUAp5zSAjt2xNRP1c0lJzSCvfgndZuuIMVR1CFeyfI9pcUIBN1W9Ni1wKq8IRJwHBEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765851608; c=relaxed/simple;
	bh=jAp/p3vaTUd3FtwV93CArxlaqR2FclrZw1C5b2g7n3E=;
	h=Date:To:From:Subject:Message-Id; b=CSr+lMhkYqVuzoWjeLHc6kN3hcFuYF40wQ2DZ38Pyhvf3MRFzt0DKfgPAvHhIBOXTVzDqy1w+S+GhTVDyrKuzaJffoiLEjXaE8DUmNGoOu9j9OcdAYx0yCziUnRnwUl82cQKkvdwwNY/3n/cFyQzRSA6ny6k2XnwkjdigT2ZEv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FbrkTFUA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FbrkTFUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C37C4CEF5;
	Tue, 16 Dec 2025 02:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765851604;
	bh=jAp/p3vaTUd3FtwV93CArxlaqR2FclrZw1C5b2g7n3E=;
	h=Date:To:From:Subject:From;
	b=FbrkTFUAsJ5dVz4vESghO+aZHa9Q8ekKmIyHBizz5aoGkcdlLrZvCZR6xy/W65+NK
	 QMy6MbkzyAkzFgOsN43UTXNOdBSxxvMYE5V8aKw5y+5o3I6gZr/mNwzB/FeGQ9U7nA
	 t4G2EqWJErCU3waj6tF1ehODjle6KrWULgXSK+Ww=
Date: Mon, 15 Dec 2025 18:20:04 -0800
To: mm-commits@vger.kernel.org,stevensd@google.com,richardycc@google.com,minchan@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-rename-zram_free_page.patch added to mm-new branch
Message-Id: <20251216022004.A7C37C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: rename zram_free_page()
has been added to the -mm mm-new branch.  Its filename is
     zram-rename-zram_free_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-rename-zram_free_page.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: rename zram_free_page()
Date: Mon, 1 Dec 2025 18:47:52 +0900

We don't free page in zram_free_page(), not all slots even have any memory
associated with them (e.g.  ZRAM_SAME).  We free the slot (or reset it),
rename the function accordingly.

Link: https://lkml.kernel.org/r/20251201094754.4149975-6-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Stevens <stevensd@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-rename-zram_free_page
+++ a/drivers/block/zram/zram_drv.c
@@ -56,7 +56,7 @@ static size_t huge_class_size;
 
 static const struct block_device_operations zram_devops;
 
-static void zram_free_page(struct zram *zram, size_t index);
+static void zram_slot_free(struct zram *zram, u32 index);
 #define slot_dep_map(zram, index) (&(zram)->table[(index)].dep_map)
 
 static void zram_slot_lock_init(struct zram *zram, u32 index)
@@ -984,7 +984,7 @@ static int zram_writeback_complete(struc
 		huge = zram_test_flag(zram, index, ZRAM_HUGE);
 	}
 
-	zram_free_page(zram, index);
+	zram_slot_free(zram, index);
 	zram_set_flag(zram, index, ZRAM_WB);
 	zram_set_handle(zram, index, req->blk_idx);
 
@@ -2025,7 +2025,7 @@ static void zram_meta_free(struct zram *
 
 	/* Free all pages that are still in this zram device */
 	for (index = 0; index < num_pages; index++)
-		zram_free_page(zram, index);
+		zram_slot_free(zram, index);
 
 	zs_destroy_pool(zram->mem_pool);
 	vfree(zram->table);
@@ -2057,7 +2057,7 @@ static bool zram_meta_alloc(struct zram
 	return true;
 }
 
-static void zram_free_page(struct zram *zram, size_t index)
+static void zram_slot_free(struct zram *zram, u32 index)
 {
 	unsigned long handle;
 
@@ -2256,7 +2256,7 @@ static int write_same_filled_page(struct
 				  u32 index)
 {
 	zram_slot_lock(zram, index);
-	zram_free_page(zram, index);
+	zram_slot_free(zram, index);
 	zram_set_flag(zram, index, ZRAM_SAME);
 	zram_set_handle(zram, index, fill);
 	zram_slot_unlock(zram, index);
@@ -2294,7 +2294,7 @@ static int write_incompressible_page(str
 	kunmap_local(src);
 
 	zram_slot_lock(zram, index);
-	zram_free_page(zram, index);
+	zram_slot_free(zram, index);
 	zram_set_flag(zram, index, ZRAM_HUGE);
 	zram_set_handle(zram, index, handle);
 	zram_set_obj_size(zram, index, PAGE_SIZE);
@@ -2359,7 +2359,7 @@ static int zram_write_page(struct zram *
 	zcomp_stream_put(zstrm);
 
 	zram_slot_lock(zram, index);
-	zram_free_page(zram, index);
+	zram_slot_free(zram, index);
 	zram_set_handle(zram, index, handle);
 	zram_set_obj_size(zram, index, comp_len);
 	zram_slot_unlock(zram, index);
@@ -2581,7 +2581,7 @@ static int recompress_slot(struct zram *
 	zs_obj_write(zram->mem_pool, handle_new, zstrm->buffer, comp_len_new);
 	zcomp_stream_put(zstrm);
 
-	zram_free_page(zram, index);
+	zram_slot_free(zram, index);
 	zram_set_handle(zram, index, handle_new);
 	zram_set_obj_size(zram, index, comp_len_new);
 	zram_set_priority(zram, index, prio);
@@ -2784,7 +2784,7 @@ static void zram_bio_discard(struct zram
 
 	while (n >= PAGE_SIZE) {
 		zram_slot_lock(zram, index);
-		zram_free_page(zram, index);
+		zram_slot_free(zram, index);
 		zram_slot_unlock(zram, index);
 		atomic64_inc(&zram->stats.notify_free);
 		index++;
@@ -2892,7 +2892,7 @@ static void zram_slot_free_notify(struct
 		return;
 	}
 
-	zram_free_page(zram, index);
+	zram_slot_free(zram, index);
 	zram_slot_unlock(zram, index);
 }
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-document-writeback_batch_size.patch
zram-move-bd_stat-to-writeback-section.patch
zram-rename-zram_free_page.patch
zram-switch-to-guard-for-init_lock.patch
zram-consolidate-device-attr-declarations.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FE91339B1
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 00:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727225602; cv=none; b=YYE3X5YeEd4zHQJGTHi+vAngkOWnr9HPUS0L+aKBkSzobo+uKJAaj4XnZrD7C8YXtw32ZJp5Vyg9obBP8kJYMj97S4WmLH1xepkxjmBxhx7b9pUtQMhasbk+KJpbJv+FWYwQx3dPET4AHBX4D1dXB69k6Bc7vg10KjS3vg7QSEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727225602; c=relaxed/simple;
	bh=3wlJD2SmlYfWTJiVZR8527TGY8DRHqnJF/Lm7Px8FM4=;
	h=Date:To:From:Subject:Message-Id; b=brOK3KXtZGRBOZcQ8vrwR7qDtYkhpxbSU5Ixb/oXgVmy6haDHhzKB7Lt6em5yOOtlEj1+haJ9gi+UvAMHPsP7XbPZEXS/24TzfB6SbLU9gMcBDwvytLmdvkdk+m8fxt9P+eftJ9UvWZ6XATTBU3TMLoueVJXUBv2j/sBuqDMYJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EBE3FMkq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EBE3FMkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87790C4CEC4;
	Wed, 25 Sep 2024 00:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727225601;
	bh=3wlJD2SmlYfWTJiVZR8527TGY8DRHqnJF/Lm7Px8FM4=;
	h=Date:To:From:Subject:From;
	b=EBE3FMkqjty9Ql0kjGc2PZM4vTCdzbzkUilIAkv7tPGoaUCqcPY8z/Kq+tbtgWESX
	 myCv0xcb/GLKo0ADTWFF4SB8AGaHIOhuK293p8p3xe6n4a6uozVjEl1iKkhCQwOfcI
	 6Ff5rBjRU9Y//g4DTyXg4xnmhmWijM0v+6JZWdRE=
Date: Tue, 24 Sep 2024 17:53:21 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-reshuffle-zram_free_page-flags-operations.patch added to mm-unstable branch
Message-Id: <20240925005321.87790C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: reshuffle zram_free_page() flags operations
has been added to the -mm mm-unstable branch.  Its filename is
     zram-reshuffle-zram_free_page-flags-operations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-reshuffle-zram_free_page-flags-operations.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: zram: reshuffle zram_free_page() flags operations
Date: Tue, 17 Sep 2024 11:09:11 +0900

Drop some redundant zram_test_flag() calls and re-order zram_clear_flag()
calls.  Plus two small trivial coding style fixes.  No functional changes.

Link: https://lkml.kernel.org/r/20240917021020.883356-7-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-reshuffle-zram_free_page-flags-operations
+++ a/drivers/block/zram/zram_drv.c
@@ -1499,20 +1499,17 @@ static void zram_free_page(struct zram *
 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
 	zram->table[index].ac_time = 0;
 #endif
-	if (zram_test_flag(zram, index, ZRAM_IDLE))
-		zram_clear_flag(zram, index, ZRAM_IDLE);
+
+	zram_clear_flag(zram, index, ZRAM_IDLE);
+	zram_clear_flag(zram, index, ZRAM_INCOMPRESSIBLE);
+	zram_clear_flag(zram, index, ZRAM_PP_SLOT);
+	zram_set_priority(zram, index, 0);
 
 	if (zram_test_flag(zram, index, ZRAM_HUGE)) {
 		zram_clear_flag(zram, index, ZRAM_HUGE);
 		atomic64_dec(&zram->stats.huge_pages);
 	}
 
-	if (zram_test_flag(zram, index, ZRAM_INCOMPRESSIBLE))
-		zram_clear_flag(zram, index, ZRAM_INCOMPRESSIBLE);
-
-	zram_set_priority(zram, index, 0);
-	zram_clear_flag(zram, index, ZRAM_PP_SLOT);
-
 	if (zram_test_flag(zram, index, ZRAM_WB)) {
 		zram_clear_flag(zram, index, ZRAM_WB);
 		free_block_bdev(zram, zram_get_element(zram, index));
@@ -1536,13 +1533,12 @@ static void zram_free_page(struct zram *
 	zs_free(zram->mem_pool, handle);
 
 	atomic64_sub(zram_get_obj_size(zram, index),
-			&zram->stats.compr_data_size);
+		     &zram->stats.compr_data_size);
 out:
 	atomic64_dec(&zram->stats.pages_stored);
 	zram_set_handle(zram, index, 0);
 	zram_set_obj_size(zram, index, 0);
-	WARN_ON_ONCE(zram->table[index].flags &
-		~(1UL << ZRAM_UNDER_WB));
+	WARN_ON_ONCE(zram->table[index].flags & ~(1UL << ZRAM_UNDER_WB));
 }
 
 /*
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-introduce-zram_pp_slot-flag.patch
zram-permit-only-one-post-processing-operation-at-a-time.patch
zram-rework-recompress-target-selection-strategy.patch
zram-rework-writeback-target-selection-strategy.patch
zram-do-not-mark-idle-slots-that-cannot-be-idle.patch
zram-reshuffle-zram_free_page-flags-operations.patch
zram-remove-under_wb-and-simplify-writeback.patch


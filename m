Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3E73C4167B
	for <mm-commits@archiver.kernel.org>; Wed, 29 Nov 2023 01:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjK2BOr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Nov 2023 20:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjK2BOq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Nov 2023 20:14:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B0210C0
        for <mm-commits@vger.kernel.org>; Tue, 28 Nov 2023 17:14:53 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C539FC433C8;
        Wed, 29 Nov 2023 01:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701220492;
        bh=ys25ROXqFvV6zVFeSWNPyQTuAK4HKqDqt0O0G6GgtLs=;
        h=Date:To:From:Subject:From;
        b=ekwW9nZY+zIngJ0uQUB8e0LQYYcZKwBe+NYMxDxlPvz6k4or6MnG11NaQsGbwN4EK
         7MlTJpTV0dGCzpjc2BfnlBmNA3QyE7PmXNgM6yJ73MGFe41CUXfSJ/6L4GG5ryzNo1
         g5MIDm7psaApKrYrbA+Y9v1cKGGmHJWh09C7U2TY=
Date:   Tue, 28 Nov 2023 17:14:52 -0800
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-use-kmap_local_page.patch added to mm-unstable branch
Message-Id: <20231129011452.C539FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: use kmap_local_page()
has been added to the -mm mm-unstable branch.  Its filename is
     zram-use-kmap_local_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-use-kmap_local_page.patch

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
Subject: zram: use kmap_local_page()
Date: Tue, 28 Nov 2023 17:22:07 +0900

Use kmap_local_page() instead of kmap_atomic() which has been
deprecated.

Link: https://lkml.kernel.org/r/20231128083845.848008-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-use-kmap_local_page
+++ a/drivers/block/zram/zram_drv.c
@@ -1321,9 +1321,9 @@ static int zram_read_from_zspool(struct
 		void *mem;
 
 		value = handle ? zram_get_element(zram, index) : 0;
-		mem = kmap_atomic(page);
+		mem = kmap_local_page(page);
 		zram_fill_page(mem, PAGE_SIZE, value);
-		kunmap_atomic(mem);
+		kunmap_local(mem);
 		return 0;
 	}
 
@@ -1336,14 +1336,14 @@ static int zram_read_from_zspool(struct
 
 	src = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
 	if (size == PAGE_SIZE) {
-		dst = kmap_atomic(page);
+		dst = kmap_local_page(page);
 		memcpy(dst, src, PAGE_SIZE);
-		kunmap_atomic(dst);
+		kunmap_local(dst);
 		ret = 0;
 	} else {
-		dst = kmap_atomic(page);
+		dst = kmap_local_page(page);
 		ret = zcomp_decompress(zstrm, src, size, dst);
-		kunmap_atomic(dst);
+		kunmap_local(dst);
 		zcomp_stream_put(zram->comps[prio]);
 	}
 	zs_unmap_object(zram->mem_pool, handle);
@@ -1416,21 +1416,21 @@ static int zram_write_page(struct zram *
 	unsigned long element = 0;
 	enum zram_pageflags flags = 0;
 
-	mem = kmap_atomic(page);
+	mem = kmap_local_page(page);
 	if (page_same_filled(mem, &element)) {
-		kunmap_atomic(mem);
+		kunmap_local(mem);
 		/* Free memory associated with this sector now. */
 		flags = ZRAM_SAME;
 		atomic64_inc(&zram->stats.same_pages);
 		goto out;
 	}
-	kunmap_atomic(mem);
+	kunmap_local(mem);
 
 compress_again:
 	zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
-	src = kmap_atomic(page);
+	src = kmap_local_page(page);
 	ret = zcomp_compress(zstrm, src, &comp_len);
-	kunmap_atomic(src);
+	kunmap_local(src);
 
 	if (unlikely(ret)) {
 		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
@@ -1494,10 +1494,10 @@ compress_again:
 
 	src = zstrm->buffer;
 	if (comp_len == PAGE_SIZE)
-		src = kmap_atomic(page);
+		src = kmap_local_page(page);
 	memcpy(dst, src, comp_len);
 	if (comp_len == PAGE_SIZE)
-		kunmap_atomic(src);
+		kunmap_local(src);
 
 	zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
 	zs_unmap_object(zram->mem_pool, handle);
@@ -1614,9 +1614,9 @@ static int zram_recompress(struct zram *
 
 		num_recomps++;
 		zstrm = zcomp_stream_get(zram->comps[prio]);
-		src = kmap_atomic(page);
+		src = kmap_local_page(page);
 		ret = zcomp_compress(zstrm, src, &comp_len_new);
-		kunmap_atomic(src);
+		kunmap_local(src);
 
 		if (ret) {
 			zcomp_stream_put(zram->comps[prio]);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-split-memory-tracking-and-ac-time-tracking.patch
zram-split-memory-tracking-and-ac-time-tracking-v2.patch
zram-tweak-writeback-config-help.patch
zram-use-kmap_local_page.patch
checkpatch-do-not-require-an-empty-line-before-error-injection.patch


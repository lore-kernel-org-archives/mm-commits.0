Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93353C433ED
	for <mm-commits@archiver.kernel.org>; Sat, 15 May 2021 00:27:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 767EB61457
	for <mm-commits@archiver.kernel.org>; Sat, 15 May 2021 00:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbhEOA2q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 May 2021 20:28:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230022AbhEOA2q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 May 2021 20:28:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0705B61440;
        Sat, 15 May 2021 00:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621038454;
        bh=5TKQccw0MfrPcBro+UF6pP1bAi79nl8XEtlMz/Eb7KU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Wwg+CCI4p7eGLnxLqkFKQUdnEXuHkZwRP2dl1wKHREtypRr95DIexmQbg7hPrjZUV
         SpYdNMFhJ99nsJdfYVoa78q8dTFFZGAchrbLNCwAwZMlVLg+4lm6yV43OKQqtiQNhd
         Xz0zdjaa2dcAfo7/BwyRlgw9YtOEy9SyP71wqHjQ=
Date:   Fri, 14 May 2021 17:27:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anatoly.trosinenko@gmail.com,
        anton@tuxera.com, jouni.roivas@tuxera.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, slava@dubeyko.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 11/13] hfsplus: prevent corruption in shrinking
 truncate
Message-ID: <20210515002733.KxUyvD09_%akpm@linux-foundation.org>
In-Reply-To: <20210514172634.9018621171d5334ceee97e95@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jouni Roivas <jouni.roivas@tuxera.com>
Subject: hfsplus: prevent corruption in shrinking truncate

I believe there are some issues introduced by commit 31651c607151
("hfsplus: avoid deadlock on file truncation")

HFS+ has extent records which always contains 8 extents.  In case the
first extent record in catalog file gets full, new ones are allocated from
extents overflow file.

In case shrinking truncate happens to middle of an extent record which
locates in extents overflow file, the logic in hfsplus_file_truncate() was
changed so that call to hfs_brec_remove() is not guarded any more.

Right action would be just freeing the extents that exceed the new size
inside extent record by calling hfsplus_free_extents(), and then check if
the whole extent record should be removed.  However since the guard
(blk_cnt > start) is now after the call to hfs_brec_remove(), this has
unfortunate effect that the last matching extent record is removed
unconditionally.

To reproduce this issue, create a file which has at least 10 extents, and
then perform shrinking truncate into middle of the last extent record, so
that the number of remaining extents is not under or divisible by 8.  This
causes the last extent record (8 extents) to be removed totally instead of
truncating into middle of it.  Thus this causes corruption, and lost data.

Fix for this is simply checking if the new truncated end is below the
start of this extent record, making it safe to remove the full extent
record.  However call to hfs_brec_remove() can't be moved to it's previous
place since we're dropping ->tree_lock and it can cause a race condition
and the cached info being invalidated possibly corrupting the node data.

Another issue is related to this one.  When entering into the block
(blk_cnt > start) we are not holding the ->tree_lock.  We break out from
the loop not holding the lock, but hfs_find_exit() does unlock it.  Not
sure if it's possible for someone else to take the lock under our feet,
but it can cause hard to debug errors and premature unlocking.  Even if
there's no real risk of it, the locking should still always be kept in
balance.  Thus taking the lock now just before the check.

Link: https://lkml.kernel.org/r/20210429165139.3082828-1-jouni.roivas@tuxera.com
Fixes: 31651c607151f ("hfsplus: avoid deadlock on file truncation")
Signed-off-by: Jouni Roivas <jouni.roivas@tuxera.com>
Reviewed-by: Anton Altaparmakov <anton@tuxera.com>
Cc: Anatoly Trosinenko <anatoly.trosinenko@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/extents.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/hfsplus/extents.c~hfsplus-prevent-corruption-in-shrinking-truncate
+++ a/fs/hfsplus/extents.c
@@ -598,13 +598,15 @@ void hfsplus_file_truncate(struct inode
 		res = __hfsplus_ext_cache_extent(&fd, inode, alloc_cnt);
 		if (res)
 			break;
-		hfs_brec_remove(&fd);
 
-		mutex_unlock(&fd.tree->tree_lock);
 		start = hip->cached_start;
+		if (blk_cnt <= start)
+			hfs_brec_remove(&fd);
+		mutex_unlock(&fd.tree->tree_lock);
 		hfsplus_free_extents(sb, hip->cached_extents,
 				     alloc_cnt - start, alloc_cnt - blk_cnt);
 		hfsplus_dump_extent(hip->cached_extents);
+		mutex_lock(&fd.tree->tree_lock);
 		if (blk_cnt > start) {
 			hip->extent_state |= HFSPLUS_EXT_DIRTY;
 			break;
@@ -612,7 +614,6 @@ void hfsplus_file_truncate(struct inode
 		alloc_cnt = start;
 		hip->cached_start = hip->cached_blocks = 0;
 		hip->extent_state &= ~(HFSPLUS_EXT_DIRTY | HFSPLUS_EXT_NEW);
-		mutex_lock(&fd.tree->tree_lock);
 	}
 	hfs_find_exit(&fd);
 
_

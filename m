Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E60C2BA19
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 17:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9899764F35
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 17:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbhCORtM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 13:49:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231679AbhCORsz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 13:48:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EE5361477;
        Mon, 15 Mar 2021 17:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615830534;
        bh=54kf42kgr9QJUvKILj8TNAzqErhIfrtk72x5Q/lPCq0=;
        h=Date:From:To:Subject:From;
        b=KVNsOhAXckt8f25xYtKCZw2SqFKzklJGJeDRy0BAyWXEkmahOlEihvfsSYq/MHUlc
         IXUindPbF4Gi8em1mSmEzRLfZ5r+VHtI2h0lel+yESs2dcnpl+nuRri6vF6y21yyYX
         kFsFkyGXBihWS76QyifGs+pmtOgKeZY08/ec0hYc=
Date:   Mon, 15 Mar 2021 10:48:54 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, joaodias@google.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com,
        stable@vger.kernel.org
Subject:  [merged] zram-fix-return-value-on-writeback_store.patch
 removed from -mm tree
Message-ID: <20210315174854.YqhEpEjZ7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: fix return value on writeback_store
has been removed from the -mm tree.  Its filename was
     zram-fix-return-value-on-writeback_store.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: fix return value on writeback_store

writeback_store's return value is overwritten by submit_bio_wait's return
value.  Thus, writeback_store will return zero since there was no IO
error.  In the end, write syscall from userspace will see the zero as
return value, which could make the process stall to keep trying the write
until it will succeed.

Link: https://lkml.kernel.org/r/20210312173949.2197662-1-minchan@kernel.org
Fixes: 3b82a051c101("drivers/block/zram/zram_drv.c: fix error return codes not being returned in writeback_store")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: John Dias <joaodias@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-return-value-on-writeback_store
+++ a/drivers/block/zram/zram_drv.c
@@ -627,7 +627,7 @@ static ssize_t writeback_store(struct de
 	struct bio_vec bio_vec;
 	struct page *page;
 	ssize_t ret = len;
-	int mode;
+	int mode, err;
 	unsigned long blk_idx = 0;
 
 	if (sysfs_streq(buf, "idle"))
@@ -728,12 +728,17 @@ static ssize_t writeback_store(struct de
 		 * XXX: A single page IO would be inefficient for write
 		 * but it would be not bad as starter.
 		 */
-		ret = submit_bio_wait(&bio);
-		if (ret) {
+		err = submit_bio_wait(&bio);
+		if (err) {
 			zram_slot_lock(zram, index);
 			zram_clear_flag(zram, index, ZRAM_UNDER_WB);
 			zram_clear_flag(zram, index, ZRAM_IDLE);
 			zram_slot_unlock(zram, index);
+			/*
+			 * Return last IO error unless every IO were
+			 * not suceeded.
+			 */
+			ret = err;
 			continue;
 		}
 
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-remove-lru_add_drain_all-in-alloc_contig_range.patch
mm-page_alloc-dump-migrate-failed-pages.patch
mm-vmstat-add-cma-statistics.patch
mm-cma-support-sysfs.patch


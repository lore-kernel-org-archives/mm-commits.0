Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9CBBC2BA1A
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 17:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F75564F26
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 17:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbhCORtP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 13:49:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230486AbhCORs6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 13:48:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90EBD64F0C;
        Mon, 15 Mar 2021 17:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615830537;
        bh=z/Y0MKdJM/BQPpwWNoDpnL+jg5jhuvyQmBG3e1il/dY=;
        h=Date:From:To:Subject:From;
        b=Ed8uSkUb0+/hNl+TgVj9GdpzskQFtgrE1LYzh0QDdDQQcogNw5cZB+EBnaZWdocxh
         7EHAVkI72oUG+TiGneJNMnytXJjujafg8j+e6ZS54gvUB/Nx7M/VDy6z5kMiRJ1dNN
         kJQWujxrYxNCr3elvOBGAQl6I/U11AGTxaOqG3fY=
Date:   Mon, 15 Mar 2021 10:48:57 -0700
From:   akpm@linux-foundation.org
To:     amosbianchi@google.com, joaodias@google.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com,
        stable@vger.kernel.org
Subject:  [merged] zram-fix-broken-page-writeback.patch removed
 from -mm tree
Message-ID: <20210315174857.BOpyj3psx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: fix broken page writeback
has been removed from the -mm tree.  Its filename was
     zram-fix-broken-page-writeback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: fix broken page writeback

commit 0d8359620d9b ("zram: support page writeback") introduced two
problems.  It overwrites writeback_store's return value as kstrtol's
return value, which makes return value zero so user could see zero as
return value of write syscall even though it wrote data successfully.

It also breaks index value in the loop in that it doesn't increase the
index any longer.  It means it can write only first starting block index
so user couldn't write all idle pages in the zram so lose memory saving
chance.

This patch fixes those issues.

Link: https://lkml.kernel.org/r/20210312173949.2197662-2-minchan@kernel.org
Fixes: 0d8359620d9b("zram: support page writeback")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Amos Bianchi <amosbianchi@google.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: John Dias <joaodias@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-broken-page-writeback
+++ a/drivers/block/zram/zram_drv.c
@@ -638,8 +638,8 @@ static ssize_t writeback_store(struct de
 		if (strncmp(buf, PAGE_WB_SIG, sizeof(PAGE_WB_SIG) - 1))
 			return -EINVAL;
 
-		ret = kstrtol(buf + sizeof(PAGE_WB_SIG) - 1, 10, &index);
-		if (ret || index >= nr_pages)
+		if (kstrtol(buf + sizeof(PAGE_WB_SIG) - 1, 10, &index) ||
+				index >= nr_pages)
 			return -EINVAL;
 
 		nr_pages = 1;
@@ -663,7 +663,7 @@ static ssize_t writeback_store(struct de
 		goto release_init_lock;
 	}
 
-	while (nr_pages--) {
+	for (; nr_pages != 0; index++, nr_pages--) {
 		struct bio_vec bvec;
 
 		bvec.bv_page = page;
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-remove-lru_add_drain_all-in-alloc_contig_range.patch
mm-page_alloc-dump-migrate-failed-pages.patch
mm-vmstat-add-cma-statistics.patch
mm-cma-support-sysfs.patch


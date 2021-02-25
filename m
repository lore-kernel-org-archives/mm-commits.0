Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E9CDC432C3
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:23:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24ECE64F3C
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:23:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234799AbhBYTXI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:23:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:60052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234675AbhBYTUG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:20:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B59364F65;
        Thu, 25 Feb 2021 19:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280420;
        bh=WkY5a6SBWoOuFGKafvY3N4yKr46lsp0nA3IA6wUFt6k=;
        h=Date:From:To:Subject:From;
        b=Ejl7PID9HEeqWrMpI6EqUXaIagxPgV0Yj6p5CY8xa4ZLEuL5iXWTTHx/9meHzOOSH
         m2cBVqkfezinkf7tIKXmxy7j/ArCFI3/0Ps9vclEXV0oZhQjl0ZlooUsnD3HC5NjsS
         5cHc9vg3pRJW2hxLhPNkqe7s7MqyZcokz5gZWXAY=
Date:   Thu, 25 Feb 2021 11:13:40 -0800
From:   akpm@linux-foundation.org
To:     georgi.djakov@linaro.org, linmiaohe@huawei.com, minchan@kernel.org,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-page_io-use-pr_alert_ratelimited-for-swap-read-write-errors.patch
 removed from -mm tree
Message-ID: <20210225191340.IrvsafFrf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_io: use pr_alert_ratelimited for swap read/write errors
has been removed from the -mm tree.  Its filename was
     mm-page_io-use-pr_alert_ratelimited-for-swap-read-write-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Georgi Djakov <georgi.djakov@linaro.org>
Subject: mm/page_io: use pr_alert_ratelimited for swap read/write errors

If there are errors during swap read or write, they can easily fill the
log buffer and remove any previous messages that might be useful for
debugging, especially on systems that rely for logging only on the kernel
ring-buffer.

For example, on a systems using zram as swap, we are more likely to see
any page allocation errors preceding the swap write errors if the alerts
are ratelimited.

Link: https://lkml.kernel.org/r/20210201142055.29068-1-georgi.djakov@linaro.org
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/page_io.c~mm-page_io-use-pr_alert_ratelimited-for-swap-read-write-errors
+++ a/mm/page_io.c
@@ -41,9 +41,9 @@ void end_swap_bio_write(struct bio *bio)
 		 * Also clear PG_reclaim to avoid rotate_reclaimable_page()
 		 */
 		set_page_dirty(page);
-		pr_alert("Write-error on swap-device (%u:%u:%llu)\n",
-			 MAJOR(bio_dev(bio)), MINOR(bio_dev(bio)),
-			 (unsigned long long)bio->bi_iter.bi_sector);
+		pr_alert_ratelimited("Write-error on swap-device (%u:%u:%llu)\n",
+				     MAJOR(bio_dev(bio)), MINOR(bio_dev(bio)),
+				     (unsigned long long)bio->bi_iter.bi_sector);
 		ClearPageReclaim(page);
 	}
 	end_page_writeback(page);
@@ -106,9 +106,9 @@ static void end_swap_bio_read(struct bio
 	if (bio->bi_status) {
 		SetPageError(page);
 		ClearPageUptodate(page);
-		pr_alert("Read-error on swap-device (%u:%u:%llu)\n",
-			 MAJOR(bio_dev(bio)), MINOR(bio_dev(bio)),
-			 (unsigned long long)bio->bi_iter.bi_sector);
+		pr_alert_ratelimited("Read-error on swap-device (%u:%u:%llu)\n",
+				     MAJOR(bio_dev(bio)), MINOR(bio_dev(bio)),
+				     (unsigned long long)bio->bi_iter.bi_sector);
 		goto out;
 	}
 
_

Patches currently in -mm which might be from georgi.djakov@linaro.org are



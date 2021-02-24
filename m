Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A7BC433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:05:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5625064F3B
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:05:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235136AbhBXUFY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:05:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:56778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235397AbhBXUDy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:03:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D42B64E60;
        Wed, 24 Feb 2021 20:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196982;
        bh=EMCDtPTrNWcTg4yKqS51VPz73gYHPSpsGa5jQGbYHF4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fVOSBhGXC2/zbOjc9Nxl+thAVd02hDPDlzG2HgtbNL3gWH+FEsakmlhD5UMeCEfEx
         1UAWSiwKLKSWu3UbklKqrn2hJzYeUCsYm46udHXHJyTvm8ZXXtsbTQLSfBL/TJ5s2e
         REslQvhJmaspN10o8LNI0dBPRfuHKsX8kN5Oq+3E=
Date:   Wed, 24 Feb 2021 12:03:01 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, georgi.djakov@linaro.org,
        linmiaohe@huawei.com, linux-mm@kvack.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 052/173] mm/page_io: use pr_alert_ratelimited for
 swap read/write errors
Message-ID: <20210224200301._0q-FlWXk%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

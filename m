Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84EC2C43381
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6983964D92
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhBAXKn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Feb 2021 18:10:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:36102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229530AbhBAXKl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Feb 2021 18:10:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C930D64EAA;
        Mon,  1 Feb 2021 23:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612221001;
        bh=ZJSofq9ur+zGYjilvZu3fC1tquLRZHO/IbwlMhs2EAQ=;
        h=Date:From:To:Subject:From;
        b=dN41MXwttjztlsh0IWcs1tZZgDOPXlGtAMlhclQe8r2ocJHNo2qm86EL48AAN68XC
         huSr+Y+fyGvOVf1WqvfILFYmmfaG02/rmcU3tStNVi6RRJ3iY5OlJuEliMt5YbF3C4
         dHJ63WTr4qnxME8eRnFICTeSjhzhH4SU9LaDwrMk=
Date:   Mon, 01 Feb 2021 15:10:00 -0800
From:   akpm@linux-foundation.org
To:     georgi.djakov@linaro.org, minchan@kernel.org,
        mm-commits@vger.kernel.org
Subject:  +
 mm-page_io-use-pr_alert_ratelimited-for-swap-read-write-errors.patch added
 to -mm tree
Message-ID: <20210201231000.5jreFo5JD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_io: use pr_alert_ratelimited for swap read/write errors
has been added to the -mm tree.  Its filename is
     mm-page_io-use-pr_alert_ratelimited-for-swap-read-write-errors.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_io-use-pr_alert_ratelimited-for-swap-read-write-errors.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_io-use-pr_alert_ratelimited-for-swap-read-write-errors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/page_io.c~mm-page_io-use-pr_alert_ratelimited-for-swap-read-write-errors
+++ a/mm/page_io.c
@@ -60,9 +60,9 @@ void end_swap_bio_write(struct bio *bio)
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
@@ -125,9 +125,9 @@ static void end_swap_bio_read(struct bio
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

mm-page_io-use-pr_alert_ratelimited-for-swap-read-write-errors.patch


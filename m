Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13131C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiJCVNB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiJCVLi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BE751A23
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 165CBB815F2
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AFCC433D6;
        Mon,  3 Oct 2022 21:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831230;
        bh=6qZhnMcMdsKc26RWa8ZWI/KJXpFWcJLw+IQj1zN/rK4=;
        h=Date:To:From:Subject:From;
        b=Bmq5eYLoavYcAVD1rXejBbQu7BxsQBqvcycPPryZmY+CLpJfDeNSbMSnhR1Yz6Pyi
         9078yAuiZaqX8LB/WlbwBGZ99+QhHIAZevl77bCluNmWms/fhOQv1Yhxxb6UZB3jHc
         dcSUn/TWm3uSPrL7w50tuqq7EnI7SMjS452dAMb8=
Date:   Mon, 03 Oct 2022 14:07:10 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-keep-comments-within-80-columns-limit.patch removed from -mm tree
Message-Id: <20221003210710.B1AFCC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: keep comments within 80-columns limit
has been removed from the -mm tree.  Its filename was
     zram-keep-comments-within-80-columns-limit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: keep comments within 80-columns limit
Date: Wed, 14 Sep 2022 14:20:33 +0900

Several trivial fixups (that I should have spotted during review).

Link: https://lkml.kernel.org/r/20220914052033.838050-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-keep-comments-within-80-columns-limit
+++ a/drivers/block/zram/zram_drv.c
@@ -329,8 +329,8 @@ static ssize_t idle_store(struct device
 
 	if (!sysfs_streq(buf, "all")) {
 		/*
-		 * If it did not parse as 'all' try to treat it as an integer when
-		 * we have memory tracking enabled.
+		 * If it did not parse as 'all' try to treat it as an integer
+		 * when we have memory tracking enabled.
 		 */
 		u64 age_sec;
 
@@ -345,7 +345,10 @@ static ssize_t idle_store(struct device
 	if (!init_done(zram))
 		goto out_unlock;
 
-	/* A cutoff_time of 0 marks everything as idle, this is the "all" behavior */
+	/*
+	 * A cutoff_time of 0 marks everything as idle, this is the
+	 * "all" behavior.
+	 */
 	mark_idle(zram, cutoff_time);
 	rv = len;
 
@@ -1416,11 +1419,11 @@ compress_again:
 		if (comp_len != PAGE_SIZE)
 			goto compress_again;
 		/*
-		 * If the page is not compressible, you need to acquire the lock and
-		 * execute the code below. The zcomp_stream_get() call is needed to
-		 * disable the cpu hotplug and grab the zstrm buffer back.
-		 * It is necessary that the dereferencing of the zstrm variable below
-		 * occurs correctly.
+		 * If the page is not compressible, you need to acquire the
+		 * lock and execute the code below. The zcomp_stream_get()
+		 * call is needed to disable the cpu hotplug and grab the
+		 * zstrm buffer back. It is necessary that the dereferencing
+		 * of the zstrm variable below occurs correctly.
 		 */
 		zstrm = zcomp_stream_get(zram->comp);
 	}
_

Patches currently in -mm which might be from senozhatsky@chromium.org are



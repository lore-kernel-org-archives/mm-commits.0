Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCEEAC352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbiLAAEv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiLAADc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:03:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197CE8EE43
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2CFFB81D84
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68732C433D7;
        Thu,  1 Dec 2022 00:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852894;
        bh=tAQ189M27GXlGoqQ6focri8iNHN/uGUCF77NSPkkO/M=;
        h=Date:To:From:Subject:From;
        b=sxR88d70Triag494D+jbxR6X77o702pARX6Ay3NsWL2Cqs5gAH5rwe+yjN559IKpb
         /ib9zjkMGGuEj/5drioDtoSDqDJVYxKbN52hI6e658W+ONNX3QlXT6HdGqxdh8SxYH
         tKxuPF/FRAAtZnoi/9jToUA+deQVkHaa3KqHjfQ4=
Date:   Wed, 30 Nov 2022 16:01:33 -0800
To:     mm-commits@vger.kernel.org, suleiman@google.com, nphamcs@gmail.com,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-remove-redundant-checks-from-zram_recompress.patch removed from -mm tree
Message-Id: <20221201000134.68732C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: remove redundant checks from zram_recompress()
has been removed from the -mm tree.  Its filename was
     zram-remove-redundant-checks-from-zram_recompress.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: remove redundant checks from zram_recompress()
Date: Wed, 9 Nov 2022 20:50:43 +0900

Size class index comparison is powerful enough so we can remove object
size comparisons.

Link: https://lkml.kernel.org/r/20221109115047.2921851-10-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-remove-redundant-checks-from-zram_recompress
+++ a/drivers/block/zram/zram_drv.c
@@ -1722,9 +1722,7 @@ static int zram_recompress(struct zram *
 							comp_len_new);
 
 		/* Continue until we make progress */
-		if (comp_len_new >= huge_class_size ||
-		    comp_len_new >= comp_len_old ||
-		    class_index_new >= class_index_old ||
+		if (class_index_new >= class_index_old ||
 		    (threshold && comp_len_new >= threshold)) {
 			zcomp_stream_put(zram->comps[prio]);
 			continue;
@@ -1747,9 +1745,7 @@ static int zram_recompress(struct zram *
 	 * that would save memory, mark the object as incompressible so that
 	 * we will not try to compress it again.
 	 */
-	if (comp_len_new >= huge_class_size ||
-	    comp_len_new >= comp_len_old ||
-	    class_index_new >= class_index_old) {
+	if (class_index_new >= class_index_old) {
 		zram_set_flag(zram, index, ZRAM_INCOMPRESSIBLE);
 		return 0;
 	}
_

Patches currently in -mm which might be from senozhatsky@chromium.org are



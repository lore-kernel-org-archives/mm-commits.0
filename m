Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 757E9C0032E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 20:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234673AbjJYUS4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 16:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjJYUSx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 16:18:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D509123
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 13:18:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282A0C433C8;
        Wed, 25 Oct 2023 20:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698265131;
        bh=bUbzuIm5tdHWQiem/zl4AM7uIsBH9l98JbnbXg27oxU=;
        h=Date:To:From:Subject:From;
        b=yQ2hZKkvcStm5c5hQjHEqsGsM3pog3/6kwr78Yhzm9xYRNCONXs8vmEjo1LV8+mJ4
         JNXme8rIIEdPMWw9rnvqyaGVQI3Ek5jxPFFAPpFQHU8ur7/KwBFIlvMLhV0ehS+7w3
         hUN0PRf92YvexoyxMce95YWDaF8WB9YOlJCtgHCs=
Date:   Wed, 25 Oct 2023 13:18:50 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, ddstreet@ieee.org, cerasuolodomenico@gmail.com,
        nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-export-compression-failure-stats.patch added to mm-unstable branch
Message-Id: <20231025201851.282A0C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: export compression failure stats
has been added to the -mm mm-unstable branch.  Its filename is
     zswap-export-compression-failure-stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zswap-export-compression-failure-stats.patch

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
From: Nhat Pham <nphamcs@gmail.com>
Subject: zswap: export compression failure stats
Date: Tue, 24 Oct 2023 16:45:09 -0700

During a zswap store attempt, the compression algorithm could fail (for
e.g due to the page containing incompressible random data).  This is not
tracked in any of existing zswap counters, making it hard to monitor for
and investigate.  We have run into this problem several times in our
internal investigations on zswap store failures.

This patch adds a dedicated debugfs counter for compression algorithm
failures.

Link: https://lkml.kernel.org/r/20231024234509.2680539-1-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/zswap.c~zswap-export-compression-failure-stats
+++ a/mm/zswap.c
@@ -62,6 +62,8 @@ static u64 zswap_pool_limit_hit;
 static u64 zswap_written_back_pages;
 /* Store failed due to a reclaim failure after pool limit was reached */
 static u64 zswap_reject_reclaim_fail;
+/* Store failed due to compression algorithm failure */
+static u64 zswap_reject_compress_fail;
 /* Compressed page was too big for the allocator to (optimally) store */
 static u64 zswap_reject_compress_poor;
 /* Store failed because underlying allocator could not get memory */
@@ -1317,8 +1319,10 @@ bool zswap_store(struct folio *folio)
 	ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
 	dlen = acomp_ctx->req->dlen;
 
-	if (ret)
+	if (ret) {
+		zswap_reject_compress_fail++;
 		goto put_dstmem;
+	}
 
 	/* store */
 	zpool = zswap_find_zpool(entry);
@@ -1558,6 +1562,8 @@ static int zswap_debugfs_init(void)
 			   zswap_debugfs_root, &zswap_reject_alloc_fail);
 	debugfs_create_u64("reject_kmemcache_fail", 0444,
 			   zswap_debugfs_root, &zswap_reject_kmemcache_fail);
+	debugfs_create_u64("reject_compress_fail", 0444,
+			   zswap_debugfs_root, &zswap_reject_compress_fail);
 	debugfs_create_u64("reject_compress_poor", 0444,
 			   zswap_debugfs_root, &zswap_reject_compress_poor);
 	debugfs_create_u64("written_back_pages", 0444,
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zswap-export-compression-failure-stats.patch


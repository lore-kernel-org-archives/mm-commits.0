Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB95C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  9 Mar 2022 22:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234234AbiCIWI2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Mar 2022 17:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233630AbiCIWI1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2022 17:08:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8464B1FD
        for <mm-commits@vger.kernel.org>; Wed,  9 Mar 2022 14:07:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B20B61B79
        for <mm-commits@vger.kernel.org>; Wed,  9 Mar 2022 22:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37BEC340E8;
        Wed,  9 Mar 2022 22:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646863646;
        bh=92nlfGAInyCDRsd1P/fgBVS+3UfyxOB4uaQDF82pPlU=;
        h=Date:To:From:Subject:From;
        b=Zy1rzDdu1u4aChhE2Ewq/JUoFaK7/VGxow5K3BUBw/EnPA6cFo/5R93LDcNnl1HQb
         Xz4WrRYni3SQUgIG8OdEOfSLrQVcIregY1K3rIMo9E7bJ1OrEsOGp3Pl64tBXGDyml
         ANiytLPw1MeeH3qa7c+XPTH50gsksVBLJR4OGGug=
Date:   Wed, 09 Mar 2022 14:07:25 -0800
To:     mm-commits@vger.kernel.org, mtosatti@redhat.com,
        joaodias@google.com, cgoldswo@codeaurora.org, minchan@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fs-fix-lru_cache_disabled-race-in-bh_lru.patch added to -mm tree
Message-Id: <20220309220725.F37BEC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fs: fix lru_cache_disabled race in bh_lru
has been added to the -mm tree.  Its filename is
     mm-fs-fix-lru_cache_disabled-race-in-bh_lru.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fs-fix-lru_cache_disabled-race-in-bh_lru.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fs-fix-lru_cache_disabled-race-in-bh_lru.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: fs: fix lru_cache_disabled race in bh_lru

Check lru_cache_disabled under bh_lru_lock.  Otherwise, it could introduce
race below and it fails to migrate pages containing buffer_head.

   CPU 0					CPU 1

bh_lru_install
                                       lru_cache_disable
  lru_cache_disabled = false
                                       atomic_inc(&lru_disable_count);
				       invalidate_bh_lrus_cpu of CPU 0
				       bh_lru_lock
				       __invalidate_bh_lrus
				       bh_lru_unlock
  bh_lru_lock
  install the bh
  bh_lru_unlock

Link: https://lkml.kernel.org/r/20220308180709.2017638-1-minchan@kernel.org
Fixes: 8cc621d2f45d ("mm: fs: invalidate BH LRU during page migration")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Chris Goldsworthy <cgoldswo@codeaurora.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: John Dias <joaodias@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/buffer.c~mm-fs-fix-lru_cache_disabled-race-in-bh_lru
+++ a/fs/buffer.c
@@ -1235,16 +1235,18 @@ static void bh_lru_install(struct buffer
 	int i;
 
 	check_irqs_on();
+	bh_lru_lock();
+
 	/*
 	 * the refcount of buffer_head in bh_lru prevents dropping the
 	 * attached page(i.e., try_to_free_buffers) so it could cause
 	 * failing page migration.
 	 * Skip putting upcoming bh into bh_lru until migration is done.
 	 */
-	if (lru_cache_disabled())
+	if (lru_cache_disabled()) {
+		bh_lru_unlock();
 		return;
-
-	bh_lru_lock();
+	}
 
 	b = this_cpu_ptr(&bh_lrus);
 	for (i = 0; i < BH_LRU_SIZE; i++) {
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-fs-fix-lru_cache_disabled-race-in-bh_lru.patch


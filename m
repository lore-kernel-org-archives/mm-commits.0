Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA560C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92C2D2080C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266301;
	bh=4uMPTZS3uBg9gLMtJQnM1XZSb75yC4DIxOIacSDwgsk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=0ANRXeSGLAo8+v0SOJ/GkL+5C3cBhOL/2VKaiezNMidxQZ3AHNcLS3Rcm7owkQtdV
	 Src35t3v0+SvKnt8lfzgB9e6ur27ee7wEryF8e0tg3kVaDQFzweLg69QAD27frA0TQ
	 vYJJZBdLRJxzLrNutG2KilJdOEnjhvFkEBYx6ByE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbgHLVFB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:05:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726709AbgHLVFB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:05:01 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87025207F7;
        Wed, 12 Aug 2020 21:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266300;
        bh=4uMPTZS3uBg9gLMtJQnM1XZSb75yC4DIxOIacSDwgsk=;
        h=Date:From:To:Subject:From;
        b=vAtWcrt2gEnjTMpYcjuF99BD9N1qSBArPK9Jsv4sQzdd1/0zwdkI01WAviP4hJrcY
         nwmxOXaWmfVjDaxtpruNbLUHq2WGtmT/wD0zXmbGvjotUuMjkvXWYxs5eo4zrlDYRa
         Gff+jOM4z34wZLFn/nA4zctrOYeaDZCUk3OW0OVY=
Date:   Wed, 12 Aug 2020 14:05:00 -0700
From:   akpm@linux-foundation.org
To:     hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org
Subject:  [merged] fat-fix-fat_ra_init-for-data-clusters-==-0.patch
 removed from -mm tree
Message-ID: <20200812210500.FCWNK1BK0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fat: fix fat_ra_init() for data clusters == 0
has been removed from the -mm tree.  Its filename was
     fat-fix-fat_ra_init-for-data-clusters-==-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: fat: fix fat_ra_init() for data clusters == 0

If data clusters == 0, fat_ra_init() calls the ->ent_blocknr() for the
cluster beyond ->max_clusters.

This checks the limit before initialization to suppress the warning.

Link: http://lkml.kernel.org/r/87mu462sv4.fsf@mail.parknet.co.jp
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Reported-by: syzbot+756199124937b31a9b7e@syzkaller.appspotmail.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fatent.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/fat/fatent.c~fat-fix-fat_ra_init-for-data-clusters-==-0
+++ a/fs/fat/fatent.c
@@ -657,6 +657,9 @@ static void fat_ra_init(struct super_blo
 	unsigned long ra_pages = sb->s_bdi->ra_pages;
 	unsigned int reada_blocks;
 
+	if (fatent->entry >= ent_limit)
+		return;
+
 	if (ra_pages > sb->s_bdi->io_pages)
 		ra_pages = rounddown(ra_pages, sb->s_bdi->io_pages);
 	reada_blocks = ra_pages << (PAGE_SHIFT - sb->s_blocksize_bits + 1);
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are



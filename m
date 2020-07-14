Return-Path: <SRS0=97KN=AZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FD9AC433E3
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E43D21941
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594690818;
	bh=u/qLUKXlbTl/qS/tE9WSeqiCY8Z78WU0i00n91vmWL0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=oLFBec3lkthR7yoZu6qgNuRGDzh49cjSRpsE2ae8wymmo+UIbg+KDmwUWfl5K0rlN
	 1A7DF5OYRG9zYlpiYTV2pWHSfDhVDR4rgwvcgYjawTNKgKzDWSfzISyaHJR3rfAn+n
	 sm7dI3Mg1i0O0Zw/XD2fYV4mMSgiMQr/4mUPW0Mg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgGNBkS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:40:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbgGNBkS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jul 2020 21:40:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 856B320578;
        Tue, 14 Jul 2020 01:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594690817;
        bh=u/qLUKXlbTl/qS/tE9WSeqiCY8Z78WU0i00n91vmWL0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LQ4IZtfeLZlEK8z+LCkQrKiIs/UySzRVyOZ6b8PZnUs1lUZjhg8vKHIT2J/tQBX9m
         enWqk8KUm/O3H7CCwdDYm+RdbgWie2ruNxZk8wKexfFPERSAYOU9MF17B/2ynNX5TG
         y4N99K6jjhJsH7Z1ARvqb3F3EXksSWH/YnYdoiqI=
Date:   Mon, 13 Jul 2020 18:40:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org
Subject:  + fat-fix-fat_ra_init-for-data-clusters-==-0.patch added
 to -mm tree
Message-ID: <20200714014017.WYEX6P6IO%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fat: fix fat_ra_init() for data clusters == 0
has been added to the -mm tree.  Its filename is
     fat-fix-fat_ra_init-for-data-clusters-==-0.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fat-fix-fat_ra_init-for-data-clusters-%3D%3D-0.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fat-fix-fat_ra_init-for-data-clusters-%3D%3D-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fat-fix-fat_ra_init-for-data-clusters-==-0.patch


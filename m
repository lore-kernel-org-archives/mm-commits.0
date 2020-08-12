Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C60BCC433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7641206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196163;
	bh=74NmFiFkDjo3W3PNUmjT3GwlYVTUsyl31JK1/8vnyAE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=C6DKeiIKbMrDYcIVxmEIoAenQxy3x6yHMM6TFEK1N7L5eyf0NgQj+KwyWWdlAvMAO
	 DDDmKALfOuhv8XDFGNcpqYW+UgONN6qe/mbnHd5I4fEIudQpkHiPYdIAmqsgPV/bSz
	 F0Oo1UWTmZ2u1WCVGmx/9tX9zy4/M5QNeb5TtXwE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgHLBgD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:36:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBgC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:36:02 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D04920678;
        Wed, 12 Aug 2020 01:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196162;
        bh=74NmFiFkDjo3W3PNUmjT3GwlYVTUsyl31JK1/8vnyAE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=imqPfPuUnXBZ5n89IIdu0h/RlhHjyiQXU/VBXF8YGeXWueDb2BaI9AXk6HGr6oy10
         6DDZ26At3UQNG2aIUpp4+UkREEtXKsB4olqZKRePJu2BYAWLwoPZoJ6slCfiO7brkC
         33FlqwSzFprL+YwzA9yGsEjDpf8i6MBmzPd0jFz4=
Date:   Tue, 11 Aug 2020 18:36:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hirofumi@mail.parknet.co.jp,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 110/165] fat: fix fat_ra_init() for data clusters
 == 0
Message-ID: <20200812013601.LbIXUhywg%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

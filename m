Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46D42C0032E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjJYXsE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjJYXrx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:47:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F377C181
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:47:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5DDC433CA;
        Wed, 25 Oct 2023 23:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277671;
        bh=GkS0vuljp/vKFZqgKAROwUg7beSV6RQD9Y3xc1AJM5k=;
        h=Date:To:From:Subject:From;
        b=GtXP4vpAIGr2BU/BB+nRxoz0B3OWU88th20VcEGsh4FInuVaW3jnZAY49ngF/nFkC
         9Y1tDPxMP65ACJLlS60vRnQn5Y+94vNY2ZILvivtWex+L3xelmeHdYwLqyrDqXzBvK
         zqRQUDyDUS7kJMwYKMp56+sgV/LsYAs/G0T0lw6E=
Date:   Wed, 25 Oct 2023 16:47:51 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mpage-convert-map_buffer_to_folio-to-folio_create_empty_buffers.patch removed from -mm tree
Message-Id: <20231025234751.BC5DDC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mpage: convert map_buffer_to_folio() to folio_create_empty_buffers()
has been removed from the -mm tree.  Its filename was
     mpage-convert-map_buffer_to_folio-to-folio_create_empty_buffers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mpage: convert map_buffer_to_folio() to folio_create_empty_buffers()
Date: Mon, 16 Oct 2023 21:10:50 +0100

Saves a folio->page->folio conversion.

Link: https://lkml.kernel.org/r/20231016201114.1928083-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/mpage.c~mpage-convert-map_buffer_to_folio-to-folio_create_empty_buffers
+++ a/fs/mpage.c
@@ -119,8 +119,7 @@ static void map_buffer_to_folio(struct f
 			folio_mark_uptodate(folio);
 			return;
 		}
-		create_empty_buffers(&folio->page, i_blocksize(inode), 0);
-		head = folio_buffers(folio);
+		head = folio_create_empty_buffers(folio, i_blocksize(inode), 0);
 	}
 
 	page_bh = head;
_

Patches currently in -mm which might be from willy@infradead.org are



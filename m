Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D10EC25B71
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbjJYXsY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjJYXsG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF68181
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:03 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5EDC433C7;
        Wed, 25 Oct 2023 23:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277682;
        bh=KPjnvIFE/TIJUB0xOnMS0Z1PRhT6KXf21DTk9ov4bHk=;
        h=Date:To:From:Subject:From;
        b=VH2PM+cwM1pIfd7xQtAD4x1qQ/Ob/NQ46VE4r9/SAujrPjJk6+crOP0Y7ZMiEtR3p
         TZN/k+C1aiG7bQQmG41K70ohjrpFdZb4OOQ9/afRKwXH17fJ21JROYgNFtFtjcdgQV
         o/DWNfHL7fSHdPBKEBx8YhAfsJ6AnDeEYesmwY2g=
Date:   Wed, 25 Oct 2023 16:48:02 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nilfs2-convert-nilfs_lookup_dirty_data_buffers-to-use-folio_create_empty_buffers.patch removed from -mm tree
Message-Id: <20231025234802.CB5EDC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: convert nilfs_lookup_dirty_data_buffers to use folio_create_empty_buffers
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_lookup_dirty_data_buffers-to-use-folio_create_empty_buffers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert nilfs_lookup_dirty_data_buffers to use folio_create_empty_buffers
Date: Mon, 16 Oct 2023 21:11:03 +0100

This function was already using a folio, so this update to the new API
removes a single folio->page->folio conversion.

Link: https://lkml.kernel.org/r/20231016201114.1928083-17-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/nilfs2/segment.c~nilfs2-convert-nilfs_lookup_dirty_data_buffers-to-use-folio_create_empty_buffers
+++ a/fs/nilfs2/segment.c
@@ -731,10 +731,9 @@ static size_t nilfs_lookup_dirty_data_bu
 			continue;
 		}
 		head = folio_buffers(folio);
-		if (!head) {
-			create_empty_buffers(&folio->page, i_blocksize(inode), 0);
-			head = folio_buffers(folio);
-		}
+		if (!head)
+			head = folio_create_empty_buffers(folio,
+					i_blocksize(inode), 0);
 		folio_unlock(folio);
 
 		bh = head;
_

Patches currently in -mm which might be from willy@infradead.org are



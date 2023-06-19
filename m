Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0590CEB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjFSX0t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjFSXYw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:24:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CD419BF
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56F3F60FC5
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0B2C433C8;
        Mon, 19 Jun 2023 23:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216993;
        bh=PPuBJBNPDNIYOznZ+BF2xBD6EznHgggK/Y9bmjaZcE8=;
        h=Date:To:From:Subject:From;
        b=cDk9rjMVpsTS5+1fBYmCQyj22z91Sz5crKL9WfAU/Jf3Mkfur0EPuT1r7kQx2l/dy
         H8oeHqMtXi5hXFrckfRZ4sEkDR+BkLPDM8qBVVco+ikrNVcvjBZxYTwKXGV+7dKdbH
         u3DELBGv/9Y09fzLeKLumZkwlqECrChWpZMssRPw=
Date:   Mon, 19 Jun 2023 16:23:13 -0700
To:     mm-commits@vger.kernel.org, rpeterso@redhat.com, mcgrof@kernel.org,
        hare@suse.com, agruenba@redhat.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-convert-link_dev_buffers-to-take-a-folio.patch removed from -mm tree
Message-Id: <20230619232313.AD0B2C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: buffer: convert link_dev_buffers to take a folio
has been removed from the -mm tree.  Its filename was
     buffer-convert-link_dev_buffers-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: convert link_dev_buffers to take a folio
Date: Mon, 12 Jun 2023 22:01:39 +0100

Its one caller already has a folio, so switch it to use the folio API. 
Removes a hidden call to compound_head().

Link: https://lkml.kernel.org/r/20230612210141.730128-13-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Bob Peterson <rpeterso@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/buffer.c~buffer-convert-link_dev_buffers-to-take-a-folio
+++ a/fs/buffer.c
@@ -907,8 +907,8 @@ struct buffer_head *alloc_page_buffers(s
 }
 EXPORT_SYMBOL_GPL(alloc_page_buffers);
 
-static inline void
-link_dev_buffers(struct page *page, struct buffer_head *head)
+static inline void link_dev_buffers(struct folio *folio,
+		struct buffer_head *head)
 {
 	struct buffer_head *bh, *tail;
 
@@ -918,7 +918,7 @@ link_dev_buffers(struct page *page, stru
 		bh = bh->b_this_page;
 	} while (bh);
 	tail->b_this_page = head;
-	attach_page_private(page, head);
+	folio_attach_private(folio, head);
 }
 
 static sector_t blkdev_max_block(struct block_device *bdev, unsigned int size)
@@ -1013,7 +1013,7 @@ grow_dev_page(struct block_device *bdev,
 	 * run under the folio lock.
 	 */
 	spin_lock(&inode->i_mapping->private_lock);
-	link_dev_buffers(&folio->page, bh);
+	link_dev_buffers(folio, bh);
 	end_block = folio_init_buffers(folio, bdev,
 			(sector_t)index << sizebits, size);
 	spin_unlock(&inode->i_mapping->private_lock);
_

Patches currently in -mm which might be from willy@infradead.org are



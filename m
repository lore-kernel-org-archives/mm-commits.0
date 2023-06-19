Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC848EB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjFSX0v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjFSXZA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:25:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09211BC0
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EE6D60FB7
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B4EC433C0;
        Mon, 19 Jun 2023 23:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216994;
        bh=FuZ6oFTx3KYJ27otHilyrkt/cGOJVsYkRfVShgvwIPU=;
        h=Date:To:From:Subject:From;
        b=dcnw/cpJznuSFAcq0XHoTxD9tMP3MYKRt1EsiQiJ5QsQe8vOp4OhrD9fpE435V6WD
         q0iNamvRaK7YiD6M2btjJ6plOstlHWBF+N3WuO484usaP1JI4ubJETb2YgFCAchNor
         Kr2FIftFZYldbYmj4JnKYqTyEyoDtQFh0MDcLXFs=
Date:   Mon, 19 Jun 2023 16:23:14 -0700
To:     mm-commits@vger.kernel.org, rpeterso@redhat.com, mcgrof@kernel.org,
        hare@suse.com, agruenba@redhat.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-use-a-folio-in-__find_get_block_slow.patch removed from -mm tree
Message-Id: <20230619232314.A8B4EC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: buffer: use a folio in __find_get_block_slow()
has been removed from the -mm tree.  Its filename was
     buffer-use-a-folio-in-__find_get_block_slow.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: use a folio in __find_get_block_slow()
Date: Mon, 12 Jun 2023 22:01:40 +0100

Saves a call to compound_head() and may be needed to support block size >
PAGE_SIZE.

Link: https://lkml.kernel.org/r/20230612210141.730128-14-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Bob Peterson <rpeterso@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/buffer.c~buffer-use-a-folio-in-__find_get_block_slow
+++ a/fs/buffer.c
@@ -195,19 +195,19 @@ __find_get_block_slow(struct block_devic
 	pgoff_t index;
 	struct buffer_head *bh;
 	struct buffer_head *head;
-	struct page *page;
+	struct folio *folio;
 	int all_mapped = 1;
 	static DEFINE_RATELIMIT_STATE(last_warned, HZ, 1);
 
 	index = block >> (PAGE_SHIFT - bd_inode->i_blkbits);
-	page = find_get_page_flags(bd_mapping, index, FGP_ACCESSED);
-	if (!page)
+	folio = __filemap_get_folio(bd_mapping, index, FGP_ACCESSED, 0);
+	if (IS_ERR(folio))
 		goto out;
 
 	spin_lock(&bd_mapping->private_lock);
-	if (!page_has_buffers(page))
+	head = folio_buffers(folio);
+	if (!head)
 		goto out_unlock;
-	head = page_buffers(page);
 	bh = head;
 	do {
 		if (!buffer_mapped(bh))
@@ -237,7 +237,7 @@ __find_get_block_slow(struct block_devic
 	}
 out_unlock:
 	spin_unlock(&bd_mapping->private_lock);
-	put_page(page);
+	folio_put(folio);
 out:
 	return ret;
 }
_

Patches currently in -mm which might be from willy@infradead.org are



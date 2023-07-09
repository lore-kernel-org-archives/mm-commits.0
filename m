Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0392EB64DC
	for <mm-commits@archiver.kernel.org>; Sun,  9 Jul 2023 00:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjGIAaY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 Jul 2023 20:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjGIAaW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 Jul 2023 20:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38A7102
        for <mm-commits@vger.kernel.org>; Sat,  8 Jul 2023 17:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6040B60B65
        for <mm-commits@vger.kernel.org>; Sun,  9 Jul 2023 00:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58E5C433C7;
        Sun,  9 Jul 2023 00:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688862620;
        bh=zLysZBvj5+T0u0NeHPDZc0NEtfRBnBBh6V1aeKmiuAk=;
        h=Date:To:From:Subject:From;
        b=C0ia0OPPb0wDNCCNX5m31fHr77DhftbeifBoexJYzwn4ijpDMNRHL65VqWfDqWAmE
         mCd+MyjaSu4+6eZGFLkJz/hbiNufThZaKPSBWcN+45wV6lM6grDESIJ5xgi7crkxZh
         v54mJ68WOcDl0cS0AaiyaoB5BL8QbldTs6SPvUiI=
Date:   Sat, 08 Jul 2023 17:30:20 -0700
To:     mm-commits@vger.kernel.org, phillip@squashfs.org.uk, hch@lst.de,
        vincent.whitchurch@axis.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] squashfs-fix-cache-race-with-migration.patch removed from -mm tree
Message-Id: <20230709003020.B58E5C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: squashfs: fix cache race with migration
has been removed from the -mm tree.  Its filename was
     squashfs-fix-cache-race-with-migration.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: squashfs: fix cache race with migration
Date: Thu, 29 Jun 2023 16:17:57 +0200

Migration replaces the page in the mapping before copying the contents and
the flags over from the old page, so check that the page in the page cache
is really up to date before using it.  Without this, stressing squashfs
reads with parallel compaction sometimes results in squashfs reporting
data corruption.

Link: https://lkml.kernel.org/r/20230629-squashfs-cache-migration-v1-1-d50ebe55099d@axis.com
Fixes: e994f5b677ee ("squashfs: cache partial compressed blocks")
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/block.c |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

--- a/fs/squashfs/block.c~squashfs-fix-cache-race-with-migration
+++ a/fs/squashfs/block.c
@@ -166,6 +166,26 @@ static int squashfs_bio_read_cached(stru
 	return 0;
 }
 
+static struct page *squashfs_get_cache_page(struct address_space *mapping,
+					    pgoff_t index)
+{
+	struct page *page;
+
+	if (!mapping)
+		return NULL;
+
+	page = find_get_page(mapping, index);
+	if (!page)
+		return NULL;
+
+	if (!PageUptodate(page)) {
+		put_page(page);
+		return NULL;
+	}
+
+	return page;
+}
+
 static int squashfs_bio_read(struct super_block *sb, u64 index, int length,
 			     struct bio **biop, int *block_offset)
 {
@@ -190,11 +210,10 @@ static int squashfs_bio_read(struct supe
 	for (i = 0; i < page_count; ++i) {
 		unsigned int len =
 			min_t(unsigned int, PAGE_SIZE - offset, total_len);
-		struct page *page = NULL;
+		pgoff_t index = (read_start >> PAGE_SHIFT) + i;
+		struct page *page;
 
-		if (cache_mapping)
-			page = find_get_page(cache_mapping,
-					     (read_start >> PAGE_SHIFT) + i);
+		page = squashfs_get_cache_page(cache_mapping, index);
 		if (!page)
 			page = alloc_page(GFP_NOIO);
 
_

Patches currently in -mm which might be from vincent.whitchurch@axis.com are

signal-print-comm-and-exe-name-on-fatal-signals.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DDF0C04A94
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbjHKW6a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236500AbjHKW63 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:58:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1304F2D55
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:58:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 992CA64E13
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1B0C433C8;
        Fri, 11 Aug 2023 22:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794708;
        bh=/N/UR6pPt4gii+4p/asdCTw5kSIaGANusT28QuqIJM4=;
        h=Date:To:From:Subject:From;
        b=lIocd80txIqR0JcNRKS/DEX0jZhkM6tpsWdsCPKXqR0d0rwq6RD1hpC1Vxn2uHY0p
         Se4/hL+O7EgVF1hefxQ3nx6rLgKtoHSMvcFOqS7lEfysFyBBSCQPPdtSrvJTwC2gcI
         TaPaAFsZUoqsbzJVnVA61i08BdN5rzo2suMQVqUA=
Date:   Fri, 11 Aug 2023 15:58:27 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        hughd@google.com, hch@lst.de, hch@infradead.org,
        adilger.kernel@dilger.ca, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-increase-usage-of-folio_next_index-helper.patch removed from -mm tree
Message-Id: <20230811225827.EF1B0C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: increase usage of folio_next_index() helper
has been removed from the -mm tree.  Its filename was
     mm-increase-usage-of-folio_next_index-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm: increase usage of folio_next_index() helper
Date: Tue, 27 Jun 2023 10:43:49 -0700

Simplify code pattern of 'folio->index + folio_nr_pages(folio)' by using
the existing helper folio_next_index().

Link: https://lkml.kernel.org/r/20230627174349.491803-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c |    4 ++--
 mm/filemap.c    |    8 ++++----
 mm/memory.c     |    2 +-
 mm/shmem.c      |    2 +-
 mm/truncate.c   |    2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

--- a/fs/ext4/inode.c~mm-increase-usage-of-folio_next_index-helper
+++ a/fs/ext4/inode.c
@@ -1569,7 +1569,7 @@ static void mpage_release_unused_pages(s
 
 			if (folio->index < mpd->first_page)
 				continue;
-			if (folio->index + folio_nr_pages(folio) - 1 > end)
+			if (folio_next_index(folio) - 1 > end)
 				continue;
 			BUG_ON(!folio_test_locked(folio));
 			BUG_ON(folio_test_writeback(folio));
@@ -2455,7 +2455,7 @@ static int mpage_prepare_extent_to_map(s
 
 			if (mpd->map.m_len == 0)
 				mpd->first_page = folio->index;
-			mpd->next_page = folio->index + folio_nr_pages(folio);
+			mpd->next_page = folio_next_index(folio);
 			/*
 			 * Writeout when we cannot modify metadata is simple.
 			 * Just submit the page. For data=journal mode we
--- a/mm/filemap.c~mm-increase-usage-of-folio_next_index-helper
+++ a/mm/filemap.c
@@ -2075,7 +2075,7 @@ unsigned find_lock_entries(struct addres
 		if (!xa_is_value(folio)) {
 			if (folio->index < *start)
 				goto put;
-			if (folio->index + folio_nr_pages(folio) - 1 > end)
+			if (folio_next_index(folio) - 1 > end)
 				goto put;
 			if (!folio_trylock(folio))
 				goto put;
@@ -2174,7 +2174,7 @@ bool folio_more_pages(struct folio *foli
 		return false;
 	if (index >= max)
 		return false;
-	return index < folio->index + folio_nr_pages(folio) - 1;
+	return index < folio_next_index(folio) - 1;
 }
 
 /**
@@ -2242,7 +2242,7 @@ update_start:
 		if (folio_test_hugetlb(folio))
 			*start = folio->index + 1;
 		else
-			*start = folio->index + folio_nr_pages(folio);
+			*start = folio_next_index(folio);
 	}
 out:
 	rcu_read_unlock();
@@ -2359,7 +2359,7 @@ static void filemap_get_read_batch(struc
 			break;
 		if (folio_test_readahead(folio))
 			break;
-		xas_advance(&xas, folio->index + folio_nr_pages(folio) - 1);
+		xas_advance(&xas, folio_next_index(folio) - 1);
 		continue;
 put_folio:
 		folio_put(folio);
--- a/mm/memory.c~mm-increase-usage-of-folio_next_index-helper
+++ a/mm/memory.c
@@ -3495,7 +3495,7 @@ void unmap_mapping_folio(struct folio *f
 	VM_BUG_ON(!folio_test_locked(folio));
 
 	first_index = folio->index;
-	last_index = folio->index + folio_nr_pages(folio) - 1;
+	last_index = folio_next_index(folio) - 1;
 
 	details.even_cows = false;
 	details.single_folio = folio;
--- a/mm/shmem.c~mm-increase-usage-of-folio_next_index-helper
+++ a/mm/shmem.c
@@ -970,7 +970,7 @@ static void shmem_undo_range(struct inod
 		same_folio = lend < folio_pos(folio) + folio_size(folio);
 		folio_mark_dirty(folio);
 		if (!truncate_inode_partial_folio(folio, lstart, lend)) {
-			start = folio->index + folio_nr_pages(folio);
+			start = folio_next_index(folio);
 			if (same_folio)
 				end = folio->index;
 		}
--- a/mm/truncate.c~mm-increase-usage-of-folio_next_index-helper
+++ a/mm/truncate.c
@@ -378,7 +378,7 @@ void truncate_inode_pages_range(struct a
 	if (!IS_ERR(folio)) {
 		same_folio = lend < folio_pos(folio) + folio_size(folio);
 		if (!truncate_inode_partial_folio(folio, lstart, lend)) {
-			start = folio->index + folio_nr_pages(folio);
+			start = folio_next_index(folio);
 			if (same_folio)
 				end = folio->index;
 		}
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are



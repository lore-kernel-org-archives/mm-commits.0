Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23417EB64D9
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jun 2023 19:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbjF0TTy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jun 2023 15:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbjF0TTw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 27 Jun 2023 15:19:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD03E6C
        for <mm-commits@vger.kernel.org>; Tue, 27 Jun 2023 12:19:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 160EA611FB
        for <mm-commits@vger.kernel.org>; Tue, 27 Jun 2023 19:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653F6C433C8;
        Tue, 27 Jun 2023 19:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687893590;
        bh=yb0XOx26M+veFg6gVLZOV5Q2Y5y4s7f3cyyfADviJXQ=;
        h=Date:To:From:Subject:From;
        b=Y6Z/mgnmLzOBiM95oKN7TW2TZC42GZiiyaGdTHs0dHEm9kn620/Tm89GgkaCoP0lF
         rb/k+FmTNhledeeYrIRxkirvjMHqPKwQtfrmfg89TnE4qCJRG7cN2dqW90i4Sp5ikV
         pbQmPlfLd1y/wmBGcXs3FgDH6aByrINqJwxsCM4o=
Date:   Tue, 27 Jun 2023 12:19:49 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        hughd@google.com, hch@infradead.org, adilger.kernel@dilger.ca,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-increase-usage-of-folio_next_index-helper.patch added to mm-unstable branch
Message-Id: <20230627191950.653F6C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: increase usage of folio_next_index() helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-increase-usage-of-folio_next_index-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-increase-usage-of-folio_next_index-helper.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm: increase usage of folio_next_index() helper
Date: Tue, 27 Jun 2023 10:43:49 -0700

Simplify code pattern of 'folio->index + folio_nr_pages(folio)' by using
the existing helper folio_next_index().

Link: https://lkml.kernel.org/r/20230627174349.491803-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
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
@@ -1583,7 +1583,7 @@ static void mpage_release_unused_pages(s
 
 			if (folio->index < mpd->first_page)
 				continue;
-			if (folio->index + folio_nr_pages(folio) - 1 > end)
+			if (folio_next_index(folio) - 1 > end)
 				continue;
 			BUG_ON(!folio_test_locked(folio));
 			BUG_ON(folio_test_writeback(folio));
@@ -2481,7 +2481,7 @@ static int mpage_prepare_extent_to_map(s
 
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
@@ -3497,7 +3497,7 @@ void unmap_mapping_folio(struct folio *f
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

mm-increase-usage-of-folio_next_index-helper.patch


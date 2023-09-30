Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AECBE77351
	for <mm-commits@archiver.kernel.org>; Sat, 30 Sep 2023 00:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbjI3AV1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 20:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233945AbjI3AVZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 20:21:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 418631A8
        for <mm-commits@vger.kernel.org>; Fri, 29 Sep 2023 17:21:23 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41B8C433CB;
        Sat, 30 Sep 2023 00:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696033282;
        bh=vw4n+/zz7PoyW739bexXS5gYjz2IdwMz0x0pUFFpKE8=;
        h=Date:To:From:Subject:From;
        b=TmwRT6SaDrinpY1OHFTEdxjllRhyIi5/vzlp8tG6knljByctuUKrX1FMhStBz3fjo
         Vepe9ogOivfUhh7RExw1KRJThxYwoGl4YNJdjWx+6098Jakxt5cMpXDH/e33sxr5OB
         ATU+BH1KsbQxcmF5hQObT3d2is5kbGYY0fHruKWg=
Date:   Fri, 29 Sep 2023 17:21:22 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, nphamcs@gmail.com, hannes@cmpxchg.org,
        ddstreet@ieee.org, cerasuolodomenico@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-zswap-fix-potential-memory-corruption-on-duplicate-store.patch removed from -mm tree
Message-Id: <20230930002122.C41B8C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: zswap: fix potential memory corruption on duplicate store
has been removed from the -mm tree.  Its filename was
     mm-zswap-fix-potential-memory-corruption-on-duplicate-store.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Subject: mm: zswap: fix potential memory corruption on duplicate store
Date: Fri, 22 Sep 2023 19:22:11 +0200

While stress-testing zswap a memory corruption was happening when writing
back pages.  __frontswap_store used to check for duplicate entries before
attempting to store a page in zswap, this was because if the store fails
the old entry isn't removed from the tree.  This change removes duplicate
entries in zswap_store before the actual attempt.

[cerasuolodomenico@gmail.com: add a warning and a comment, per Johannes]
  Link: https://lkml.kernel.org/r/20230925130002.1929369-1-cerasuolodomenico@gmail.com
Link: https://lkml.kernel.org/r/20230922172211.1704917-1-cerasuolodomenico@gmail.com
Fixes: 42c06a0e8ebe ("mm: kill frontswap")
Signed-off-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/mm/zswap.c~mm-zswap-fix-potential-memory-corruption-on-duplicate-store
+++ a/mm/zswap.c
@@ -1219,6 +1219,19 @@ bool zswap_store(struct folio *folio)
 		return false;
 
 	/*
+	 * If this is a duplicate, it must be removed before attempting to store
+	 * it, otherwise, if the store fails the old page won't be removed from
+	 * the tree, and it might be written back overriding the new data.
+	 */
+	spin_lock(&tree->lock);
+	dupentry = zswap_rb_search(&tree->rbroot, offset);
+	if (dupentry) {
+		zswap_duplicate_entry++;
+		zswap_invalidate_entry(tree, dupentry);
+	}
+	spin_unlock(&tree->lock);
+
+	/*
 	 * XXX: zswap reclaim does not work with cgroups yet. Without a
 	 * cgroup-aware entry LRU, we will push out entries system-wide based on
 	 * local cgroup limits.
@@ -1333,7 +1346,14 @@ insert_entry:
 
 	/* map */
 	spin_lock(&tree->lock);
+	/*
+	 * A duplicate entry should have been removed at the beginning of this
+	 * function. Since the swap entry should be pinned, if a duplicate is
+	 * found again here it means that something went wrong in the swap
+	 * cache.
+	 */
 	while (zswap_rb_insert(&tree->rbroot, entry, &dupentry) == -EEXIST) {
+		WARN_ON(1);
 		zswap_duplicate_entry++;
 		zswap_invalidate_entry(tree, dupentry);
 	}
_

Patches currently in -mm which might be from cerasuolodomenico@gmail.com are

zswap-make-shrinking-memcg-aware.patch


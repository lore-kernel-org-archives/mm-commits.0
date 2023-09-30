Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 855BAE7734B
	for <mm-commits@archiver.kernel.org>; Sat, 30 Sep 2023 00:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjI3ASz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 20:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjI3ASz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 20:18:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90433AC
        for <mm-commits@vger.kernel.org>; Fri, 29 Sep 2023 17:18:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05406C433C8;
        Sat, 30 Sep 2023 00:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696033133;
        bh=YHQWF1AhoGPXkOul+YsRtuR+jHhiTT21LrA2dPlh6Ok=;
        h=Date:To:From:Subject:From;
        b=LuOlf/F55PTYQ9I2HglDkLKsJBEukztqcklp9tgidKLOheUuCRZTuzj/GtIu2wciY
         g/LIT6chHO5FgzAFm9+QLZlS5K4RUcdvodO22LiNLprHsAeLdFZA08LEqwa0vKDSUR
         wPTf3YkCe8kU8L9z+O55nUNRzYBzGUcy4AtC5BlI=
Date:   Fri, 29 Sep 2023 17:18:52 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, nphamcs@gmail.com, hannes@cmpxchg.org,
        ddstreet@ieee.org, cerasuolodomenico@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-zswap-fix-potential-memory-corruption-on-duplicate-store-v2.patch removed from -mm tree
Message-Id: <20230930001853.05406C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-zswap-fix-potential-memory-corruption-on-duplicate-store-v2
has been removed from the -mm tree.  Its filename was
     mm-zswap-fix-potential-memory-corruption-on-duplicate-store-v2.patch

This patch was dropped because it was folded into mm-zswap-fix-potential-memory-corruption-on-duplicate-store.patch

------------------------------------------------------
From: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Subject: mm-zswap-fix-potential-memory-corruption-on-duplicate-store-v2
Date: Mon, 25 Sep 2023 15:00:02 +0200

add a warning and a comment to the second duplicates check in
zswap_store() (Johannes).

Link: https://lkml.kernel.org/r/20230925130002.1929369-1-cerasuolodomenico@gmail.com
Fixes: 42c06a0e8ebe ("mm: kill frontswap")
Signed-off-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/zswap.c~mm-zswap-fix-potential-memory-corruption-on-duplicate-store-v2
+++ a/mm/zswap.c
@@ -1346,7 +1346,14 @@ insert_entry:
 
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

mm-zswap-fix-potential-memory-corruption-on-duplicate-store.patch
zswap-make-shrinking-memcg-aware.patch


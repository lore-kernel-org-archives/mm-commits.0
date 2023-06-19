Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D223EEB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjFSX0x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjFSXZH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:25:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6B71BC7
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD22D60FBB
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA86C433C8;
        Mon, 19 Jun 2023 23:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216999;
        bh=ICS4VyZSLVubCFU/bQEcKzm+0jvupYyTxCKxdkn+1tA=;
        h=Date:To:From:Subject:From;
        b=ADHw25Jw+HEXxZRILxZa6vvLjnxEXBZsOyj861UloM4wxm14n6FPjXxfva7Z/yFFC
         whhRRdcZK4qxJ8ZUiotTP/sq2epsKfyw1hX73Ezz7xST0Hxg4Jw7bhmBYs7wTPBNaz
         6YCdc4859UbBanaCrKCZBUxyrCoSzHc7UmegQSHY=
Date:   Mon, 19 Jun 2023 16:23:18 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, nphamcs@gmail.com,
        hannes@cmpxchg.org, ddstreet@ieee.org, cerasuolodomenico@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-invaldiate-entry-after-writeback.patch removed from -mm tree
Message-Id: <20230619232319.3CA86C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: zswap: invaldiate entry after writeback
has been removed from the -mm tree.  Its filename was
     mm-zswap-invaldiate-entry-after-writeback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Subject: mm: zswap: invaldiate entry after writeback
Date: Wed, 14 Jun 2023 16:31:22 +0200

When an entry started writeback, it used to be invalidated with ref count
logic alone, meaning that it would stay on the tree until all references
were put.  The problem with this behavior is that as soon as the writeback
started, the ownership of the data held by the entry is passed to the
swapcache and should not be left in zswap too.  Currently there are no
known issues because of this, but this change explicitly invalidates an
entry that started writeback to reduce opportunities for future bugs.

This patch is a follow up on the series titled "mm: zswap: move writeback
LRU from zpool to zswap" + commit f090b7949768("mm: zswap: support
exclusive loads").

Link: https://lkml.kernel.org/r/20230614143122.74471-1-cerasuolodomenico@gmail.com
Signed-off-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/mm/zswap.c~mm-zswap-invaldiate-entry-after-writeback
+++ a/mm/zswap.c
@@ -599,6 +599,16 @@ static struct zswap_pool *zswap_pool_fin
 	return NULL;
 }
 
+static void zswap_invalidate_entry(struct zswap_tree *tree,
+				   struct zswap_entry *entry)
+{
+	/* remove from rbtree */
+	zswap_rb_erase(&tree->rbroot, entry);
+
+	/* drop the initial reference from entry creation */
+	zswap_entry_put(tree, entry);
+}
+
 static int zswap_reclaim_entry(struct zswap_pool *pool)
 {
 	struct zswap_entry *entry;
@@ -644,12 +654,13 @@ static int zswap_reclaim_entry(struct zs
 		goto put_unlock;
 	}
 
-	/* Check for invalidate() race */
-	if (entry != zswap_rb_search(&tree->rbroot, swpoffset))
-		goto put_unlock;
-
-	/* Drop base reference */
-	zswap_entry_put(tree, entry);
+	/*
+	 * Writeback started successfully, the page now belongs to the
+	 * swapcache. Drop the entry from zswap - unless invalidate already
+	 * took it out while we had the tree->lock released for IO.
+	 */
+	if (entry == zswap_rb_search(&tree->rbroot, swpoffset))
+		zswap_invalidate_entry(tree, entry);
 
 put_unlock:
 	/* Drop local reference */
@@ -1376,16 +1387,6 @@ shrink:
 	goto reject;
 }
 
-static void zswap_invalidate_entry(struct zswap_tree *tree,
-				   struct zswap_entry *entry)
-{
-	/* remove from rbtree */
-	zswap_rb_erase(&tree->rbroot, entry);
-
-	/* drop the initial reference from entry creation */
-	zswap_entry_put(tree, entry);
-}
-
 /*
  * returns 0 if the page was successfully decompressed
  * return -1 on entry not found or error
_

Patches currently in -mm which might be from cerasuolodomenico@gmail.com are



Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0755DEB64DD
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:01:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbjFXABF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbjFXAAe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:00:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE90272C
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:00:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7384A61584
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89FBC433C8;
        Sat, 24 Jun 2023 00:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564829;
        bh=KIc1QY9LCDe2zXJBUn6y8Lxyt7PX/c8gdqVwH77KvQU=;
        h=Date:To:From:Subject:From;
        b=bPFZkFoHrqOqAa7XGLZysaJ/8G+1fzBhcf+VIuSuZvS1WcYTNqrK6wEfhlmJYRI2j
         Zix/yzPNVF/BB5I2ixn68OSoQmUMfZdITtn8TsG76m8lh5Wlh2YLn0Ko6qtvjO2imP
         rgj9K+Wlexkg2DrNasuxLBxYRJW9Udg1/4AX4iQ4=
Date:   Fri, 23 Jun 2023 17:00:29 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, nphamcs@gmail.com,
        konrad.wilk@oracle.com, hannes@cmpxchg.org, ddstreet@ieee.org,
        cerasuolodomenico@gmail.com, 42.hyeyoo@gmail.com,
        yosryahmed@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-fix-double-invalidate-with-exclusive-loads.patch removed from -mm tree
Message-Id: <20230624000029.C89FBC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: zswap: fix double invalidate with exclusive loads
has been removed from the -mm tree.  Its filename was
     mm-zswap-fix-double-invalidate-with-exclusive-loads.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: zswap: fix double invalidate with exclusive loads
Date: Wed, 21 Jun 2023 09:30:09 +0000

If exclusive loads are enabled for zswap, we invalidate the entry before
returning from zswap_frontswap_load(), after dropping the local reference.
However, the tree lock is dropped during decompression after the local
reference is acquired, so the entry could be invalidated before we drop
the local ref.  If this happens, the entry is freed once we drop the local
ref, and zswap_invalidate_entry() tries to invalidate an already freed
entry.

Fix this by:
(a) Making sure zswap_invalidate_entry() is always called with a local
    ref held, to avoid being called on a freed entry.
(b) Making sure zswap_invalidate_entry() only drops the ref if the entry
    was actually on the rbtree. Otherwise, another invalidation could
    have already happened, and the initial ref is already dropped.

With these changes, there is no need to check that there is no need to
make sure the entry still exists in the tree in zswap_reclaim_entry()
before invalidating it, as zswap_reclaim_entry() will make this check
internally.

Link: https://lkml.kernel.org/r/20230621093009.637544-1-yosryahmed@google.com
Fixes: b9c91c43412f ("mm: zswap: support exclusive loads")
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reported-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/mm/zswap.c~mm-zswap-fix-double-invalidate-with-exclusive-loads
+++ a/mm/zswap.c
@@ -355,12 +355,14 @@ static int zswap_rb_insert(struct rb_roo
 	return 0;
 }
 
-static void zswap_rb_erase(struct rb_root *root, struct zswap_entry *entry)
+static bool zswap_rb_erase(struct rb_root *root, struct zswap_entry *entry)
 {
 	if (!RB_EMPTY_NODE(&entry->rbnode)) {
 		rb_erase(&entry->rbnode, root);
 		RB_CLEAR_NODE(&entry->rbnode);
+		return true;
 	}
+	return false;
 }
 
 /*
@@ -599,14 +601,16 @@ static struct zswap_pool *zswap_pool_fin
 	return NULL;
 }
 
+/*
+ * If the entry is still valid in the tree, drop the initial ref and remove it
+ * from the tree. This function must be called with an additional ref held,
+ * otherwise it may race with another invalidation freeing the entry.
+ */
 static void zswap_invalidate_entry(struct zswap_tree *tree,
 				   struct zswap_entry *entry)
 {
-	/* remove from rbtree */
-	zswap_rb_erase(&tree->rbroot, entry);
-
-	/* drop the initial reference from entry creation */
-	zswap_entry_put(tree, entry);
+	if (zswap_rb_erase(&tree->rbroot, entry))
+		zswap_entry_put(tree, entry);
 }
 
 static int zswap_reclaim_entry(struct zswap_pool *pool)
@@ -659,8 +663,7 @@ static int zswap_reclaim_entry(struct zs
 	 * swapcache. Drop the entry from zswap - unless invalidate already
 	 * took it out while we had the tree->lock released for IO.
 	 */
-	if (entry == zswap_rb_search(&tree->rbroot, swpoffset))
-		zswap_invalidate_entry(tree, entry);
+	zswap_invalidate_entry(tree, entry);
 
 put_unlock:
 	/* Drop local reference */
@@ -1466,7 +1469,6 @@ stats:
 		count_objcg_event(entry->objcg, ZSWPIN);
 freeentry:
 	spin_lock(&tree->lock);
-	zswap_entry_put(tree, entry);
 	if (!ret && zswap_exclusive_loads_enabled) {
 		zswap_invalidate_entry(tree, entry);
 		*exclusive = true;
@@ -1475,6 +1477,7 @@ freeentry:
 		list_move(&entry->lru, &entry->pool->lru);
 		spin_unlock(&entry->pool->lru_lock);
 	}
+	zswap_entry_put(tree, entry);
 	spin_unlock(&tree->lock);
 
 	return ret;
_

Patches currently in -mm which might be from yosryahmed@google.com are



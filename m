Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD7CFEB64D8
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jun 2023 21:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjFUVXU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jun 2023 17:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjFUVXT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jun 2023 17:23:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F600171C
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 14:23:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD370616CD
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 21:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0513DC433C0;
        Wed, 21 Jun 2023 21:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687382597;
        bh=gBQkxvtODkofCdfX+P014YHax8lhSasbjVFLUjpLNH0=;
        h=Date:To:From:Subject:From;
        b=ufUZ8pMJFgsLXDb5IpOwR+B+VHo8n8WhRAGn3OQLg/gjhOBPO8C/iy4h7oZaDxSfo
         uUFs5aDa/v2rJvFxIiQzYQ5wHLeF1D89kd1P6NQcUmD/OGZnZVtm0m5qGLi5733N9V
         WXi+hTtn/81xwEDjXtD9hhCLZ1JGW1Oo0ixUy5pk=
Date:   Wed, 21 Jun 2023 14:23:16 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, nphamcs@gmail.com,
        konrad.wilk@oracle.com, hannes@cmpxchg.org, ddstreet@ieee.org,
        cerasuolodomenico@gmail.com, 42.hyeyoo@gmail.com,
        yosryahmed@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-fix-double-invalidate-with-exclusive-loads.patch added to mm-unstable branch
Message-Id: <20230621212317.0513DC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: zswap: fix double invalidate with exclusive loads
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-fix-double-invalidate-with-exclusive-loads.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-fix-double-invalidate-with-exclusive-loads.patch

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

mm-zswap-fix-double-invalidate-with-exclusive-loads.patch


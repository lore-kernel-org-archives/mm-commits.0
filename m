Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3567F8BFC
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560126; cv=none; b=oWbu6tRjHOGlG92tQ8fJPYb4QEmJLiz8v5R1Yu5ZNcWouQtAAULv3+UJ3U1dqBfZs6AyCBQ1y3Ti6+FNERjzdrm99VXFu2GF/zo5N13JXzd90IawPESwy7Rz1qB/gTm3kDIPArAudh7/Qit+hwxJCI5TdGH84FEhzkRv4zQLCaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560126; c=relaxed/simple;
	bh=uIwvh8efJqaNJWjnmGhk2kF4ARYefpswkt7LMUQDU9Y=;
	h=Date:To:From:Subject:Message-Id; b=n7+fsjEFhszPTslgkRWUZlfTtD/bt8RcIM5HJ496A5GUhdyqaeD36rQ6zIT0YU0IJdue5mh363bq7In6RFaWmJEYigiR0xXM0L9Ok8oujxa8MD27S7Ro62h45F7LdPfF49Spggzk2u/jMDYCFbEz0PvSFwMRdTuudHmqeZo9oLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s/KeWQLA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s/KeWQLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0959DC433F1;
	Thu, 22 Feb 2024 00:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560126;
	bh=uIwvh8efJqaNJWjnmGhk2kF4ARYefpswkt7LMUQDU9Y=;
	h=Date:To:From:Subject:From;
	b=s/KeWQLAMFJgc3di85aZAklUgMubRdIFstDjiGw017c+quyBsamB63Gr+f5vf33T3
	 zIq11IfgEDG5QMTIWMR/evJkxAkxCLojnUgJHZbzf2SdblgXXpmeNBsuAGTyPPYPC4
	 CPF1SdwjqT338885N6CG1tKWcJrRiUtIJO1eGglA=
Date: Wed, 21 Feb 2024 16:02:05 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-function-ordering-move-entry-section-out-of-tree-section.patch removed from -mm tree
Message-Id: <20240222000206.0959DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: function ordering: move entry section out of tree section
has been removed from the -mm tree.  Its filename was
     mm-zswap-function-ordering-move-entry-section-out-of-tree-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: function ordering: move entry section out of tree section
Date: Mon, 29 Jan 2024 20:36:52 -0500

The higher-level entry operations modify the tree, so move the entry
API after the tree section.

Link: https://lkml.kernel.org/r/20240130014208.565554-17-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

--- a/mm/zswap.c~mm-zswap-function-ordering-move-entry-section-out-of-tree-section
+++ a/mm/zswap.c
@@ -849,27 +849,6 @@ void zswap_memcg_offline_cleanup(struct
 }
 
 /*********************************
-* zswap entry functions
-**********************************/
-static struct kmem_cache *zswap_entry_cache;
-
-static struct zswap_entry *zswap_entry_cache_alloc(gfp_t gfp, int nid)
-{
-	struct zswap_entry *entry;
-	entry = kmem_cache_alloc_node(zswap_entry_cache, gfp, nid);
-	if (!entry)
-		return NULL;
-	entry->refcount = 1;
-	RB_CLEAR_NODE(&entry->rbnode);
-	return entry;
-}
-
-static void zswap_entry_cache_free(struct zswap_entry *entry)
-{
-	kmem_cache_free(zswap_entry_cache, entry);
-}
-
-/*********************************
 * rbtree functions
 **********************************/
 static struct zswap_entry *zswap_rb_search(struct rb_root *root, pgoff_t offset)
@@ -930,6 +909,27 @@ static bool zswap_rb_erase(struct rb_roo
 	return false;
 }
 
+/*********************************
+* zswap entry functions
+**********************************/
+static struct kmem_cache *zswap_entry_cache;
+
+static struct zswap_entry *zswap_entry_cache_alloc(gfp_t gfp, int nid)
+{
+	struct zswap_entry *entry;
+	entry = kmem_cache_alloc_node(zswap_entry_cache, gfp, nid);
+	if (!entry)
+		return NULL;
+	entry->refcount = 1;
+	RB_CLEAR_NODE(&entry->rbnode);
+	return entry;
+}
+
+static void zswap_entry_cache_free(struct zswap_entry *entry)
+{
+	kmem_cache_free(zswap_entry_cache, entry);
+}
+
 static struct zpool *zswap_find_zpool(struct zswap_entry *entry)
 {
 	int i = 0;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are



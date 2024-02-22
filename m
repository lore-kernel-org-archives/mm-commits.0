Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DF718D
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560115; cv=none; b=mqagX5BiB8S1qnvhEMBhsIz3ESqDT/haXAB7p/6Ofybmi3IZ4QcpEYa+7G0LT8ZtEIGaoaYMng4o9iE55dooQoKQeURL4nMWDm4SA5HUT3u3V7KqG1sESIDSNNUyiqNAWGT3T+h5S91pStNzQ78bph/9WDZGzr23xM/WHf08i0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560115; c=relaxed/simple;
	bh=fxwR3KTeZcjSTjy/J8oJx+FQGLGDGJJrRPJD9YF43bw=;
	h=Date:To:From:Subject:Message-Id; b=kvBTU2Pd13esRlSbdWPdl/r+yIk+m0AweoyBpgcnksMmC8epr4bi7Sq1YcGcbJKgSlCAtegI53wHsl9HX5y1hCRSDuFNaFno1b4xs266ZRKxfp0RMpXbcm/0zYT4zIflj8Sc+X/7x9H67946FuXc1rFzTkT7mNHEIzW+penYd+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oC34wgFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oC34wgFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E39C433C7;
	Thu, 22 Feb 2024 00:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560114;
	bh=fxwR3KTeZcjSTjy/J8oJx+FQGLGDGJJrRPJD9YF43bw=;
	h=Date:To:From:Subject:From;
	b=oC34wgFB0Sh9l7RAULRsPnK9DMJCRhAzruoVWeHfwJ+sDYpsdl6jWrwodqyG3xkjF
	 qVGMA3ixEEozG2PAKycaY/nNEr2/+yh+UJy2pblHUqeiJ1dKksMX95Z6i7fsvWEnkx
	 FB4Q0/81uNDexUjYs0TKt441BvMgsGtU6Axi91Uo=
Date: Wed, 21 Feb 2024 16:01:54 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-move-zswap_invalidate_entry-to-related-functions.patch removed from -mm tree
Message-Id: <20240222000154.B3E39C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: move zswap_invalidate_entry() to related functions
has been removed from the -mm tree.  Its filename was
     mm-zswap-move-zswap_invalidate_entry-to-related-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: move zswap_invalidate_entry() to related functions
Date: Mon, 29 Jan 2024 20:36:39 -0500

Move it up to the other tree and refcounting functions.

Link: https://lkml.kernel.org/r/20240130014208.565554-4-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/mm/zswap.c~mm-zswap-move-zswap_invalidate_entry-to-related-functions
+++ a/mm/zswap.c
@@ -558,6 +558,18 @@ static void zswap_entry_put(struct zswap
 	}
 }
 
+/*
+ * If the entry is still valid in the tree, drop the initial ref and remove it
+ * from the tree. This function must be called with an additional ref held,
+ * otherwise it may race with another invalidation freeing the entry.
+ */
+static void zswap_invalidate_entry(struct zswap_tree *tree,
+				   struct zswap_entry *entry)
+{
+	if (zswap_rb_erase(&tree->rbroot, entry))
+		zswap_entry_put(entry);
+}
+
 /*********************************
 * shrinker functions
 **********************************/
@@ -808,18 +820,6 @@ static struct zswap_pool *zswap_pool_fin
 	return NULL;
 }
 
-/*
- * If the entry is still valid in the tree, drop the initial ref and remove it
- * from the tree. This function must be called with an additional ref held,
- * otherwise it may race with another invalidation freeing the entry.
- */
-static void zswap_invalidate_entry(struct zswap_tree *tree,
-				   struct zswap_entry *entry)
-{
-	if (zswap_rb_erase(&tree->rbroot, entry))
-		zswap_entry_put(entry);
-}
-
 static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_one *l,
 				       spinlock_t *lock, void *arg)
 {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are



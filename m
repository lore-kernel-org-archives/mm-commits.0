Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A7A3C3F
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560098; cv=none; b=GoZKqt9XbnLNSbYHwsZhq9jwBgxjikEOnbbEL0lKNvvC84M838koOHrK/VoEbYu5W1dkcFfnZUjiumECOi4qQP2cPhvNwKjC9BAadNr+CWoYtmZRIn8veonouA1fRyz2DXwGolZ1oWkz/2qoIXjesg9Hrud9ooYONsch2y9curM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560098; c=relaxed/simple;
	bh=oPkxu2HVrUNFFuZiwGLEb9THhn5gLwS8O+JBZnvIQYI=;
	h=Date:To:From:Subject:Message-Id; b=d8YHXZtaTtDkC4CySrmsXW4i+78E4DATHbTo7AVKTS8ut0NwyC/yh/GztV45RDZ6SyI9bo3hqggYulL24TRzg/H5JZ+mhxKDhgvlgb7oaKBQ5GGrNpG6yGLxRujxBKFCSMI1QS14BSMnsO3L7/bhYgdvb5NWqAeAqQnW2eCfTwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=huGR4n3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="huGR4n3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D245C43390;
	Thu, 22 Feb 2024 00:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560098;
	bh=oPkxu2HVrUNFFuZiwGLEb9THhn5gLwS8O+JBZnvIQYI=;
	h=Date:To:From:Subject:From;
	b=huGR4n3EK6/HfOlYrE1nv9y1y7Y28hMdkkRZxxnQG69yb0xWjnNKo/vmJI7TtFYbk
	 XVfYY1BckycAb0RTtBvbIAHZO0umUuJveKFXIPDxsj1kR/+PVfMyJeNs+nJ0vJnTPP
	 4ur3a7lqT9D+XcjSGWV7NITy2KeNduXzSs7aEgXQ=
Date: Wed, 21 Feb 2024 16:01:37 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,nphamcs@gmail.com,hannes@cmpxchg.org,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-remove-unused-tree-argument-in-zswap_entry_put.patch removed from -mm tree
Message-Id: <20240222000138.4D245C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: remove unused tree argument in zswap_entry_put()
has been removed from the -mm tree.  Its filename was
     mm-zswap-remove-unused-tree-argument-in-zswap_entry_put.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: zswap: remove unused tree argument in zswap_entry_put()
Date: Thu, 25 Jan 2024 08:14:23 +0000

Commit 7310895779624 ("mm: zswap: tighten up entry invalidation") removed
the usage of tree argument, delete it.

Link: https://lkml.kernel.org/r/20240125081423.1200336-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/zswap.c~mm-zswap-remove-unused-tree-argument-in-zswap_entry_put
+++ a/mm/zswap.c
@@ -568,8 +568,7 @@ static void zswap_entry_get(struct zswap
 /* caller must hold the tree lock
 * remove from the tree and free it, if nobody reference the entry
 */
-static void zswap_entry_put(struct zswap_tree *tree,
-			struct zswap_entry *entry)
+static void zswap_entry_put(struct zswap_entry *entry)
 {
 	int refcount = --entry->refcount;
 
@@ -852,7 +851,7 @@ static void zswap_invalidate_entry(struc
 				   struct zswap_entry *entry)
 {
 	if (zswap_rb_erase(&tree->rbroot, entry))
-		zswap_entry_put(tree, entry);
+		zswap_entry_put(entry);
 }
 
 static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_one *l,
@@ -921,7 +920,7 @@ static enum lru_status shrink_memcg_cb(s
 
 put_unlock:
 	/* Drop local reference */
-	zswap_entry_put(tree, entry);
+	zswap_entry_put(entry);
 unlock:
 	spin_unlock(&tree->lock);
 	spin_lock(lock);
@@ -1754,7 +1753,7 @@ bool zswap_load(struct folio *folio)
 		zswap_lru_del(&entry->pool->list_lru, entry);
 		zswap_lru_add(&entry->pool->list_lru, entry);
 	}
-	zswap_entry_put(tree, entry);
+	zswap_entry_put(entry);
 	spin_unlock(&tree->lock);
 
 	return true;
_

Patches currently in -mm which might be from yosryahmed@google.com are



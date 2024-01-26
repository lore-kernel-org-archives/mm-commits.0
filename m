Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C86C5CBD
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235362; cv=none; b=SoOY70i8IWKVO6wMsJHqyJE3SIftUhrKiaEQBvysE72m7lCjQtOItqq7Hck9Aalp/lMub1YSE1uA0/NTb9fyQm2LyBH5rmJ92r1NJCNuwA4IcQ0oGypva6owss68UWOTh3Q/dSdR/fv5uGCWcWigmNZvDfTKS9uiSyl2rLBBwWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235362; c=relaxed/simple;
	bh=0iCpVMvlTfaILT3B0NQfy9+djRPbY/b5XpQ69h728/Y=;
	h=Date:To:From:Subject:Message-Id; b=I36P/lHng5s6F517t55V52bMfvSk8BnRX+17UNCJvbAJmNcJQ8HP8MMP6VbycuLQ/hxuHai2fzMg9xz3WbG9u3jTZMSa8BMebD9d/HEkRdc0F5yVrzdH+DxUTUC9JQc2ohwPst4+7FPvkxsa+1lTq/lcTyWWnRNE1buAQg2KZiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YyXtsVYh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YyXtsVYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAAD9C433C7;
	Fri, 26 Jan 2024 02:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235362;
	bh=0iCpVMvlTfaILT3B0NQfy9+djRPbY/b5XpQ69h728/Y=;
	h=Date:To:From:Subject:From;
	b=YyXtsVYhJPluiudojnaWAo2hcOpvy2mlEcXagZT51G8CbRo6gKDpWCEbhabK+hpbF
	 i6AeFH/ERS92R1QsuGmVWeZpyIlST1FjuCFaCiiC9FpZ9yIGpIfF0xQnEYa6+kDetB
	 /Y+nJaqs6RUknlSTNLa17RH57lo3AQUdySJl551I=
Date: Thu, 25 Jan 2024 18:15:58 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,nphamcs@gmail.com,hannes@cmpxchg.org,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-remove-unused-tree-argument-in-zswap_entry_put.patch added to mm-unstable branch
Message-Id: <20240126021601.DAAD9C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: remove unused tree argument in zswap_entry_put()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-remove-unused-tree-argument-in-zswap_entry_put.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-remove-unused-tree-argument-in-zswap_entry_put.patch

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
@@ -569,8 +569,7 @@ static void zswap_entry_get(struct zswap
 /* caller must hold the tree lock
 * remove from the tree and free it, if nobody reference the entry
 */
-static void zswap_entry_put(struct zswap_tree *tree,
-			struct zswap_entry *entry)
+static void zswap_entry_put(struct zswap_entry *entry)
 {
 	int refcount = --entry->refcount;
 
@@ -853,7 +852,7 @@ static void zswap_invalidate_entry(struc
 				   struct zswap_entry *entry)
 {
 	if (zswap_rb_erase(&tree->rbroot, entry))
-		zswap_entry_put(tree, entry);
+		zswap_entry_put(entry);
 }
 
 static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_one *l,
@@ -924,7 +923,7 @@ static enum lru_status shrink_memcg_cb(s
 
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

maintainers-supplement-of-zswap-maintainers-update.patch
mm-swap-enforce-updating-inuse_pages-at-the-end-of-swap_range_free.patch
mm-zswap-remove-unnecessary-trees-cleanups-in-zswap_swapoff.patch
mm-zswap-remove-unused-tree-argument-in-zswap_entry_put.patch


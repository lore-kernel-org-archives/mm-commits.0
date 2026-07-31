Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7F137883C
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 20:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785529410; cv=none; b=rmebWOYsTNLz45yngcTIbGJ8fZTKOxAEJpLkaIbGPIcHOnhm2w4zAy2XFJgN1fWmK/ZFvkflm/dIJpGLYmUPe4y6lJOVRqF2kOwH0+Nq6iQuvTPmlDWZGZjD51HhBeWIvy39jeBJQlfzhgic9zuM1Pg1obgrURyjnq40QPBMM7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785529410; c=relaxed/simple;
	bh=2rBa1udHW6rbAMbeTd6lgCl3ne7NCDghPRYWxGn8b20=;
	h=Date:To:From:Subject:Message-Id; b=JaSEOLNpS3yH0TtCMuuav1Co2ygT0EBmRn1ffs70SlxmAWlPl1zyyALHMbVNSgDZEF9q3tMJk0pviIP7bUZOZIvIpWsvvm682w6s8ic1VbMXpYkdQtbNFEM7qf0I8tR40k2uvBVjTYrI5XAeEGw4rOdm8HqjpRfXElgS4FhWHGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KOBg8spJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KOBg8spJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFE51F00AC4;
	Fri, 31 Jul 2026 20:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785529408;
	bh=RKscd1W43ez4YDyvyTXB6Bxf7UoSshWGaX/XRNWFoAU=;
	h=Date:To:From:Subject;
	b=KOBg8spJoTTv06oaCRKeoEbCfRaqW3EXtWMfmmv6kCpwbwt67mZHHsi+UZJXlAIV/
	 jYWqBsis47bpEjtUCEJS4XSozT0nTnNEfZ1m0RYzBuTVTSPeFxV0t/uX3KEtuzvyRa
	 6daJLTniN+Z7Y+OeUtx3GNfEGGgxu6HSmUGMyzQo=
Date: Fri, 31 Jul 2026 13:23:28 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,wfelipe@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-drop-list_lru-param-from-zswap_lru_add-and-_del.patch added to mm-new branch
Message-Id: <20260731202328.9AFE51F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: drop list_lru param from zswap_lru_add() and _del()
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-drop-list_lru-param-from-zswap_lru_add-and-_del.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-drop-list_lru-param-from-zswap_lru_add-and-_del.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Wilson Felipe Pereira <wfelipe@google.com>
Subject: mm: zswap: drop list_lru param from zswap_lru_add() and _del()
Date: Fri, 31 Jul 2026 05:37:06 +0000

Since zswap_lru_add() and zswap_lru_del() are only called with the global
zswap_list_lru, remove the redundant list_lru argument and use
zswap_list_lru directly.

Link: https://lore.kernel.org/20260731053721.1412304-1-wfelipe@google.com
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/zswap.c~mm-zswap-drop-list_lru-param-from-zswap_lru_add-and-_del
+++ a/mm/zswap.c
@@ -665,7 +665,7 @@ static inline int entry_to_nid(struct zs
 	return page_to_nid(virt_to_page(entry));
 }
 
-static void zswap_lru_add(struct list_lru *list_lru, struct zswap_entry *entry)
+static void zswap_lru_add(struct zswap_entry *entry)
 {
 	int nid = entry_to_nid(entry);
 	struct mem_cgroup *memcg;
@@ -684,11 +684,11 @@ static void zswap_lru_add(struct list_lr
 	rcu_read_lock();
 	memcg = mem_cgroup_from_entry(entry);
 	/* will always succeed */
-	list_lru_add(list_lru, &entry->lru, nid, memcg);
+	list_lru_add(&zswap_list_lru, &entry->lru, nid, memcg);
 	rcu_read_unlock();
 }
 
-static void zswap_lru_del(struct list_lru *list_lru, struct zswap_entry *entry)
+static void zswap_lru_del(struct zswap_entry *entry)
 {
 	int nid = entry_to_nid(entry);
 	struct mem_cgroup *memcg;
@@ -696,7 +696,7 @@ static void zswap_lru_del(struct list_lr
 	rcu_read_lock();
 	memcg = mem_cgroup_from_entry(entry);
 	/* will always succeed */
-	list_lru_del(list_lru, &entry->lru, nid, memcg);
+	list_lru_del(&zswap_list_lru, &entry->lru, nid, memcg);
 	rcu_read_unlock();
 }
 
@@ -764,7 +764,7 @@ static void zswap_entry_cache_free(struc
  */
 static void zswap_entry_free(struct zswap_entry *entry)
 {
-	zswap_lru_del(&zswap_list_lru, entry);
+	zswap_lru_del(entry);
 	zs_free(entry->pool->zs_pool, entry->handle);
 	zswap_pool_put(entry->pool);
 	if (entry->objcg) {
@@ -1463,7 +1463,7 @@ static bool zswap_store_page(struct page
 	entry->referenced = true;
 	if (entry->length) {
 		INIT_LIST_HEAD(&entry->lru);
-		zswap_lru_add(&zswap_list_lru, entry);
+		zswap_lru_add(entry);
 	}
 
 	return true;
_

Patches currently in -mm which might be from wfelipe@google.com are

mm-zswap-drop-list_lru-param-from-zswap_lru_add-and-_del.patch


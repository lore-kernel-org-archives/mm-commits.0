Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C884D343D91
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622811; cv=none; b=PzcbSfBmGkwrR07qg5m0/fD6BaqABcaExes6rKL5BatsAj/XPl15qDegRS5KVkjeSdMdJixfAXbqtIAR6DnunHOgJlDIWrEnE2fOeS7x/gVhXlg96qanrtbL30lUbfth1YZu0iaWIe5Kkl55XWTRViE4T8vnBou0lmjx6rJKGnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622811; c=relaxed/simple;
	bh=k8JaOMlZo3PoapBmGs1yT0E3jHIFA+R/0rxdNhGKzQE=;
	h=Date:To:From:Subject:Message-Id; b=GjKoO+BsY1Nen0ZtGpbfOI+DZm5xeEXYLXl0YtL2kE3K/oHQDzTuVkSVamUB8YQphP9mAwijOTkFm/TgompRsO2Bovf1e4TBgFGETsaou5F6T6903ehmZ9uaVxul6kUrc5VHKE4wUBWG9kYmu5DVNAcpkhAhhsR3sAO0CICpq5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fuS2sNr7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fuS2sNr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816711F00A3A;
	Tue, 25 Aug 2026 01:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622809;
	bh=dI7t8UiepSVyD7dVW0Rw1QyVuTAcIYO8FbNhoqY/rqE=;
	h=Date:To:From:Subject;
	b=fuS2sNr78nygC+QFl+3hgLzE91RrrHDmL8vBb5B6+cMc+rztN2yhfXufb4RTDRZhh
	 /SRhJcx8OMK2qI9DlhrbTLTyH1RrPS1w8wxN2ko/2J9gOpmVnb0iw6xWyeEY9AD/Z1
	 IFNhxfWWbPvvUSw8mPBXdOdFfXupsvp8fG0b0zOM=
Date: Mon, 24 Aug 2026 18:53:29 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,sj@kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,wfelipe@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-drop-list_lru-param-from-zswap_lru_add-and-_del.patch removed from -mm tree
Message-Id: <20260825015329.816711F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: drop list_lru param from zswap_lru_add() and _del()
has been removed from the -mm tree.  Its filename was
     mm-zswap-drop-list_lru-param-from-zswap_lru_add-and-_del.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wilson Felipe Pereira <wfelipe@google.com>
Subject: mm: zswap: drop list_lru param from zswap_lru_add() and _del()
Date: Fri, 31 Jul 2026 05:37:06 +0000

Since zswap_lru_add() and zswap_lru_del() are only called with the global
zswap_list_lru, remove the redundant list_lru argument and use
zswap_list_lru directly.

Link: https://lore.kernel.org/20260731053721.1412304-1-wfelipe@google.com
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
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
@@ -1461,7 +1461,7 @@ static bool zswap_store_page(struct page
 	entry->referenced = true;
 	if (entry->length) {
 		INIT_LIST_HEAD(&entry->lru);
-		zswap_lru_add(&zswap_list_lru, entry);
+		zswap_lru_add(entry);
 	}
 
 	return true;
_

Patches currently in -mm which might be from wfelipe@google.com are



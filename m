Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8395513C691
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291688; cv=none; b=BPmCR5QGELfhL9AYF7w1jRxksPArL4oaQUZT+LzI5ZhIM1JnZBc6FMCfSLIc9q2KqWXmexQTg784n06gIW4JrrH69BmUXwFCLa29mmL+pIt3c1dWxlPWdW7qPF4v9x1hbh5gsX2MnUfNy0wTfDBdOKrLDZD9xm6sS2jveC4IxuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291688; c=relaxed/simple;
	bh=n7jS+9ucFIkPSvK0pKS0/wUvkeDIfJ761b4+rmnDzl8=;
	h=Date:To:From:Subject:Message-Id; b=KJfwpZhip1yPngPjmDOZ8T8qtrA2gKvZLEF5Cv48ltXoWVe6tMZBJ7Z5ZdkGkQuI9Y2QMK0G/SXpaU6igSexWiz7549txBmbg4OOTIpYV5m/428Vt86OgDtNPNB2//Jsv1AHdCvaz1p5DJJZlCVPG/nrsDp80/P2t+Xu8SIBRAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dXGr8Euc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dXGr8Euc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597AFC32782;
	Tue, 25 Jun 2024 05:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291688;
	bh=n7jS+9ucFIkPSvK0pKS0/wUvkeDIfJ761b4+rmnDzl8=;
	h=Date:To:From:Subject:From;
	b=dXGr8EucgUabAkNFxwSz6kR4dXzl0YCHFZbkkSCGwtI6fgxYrFioE4oZfYmjWojRN
	 0LNTDuip23QStZGSxeqB97AENwCG6anorc3MgZtyxQ9Kp8eWlaqvIZR3pp0YX3Z+1h
	 obGdQ9j5kV0YueplGn8DJgRKuNkANLUk2ZqHeb5k=
Date: Mon, 24 Jun 2024 22:01:27 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,nphamcs@gmail.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,chengming.zhou@linux.dev,baohua@kernel.org,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-add-zswap_never_enabled.patch removed from -mm tree
Message-Id: <20240625050128.597AFC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: add zswap_never_enabled()
has been removed from the -mm tree.  Its filename was
     mm-zswap-add-zswap_never_enabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: zswap: add zswap_never_enabled()
Date: Tue, 11 Jun 2024 02:45:15 +0000

Add zswap_never_enabled() to skip the xarray lookup in zswap_load() if
zswap was never enabled on the system.  It is implemented using static
branches for efficiency, as enabling zswap should be a rare event.  This
could shave some cycles off zswap_load() when CONFIG_ZSWAP is used but
zswap is never enabled.

However, the real motivation behind this patch is two-fold:
- Incoming large folio swapin work will need to fallback to order-0
  folios if zswap was ever enabled, because any part of the folio could be
  in zswap, until proper handling of large folios with zswap is added.

- A warning and recovery attempt will be added in a following change in
  case the above was not done incorrectly.  Zswap will fail the read if
  the folio is large and it was ever enabled.

Expose zswap_never_enabled() in the header for the swapin work to use
it later.

[yosryahmed@google.com: expose zswap_never_enabled() in the header]
  Link: https://lkml.kernel.org/r/Zmjf0Dr8s9xSW41X@google.com
Link: https://lkml.kernel.org/r/20240611024516.1375191-2-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zswap.h |    6 ++++++
 mm/zswap.c            |   10 ++++++++++
 2 files changed, 16 insertions(+)

--- a/include/linux/zswap.h~mm-zswap-add-zswap_never_enabled
+++ a/include/linux/zswap.h
@@ -36,6 +36,7 @@ void zswap_memcg_offline_cleanup(struct
 void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
 bool zswap_is_enabled(void);
+bool zswap_never_enabled(void);
 #else
 
 struct zswap_lruvec_state {};
@@ -64,6 +65,11 @@ static inline bool zswap_is_enabled(void
 {
 	return false;
 }
+
+static inline bool zswap_never_enabled(void)
+{
+	return false;
+}
 
 #endif
 
--- a/mm/zswap.c~mm-zswap-add-zswap_never_enabled
+++ a/mm/zswap.c
@@ -83,6 +83,7 @@ static bool zswap_pool_reached_full;
 static int zswap_setup(void);
 
 /* Enable/disable zswap */
+static DEFINE_STATIC_KEY_MAYBE(CONFIG_ZSWAP_DEFAULT_ON, zswap_ever_enabled);
 static bool zswap_enabled = IS_ENABLED(CONFIG_ZSWAP_DEFAULT_ON);
 static int zswap_enabled_param_set(const char *,
 				   const struct kernel_param *);
@@ -136,6 +137,11 @@ bool zswap_is_enabled(void)
 	return zswap_enabled;
 }
 
+bool zswap_never_enabled(void)
+{
+	return !static_branch_maybe(CONFIG_ZSWAP_DEFAULT_ON, &zswap_ever_enabled);
+}
+
 /*********************************
 * data structures
 **********************************/
@@ -1557,6 +1563,9 @@ bool zswap_load(struct folio *folio)
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 
+	if (zswap_never_enabled())
+		return false;
+
 	/*
 	 * When reading into the swapcache, invalidate our entry. The
 	 * swapcache can be the authoritative owner of the page and
@@ -1735,6 +1744,7 @@ static int zswap_setup(void)
 			zpool_get_type(pool->zpools[0]));
 		list_add(&pool->list, &zswap_pools);
 		zswap_has_pool = true;
+		static_branch_enable(&zswap_ever_enabled);
 	} else {
 		pr_err("pool creation failed\n");
 		zswap_enabled = false;
_

Patches currently in -mm which might be from yosryahmed@google.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5AD4A18
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560124; cv=none; b=oGiaWL7rYs9OxsvkY/fafBJ9Vo6V1xb+vfT37whwFmO2yytlDFmciPYBLkWuH9it5I/MrzHBAvkijD6O4aEMgKrXzLC+529xFWQIghcVOx1X2ATUPQKJdB6BZ7SAIGMt4W2YqA+vPQnDhuA0ju/Dqf91H6E/hZ+rRvA1rk2FBAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560124; c=relaxed/simple;
	bh=6/NNsZy6Xp9XWJJBYKp7UDZ3zv2SQ3jyj/We3eAKaH0=;
	h=Date:To:From:Subject:Message-Id; b=h6HB+vyfb4172JbJZBH5fW2wrDEPz+D7UOW95IzP6ziInwv4NzpMCsLOsnmsXabhtFj81iXeeqpCcYhmQsTMnoOAMVLZ89m8yNy1xVdNzq1opF2/4W4+eNacuEYygcoTR8R6CaEzt8XWJSFAEjua5+0w4o4GWo/XA9/cSM5ejsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OHHlfQXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OHHlfQXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506AAC433C7;
	Thu, 22 Feb 2024 00:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560124;
	bh=6/NNsZy6Xp9XWJJBYKp7UDZ3zv2SQ3jyj/We3eAKaH0=;
	h=Date:To:From:Subject:From;
	b=OHHlfQXlF/IshP5NXNfoVQOn5qZBwI8AAfXkKHi3Lk8DU3rK63NDQo6UTYYnNkZow
	 7OBU+YxsDGtTAeQn3q+okcRtTRKWpl8rXz8gWb0H9wPYYcbc3RD0FmU30QMy1fQLDz
	 CkPnDTu7ZQ/U0mAd268evEi6akLXKc+x6U8Sjw6Y=
Date: Wed, 21 Feb 2024 16:02:03 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-function-ordering-public-lru-api.patch removed from -mm tree
Message-Id: <20240222000204.506AAC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: function ordering: public lru api
has been removed from the -mm tree.  Its filename was
     mm-zswap-function-ordering-public-lru-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: function ordering: public lru api
Date: Mon, 29 Jan 2024 20:36:50 -0500

The zswap entry section sits awkwardly in the middle of LRU-related
functions. Group the external LRU API functions first.

Link: https://lkml.kernel.org/r/20240130014208.565554-15-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

--- a/mm/zswap.c~mm-zswap-function-ordering-public-lru-api
+++ a/mm/zswap.c
@@ -746,6 +746,10 @@ static int zswap_enabled_param_set(const
 	return ret;
 }
 
+/*********************************
+* lru functions
+**********************************/
+
 /* should be called under RCU */
 #ifdef CONFIG_MEMCG
 static inline struct mem_cgroup *mem_cgroup_from_entry(struct zswap_entry *entry)
@@ -764,6 +768,21 @@ static inline int entry_to_nid(struct zs
 	return page_to_nid(virt_to_page(entry));
 }
 
+void zswap_lruvec_state_init(struct lruvec *lruvec)
+{
+	atomic_long_set(&lruvec->zswap_lruvec_state.nr_zswap_protected, 0);
+}
+
+void zswap_folio_swapin(struct folio *folio)
+{
+	struct lruvec *lruvec;
+
+	if (folio) {
+		lruvec = folio_lruvec(folio);
+		atomic_long_inc(&lruvec->zswap_lruvec_state.nr_zswap_protected);
+	}
+}
+
 void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg)
 {
 	struct zswap_pool *pool;
@@ -799,23 +818,6 @@ static void zswap_entry_cache_free(struc
 }
 
 /*********************************
-* zswap lruvec functions
-**********************************/
-void zswap_lruvec_state_init(struct lruvec *lruvec)
-{
-	atomic_long_set(&lruvec->zswap_lruvec_state.nr_zswap_protected, 0);
-}
-
-void zswap_folio_swapin(struct folio *folio)
-{
-	struct lruvec *lruvec;
-
-	VM_WARN_ON_ONCE(!folio_test_locked(folio));
-	lruvec = folio_lruvec(folio);
-	atomic_long_inc(&lruvec->zswap_lruvec_state.nr_zswap_protected);
-}
-
-/*********************************
 * lru functions
 **********************************/
 static void zswap_lru_add(struct list_lru *list_lru, struct zswap_entry *entry)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are



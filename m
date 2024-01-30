Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07ABB38DF9
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706596988; cv=none; b=S6sPFwaaXIonPXoh7pT99PbUImdMZVrnTCJSA4iUhkELvQepYIgvDHlZoU9rOgBrxrSfiyaafJa9mLRDHthPpKPQjMUGLSqHzs8+qcbyq90dXRZtnllnO2yrmqafRaiGZz7gemflhAeVIZ9xkdWhoAMdA0+IS2ruSCaLu/h3a4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706596988; c=relaxed/simple;
	bh=F02I5Epke3I0TQkbWO9R7dQjdFgVy1t2lJ6BgrTztxI=;
	h=Date:To:From:Subject:Message-Id; b=pGHPhYI8K3TohJS72Nrwg35t1ALKPJTnrYvu9ppEWnG3tj3WT2RjVTD+PLzDABXveS1LfehnMNBCRx4MfrchpHBQzKpyOCFTDT7kCrOwZkhYow3R77UnjHP+hyeo4QsjnoVbnsqDX14kOdRRlQtwanRA9FmTDf4Gh9Ko/UUBAEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fpXQyvcM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fpXQyvcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22EE6C433C7;
	Tue, 30 Jan 2024 06:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706596987;
	bh=F02I5Epke3I0TQkbWO9R7dQjdFgVy1t2lJ6BgrTztxI=;
	h=Date:To:From:Subject:From;
	b=fpXQyvcMK9J5pc0yWWxLC6GLFvyiEEqRNQHvxZIQekx6HwM3R0hfnrL3Ey8Qc7Nb2
	 6hsuWDK6N6WM+fML+5xI7MrX0OcymbEC7Wp53DxfzKLDdhEONo8SBMWdeRfJ0KuNUy
	 SLt5LM/dYM8e8hdEPtc6hRS7HE3Jnugm/m7lKoqE=
Date: Mon, 29 Jan 2024 22:42:54 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-function-ordering-public-lru-api.patch added to mm-unstable branch
Message-Id: <20240130064306.22EE6C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: function ordering: public lru api
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-function-ordering-public-lru-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-function-ordering-public-lru-api.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: function ordering: public lru api
Date: Mon, 29 Jan 2024 20:36:50 -0500

The zswap entry section sits awkwardly in the middle of LRU-related
functions. Group the external LRU API functions first.

Link: https://lkml.kernel.org/r/20240130014208.565554-15-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

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
@@ -799,24 +818,6 @@ static void zswap_entry_cache_free(struc
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
-	if (folio) {
-		lruvec = folio_lruvec(folio);
-		atomic_long_inc(&lruvec->zswap_lruvec_state.nr_zswap_protected);
-	}
-}
-
-/*********************************
 * lru functions
 **********************************/
 static void zswap_lru_add(struct list_lru *list_lru, struct zswap_entry *entry)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-zswap-fix-objcg-use-after-free-in-entry-destruction.patch
mm-zswap-rename-zswap_free_entry-to-zswap_entry_free.patch
mm-zswap-inline-and-remove-zswap_entry_find_get.patch
mm-zswap-move-zswap_invalidate_entry-to-related-functions.patch
mm-zswap-warn-when-referencing-a-dead-entry.patch
mm-zswap-clean-up-zswap_entry_put.patch
mm-zswap-rename-__zswap_load-to-zswap_decompress.patch
mm-zswap-break-out-zwap_compress.patch
mm-zswap-further-cleanup-zswap_store.patch
mm-zswap-simplify-zswap_invalidate.patch
mm-zswap-function-ordering-pool-alloc-free.patch
mm-zswap-function-ordering-pool-refcounting.patch
mm-zswap-function-ordering-zswap_pools.patch
mm-zswap-function-ordering-pool-params.patch
mm-zswap-function-ordering-public-lru-api.patch
mm-zswap-function-ordering-move-entry-sections-out-of-lru-section.patch
mm-zswap-function-ordering-move-entry-section-out-of-tree-section.patch
mm-zswap-function-ordering-compress-decompress-functions.patch
mm-zswap-function-ordering-per-cpu-compression-infra.patch
mm-zswap-function-ordering-writeback.patch
mm-zswap-function-ordering-shrink_memcg_cb.patch


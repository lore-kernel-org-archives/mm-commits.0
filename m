Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11E638DF9
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706597015; cv=none; b=fUV2raXCUfZatcRkc5VqL7pQuQOnurKO3S0xQgHbENvNmHXKviITTmeIr21vRCdOKIsoUDrEesRBNFI3CGIhilWhDGHMJjyBSm/a269EbRZAqJ0mcH7msEd0b5c6aCyeMtktmuBOgsLrLZaYFwM4al/7GnL4VXyXRsBwwWYDeUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706597015; c=relaxed/simple;
	bh=O0/AvUP9VM+VuxoSJYPWdFmUGqPNEZUuHHUZZyFQSPE=;
	h=Date:To:From:Subject:Message-Id; b=KVioYFqCP/j0aColtJd8ypkiAMhW78jI6WAa7AdD3+xonvy4duBBlHNXxPdpGS1HmDgpDWtY9QV3gsuFg08keMfCIPZyxbywuk4dyYVVkq+m5OpoKZUxnbh523kLUhr6fagmKNbugDSHV82h6gljY9DJvyc8ZoCE3XctPmdY37k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n8GymJ6E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n8GymJ6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1ECC43390;
	Tue, 30 Jan 2024 06:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706597015;
	bh=O0/AvUP9VM+VuxoSJYPWdFmUGqPNEZUuHHUZZyFQSPE=;
	h=Date:To:From:Subject:From;
	b=n8GymJ6Ev/JObHrC9+10fiiKqutdGHgpbbeOHZxRtNrgj5BtVrihxt5bhLzPLUZcR
	 996Ddf/5AiGlp3tH20E4IOYEkt8pVFDpC+X0AXR5STOYloPZkjesLbg1yLFSiOdCSl
	 qSooYQ8Us4WIod+0KpkyUPs169SaXgxkylAz6+mI=
Date: Mon, 29 Jan 2024 22:43:23 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-function-ordering-move-entry-section-out-of-tree-section.patch added to mm-unstable branch
Message-Id: <20240130064334.5D1ECC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: function ordering: move entry section out of tree section
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-function-ordering-move-entry-section-out-of-tree-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-function-ordering-move-entry-section-out-of-tree-section.patch

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
Subject: mm: zswap: function ordering: move entry section out of tree section
Date: Mon, 29 Jan 2024 20:36:52 -0500

The higher-level entry operations modify the tree, so move the entry
API after the tree section.

Link: https://lkml.kernel.org/r/20240130014208.565554-17-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
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


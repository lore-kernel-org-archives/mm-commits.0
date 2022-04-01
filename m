Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A829DC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 02:49:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbiDACvp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 22:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242572AbiDACvp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 22:51:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C85D205960
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 19:49:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C881E619F6
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 02:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13ADFC340F0;
        Fri,  1 Apr 2022 02:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648781395;
        bh=WauCPScKG+6/ITS5ambePXdec+Psxw2N7mfUR4Ot7HY=;
        h=Date:To:From:Subject:From;
        b=IIz8tnXKe6r5cSUCnrvoNRWhCmx4pUcNokJvFf70fG+uP/RNyp47UGBOF7gj1yp+X
         miKYWMhKvd2uGph7BM6OvIL1vNNewSyUI43xCSnT8pTCy8k8JLg5qV9upN1bIg6WjV
         ZiuTwKCKemMloM8homQXvMSeIPDZZr2LyYo26SaU=
Date:   Thu, 31 Mar 2022 19:49:54 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        neilb@suse.de, songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] nfs42-use-a-specific-kmem_cache-to-allocate-nfs4_xattr_entry.patch removed from -mm tree
Message-Id: <20220401024955.13ADFC340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nfs42: use a specific kmem_cache to allocate nfs4_xattr_entry
has been removed from the -mm tree.  Its filename was
     nfs42-use-a-specific-kmem_cache-to-allocate-nfs4_xattr_entry.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: nfs42: use a specific kmem_cache to allocate nfs4_xattr_entry

Fixes a null-pointer deref in nfs4.

If we want to add the allocated objects to its list_lru, we should use
kmem_cache_alloc_lru() to allocate objects.  So intruduce
nfs4_xattr_entry_cachep which is used to allocate nfs4_xattr_entry.

Link: https://lkml.kernel.org/r/164876616694.25542.14010655277238655246@noble.neil.brown.name
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Tested-by: NeilBrown <neilb@suse.de>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/nfs42xattr.c |   95 ++++++++++++++++++++----------------------
 1 file changed, 47 insertions(+), 48 deletions(-)

--- a/fs/nfs/nfs42xattr.c~nfs42-use-a-specific-kmem_cache-to-allocate-nfs4_xattr_entry
+++ a/fs/nfs/nfs42xattr.c
@@ -81,7 +81,7 @@ struct nfs4_xattr_entry {
 	struct hlist_node hnode;
 	struct list_head lru;
 	struct list_head dispose;
-	char *xattr_name;
+	const char *xattr_name;
 	void *xattr_value;
 	size_t xattr_size;
 	struct nfs4_xattr_bucket *bucket;
@@ -98,6 +98,7 @@ static struct list_lru nfs4_xattr_entry_
 static struct list_lru nfs4_xattr_large_entry_lru;
 
 static struct kmem_cache *nfs4_xattr_cache_cachep;
+static struct kmem_cache *nfs4_xattr_entry_cachep;
 
 /*
  * Hashing helper functions.
@@ -177,49 +178,28 @@ nfs4_xattr_alloc_entry(const char *name,
 {
 	struct nfs4_xattr_entry *entry;
 	void *valp;
-	char *namep;
-	size_t alloclen, slen;
-	char *buf;
-	uint32_t flags;
+	const char *namep;
+	uint32_t flags = len > PAGE_SIZE ? NFS4_XATTR_ENTRY_EXTVAL : 0;
+	gfp_t gfp = GFP_KERNEL;
+	struct list_lru *lru;
 
 	BUILD_BUG_ON(sizeof(struct nfs4_xattr_entry) +
 	    XATTR_NAME_MAX + 1 > PAGE_SIZE);
 
-	alloclen = sizeof(struct nfs4_xattr_entry);
-	if (name != NULL) {
-		slen = strlen(name) + 1;
-		alloclen += slen;
-	} else
-		slen = 0;
-
-	if (alloclen + len <= PAGE_SIZE) {
-		alloclen += len;
-		flags = 0;
-	} else {
-		flags = NFS4_XATTR_ENTRY_EXTVAL;
-	}
-
-	buf = kmalloc(alloclen, GFP_KERNEL);
-	if (buf == NULL)
+	lru = flags & NFS4_XATTR_ENTRY_EXTVAL ? &nfs4_xattr_large_entry_lru :
+	      &nfs4_xattr_entry_lru;
+	entry = kmem_cache_alloc_lru(nfs4_xattr_entry_cachep, lru, gfp);
+	if (!entry)
 		return NULL;
-	entry = (struct nfs4_xattr_entry *)buf;
-
-	if (name != NULL) {
-		namep = buf + sizeof(struct nfs4_xattr_entry);
-		memcpy(namep, name, slen);
-	} else {
-		namep = NULL;
-	}
-
-
-	if (flags & NFS4_XATTR_ENTRY_EXTVAL) {
-		valp = kvmalloc(len, GFP_KERNEL);
-		if (valp == NULL) {
-			kfree(buf);
-			return NULL;
-		}
-	} else if (len != 0) {
-		valp = buf + sizeof(struct nfs4_xattr_entry) + slen;
+	kref_init(&entry->ref);
+	namep = kstrdup_const(name, gfp);
+	if (!namep && name)
+		goto free_buf;
+
+	if (len != 0) {
+		valp = kvmalloc(len, gfp);
+		if (!valp)
+			goto free_name;
 	} else
 		valp = NULL;
 
@@ -232,23 +212,23 @@ nfs4_xattr_alloc_entry(const char *name,
 
 	entry->flags = flags;
 	entry->xattr_value = valp;
-	kref_init(&entry->ref);
 	entry->xattr_name = namep;
 	entry->xattr_size = len;
-	entry->bucket = NULL;
-	INIT_LIST_HEAD(&entry->lru);
-	INIT_LIST_HEAD(&entry->dispose);
-	INIT_HLIST_NODE(&entry->hnode);
 
 	return entry;
+free_name:
+	kfree_const(namep);
+free_buf:
+	kmem_cache_free(nfs4_xattr_entry_cachep, entry);
+	return NULL;
 }
 
 static void
 nfs4_xattr_free_entry(struct nfs4_xattr_entry *entry)
 {
-	if (entry->flags & NFS4_XATTR_ENTRY_EXTVAL)
-		kvfree(entry->xattr_value);
-	kfree(entry);
+	kvfree(entry->xattr_value);
+	kfree_const(entry->xattr_name);
+	kmem_cache_free(nfs4_xattr_entry_cachep, entry);
 }
 
 static void
@@ -289,7 +269,7 @@ nfs4_xattr_alloc_cache(void)
 {
 	struct nfs4_xattr_cache *cache;
 
-	cache = kmem_cache_alloc(nfs4_xattr_cache_cachep, GFP_KERNEL);
+	cache = kmem_cache_alloc_lru(nfs4_xattr_cache_cachep, &nfs4_xattr_cache_lru, GFP_KERNEL);
 	if (cache == NULL)
 		return NULL;
 
@@ -991,6 +971,16 @@ static void nfs4_xattr_cache_init_once(v
 	INIT_LIST_HEAD(&cache->dispose);
 }
 
+static void nfs4_xattr_entry_init_once(void *p)
+{
+	struct nfs4_xattr_entry *entry = p;
+
+	entry->bucket = NULL;
+	INIT_LIST_HEAD(&entry->lru);
+	INIT_LIST_HEAD(&entry->dispose);
+	INIT_HLIST_NODE(&entry->hnode);
+}
+
 int __init nfs4_xattr_cache_init(void)
 {
 	int ret = 0;
@@ -1002,6 +992,13 @@ int __init nfs4_xattr_cache_init(void)
 	if (nfs4_xattr_cache_cachep == NULL)
 		return -ENOMEM;
 
+	nfs4_xattr_entry_cachep = kmem_cache_create("nfs4_xattr_entry",
+			sizeof(struct nfs4_xattr_entry), 0,
+			(SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD | SLAB_ACCOUNT),
+			nfs4_xattr_entry_init_once);
+	if (!nfs4_xattr_entry_cachep)
+		goto out5;
+
 	ret = list_lru_init_memcg(&nfs4_xattr_large_entry_lru,
 	    &nfs4_xattr_large_entry_shrinker);
 	if (ret)
@@ -1039,6 +1036,8 @@ out2:
 out3:
 	list_lru_destroy(&nfs4_xattr_large_entry_lru);
 out4:
+	kmem_cache_destroy(nfs4_xattr_entry_cachep);
+out5:
 	kmem_cache_destroy(nfs4_xattr_cache_cachep);
 
 	return ret;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-kfence-fix-objcgs-vector-allocation.patch
mm-hugetlb_vmemmap-introduce-arch_want_hugetlb_page_free_vmemmap.patch
arm64-mm-hugetlb-enable-hugetlb_page_free_vmemmap-for-arm64.patch


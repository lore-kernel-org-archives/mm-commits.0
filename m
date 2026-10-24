Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832335;
	b=UoyGQR8PCVrAqhFqPJL1YwEVILtnuWbq5/vZx5Ddrzq7wKnBnFdiTRQABO0n7XOSseV2
	 jv6NzQH1yoErsyfqHXXbWlDluofWBzGEEWAAbvK26NfNiYJwev8FaB8ddBr3Iwl4CeYE0
	 ZRjWp0iHt2x3lQlr1R/bKposfqjCM3dsiQp+3aVJ8Xt1FyKK/9x/vYb18lwsIWJfkRcFY
	 kPsltFgAAykd9hDUFRJ8TSNdnN/ZcwafTcGZbbjDLsqJu/aFoshVwJ1w2sSlhgI3dn4Wm
	 BXIPpl8ADFjB0FLBxvBr2ttFinHyHUXl7D2UXOsaFK4Z2x2dbdB15tS2A+LnLLq1JcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832335;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Oh4ZiEOQ+6BLrMyrP4cDJKabr3aqPz/mJ0u7kOtYd/I=;
	b=sCrbyGeozqZQ2dmI6V0GACkRi2Hci/3XSXCsDywhQNbToOef0jZWUVwl8CxvNoawXDBR
	 3B+sYRIet+yQRXoUZzApq8RNK4ys9E65T4tZ0SubmxHnhEtl4O0kp8CpxtyPV/9Mt/t0i
	 Vd7DtlTvuWpXnbTYtV5HvhAGNubClkX+M5oMVsKkKBJwDIuJNsUWDMs+z7d4uEzRE4qET
	 jp3KsNjOKFRA/75riy9NioUKrpdWmQM7/kFXp4Mxlmwi+J/GHsTOwih7IsY5kcDmGQkN1
	 o7VuCForPsdA/paqfBfVsCKW21ZvGtsomIUqeBxrCWWv/HT/GbSfFlTrFV1BO/QqBuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=x8bTKoJj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52185606A31B
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=x8bTKoJj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176021F01828;
	Sat, 24 Oct 2026 08:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832335;
	bh=Oh4ZiEOQ+6BLrMyrP4cDJKabr3aqPz/mJ0u7kOtYd/I=;
	h=Date:To:From:Subject;
	b=x8bTKoJj/FlOhpqsFJ9rCCY5NcD5bHu+s6UtRC5tuhgDZFy0OeUIrNTs3jJj7y7ao
	 4CpGHkN72W81q1/IINllE+Pi7r4M6l7sZlqyqZXjQqJKbv71z+uYcNL3wRe95EYv8Z
	 91i6nAZ/JbEzzBXQ3yfs122LgiobJv1E3JHkepvM=
Date: Sat, 24 Oct 2026 01:58:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rafael@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kbingham@kernel.org,kasong@tencent.com,jan.kiszka@siemens.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,dakr@kernel.org,brendan.jackman@linux.dev,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-move-mem_section-init-to-sparse_extreme_init.patch removed from -mm tree
Message-Id: <20261024085855.176021F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/sparse: move mem_section init to sparse_extreme_init()
has been removed from the -mm tree.  Its filename was
     mm-sparse-move-mem_section-init-to-sparse_extreme_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/sparse: move mem_section init to sparse_extreme_init()
Date: Mon, 21 Sep 2026 21:58:53 +0200

Patch series "mm/sparse: remove SECTION_MARKED_PRESENT and further
cleanups", v2.

SECTION_MARKED_PRESENT is really only needed during boot, where we can
instead just rely on SECTION_IS_EARLY_BIT by setting that flag earlier.

Some preparations for doing that conversion and some cleanups in the same
(sparse) area.


This patch (of 13):

Let's just avoid another pair of ifdef inside a function.  While at it,
switch to INTERNODE_CACHE_BYTES by just defining a fallback in cache.h as
well, given that the x86 variant already provides one.

Link: https://lore.kernel.org/20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org
Link: https://lore.kernel.org/20260921-b4-sparsemem_cleanups-v2-1-54d81d65e125@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
---

 include/linux/cache.h |    1 +
 mm/sparse.c           |   19 ++++++++++++-------
 2 files changed, 13 insertions(+), 7 deletions(-)

--- a/include/linux/cache.h~mm-sparse-move-mem_section-init-to-sparse_extreme_init
+++ a/include/linux/cache.h
@@ -89,6 +89,7 @@
  */
 #ifndef INTERNODE_CACHE_SHIFT
 #define INTERNODE_CACHE_SHIFT L1_CACHE_SHIFT
+#define INTERNODE_CACHE_BYTES (1 << INTERNODE_CACHE_SHIFT)
 #endif
 
 #if !defined(____cacheline_internodealigned_in_smp)
--- a/mm/sparse.c~mm-sparse-move-mem_section-init-to-sparse_extreme_init
+++ a/mm/sparse.c
@@ -103,11 +103,22 @@ int __meminit sparse_index_init(unsigned
 
 	return 0;
 }
+
+static void __init sparse_extreme_init(void)
+{
+	const unsigned long size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
+
+	mem_section = memblock_alloc_or_panic(size, INTERNODE_CACHE_BYTES);
+}
 #else /* !SPARSEMEM_EXTREME */
 int __meminit sparse_index_init(unsigned long section_nr, int nid)
 {
 	return 0;
 }
+
+static void __init sparse_extreme_init(void)
+{
+}
 #endif
 
 /*
@@ -196,13 +207,7 @@ void __init sparse_sections_init(void)
 	unsigned long start, end;
 	int i, nid;
 
-#ifdef CONFIG_SPARSEMEM_EXTREME
-	unsigned long size, align;
-
-	size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
-	align = 1 << (INTERNODE_CACHE_SHIFT);
-	mem_section = memblock_alloc_or_panic(size, align);
-#endif
+	sparse_extreme_init();
 
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)
 		memory_present(nid, start, end);
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch
mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch
mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch


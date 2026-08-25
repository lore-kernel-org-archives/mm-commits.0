Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AB83438B5
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622848; cv=none; b=St7O0N+CezYkBMNYaIM9Yhm1FaMCyIbtyE790DCLqSDAiPnd58zf/JLoApAHAXATgKT3b1uGF5KbbAh4ef+Mzxf/Q2heNXf/1hSE5tSnJ9WnEjQpMnbQaksJJlp+7I5za9xTk1oXZB9m1V/Y3ca9KbxHDkmKubE2o2L3M4dXIK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622848; c=relaxed/simple;
	bh=SmVwnT21mC71NP1Ofv1CRrZaUql6wQiEF+DgMcy98as=;
	h=Date:To:From:Subject:Message-Id; b=ggi5IC2jZZ501BQr1VAsfGMnz5gOjTCKSZJlV+RJ3WqvCC07mBL0VAu8Qm7Jge3CR+iHJANP4YruXkuCn4PKtwsqt5eOTOjjXKe2myOPr52fyUK299qr4zQq2SH6nDvMmi1WAT2GWrznVFib68LLX47l5Z/o9aNFwwgikenkHwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bez41QKu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bez41QKu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306AD1F00A3D;
	Tue, 25 Aug 2026 01:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622846;
	bh=sX4sNv8IraZil4phvCEnW+xXWmNNSTXd8mNyxB6W5fU=;
	h=Date:To:From:Subject;
	b=Bez41QKuQ7JBRJ8M27avpfjHHvPccloDU4df01RfEPDzFYVpwbZ3twCuX+RXPxt6O
	 zCjMGpoH0Ed9dXLSaiSvpKrO2pTgkvxwmDLqJigjLToKhKrciNQ5KUfs3pFHTUsvCx
	 Xitqo0fVH+oUD+Spr9xJ28NZxj58VH3hyzifWgJQ=
Date: Mon, 24 Aug 2026 18:54:05 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-keep-mem_section_usage_size-internal.patch removed from -mm tree
Message-Id: <20260825015406.306AD1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: keep mem_section_usage_size() internal
has been removed from the -mm tree.  Its filename was
     mm-sparse-keep-mem_section_usage_size-internal.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse: keep mem_section_usage_size() internal
Date: Wed, 5 Aug 2026 10:25:36 +0800

mem_section_usage_size() is only needed by sparsemem implementation code
after commit ae751d567baa ("mm/bootmem_info: stop marking
mem_section_usage as MIX_SECTION_INFO"), so keeping the declaration in
mmzone.h now exposes the helper to all mmzone.h users for no reason.

Move the helper to sparse.h so sparse.c and sparse-vmemmap.c can share it
through the internal header.  While doing so, calculate the allocation
size with struct_size_t(), which ties the expression to the
pageblock_flags trailing array instead of open-coding the struct header
plus bitmap size.

Link: https://lore.kernel.org/20260805022536.1206575-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 -
 mm/sparse.c            |   10 ----------
 mm/sparse.h            |    6 ++++++
 3 files changed, 6 insertions(+), 11 deletions(-)

--- a/include/linux/mmzone.h~mm-sparse-keep-mem_section_usage_size-internal
+++ a/include/linux/mmzone.h
@@ -2069,7 +2069,6 @@ static inline struct mem_section *__nr_t
 #endif
 	return &mem_section[root][nr & SECTION_ROOT_MASK];
 }
-extern size_t mem_section_usage_size(void);
 
 /*
  * We use the lower bits of the mem_map pointer to store a little bit of
--- a/mm/sparse.c~mm-sparse-keep-mem_section_usage_size-internal
+++ a/mm/sparse.c
@@ -213,16 +213,6 @@ static void __init memblocks_present(voi
 		memory_present(nid, start, end);
 }
 
-static unsigned long usemap_size(void)
-{
-	return BITS_TO_LONGS(SECTION_BLOCKFLAGS_BITS) * sizeof(unsigned long);
-}
-
-size_t mem_section_usage_size(void)
-{
-	return sizeof(struct mem_section_usage) + usemap_size();
-}
-
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 unsigned long __init section_map_size(void)
 {
--- a/mm/sparse.h~mm-sparse-keep-mem_section_usage_size-internal
+++ a/mm/sparse.h
@@ -47,6 +47,12 @@ static inline void __section_mark_presen
 
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 }
+
+static inline size_t mem_section_usage_size(void)
+{
+	return struct_size_t(struct mem_section_usage, pageblock_flags,
+			     BITS_TO_LONGS(SECTION_BLOCKFLAGS_BITS));
+}
 #else
 static inline void sparse_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
_

Patches currently in -mm which might be from songmuchun@bytedance.com are



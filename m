Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B00237C92A
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 18:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785955317; cv=none; b=s48i/rGLIUyS7Lxyf8m0DLOIXLgklkEtbQE6maErjDjq/Vav4wVHmoulM4iFNjbd1TaUKdteyr1qAh1uZOFm+LkzPudQpEMxyWBhR8d2AoEbcYsNf/rbPaIYgN+/BTBNKf3d5Bz4MzWbgNlpuyKOXeB6OBYXlS7mlez9lhepDAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785955317; c=relaxed/simple;
	bh=eusSiQvUmBrNId9AGFiytQ01acc6pzalziovnAkwgNo=;
	h=Date:To:From:Subject:Message-Id; b=r5qiTFuEuy/2nsCiFmrGoe0RCE2iOS57dYURf2YHpSmVpdaLfkYclsAxV8VPc9hbLamXyy03DsGS5F4IGzlv/CfjH9AHArxXkBBFqV3FiZrMc4mwMugQGJKxfoJisWviyClYyvOrMSxlIlAk5wmKBWX5BRl/Do9f5IdIn5MV0fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SSxiEV+g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SSxiEV+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF1D1F00A3A;
	Wed,  5 Aug 2026 18:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785955316;
	bh=efPMr3hJyYaIrLBFg12c15eOz6rt0mvG7cr2w8U4kpE=;
	h=Date:To:From:Subject;
	b=SSxiEV+gBOb2hu4SJ/tmPfHZy2g5uYXjjcJT6rYaIFFIOv/sKKgJX2x+0VptkFpwG
	 6L7rfq5Wpxi+ZZZI4kIsuICBx+xg3a1mzPJPzmv8PPxhkkMZeEeC4WXYrJftVvjyPX
	 4uCfwJu2V7vDoTA0r2koE9wwHZ37Ru86jXf76K/0=
Date: Wed, 05 Aug 2026 11:41:55 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-keep-mem_section_usage_size-internal.patch added to mm-new branch
Message-Id: <20260805184156.0EF1D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: keep mem_section_usage_size() internal
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-keep-mem_section_usage_size-internal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-keep-mem_section_usage_size-internal.patch

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
@@ -2070,7 +2070,6 @@ static inline struct mem_section *__nr_t
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

mm-sparse-keep-mem_section_usage_size-internal.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E327142E86
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854738; cv=none; b=F49C1lqBqX4wfwX7UmQGUdyurqUkYoWLa+qFhklfbF3LedriwABAGKs0X8le2XlGht9O/iOwCPBFu9VBGd996rzl+pLuHMcSWMUgT46E0XdOjr10UdmAOTdAJLpQG8NkxrmObhy7jBL9rCH7WH+CxHg13IoHaDn4cIdPaOy4Fuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854738; c=relaxed/simple;
	bh=zAD/T6eLG4KL6DbEc+vpcy24Np1MdSjNiwnK6Vb/gwY=;
	h=Date:To:From:Subject:Message-Id; b=KHJyKX3p5s7fjsNS58vLwk6E8GEILEkka0aYEjuVaMHDD89zkhg5hwcBYPsUmWrOk0T6kbWTg5iaX7n+eowfhjdk51cbfzZMPFXsLhfoYRXudXVPjtFxL/yj9Tdu1I21v++MMb52VbKBksLAiCmGu8QIm3kXcIPRrFeESGCtXQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wxb0vPf7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wxb0vPf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554BFC4CECF;
	Wed,  6 Nov 2024 00:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854738;
	bh=zAD/T6eLG4KL6DbEc+vpcy24Np1MdSjNiwnK6Vb/gwY=;
	h=Date:To:From:Subject:From;
	b=Wxb0vPf7Vd5idLy/0XO2MVHMfSJXLLCmwWAbqFzvSeM3ta0//H25FdG7htho2Tetz
	 BKXTfMu1MsSqc3LHx4o64G9sX6+MUoL3LCqJvi9BW136NUvZgDgJiqBhGFMZ9YBJvs
	 L0nId6ZKzqDEi7pMlpo2WkJOZK7hu32jatWV0LDE=
Date: Tue, 05 Nov 2024 16:58:57 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-multi-gen-lru-walk_pte_range-use-pte_offset_map_rw_nolock.patch removed from -mm tree
Message-Id: <20241106005858.554BFC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: multi-gen LRU: walk_pte_range() use pte_offset_map_rw_nolock()
has been removed from the -mm tree.  Its filename was
     mm-multi-gen-lru-walk_pte_range-use-pte_offset_map_rw_nolock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: multi-gen LRU: walk_pte_range() use pte_offset_map_rw_nolock()
Date: Thu, 26 Sep 2024 14:46:25 +0800

In walk_pte_range(), we may modify the pte entry after holding the ptl, so
convert it to using pte_offset_map_rw_nolock().  At this time, the
pte_same() check is not performed after the ptl held, so we should get
pmdval and do pmd_same() check to ensure the stability of pmd entry.

Link: https://lkml.kernel.org/r/7e9c194a5efacc9609cfd31abb9c7df88b53b530.1727332572.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-multi-gen-lru-walk_pte_range-use-pte_offset_map_rw_nolock
+++ a/mm/vmscan.c
@@ -3386,8 +3386,10 @@ static bool walk_pte_range(pmd_t *pmd, u
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
 	DEFINE_MAX_SEQ(walk->lruvec);
 	int old_gen, new_gen = lru_gen_from_seq(max_seq);
+	pmd_t pmdval;
 
-	pte = pte_offset_map_nolock(args->mm, pmd, start & PMD_MASK, &ptl);
+	pte = pte_offset_map_rw_nolock(args->mm, pmd, start & PMD_MASK, &pmdval,
+				       &ptl);
 	if (!pte)
 		return false;
 	if (!spin_trylock(ptl)) {
@@ -3395,6 +3397,11 @@ static bool walk_pte_range(pmd_t *pmd, u
 		return false;
 	}
 
+	if (unlikely(!pmd_same(pmdval, pmdp_get_lockless(pmd)))) {
+		pte_unmap_unlock(pte, ptl);
+		return false;
+	}
+
 	arch_enter_lazy_mmu_mode();
 restart:
 	for (i = pte_index(start), addr = start; addr != end; i++, addr += PAGE_SIZE) {
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are



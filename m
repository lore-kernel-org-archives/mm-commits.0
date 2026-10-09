Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5894F403AEA
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525441; cv=none; b=GRFfjhuyyd8BcLVJEvhArTwyTJem94ZUzQbN98MnaZtkIi0lb1B8JqSCFM/VVZe50LqImSHzDz1vTZB33/y+jKnM4Wl1ZZldJA8K6quTdOOneFPAGNY3jlYMWUV/sqzz6Ocm1znmWgw3Ric1IwUgQgir/Eykt0gonOgZTIJoLrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525441; c=relaxed/simple;
	bh=mTE2mAomXM9Eqnjpt1p5bAcGtHtYyFs3TYGsLV7pph4=;
	h=Date:To:From:Subject:Message-Id; b=PhP4niD515+is6smIW6aCkFRgeZ5TxvoYhNxozXlmeyvKI10GugqeZgYuQNfDQ193MnDWM9IMqdUDyjB21RuF1dBsiuD93UaLxNpCnNIIwZIHN4FrqZ6OwPgWOe+91ck76HocajFA4aMnPLblb/8PgePo5obaFEEh0yp20TJ51A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IaDLoYd8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IaDLoYd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277EE1F000FF;
	Fri,  9 Oct 2026 05:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525440;
	bh=mEDjn4nbRO1Pu9fs8LU6Vp80n+6sql7fw1Hm3Pc/jXA=;
	h=Date:To:From:Subject;
	b=IaDLoYd8UuCnTQwWL9sjHujB7Yl4r3PIf9tTi+3DlT3iWkDy343c5n3mGznGCE0xp
	 D998fFyrGhk/AGLmLdP7zcILuEVEi4lW/ML/cEBrWvGvdWHCNsegvr90KZuOgErBBm
	 72aBWPa+xDsbnA2H5Y2PAAzkkMcuxFQHLYlwwdlg=
Date: Thu, 08 Oct 2026 22:57:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,vbabka@kernel.org,shikemeng@huaweicloud.com,ryan.roberts@arm.com,riel@surriel.com,nphamcs@gmail.com,mark.rutland@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,kas@kernel.org,jannh@google.com,harry@kernel.org,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,catalin.marinas@arm.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mte-make-mte_save_tags-and-mte_restore_tags-static.patch removed from -mm tree
Message-Id: <20261009055720.277EE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: mte: make mte_save_tags() and mte_restore_tags() static
has been removed from the -mm tree.  Its filename was
     arm64-mte-make-mte_save_tags-and-mte_restore_tags-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: arm64: mte: make mte_save_tags() and mte_restore_tags() static
Date: Tue, 08 Sep 2026 11:16:36 -0400

mte_save_tags() and mte_restore_tags() are only used by
arch_prepare_to_swap() and arch_swap_restore() in mteswap.c.  Make them
static and remove their declarations from mte.h.

No functional change.

Link: https://lore.kernel.org/20260908-folio_swap_entry-v2-6-ee6d01dfa5e1@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 arch/arm64/include/asm/mte.h |    2 --
 arch/arm64/mm/mteswap.c      |    4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/arch/arm64/include/asm/mte.h~arm64-mte-make-mte_save_tags-and-mte_restore_tags-static
+++ a/arch/arm64/include/asm/mte.h
@@ -23,9 +23,7 @@ unsigned long mte_copy_tags_from_user(vo
 				      unsigned long n);
 unsigned long mte_copy_tags_to_user(void __user *to, void *from,
 				    unsigned long n);
-int mte_save_tags(struct page *page);
 void mte_save_page_tags(const void *page_addr, void *tag_storage);
-void mte_restore_tags(swp_entry_t entry, struct page *page);
 void mte_restore_page_tags(void *page_addr, const void *tag_storage);
 void mte_invalidate_tags(int type, pgoff_t offset);
 void mte_invalidate_tags_area(int type);
--- a/arch/arm64/mm/mteswap.c~arm64-mte-make-mte_save_tags-and-mte_restore_tags-static
+++ a/arch/arm64/mm/mteswap.c
@@ -20,7 +20,7 @@ void mte_free_tag_storage(char *storage)
 	kfree(storage);
 }
 
-int mte_save_tags(struct page *page)
+static int mte_save_tags(struct page *page)
 {
 	void *tag_storage, *ret;
 
@@ -47,7 +47,7 @@ int mte_save_tags(struct page *page)
 	return 0;
 }
 
-void mte_restore_tags(swp_entry_t entry, struct page *page)
+static void mte_restore_tags(swp_entry_t entry, struct page *page)
 {
 	void *tags = xa_load(&mte_pages, entry.val);
 
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-memcontrol-take-a-const-folio-in-folio_memcg-and-friends.patch
mm-memcontrol-constify-obj_cgroup_memcg-and-friends.patch
mm-memcontrol-constify-the-lruvec-helpers.patch
mm-page_io-take-a-const-folio-in-bio_associate_blkg_from_folio.patch
mm-memcontrol-constify-the-mem_cgroup-accessors.patch
mm-page_counter-constify-page_counter_read-and-page_counter_margin.patch
mm-memcontrol-constify-the-reclaim-protection-helpers.patch
mm-memcontrol-constify-the-memcg-and-lruvec-stat-readers.patch
mm-memcontrol-constify-the-swap-accounting-helpers.patch
mm-memcontrol-constify-mem_cgroup_swappiness-and-mem_cgroup_get_max.patch
mm-memcontrol-constify-the-zswap-and-socket-pressure-helpers.patch
vmcore-convert-mmap_vmcore_fault-to-use-folios.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333FE349CC4
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622893; cv=none; b=GsYoQB6lNCRGUaJho1bMpzZf+Y81fuMMtuN3HLeEmkPOg8CG5uSh1ZgDJ+eqplTbYIlgQCIIP4VA5mXXAZyfLPz9DGsrmzQ9pXCVacKXPYo4xG8z55arGTlsnyppkR/seLk1dPpj6nFhNxNU+1ciNpaI09EtK7PhV++es7SrwVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622893; c=relaxed/simple;
	bh=T6l3xYwp934DxqtteVHHjAQ5emgEF4okHuyEa3jywCg=;
	h=Date:To:From:Subject:Message-Id; b=hdRDCddKTxJb/qEufVKbp42n/3sLtHoY/VuSq8UexilRwALUhp3F2JyKaCjzu+6YeaRvMBYiIRnKVWCKUAB6ZIF+Rd7sfAq5JB1qXqmfOSjQsDGvAONZAT8/Y5nFul45LuY/n+FLkshxO4WU4QKroAUtDwz3I9TGJvBhNtxu3P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E4nm+qVj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E4nm+qVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1071F00A3A;
	Tue, 25 Aug 2026 01:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622891;
	bh=LVubko8NWX3IT2whUsEXaPyAkz3YDAKcd0kkNiPJIk0=;
	h=Date:To:From:Subject;
	b=E4nm+qVjzhUXFbqnXTO99xkGHHm+qQ/718FWX23lv4rR22bzIA/HuYTbAkzVOD79M
	 woKNHEsV+LXHn64Alo6ZoG3BQT6BVCKZM+9e682F85z/501Qq8VWnm24CC0lw6oHWa
	 5XQ7ZpaIxUE/nUx8c+L7e1aa2D5k5kwhEbZ18/ZU=
Date: Mon, 24 Aug 2026 18:54:51 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-remove-count_swpout_vm_event.patch removed from -mm tree
Message-Id: <20260825015451.BC1071F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: remove count_swpout_vm_event
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-count_swpout_vm_event.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm/swap: remove count_swpout_vm_event
Date: Mon, 13 Jul 2026 11:33:41 +0200

There is only one caller left, so merge it into that.

Link: https://lore.kernel.org/20260713093350.2154226-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

--- a/mm/page_io.c~mm-swap-remove-count_swpout_vm_event
+++ a/mm/page_io.c
@@ -254,19 +254,6 @@ out_unlock:
 	return ret;
 }
 
-static inline void count_swpout_vm_event(struct folio *folio)
-{
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (unlikely(folio_test_pmd_mappable(folio))) {
-		count_memcg_folio_events(folio, THP_SWPOUT, 1);
-		count_vm_event(THP_SWPOUT);
-	}
-#endif
-	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPOUT);
-	count_memcg_folio_events(folio, PSWPOUT, folio_nr_pages(folio));
-	count_vm_events(PSWPOUT, folio_nr_pages(folio));
-}
-
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
 static struct cgroup_subsys_state *folio_memcg_blkg_css(struct folio *folio)
 {
@@ -397,7 +384,16 @@ void __swap_writepage(struct swap_io_ctx
 {
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
-	count_swpout_vm_event(folio);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (unlikely(folio_test_pmd_mappable(folio))) {
+		count_memcg_folio_events(folio, THP_SWPOUT, 1);
+		count_vm_event(THP_SWPOUT);
+	}
+#endif
+	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPOUT);
+	count_memcg_folio_events(folio, PSWPOUT, folio_nr_pages(folio));
+	count_vm_events(PSWPOUT, folio_nr_pages(folio));
+
 	folio_start_writeback(folio);
 	folio_unlock(folio);
 	swap_add_folio(ctx, folio, WRITE);
_

Patches currently in -mm which might be from hch@lst.de are



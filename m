Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881FB364941
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 03:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785297265; cv=none; b=IJdpQROZaz543HJoUmjf0FtKKw3Mt+5FgWRwuak1kBpl0MHIG74V3Z3kE7bwVmQSlmgbOWlmyfbB8GrgmV60ileoSS6bpdsyNivUyTdL5ySgKSkQqtrIhRykNhmBFQkRARGinABskk8p51DkSFpUpgbE3NzrDF3N2OeGNIRpu2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785297265; c=relaxed/simple;
	bh=ed/C2mu6YLUbH14+2g3QMY1eXmYXlf1DHjW7NwBC/KI=;
	h=Date:To:From:Subject:Message-Id; b=gXRIHJgCtkKPC08ZgoXww1iAGUtIsQTt6h3u2Swvi24K2+VA37fpKBH0o1I5mCOtdWTVRrFrP89mkWj8MqI1kSz7IgYVapyDfzhaSeYCyUT38dzcfNDDqsFKC1XEb7uBsm9hh+BvfQoqTk+l9UEL/2s4POcNlvrPyNq7N/Yaabo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zXzaDhyk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zXzaDhyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C95F1F000E9;
	Wed, 29 Jul 2026 03:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785297264;
	bh=//iUzUz9Ds8+mdNff3dHFcA9I5gazDhuSHEwCIk4F4I=;
	h=Date:To:From:Subject;
	b=zXzaDhykAVIs05NvaLn2mQH9ATs9O7YCWI/ITJX3aq49Ob8n6fU46h/lKjVDKAUQE
	 QGhBLZe0w8oPU71kGcf3pGG3FLFVFcdBd8V/OWyWGbQtPxhcSC6WIFaqHZu122ddMe
	 ZGpChpY6LrX9V3pgld91yYq0D7dwmRA/QQKpLD/k=
Date: Tue, 28 Jul 2026 20:54:23 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,joshua.hahnjy@gmail.com,haowenchao@xiaomi.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-2.patch removed from -mm tree
Message-Id: <20260729035424.5C95F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-2
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-2.patch

This patch was dropped because it was folded into mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems.patch

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-2
Date: Sat, 25 Jul 2026 11:45:09 +0800

mm: zsmalloc: update the comment about pool lock

Update the comment to reflect that `zs_free()` can be lockless when
`ZS_OBJ_CLASS_BITS` applies.

Link: https://lore.kernel.org/20260725035733.53241-1-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Wenchao Hao <haowenchao@xiaomi.com>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-2
+++ a/mm/zsmalloc.c
@@ -1832,8 +1832,8 @@ static int zs_page_migrate(struct page *
 	pool = zspage->pool;
 
 	/*
-	 * The pool migrate_lock protects the race between zpage migration
-	 * and zs_free.
+	 * The pool migrate_lock protects against races between zpage migration
+	 * and zs_free(), but only when ZS_OBJ_CLASS_BITS does not apply.
 	 */
 	write_lock(&pool->lock);
 	class = zspage_class(pool, zspage);
@@ -2012,8 +2012,9 @@ static unsigned long __zs_compact(struct
 	unsigned long pages_freed = 0;
 
 	/*
-	 * protect the race between zpage migration and zs_free
-	 * as well as zpage allocation/free
+	 * Protect against races between zpage migration and zs_free()
+	 * (only when ZS_OBJ_CLASS_BITS does not apply), as well as
+	 * zpage allocation and free.
 	 */
 	write_lock(&pool->lock);
 	spin_lock(&class->lock);
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems.patch
mm-avoid-unnecessary-lru-drain-for-wp_can_reuse_anon_folio.patch
mm-avoid-unnecessary-lru-drain-for-wp_can_reuse_anon_folio-fix.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic.patch
mm-entirely-remove-lru_add_drain-in-do_swap_page.patch
mm-clarify-the-folio_free_swap-for-do_swap_page.patch
arm64-hugetlb-extend-batching-of-multiple-cont_pte-in-a-single-pte-setup.patch
arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A129330656
	for <mm-commits@vger.kernel.org>; Sun, 26 Jul 2026 02:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785033564; cv=none; b=KtYQRKT67ftl1TeGYPeaBSwNTAB+kOgjPR/WOyYiC0nepEvaNv1/Lwx38HX2tyawjRKCDTfRfNFZrwhCb0qJXASmpZ9D47zVBMkkmKAaD7J0TdgvTHyob3W0yiID3sO75N4rg5p560NmJG6X0dOPDuG6IJWDqrOHLGN2aUlxmHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785033564; c=relaxed/simple;
	bh=RpGWWgMACC1Dvx0xLjJKf/pM8+VurRfnWlcj8YbQZu8=;
	h=Date:To:From:Subject:Message-Id; b=m8L0PblmxVWlBbLhtmTdk60AmB0OXv32Ev3GOlv7h4X2EA4OcmEcSZv0cV0sh5tb/PHvM2GQOmFPcIt6y1iaK0RXj/6praTJu5hkwiur8GuZNXb/gfvwvj1YSkfkJy7bS2dNu+x3iXEhSVZ5U6O5uIoBQNvrcS6v4MIM9XxzBwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E7wfJh/L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E7wfJh/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF8D1F000E9;
	Sun, 26 Jul 2026 02:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785033562;
	bh=j7loOMRQ3TsVsLjShe73zqH20jKMCv6oYPbMF1WHHto=;
	h=Date:To:From:Subject;
	b=E7wfJh/LKDDm1ZEAXxuAxaQweZwIEa1Rj9FSjHCf21lEbLPfuq3WkNvwlf8/Jc9O/
	 UOcrC75WB8YvJ4ZQpLBX4DdM0127F1olW8BP1NVv5z9Nksl/MXnO/ZKJpCaRb9+lxU
	 WWl535SlT4zlaJ7pIYEYQFZttDPcH4Tmaxafft4M=
Date: Sat, 25 Jul 2026 19:39:22 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,joshua.hahnjy@gmail.com,haowenchao@xiaomi.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-2.patch added to mm-unstable branch
Message-Id: <20260726023922.BFF8D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-2.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-2.patch
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


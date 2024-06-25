Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D338144306
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291746; cv=none; b=OPHp0f37SoxPqEluwJodtA1kkqxi4bM9R2/wKRx+GpPYkjwlRo65g0oPhSZIUnaxI3zzaidE4o3PHk8TRUSblSH0j20ylc5a8XaJrrsL9fK749kdFupizZ8y9QY5QJM1EeV1lURANeA5615wkWuEWXkCRyMKX/W8RGLvBk/BoMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291746; c=relaxed/simple;
	bh=zy3mmMuS9X8r/XcCMS8PJgFqN5H+BO0EKWrTVvndNSY=;
	h=Date:To:From:Subject:Message-Id; b=ZVU/WAiqQseKiNBql+UpHcGaFgCCg+RCRIC9Ope9DPJSMgY2/KGkymIlsrn5/eaXmZXjEc/lpXbGVvgwgiYK/DyALsPeLCNI6V4pe5h3NhZLVXfWmuVE0ZfJ+jAr7v2vBKuC5BKWvfF7cW1SG0FFUhRq6OKCyXHbdbAiUlFrQDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L4hwFVLG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L4hwFVLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6213DC4AF07;
	Tue, 25 Jun 2024 05:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291746;
	bh=zy3mmMuS9X8r/XcCMS8PJgFqN5H+BO0EKWrTVvndNSY=;
	h=Date:To:From:Subject:From;
	b=L4hwFVLG6KUX7vdIJVvxN7u4Vzajth9wdzlflReUGpsa4fKUpdEMxy0nZZPRjOz4q
	 Bc8hYQe6nzyytSm7vIHa77xPrnqbD4hFX4mmvNq2F5MbeffFLA/AcXOGA5aLflwcM2
	 zOGphpjBJVTfMjViu+OlgqYJRsgaBFiTUKeNZ+H0=
Date: Mon, 24 Jun 2024 22:02:25 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-drop-ksm_kmem_cache.patch removed from -mm tree
Message-Id: <20240625050226.6213DC4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: ksm: drop KSM_KMEM_CACHE()
has been removed from the -mm tree.  Its filename was
     mm-ksm-drop-ksm_kmem_cache.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: ksm: drop KSM_KMEM_CACHE()
Date: Tue, 18 Jun 2024 16:12:01 +0800

After commit 21fbd59136e0 ("ksm: add the ksm prefix to the names of the
ksm private structures"), we could directly use KMEM_CACHE().

Link: https://lkml.kernel.org/r/20240618081201.134985-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/mm/ksm.c~mm-ksm-drop-ksm_kmem_cache
+++ a/mm/ksm.c
@@ -488,21 +488,17 @@ static DECLARE_WAIT_QUEUE_HEAD(ksm_iter_
 static DEFINE_MUTEX(ksm_thread_mutex);
 static DEFINE_SPINLOCK(ksm_mmlist_lock);
 
-#define KSM_KMEM_CACHE(__struct, __flags) kmem_cache_create(#__struct,\
-		sizeof(struct __struct), __alignof__(struct __struct),\
-		(__flags), NULL)
-
 static int __init ksm_slab_init(void)
 {
-	rmap_item_cache = KSM_KMEM_CACHE(ksm_rmap_item, 0);
+	rmap_item_cache = KMEM_CACHE(ksm_rmap_item, 0);
 	if (!rmap_item_cache)
 		goto out;
 
-	stable_node_cache = KSM_KMEM_CACHE(ksm_stable_node, 0);
+	stable_node_cache = KMEM_CACHE(ksm_stable_node, 0);
 	if (!stable_node_cache)
 		goto out_free1;
 
-	mm_slot_cache = KSM_KMEM_CACHE(ksm_mm_slot, 0);
+	mm_slot_cache = KMEM_CACHE(ksm_mm_slot, 0);
 	if (!mm_slot_cache)
 		goto out_free2;
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

fs-proc-task_mmu-use-folio-api-in-pte_is_pinned.patch
mm-remove-page_maybe_dma_pinned.patch
mm-remove-page_maybe_dma_pinned-fix.patch
fb_defio-use-a-folio-in-fb_deferred_io_work.patch
mm-remove-page_mkclean.patch
mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poison-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch
mm-memory-convert-clear_huge_page-to-folio_zero_user.patch
mm-memory-use-folio-in-struct-copy_subpage_arg.patch
mm-memory-improve-copy_user_large_folio.patch
mm-memory-rename-pages_per_huge_page-to-nr_pages.patch


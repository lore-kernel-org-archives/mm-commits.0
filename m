Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A422C7C6CE
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103936; cv=none; b=E5B9IGzpzWe5jMia2RPsw7TqQI7Fp4CY52GId0mTHQkzOhQDVFmic7QxDm4l4Xrtk0iFI62yvtXeQt0fVTo1GCcskrwwyUgxhDJVq2LSm4q0ELjDBLc6ns31vxkAWHTu5kgPhjyjsdXFCfPaW5Ta0U4/Yz8yCnplK0m5/+XPogY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103936; c=relaxed/simple;
	bh=HEDBHM1bQ+Mhegvuo1OzxHrejYo+znDDZc4zCBp3XcU=;
	h=Date:To:From:Subject:Message-Id; b=P3jrEM12/dtZCGB/RMnI/xQdOU6Kr9n7+v4UZTogU1GiWRmnPzUm9JCDAnd68n2ul9VA6Aa4juSqUvIx4tg8I6cjUz5GsmNsxmXxT2Qb8gAMmjR9blGU5lrkNau+oP4vzWyscD4XEixYH1KRFmnZvIBTFOAflBxJA4fuNL3tAo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kGBgatzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kGBgatzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F15C113CD;
	Fri, 26 Apr 2024 03:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103936;
	bh=HEDBHM1bQ+Mhegvuo1OzxHrejYo+znDDZc4zCBp3XcU=;
	h=Date:To:From:Subject:From;
	b=kGBgatzM3CljPaK17fA4ne0SVkP5iP6bh/szIOvRHAi7xlxI+fO1sruZAxfBXwWL/
	 CI1GNVjOIv+3QIw0cO88N15mqhPr0EBwsNw57vw8VlbyvaVzb87jExVriQALCPkDS8
	 hOU4IwCUY3LMgilqXs2va47uDxy1GYh40Dqs2gts=
Date: Thu, 25 Apr 2024 20:58:56 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterx@redhat.com,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-always-initialise-folio-_deferred_list.patch removed from -mm tree
Message-Id: <20240426035856.79F15C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: always initialise folio->_deferred_list
has been removed from the -mm tree.  Its filename was
     mm-always-initialise-folio-_deferred_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: always initialise folio->_deferred_list
Date: Thu, 21 Mar 2024 14:24:39 +0000

Patch series "Various significant MM patches".

These patches all interact in annoying ways which make it tricky to send
them out in any way other than a big batch, even though there's not really
an overarching theme to connect them.

The big effects of this patch series are:

 - folio_test_hugetlb() becomes reliable, even when called without a
   page reference
 - We free up PG_slab, and we could always use more page flags
 - We no longer need to check PageSlab before calling page_mapcount()


This patch (of 9):

For compound pages which are at least order-2 (and hence have a
deferred_list), initialise it and then we can check at free that the page
is not part of a deferred list.  We recently found this useful to rule out
a source of corruption.

[peterx@redhat.com: always initialise folio->_deferred_list]
  Link: https://lkml.kernel.org/r/20240417211836.2742593-2-peterx@redhat.com
Link: https://lkml.kernel.org/r/20240321142448.1645400-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240321142448.1645400-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 --
 mm/hugetlb.c     |    3 ++-
 mm/internal.h    |    2 ++
 mm/memcontrol.c  |    3 +++
 mm/page_alloc.c  |    9 +++++----
 5 files changed, 12 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-always-initialise-folio-_deferred_list
+++ a/mm/huge_memory.c
@@ -793,8 +793,6 @@ void folio_prep_large_rmappable(struct f
 {
 	if (!folio || !folio_test_large(folio))
 		return;
-	if (folio_order(folio) > 1)
-		INIT_LIST_HEAD(&folio->_deferred_list);
 	folio_set_large_rmappable(folio);
 }
 
--- a/mm/hugetlb.c~mm-always-initialise-folio-_deferred_list
+++ a/mm/hugetlb.c
@@ -1796,7 +1796,8 @@ static void __update_and_free_hugetlb_fo
 		destroy_compound_gigantic_folio(folio, huge_page_order(h));
 		free_gigantic_folio(folio, huge_page_order(h));
 	} else {
-		__free_pages(&folio->page, huge_page_order(h));
+		INIT_LIST_HEAD(&folio->_deferred_list);
+		folio_put(folio);
 	}
 }
 
--- a/mm/internal.h~mm-always-initialise-folio-_deferred_list
+++ a/mm/internal.h
@@ -525,6 +525,8 @@ static inline void prep_compound_head(st
 	atomic_set(&folio->_entire_mapcount, -1);
 	atomic_set(&folio->_nr_pages_mapped, 0);
 	atomic_set(&folio->_pincount, 0);
+	if (order > 1)
+		INIT_LIST_HEAD(&folio->_deferred_list);
 }
 
 static inline void prep_compound_tail(struct page *head, int tail_idx)
--- a/mm/memcontrol.c~mm-always-initialise-folio-_deferred_list
+++ a/mm/memcontrol.c
@@ -7400,6 +7400,9 @@ static void uncharge_folio(struct folio
 	struct obj_cgroup *objcg;
 
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
+	VM_BUG_ON_FOLIO(folio_order(folio) > 1 &&
+			!folio_test_hugetlb(folio) &&
+			!list_empty(&folio->_deferred_list), folio);
 
 	/*
 	 * Nobody should be changing or seriously looking at
--- a/mm/page_alloc.c~mm-always-initialise-folio-_deferred_list
+++ a/mm/page_alloc.c
@@ -1007,10 +1007,11 @@ static int free_tail_page_prepare(struct
 		}
 		break;
 	case 2:
-		/*
-		 * the second tail page: ->mapping is
-		 * deferred_list.next -- ignore value.
-		 */
+		/* the second tail page: deferred_list overlaps ->mapping */
+		if (unlikely(!list_empty(&folio->_deferred_list))) {
+			bad_page(page, "on deferred list");
+			goto out;
+		}
 		break;
 	default:
 		if (page->mapping != TAIL_MAPPING) {
_

Patches currently in -mm which might be from willy@infradead.org are

doc-improve-the-description-of-__folio_mark_dirty.patch
buffer-add-kernel-doc-for-block_dirty_folio.patch
buffer-add-kernel-doc-for-try_to_free_buffers.patch
buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch
buffer-add-kernel-doc-for-brelse-and-__brelse.patch
buffer-add-kernel-doc-for-bforget-and-__bforget.patch
buffer-improve-bdev_getblk-documentation.patch
doc-split-bufferrst-out-of-api-summaryrst.patch
doc-split-bufferrst-out-of-api-summaryrst-fix.patch
mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill.patch
mm-memory-failure-pass-addr-to-__add_to_kill.patch
mm-return-the-address-from-page_mapped_in_vma.patch
mm-make-page_mapped_in_vma-conditional-on-config_memory_failure.patch
mm-memory-failure-convert-shake_page-to-shake_folio.patch
mm-convert-hugetlb_page_mapping_lock_write-to-folio.patch
mm-memory-failure-convert-memory_failure-to-use-a-folio.patch
mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio.patch
mm-memory-failure-add-some-folio-conversions-to-unpoison_memory.patch
mm-memory-failure-use-folio-functions-throughout-collect_procs.patch
mm-memory-failure-pass-the-folio-to-collect_procs_ksm.patch
fscrypt-convert-bh_get_inode_and_lblk_num-to-use-a-folio.patch
f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio.patch
memory-failure-remove-calls-to-page_mapping.patch
migrate-expand-the-use-of-folio-in-__migrate_device_pages.patch
userfault-expand-folio-use-in-mfill_atomic_install_pte.patch
mm-remove-page_mapping.patch
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch
mm-simplify-thp_vma_allowable_order.patch


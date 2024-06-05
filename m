Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C725C613
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 03:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717558296; cv=none; b=pPugc1ZF2p9Bo4I4dd5kTUtcXP3hdMbpHMO++K5axERKJJHTaIGPOtGev7KZdYZ1dRwPCk5wkxCMTtBvF7PVSdNVKM2uKN1nfMNKAy0Mnr6BOihtE7rDMYzq/I77Ez+l0GqSC4awHkm86WKGp0wzdYkStALwLWFBA2V+ioUP8wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717558296; c=relaxed/simple;
	bh=CVGjqf10cp5jZ1PB54YgCuoyjQeXekqKfBmhkpuhtTQ=;
	h=Date:To:From:Subject:Message-Id; b=sYnEkfTH/LI3IqsMK83Gxk2p+01lyOd56oerf834IffllBCx/fM2OXPICmxWwUnNHYtHlC0CMgOwHN4gKT4naZUm2Rr9qJGiy6VhJsNqI60gmkAulMwJHRLuMAllxhU8AtA42EeHuNN8yVKDZau6YRnSmLJ5oA3z2UQtzCa+T5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ySRM7VCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ySRM7VCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D95CC32781;
	Wed,  5 Jun 2024 03:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717558296;
	bh=CVGjqf10cp5jZ1PB54YgCuoyjQeXekqKfBmhkpuhtTQ=;
	h=Date:To:From:Subject:From;
	b=ySRM7VClX9R2ugpsTi2zSrmnlaMkO95doOtqnNouHJ7V56qAPq0DjAIT2H+Fa2kEy
	 tfYmlDDRL2E5XmZiJ3DVCEI+gWxuc9fkyGMWV1LPOBoPKAFKCn8tWiknAp7qnLL2gy
	 cWeaG3IBa0e/tQFlxgQH021rWDc7fmWA+dZ0icwg=
Date: Tue, 04 Jun 2024 20:31:35 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,tony.luck@intel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jglisse@redhat.com,jane.chu@oracle.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,bcrl@kvack.org,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-memory_failure_queue-into-copy_mc__highpage.patch added to mm-unstable branch
Message-Id: <20240605033136.0D95CC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: move memory_failure_queue() into copy_mc_[user]_highpage()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-memory_failure_queue-into-copy_mc__highpage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-memory_failure_queue-into-copy_mc__highpage.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: move memory_failure_queue() into copy_mc_[user]_highpage()
Date: Mon, 3 Jun 2024 17:24:34 +0800

Patch series "mm: migrate: support poison recover from migrate folio", v4.

The folio migration is widely used in kernel, memory compaction, memory
hotplug, soft offline page, numa balance, memory demote/promotion, etc,
but once access a poisoned source folio when migrating, the kernel will
panic.

There is a mechanism in the kernel to recover from uncorrectable memory
errors, ARCH_HAS_COPY_MC(eg, Machine Check Safe Memory Copy on x86), which
is already used in NVDIMM or core-mm paths(eg, CoW, khugepaged, coredump,
ksm copy), see copy_mc_to_{user,kernel}, copy_mc_{user_}highpage callers.

This series of patches provide the recovery mechanism from folio copy for
the widely used folio migration.  Please note, because folio migration is
no guarantee of success, so we could chose to make folio migration
tolerant of memory failures, adding folio_mc_copy() which is a #MC
versions of folio_copy(), once accessing a poisoned source folio, we could
return error and make the folio migration fail, and this could avoid the
similar panic shown below.

  CPU: 1 PID: 88343 Comm: test_softofflin Kdump: loaded Not tainted 6.6.0
  pc : copy_page+0x10/0xc0
  lr : copy_highpage+0x38/0x50
  ...
  Call trace:
   copy_page+0x10/0xc0
   folio_copy+0x78/0x90
   migrate_folio_extra+0x54/0xa0
   move_to_new_folio+0xd8/0x1f0
   migrate_folio_move+0xb8/0x300
   migrate_pages_batch+0x528/0x788
   migrate_pages_sync+0x8c/0x258
   migrate_pages+0x440/0x528
   soft_offline_in_use_page+0x2ec/0x3c0
   soft_offline_page+0x238/0x310
   soft_offline_page_store+0x6c/0xc0
   dev_attr_store+0x20/0x40
   sysfs_kf_write+0x4c/0x68
   kernfs_fop_write_iter+0x130/0x1c8
   new_sync_write+0xa4/0x138
   vfs_write+0x238/0x2d8
   ksys_write+0x74/0x110


This patch (of 4):

There is a memory_failure_queue() call after copy_mc_[user]_highpage(),
see callers, eg, CoW/KSM page copy, it is used to mark the source page as
h/w poisoned and unmap it from other tasks, and the upcomming poison
recover from migrate folio will do the similar thing, so let's move the
memory_failure_queue() into the copy_mc_[user]_highpage() instead of
adding it into each user, this should also enhance the handling of
poisoned page in khugepaged.

Link: https://lkml.kernel.org/r/20240603092439.3360652-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20240603092439.3360652-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    6 ++++++
 mm/ksm.c                |    1 -
 mm/memory.c             |   12 +++---------
 3 files changed, 9 insertions(+), 10 deletions(-)

--- a/include/linux/highmem.h~mm-move-memory_failure_queue-into-copy_mc__highpage
+++ a/include/linux/highmem.h
@@ -352,6 +352,9 @@ static inline int copy_mc_user_highpage(
 	kunmap_local(vto);
 	kunmap_local(vfrom);
 
+	if (ret)
+		memory_failure_queue(page_to_pfn(from), 0);
+
 	return ret;
 }
 
@@ -368,6 +371,9 @@ static inline int copy_mc_highpage(struc
 	kunmap_local(vto);
 	kunmap_local(vfrom);
 
+	if (ret)
+		memory_failure_queue(page_to_pfn(from), 0);
+
 	return ret;
 }
 #else
--- a/mm/ksm.c~mm-move-memory_failure_queue-into-copy_mc__highpage
+++ a/mm/ksm.c
@@ -3088,7 +3088,6 @@ struct folio *ksm_might_need_to_copy(str
 		if (copy_mc_user_highpage(folio_page(new_folio, 0), page,
 								addr, vma)) {
 			folio_put(new_folio);
-			memory_failure_queue(folio_pfn(folio), 0);
 			return ERR_PTR(-EHWPOISON);
 		}
 		folio_set_dirty(new_folio);
--- a/mm/memory.c~mm-move-memory_failure_queue-into-copy_mc__highpage
+++ a/mm/memory.c
@@ -3028,10 +3028,8 @@ static inline int __wp_page_copy_user(st
 	unsigned long addr = vmf->address;
 
 	if (likely(src)) {
-		if (copy_mc_user_highpage(dst, src, addr, vma)) {
-			memory_failure_queue(page_to_pfn(src), 0);
+		if (copy_mc_user_highpage(dst, src, addr, vma))
 			return -EHWPOISON;
-		}
 		return 0;
 	}
 
@@ -6475,10 +6473,8 @@ static int copy_user_gigantic_page(struc
 
 		cond_resched();
 		if (copy_mc_user_highpage(dst_page, src_page,
-					  addr + i*PAGE_SIZE, vma)) {
-			memory_failure_queue(page_to_pfn(src_page), 0);
+					  addr + i*PAGE_SIZE, vma))
 			return -EHWPOISON;
-		}
 	}
 	return 0;
 }
@@ -6495,10 +6491,8 @@ static int copy_subpage(unsigned long ad
 	struct page *dst = nth_page(copy_arg->dst, idx);
 	struct page *src = nth_page(copy_arg->src, idx);
 
-	if (copy_mc_user_highpage(dst, src, addr, copy_arg->vma)) {
-		memory_failure_queue(page_to_pfn(src), 0);
+	if (copy_mc_user_highpage(dst, src, addr, copy_arg->vma))
 		return -EHWPOISON;
-	}
 	return 0;
 }
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-add-folio_alloc_mpol.patch
mm-mempolicy-use-folio_alloc_mpol_noprof-in-vma_alloc_folio_noprof.patch
mm-mempolicy-use-folio_alloc_mpol-in-alloc_migration_target_by_mpol.patch
mm-shmem-use-folio_alloc_mpol-in-shmem_alloc_folio.patch
mm-refactor-folio_undo_large_rmappable.patch
mm-memcontrol-remove-page_memcg.patch
rmap-remove-define_page_vma_walk.patch
mm-migrate-simplify-__buffer_migrate_folio.patch
mm-migrate_device-use-a-newfolio-in-__migrate_device_pages.patch
mm-migrate_device-unify-migrate-folio-for-migrate_sync_no_copy.patch
mm-migrate-remove-migrate_folio_extra.patch
mm-remove-migrate_sync_no_copy-mode.patch
fs-proc-task_mmu-use-folio-api-in-pte_is_pinned.patch
mm-remove-page_maybe_dma_pinned.patch
fb_defio-use-a-folio-in-fb_deferred_io_work.patch
mm-remove-page_mkclean.patch
mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poison-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch


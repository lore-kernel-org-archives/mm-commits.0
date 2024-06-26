Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58359192B70
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 20:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719432531; cv=none; b=sVBEvC43uCA+oY2w1DsAAdesNfiiDLeh80UdJ16pwp220kkhx3KGWrkeaAipwl1nzkDZAZJQsbJ2kKu4kkYBK6NmGlhWiPqRclGZTKNHQkl6ivVhOSDuoEZ68nFk0l4FycgfQlgpn9NQ7Zb/6PkwBfsQV7Z+ROewpNGUZe2eAPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719432531; c=relaxed/simple;
	bh=r/ityGQw9SNbKWoAXzkI739eSsL5GhulXWCmhUt5Yw0=;
	h=Date:To:From:Subject:Message-Id; b=lzIXZ+EuPTNVS+B0s56o6UAS3qTIrbFfQQ3KCeMfqw2eF06+DJGQd78wb/8Yyxe47fDIlAbZlFLuCY77eMlTA+jd6WZoM65HJdGksntcInvkgS5amiKpHB6yJml3Bf2xZQoI1NpmgHd+E6V+/4Fv7Jb2SNKVSIwgET8X5v3YvU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kL5ee4yW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kL5ee4yW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE7CC4AF07;
	Wed, 26 Jun 2024 20:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719432530;
	bh=r/ityGQw9SNbKWoAXzkI739eSsL5GhulXWCmhUt5Yw0=;
	h=Date:To:From:Subject:From;
	b=kL5ee4yWTJL1inkiRIo3YtwqFuNdP0BWob5SBhMPqx1Wh8dnTfRslsFFEqdnUmFgT
	 W+PcQwAqEX/ba8BGabqjS3ZhFd+bTfi3TsF3ObmRRqvFwPh+waj6sIgWaD2cWQsEUA
	 aFqqUPe7QypwJ4jiRVQfboNQSTsPS/zbgS1eltvo=
Date: Wed, 26 Jun 2024 13:08:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,tony.luck@intel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jglisse@redhat.com,jane.chu@oracle.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,bcrl@kvack.org,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-memory_failure_queue-into-copy_mc__highpage.patch added to mm-unstable branch
Message-Id: <20240626200850.BBE7CC4AF07@smtp.kernel.org>
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
Date: Wed, 26 Jun 2024 16:53:23 +0800

Patch series "mm: migrate: support poison recover from migrate folio", v5.

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


This patch (of 5):

There is a memory_failure_queue() call after copy_mc_[user]_highpage(),
see callers, eg, CoW/KSM page copy, it is used to mark the source page as
h/w poisoned and unmap it from other tasks, and the upcomming poison
recover from migrate folio will do the similar thing, so let's move the
memory_failure_queue() into the copy_mc_[user]_highpage() instead of
adding it into each user, this should also enhance the handling of
poisoned page in khugepaged.

Link: https://lkml.kernel.org/r/20240626085328.608006-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20240626085328.608006-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
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
@@ -2998,7 +2998,6 @@ struct folio *ksm_might_need_to_copy(str
 		if (copy_mc_user_highpage(folio_page(new_folio, 0), page,
 								addr, vma)) {
 			folio_put(new_folio);
-			memory_failure_queue(folio_pfn(folio), 0);
 			return ERR_PTR(-EHWPOISON);
 		}
 		folio_set_dirty(new_folio);
--- a/mm/memory.c~mm-move-memory_failure_queue-into-copy_mc__highpage
+++ a/mm/memory.c
@@ -3022,10 +3022,8 @@ static inline int __wp_page_copy_user(st
 	unsigned long addr = vmf->address;
 
 	if (likely(src)) {
-		if (copy_mc_user_highpage(dst, src, addr, vma)) {
-			memory_failure_queue(page_to_pfn(src), 0);
+		if (copy_mc_user_highpage(dst, src, addr, vma))
 			return -EHWPOISON;
-		}
 		return 0;
 	}
 
@@ -6492,10 +6490,8 @@ static int copy_user_gigantic_page(struc
 
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
@@ -6512,10 +6508,8 @@ static int copy_subpage(unsigned long ad
 	struct page *dst = folio_page(copy_arg->dst, idx);
 	struct page *src = folio_page(copy_arg->src, idx);
 
-	if (copy_mc_user_highpage(dst, src, addr, copy_arg->vma)) {
-		memory_failure_queue(page_to_pfn(src), 0);
+	if (copy_mc_user_highpage(dst, src, addr, copy_arg->vma))
 		return -EHWPOISON;
-	}
 	return 0;
 }
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

fs-proc-task_mmu-use-folio-api-in-pte_is_pinned.patch
mm-remove-page_maybe_dma_pinned.patch
mm-remove-page_maybe_dma_pinned-fix.patch
fb_defio-use-a-folio-in-fb_deferred_io_work.patch
mm-remove-page_mkclean.patch
mm-memory-convert-clear_huge_page-to-folio_zero_user.patch
mm-memory-use-folio-in-struct-copy_subpage_arg.patch
mm-memory-improve-copy_user_large_folio.patch
mm-memory-rename-pages_per_huge_page-to-nr_pages.patch
mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poisoned-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch


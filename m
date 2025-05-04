Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9112F22
	for <mm-commits@vger.kernel.org>; Sun,  4 May 2025 01:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746322774; cv=none; b=JNQSThI/z1WDy7FsBzDq3Bg9A3c7iu7iKdeKyw/YCtEPL+YRvQ26OKQWogI6mlGpvwYywORJUXyhtDAJwcsmxfvgfgoZXFlhPf+phj4fMNKiVEC8d6e5ZTatwdRpq5CJTDh1k0Cz+SqsVJc0pI4k1kWHB0VP4etME0644Eo3VuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746322774; c=relaxed/simple;
	bh=t4NOisBy+iGARSAyJfqqYMj95oodg6nj/Ca7Qr43L08=;
	h=Date:To:From:Subject:Message-Id; b=SFILCJhGDmrUXc+JVWMYnK1KQRccOKBQkvKYJbawV1p57agkmvQXkoD+YkLbd166sduq61XqbttpMWI3qsaYZ+D+07RhzIHpt0CZhRCdrJLVk/Y4TxZsFxVuBFreVOm4NvXlondFfQbkNyXzprrLFnhc28HOzGRTqamXW14a5qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fCO/c3tV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fCO/c3tV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5328C4CEE3;
	Sun,  4 May 2025 01:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746322773;
	bh=t4NOisBy+iGARSAyJfqqYMj95oodg6nj/Ca7Qr43L08=;
	h=Date:To:From:Subject:From;
	b=fCO/c3tVOnSkK9pNrUYAzjbmidOSzk6TEynemoILR++SGrQW+eVtwzEqMRN7XjRnF
	 3YhwS2v2X2mqeA5NeKKQr0U7I7z/6R+o/G2xJPtiZwu80d99A/1k0KULQBnuCXv9WV
	 HYCk5g89ESrJU7PmqFiz1MHIGH3xYb2IH58iY034=
Date: Sat, 03 May 2025 18:39:33 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,wang.yaxin@zte.com.cn,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,lkp@intel.com,hannes@cmpxchg.org,david@redhat.com,chen.haonan2@zte.com.cn,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix.patch added to mm-new branch
Message-Id: <20250504013933.C5328C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix
has been added to the -mm mm-new branch.  Its filename is
     memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix
Date: Sat May  3 06:37:28 PM PDT 2025

make ksm_process_profit() available on CONFIG_PROCFS=n

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505030429.a2GUiRAz-lkp@intel.com/
Cc: David Hildenbrand <david@redhat.com>
Cc: Haonan Chen <chen.haonan2@zte.com.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/ksm.c~memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix
+++ a/mm/ksm.c
@@ -3268,7 +3268,6 @@ static void wait_while_offlining(void)
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
-#ifdef CONFIG_PROC_FS
 /*
  * The process is mergeable only if any VMA is currently
  * applicable to KSM.
@@ -3293,7 +3292,6 @@ long ksm_process_profit(struct mm_struct
 	return (long)(mm->ksm_merging_pages + mm_ksm_zero_pages(mm)) * PAGE_SIZE -
 		mm->ksm_rmap_items * sizeof(struct ksm_rmap_item);
 }
-#endif /* CONFIG_PROC_FS */
 
 #ifdef CONFIG_SYSFS
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

x86-disable-image-size-check-for-test-builds-fix.patch
x86-disable-image-size-check-for-test-builds-fix-fix.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes.patch
jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2.patch
mm-add-zblock-allocator-fix.patch
mm-zblock-avoid-failing-the-build-fix.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix.patch
mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios-fix.patch
memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix.patch
compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix.patch


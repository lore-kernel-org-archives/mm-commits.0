Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D2F17BB3F;
	Tue, 18 Feb 2025 04:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739851254; cv=none; b=cvqPgajQa3e3pqs0kUTINIYfHDwcvvSYN5l31tnBm86X4fh744XjK6a0fAQDxZx2Ah3KYdaKYMdFesLmvubxuddnR6aAf5lrjIXA/ussIafNln5QXhGVURuZeejE/BB7NdBAV6z/++BZjazBtnZ+I9uer8SzkuPvMFDTEZntfx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739851254; c=relaxed/simple;
	bh=p+YDTmBP4uZLmJuUxl4KiBvoVM9QF6srX6CEw8LCUew=;
	h=Date:To:From:Subject:Message-Id; b=BRx8sqchoqVS023Ba2t1aGWiXPazgdrv4eVjKVl4rHJDP6xzPOj3ALe4Qq15kUQ56IWLmavK4QGbcjD3oNP12TLbdv5lye06Fe9KpHgPNel/ctu6pllTWX19Hp0uVkJQUqUqbpdBuLr7IEuxraEJcOcivtJuIULKnApHiDu2VZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OZRzjqDV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OZRzjqDV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A82C4CEE6;
	Tue, 18 Feb 2025 04:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739851253;
	bh=p+YDTmBP4uZLmJuUxl4KiBvoVM9QF6srX6CEw8LCUew=;
	h=Date:To:From:Subject:From;
	b=OZRzjqDVbh8Y7t/1FzJL31d96UykzXH+XRo1PBsAqpP1k480sw/Jsb4VvD0ZHfHrn
	 Y/2ArAySPniaj9rgSgL+4fTXe7Ms67IpltL60cts67wMPix6xadeFJu9Yuy6uXXASQ
	 FKTzQhO8D9gCOp5P5NkCaodaudZ0dk/ER0sZGn6w=
Date: Mon, 17 Feb 2025 20:00:53 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,mhocko@suse.com,linmiaohe@huawei.com,david@redhat.com,mawupeng1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-update-ttu-flag-inside-unmap_poisoned_folio.patch added to mm-hotfixes-unstable branch
Message-Id: <20250218040053.B3A82C4CEE6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memory-failure: update ttu flag inside unmap_poisoned_folio
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-failure-update-ttu-flag-inside-unmap_poisoned_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-update-ttu-flag-inside-unmap_poisoned_folio.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Ma Wupeng <mawupeng1@huawei.com>
Subject: mm: memory-failure: update ttu flag inside unmap_poisoned_folio
Date: Mon, 17 Feb 2025 09:43:27 +0800

Patch series "mm: memory_failure: unmap poisoned folio during migrate
properly", v3.

Fix two bugs during folio migration if the folio is poisoned.


This patch (of 3):

Commit 6da6b1d4a7df ("mm/hwpoison: convert TTU_IGNORE_HWPOISON to
TTU_HWPOISON") introduce TTU_HWPOISON to replace TTU_IGNORE_HWPOISON in
order to stop send SIGBUS signal when accessing an error page after a
memory error on a clean folio.  However during page migration, anon folio
must be set with TTU_HWPOISON during unmap_*().  For pagecache we need
some policy just like the one in hwpoison_user_mappings to set this flag. 
So move this policy from hwpoison_user_mappings to unmap_poisoned_folio to
handle this warning properly.

Warning will be produced during unamp poison folio with the following log:

  ------------[ cut here ]------------
  WARNING: CPU: 1 PID: 365 at mm/rmap.c:1847 try_to_unmap_one+0x8fc/0xd3c
  Modules linked in:
  CPU: 1 UID: 0 PID: 365 Comm: bash Tainted: G        W          6.13.0-rc1-00018-gacdb4bbda7ab #42
  Tainted: [W]=WARN
  Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
  pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : try_to_unmap_one+0x8fc/0xd3c
  lr : try_to_unmap_one+0x3dc/0xd3c
  Call trace:
   try_to_unmap_one+0x8fc/0xd3c (P)
   try_to_unmap_one+0x3dc/0xd3c (L)
   rmap_walk_anon+0xdc/0x1f8
   rmap_walk+0x3c/0x58
   try_to_unmap+0x88/0x90
   unmap_poisoned_folio+0x30/0xa8
   do_migrate_range+0x4a0/0x568
   offline_pages+0x5a4/0x670
   memory_block_action+0x17c/0x374
   memory_subsys_offline+0x3c/0x78
   device_offline+0xa4/0xd0
   state_store+0x8c/0xf0
   dev_attr_store+0x18/0x2c
   sysfs_kf_write+0x44/0x54
   kernfs_fop_write_iter+0x118/0x1a8
   vfs_write+0x3a8/0x4bc
   ksys_write+0x6c/0xf8
   __arm64_sys_write+0x1c/0x28
   invoke_syscall+0x44/0x100
   el0_svc_common.constprop.0+0x40/0xe0
   do_el0_svc+0x1c/0x28
   el0_svc+0x30/0xd0
   el0t_64_sync_handler+0xc8/0xcc
   el0t_64_sync+0x198/0x19c
  ---[ end trace 0000000000000000 ]---

Link: https://lkml.kernel.org/r/20250217014329.3610326-1-mawupeng1@huawei.com
Link: https://lkml.kernel.org/r/20250217014329.3610326-2-mawupeng1@huawei.com
Fixes: 6da6b1d4a7df ("mm/hwpoison: convert TTU_IGNORE_HWPOISON to TTU_HWPOISON")
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Ma Wupeng <mawupeng1@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h       |    5 ++-
 mm/memory-failure.c |   61 +++++++++++++++++++++---------------------
 mm/memory_hotplug.c |    3 +-
 3 files changed, 36 insertions(+), 33 deletions(-)

--- a/mm/internal.h~mm-memory-failure-update-ttu-flag-inside-unmap_poisoned_folio
+++ a/mm/internal.h
@@ -1115,7 +1115,7 @@ static inline int find_next_best_node(in
  * mm/memory-failure.c
  */
 #ifdef CONFIG_MEMORY_FAILURE
-void unmap_poisoned_folio(struct folio *folio, enum ttu_flags ttu);
+int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, bool must_kill);
 void shake_folio(struct folio *folio);
 extern int hwpoison_filter(struct page *p);
 
@@ -1138,8 +1138,9 @@ unsigned long page_mapped_in_vma(const s
 		struct vm_area_struct *vma);
 
 #else
-static inline void unmap_poisoned_folio(struct folio *folio, enum ttu_flags ttu)
+static inline int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, bool must_kill)
 {
+	return -EBUSY;
 }
 #endif
 
--- a/mm/memory-failure.c~mm-memory-failure-update-ttu-flag-inside-unmap_poisoned_folio
+++ a/mm/memory-failure.c
@@ -1556,8 +1556,34 @@ static int get_hwpoison_page(struct page
 	return ret;
 }
 
-void unmap_poisoned_folio(struct folio *folio, enum ttu_flags ttu)
+int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, bool must_kill)
 {
+	enum ttu_flags ttu = TTU_IGNORE_MLOCK | TTU_SYNC | TTU_HWPOISON;
+	struct address_space *mapping;
+
+	if (folio_test_swapcache(folio)) {
+		pr_err("%#lx: keeping poisoned page in swap cache\n", pfn);
+		ttu &= ~TTU_HWPOISON;
+	}
+
+	/*
+	 * Propagate the dirty bit from PTEs to struct page first, because we
+	 * need this to decide if we should kill or just drop the page.
+	 * XXX: the dirty test could be racy: set_page_dirty() may not always
+	 * be called inside page lock (it's recommended but not enforced).
+	 */
+	mapping = folio_mapping(folio);
+	if (!must_kill && !folio_test_dirty(folio) && mapping &&
+	    mapping_can_writeback(mapping)) {
+		if (folio_mkclean(folio)) {
+			folio_set_dirty(folio);
+		} else {
+			ttu &= ~TTU_HWPOISON;
+			pr_info("%#lx: corrupted page was clean: dropped without side effects\n",
+				pfn);
+		}
+	}
+
 	if (folio_test_hugetlb(folio) && !folio_test_anon(folio)) {
 		struct address_space *mapping;
 
@@ -1572,7 +1598,7 @@ void unmap_poisoned_folio(struct folio *
 		if (!mapping) {
 			pr_info("%#lx: could not lock mapping for mapped hugetlb folio\n",
 				folio_pfn(folio));
-			return;
+			return -EBUSY;
 		}
 
 		try_to_unmap(folio, ttu|TTU_RMAP_LOCKED);
@@ -1580,6 +1606,8 @@ void unmap_poisoned_folio(struct folio *
 	} else {
 		try_to_unmap(folio, ttu);
 	}
+
+	return folio_mapped(folio) ? -EBUSY : 0;
 }
 
 /*
@@ -1589,8 +1617,6 @@ void unmap_poisoned_folio(struct folio *
 static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
 		unsigned long pfn, int flags)
 {
-	enum ttu_flags ttu = TTU_IGNORE_MLOCK | TTU_SYNC | TTU_HWPOISON;
-	struct address_space *mapping;
 	LIST_HEAD(tokill);
 	bool unmap_success;
 	int forcekill;
@@ -1613,29 +1639,6 @@ static bool hwpoison_user_mappings(struc
 	if (!folio_mapped(folio))
 		return true;
 
-	if (folio_test_swapcache(folio)) {
-		pr_err("%#lx: keeping poisoned page in swap cache\n", pfn);
-		ttu &= ~TTU_HWPOISON;
-	}
-
-	/*
-	 * Propagate the dirty bit from PTEs to struct page first, because we
-	 * need this to decide if we should kill or just drop the page.
-	 * XXX: the dirty test could be racy: set_page_dirty() may not always
-	 * be called inside page lock (it's recommended but not enforced).
-	 */
-	mapping = folio_mapping(folio);
-	if (!(flags & MF_MUST_KILL) && !folio_test_dirty(folio) && mapping &&
-	    mapping_can_writeback(mapping)) {
-		if (folio_mkclean(folio)) {
-			folio_set_dirty(folio);
-		} else {
-			ttu &= ~TTU_HWPOISON;
-			pr_info("%#lx: corrupted page was clean: dropped without side effects\n",
-				pfn);
-		}
-	}
-
 	/*
 	 * First collect all the processes that have the page
 	 * mapped in dirty form.  This has to be done before try_to_unmap,
@@ -1643,9 +1646,7 @@ static bool hwpoison_user_mappings(struc
 	 */
 	collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
 
-	unmap_poisoned_folio(folio, ttu);
-
-	unmap_success = !folio_mapped(folio);
+	unmap_success = !unmap_poisoned_folio(folio, pfn, flags & MF_MUST_KILL);
 	if (!unmap_success)
 		pr_err("%#lx: failed to unmap page (folio mapcount=%d)\n",
 		       pfn, folio_mapcount(folio));
--- a/mm/memory_hotplug.c~mm-memory-failure-update-ttu-flag-inside-unmap_poisoned_folio
+++ a/mm/memory_hotplug.c
@@ -1833,7 +1833,8 @@ static void do_migrate_range(unsigned lo
 			if (WARN_ON(folio_test_lru(folio)))
 				folio_isolate_lru(folio);
 			if (folio_mapped(folio))
-				unmap_poisoned_folio(folio, TTU_IGNORE_MLOCK);
+				unmap_poisoned_folio(folio, pfn, false);
+
 			continue;
 		}
 
_

Patches currently in -mm which might be from mawupeng1@huawei.com are

mm-memory-failure-update-ttu-flag-inside-unmap_poisoned_folio.patch
mm-memory-hotplug-check-folio-ref-count-first-in-do_migrate_range.patch
hwpoison-memory_hotplug-lock-folio-before-unmap-hwpoisoned-folio.patch


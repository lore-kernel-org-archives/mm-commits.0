Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489DE23E334
	for <mm-commits@vger.kernel.org>; Sat, 28 Feb 2026 20:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772308940; cv=none; b=KDQ2bMqNTtqe3GP/kPvumOiN3d3EViH/I7Ipos5o4DuMP4Bv9ZnbnaSRBsbIQc/mw0vhs7PszLUgBdQ+WN7wKMa4e0PZctFT29tGfMKJG9+LkNC0Hf3HSlBlDcW8kt1CZuEp2g7j5bGDaGnWKJpDqWWtP8I/yKVH3sgHFtUakdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772308940; c=relaxed/simple;
	bh=AsSrRQYVdPsSQAFd4r2YYJOeWjHn7mmOL/2OAH76ZEo=;
	h=Date:To:From:Subject:Message-Id; b=V3BIW0Fs7JzqYQl23Q7SpyZVcaGwgj5SbsNIwzB19wDAgqOl/o4KTB+OaUo0idR/MoBxbmaEHq/qySWxlGTa2IJBnGpK/bMissCk209Jkt01767yHxqgmJnHB+29BRBLRcY0rR126e3A+oZ5+9jgZnHNZcsv3HR/Ya+2eBSFo+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jJey/bw6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jJey/bw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0790C116D0;
	Sat, 28 Feb 2026 20:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772308939;
	bh=AsSrRQYVdPsSQAFd4r2YYJOeWjHn7mmOL/2OAH76ZEo=;
	h=Date:To:From:Subject:From;
	b=jJey/bw66VzMOreccqE6BavSXjstsyVXpODHKjqdcXkiZG2ZCspVzETQ0horerubm
	 qJrIXuuVJopNfF8s9XdiUa+EQcG3Z1xiDk2nwo/tmQ75cMEhJnp/84RE3FPlKD1ufb
	 fHyJy0NXJ6ESPH88yeDBjFyszmBw8s+gjR2uZeAI=
Date: Sat, 28 Feb 2026 12:02:19 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,willy@infradead.org,will@kernel.org,weixugc@google.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,axelrasmussen@google.com,apopple@nvidia.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-ptep-pmdp_clear_young_notify-to-ptep-pmdp_test_and_clear_young_notify.patch added to mm-new branch
Message-Id: <20260228200219.D0790C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rename ptep/pmdp_clear_young_notify() to ptep/pmdp_test_and_clear_young_notify()
has been added to the -mm mm-new branch.  Its filename is
     mm-rename-ptep-pmdp_clear_young_notify-to-ptep-pmdp_test_and_clear_young_notify.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rename-ptep-pmdp_clear_young_notify-to-ptep-pmdp_test_and_clear_young_notify.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: rename ptep/pmdp_clear_young_notify() to ptep/pmdp_test_and_clear_young_notify()
Date: Fri, 27 Feb 2026 17:44:36 +0800

Rename ptep/pmdp_clear_young_notify() to
ptep/pmdp_test_and_clear_young_notify() to make the function names
consistent.

Link: https://lkml.kernel.org/r/283d103c5131e32879bd847263c93b768df64d15.1772185080.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    8 ++++----
 mm/vmscan.c   |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/mm/internal.h~mm-rename-ptep-pmdp_clear_young_notify-to-ptep-pmdp_test_and_clear_young_notify
+++ a/mm/internal.h
@@ -1822,7 +1822,7 @@ static inline int pmdp_clear_flush_young
 	return young;
 }
 
-static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
+static inline int ptep_test_and_clear_young_notify(struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep)
 {
 	int young;
@@ -1832,7 +1832,7 @@ static inline int ptep_clear_young_notif
 	return young;
 }
 
-static inline int pmdp_clear_young_notify(struct vm_area_struct *vma,
+static inline int pmdp_test_and_clear_young_notify(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmdp)
 {
 	int young;
@@ -1846,8 +1846,8 @@ static inline int pmdp_clear_young_notif
 
 #define clear_flush_young_ptes_notify	clear_flush_young_ptes
 #define pmdp_clear_flush_young_notify	pmdp_clear_flush_young
-#define ptep_clear_young_notify	ptep_test_and_clear_young
-#define pmdp_clear_young_notify	pmdp_test_and_clear_young
+#define ptep_test_and_clear_young_notify	ptep_test_and_clear_young
+#define pmdp_test_and_clear_young_notify	pmdp_test_and_clear_young
 
 #endif /* CONFIG_MMU_NOTIFIER */
 
--- a/mm/vmscan.c~mm-rename-ptep-pmdp_clear_young_notify-to-ptep-pmdp_test_and_clear_young_notify
+++ a/mm/vmscan.c
@@ -3513,7 +3513,7 @@ restart:
 		if (!folio)
 			continue;
 
-		if (!ptep_clear_young_notify(args->vma, addr, pte + i))
+		if (!ptep_test_and_clear_young_notify(args->vma, addr, pte + i))
 			continue;
 
 		if (last != folio) {
@@ -3604,7 +3604,7 @@ static void walk_pmd_range_locked(pud_t
 		if (!folio)
 			goto next;
 
-		if (!pmdp_clear_young_notify(vma, addr, pmd + i))
+		if (!pmdp_test_and_clear_young_notify(vma, addr, pmd + i))
 			goto next;
 
 		if (last != folio) {
@@ -4194,7 +4194,7 @@ bool lru_gen_look_around(struct page_vma
 	lockdep_assert_held(pvmw->ptl);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
 
-	if (!ptep_clear_young_notify(vma, addr, pte))
+	if (!ptep_test_and_clear_young_notify(vma, addr, pte))
 		return false;
 
 	if (spin_is_contended(pvmw->ptl))
@@ -4246,7 +4246,7 @@ bool lru_gen_look_around(struct page_vma
 		if (!folio)
 			continue;
 
-		if (!ptep_clear_young_notify(vma, addr, pte + i))
+		if (!ptep_test_and_clear_young_notify(vma, addr, pte + i))
 			continue;
 
 		if (last != folio) {
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-use-inline-helper-functions-instead-of-ugly-macros.patch
mm-rename-ptep-pmdp_clear_young_notify-to-ptep-pmdp_test_and_clear_young_notify.patch
mm-rmap-add-a-zone_device-folio-warning-in-folio_referenced.patch
mm-add-a-batched-helper-to-clear-the-young-flag-for-large-folios.patch
mm-support-batched-checking-of-the-young-flag-for-mglru.patch
arm64-mm-implement-the-architecture-specific-test_and_clear_young_ptes.patch


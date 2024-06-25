Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558191448E5
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291674; cv=none; b=Rj3xkw4iBY083JAwzHWpOW3e6cB8iYb49T4RAYawlAuX2GvjXgg7yhH9Fk41rVyb0sIrItCIkSVJ1ZVPZvHMrtDMPLWyDIxBiiw045yfi6whTJtPZR0IXQXYI7eMTJIQUk5A/9S6G0d36Skf3ArCfaZW1NN15EIiLv2UkfQfAFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291674; c=relaxed/simple;
	bh=kfRHSZai3dHKfusgCEVKrhViF4esDBbMEwGmKteAbr8=;
	h=Date:To:From:Subject:Message-Id; b=LhI/xsbefsGQwnogNPMV3sWNds0miAta5cxe/N4BYCkgwd6KzWP1+rMA+g4pEkzYcOIbVAFx2cW4NmwsRCS8XVfBI+gOsr/6PRHEksV10YjfF4C94YkfDLvmG3ozW8rqHYnePOrzj3cHXS1rmXOIV66h5HNb5dqY5JKuac88Hes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q/myrM1Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q/myrM1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4E0C32789;
	Tue, 25 Jun 2024 05:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291673;
	bh=kfRHSZai3dHKfusgCEVKrhViF4esDBbMEwGmKteAbr8=;
	h=Date:To:From:Subject:From;
	b=q/myrM1Yv7YLROXy6YtvfktlaRZhh4Id6vDezHtjIbgpeIwpSnyijdhqBg6amPCHT
	 /HG7iHJPrI4HTWzIl/jKMphpD3H8z6j99fb6rbcXgb1Niipv0IHkVbnZiP3oCVINSB
	 ynIHQK1VpK0ZhNiOey8YMw3Ftn+gEFGeZQu/Wsfs=
Date: Mon, 24 Jun 2024 22:01:13 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,ryan.roberts@arm.com,minchan@kernel.org,kasong@tencent.com,david@redhat.com,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-pmdpte_needs_soft_dirty_wp-helpers-for-softdirty-write-protect.patch removed from -mm tree
Message-Id: <20240625050113.CE4E0C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce pmd|pte_needs_soft_dirty_wp helpers for softdirty write-protect
has been removed from the -mm tree.  Its filename was
     mm-introduce-pmdpte_needs_soft_dirty_wp-helpers-for-softdirty-write-protect.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: introduce pmd|pte_needs_soft_dirty_wp helpers for softdirty write-protect
Date: Sat, 8 Jun 2024 09:13:57 +1200

Patch series "mm: introduce pmd|pte_needs_soft_dirty_wp helpers and
utilize them", v2.


This patchset introduces the pte_need_soft_dirty_wp and
pmd_need_soft_dirty_wp helpers to determine if write protection is
required for softdirty tracking.  These helpers enhance code readability
and improve the overall appearance.

They are then utilized in gup, mprotect, swap, and other related
functions.


This patch (of 2): 

This patch introduces the pte_needs_soft_dirty_wp and
pmd_needs_soft_dirty_wp helpers to determine if write protection is
required for softdirty tracking.  This can enhance code readability and
improve its overall appearance.  These new helpers are then utilized in
gup, huge_memory, and mprotect.

Link: https://lkml.kernel.org/r/20240607211358.4660-1-21cnbao@gmail.com
Link: https://lkml.kernel.org/r/20240607211358.4660-2-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c         |    4 ++--
 mm/huge_memory.c |    2 +-
 mm/internal.h    |   10 ++++++++++
 mm/mprotect.c    |    2 +-
 4 files changed, 14 insertions(+), 4 deletions(-)

--- a/mm/gup.c~mm-introduce-pmdpte_needs_soft_dirty_wp-helpers-for-softdirty-write-protect
+++ a/mm/gup.c
@@ -771,7 +771,7 @@ static inline bool can_follow_write_pmd(
 		return false;
 
 	/* ... and a write-fault isn't required for other reasons. */
-	if (vma_soft_dirty_enabled(vma) && !pmd_soft_dirty(pmd))
+	if (pmd_needs_soft_dirty_wp(vma, pmd))
 		return false;
 	return !userfaultfd_huge_pmd_wp(vma, pmd);
 }
@@ -892,7 +892,7 @@ static inline bool can_follow_write_pte(
 		return false;
 
 	/* ... and a write-fault isn't required for other reasons. */
-	if (vma_soft_dirty_enabled(vma) && !pte_soft_dirty(pte))
+	if (pte_needs_soft_dirty_wp(vma, pte))
 		return false;
 	return !userfaultfd_pte_wp(vma, pte);
 }
--- a/mm/huge_memory.c~mm-introduce-pmdpte_needs_soft_dirty_wp-helpers-for-softdirty-write-protect
+++ a/mm/huge_memory.c
@@ -1626,7 +1626,7 @@ static inline bool can_change_pmd_writab
 		return false;
 
 	/* Do we need write faults for softdirty tracking? */
-	if (vma_soft_dirty_enabled(vma) && !pmd_soft_dirty(pmd))
+	if (pmd_needs_soft_dirty_wp(vma, pmd))
 		return false;
 
 	/* Do we need write faults for uffd-wp tracking? */
--- a/mm/internal.h~mm-introduce-pmdpte_needs_soft_dirty_wp-helpers-for-softdirty-write-protect
+++ a/mm/internal.h
@@ -1348,6 +1348,16 @@ static inline bool vma_soft_dirty_enable
 	return !(vma->vm_flags & VM_SOFTDIRTY);
 }
 
+static inline bool pmd_needs_soft_dirty_wp(struct vm_area_struct *vma, pmd_t pmd)
+{
+	return vma_soft_dirty_enabled(vma) && !pmd_soft_dirty(pmd);
+}
+
+static inline bool pte_needs_soft_dirty_wp(struct vm_area_struct *vma, pte_t pte)
+{
+	return vma_soft_dirty_enabled(vma) && !pte_soft_dirty(pte);
+}
+
 static inline void vma_iter_config(struct vma_iterator *vmi,
 		unsigned long index, unsigned long last)
 {
--- a/mm/mprotect.c~mm-introduce-pmdpte_needs_soft_dirty_wp-helpers-for-softdirty-write-protect
+++ a/mm/mprotect.c
@@ -53,7 +53,7 @@ bool can_change_pte_writable(struct vm_a
 		return false;
 
 	/* Do we need write faults for softdirty tracking? */
-	if (vma_soft_dirty_enabled(vma) && !pte_soft_dirty(pte))
+	if (pte_needs_soft_dirty_wp(vma, pte))
 		return false;
 
 	/* Do we need write faults for uffd-wp tracking? */
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-2.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-3.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-2.patch
mm-remove-folio_test_anonfolio==false-path-in-__folio_add_anon_rmap.patch
tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout.patch


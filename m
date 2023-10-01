Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB714E78488
	for <mm-commits@archiver.kernel.org>; Sun,  1 Oct 2023 19:56:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235356AbjJAT45 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Oct 2023 15:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235363AbjJAT4w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 1 Oct 2023 15:56:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A4F91
        for <mm-commits@vger.kernel.org>; Sun,  1 Oct 2023 12:56:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6ACC433C7;
        Sun,  1 Oct 2023 19:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696190208;
        bh=YRhF3+ubL3NE3IpVAS2ituwbXQhP+/dCGLZ9naSqrC8=;
        h=Date:To:From:Subject:From;
        b=DUHc8esinWVamWe07FEkX9QIKe9SmUPFmB2WY/9vlRVuxQO0IL5fFiMKbgJm9m9Kj
         6EjCQqNxVEnFbOBjtupMVtc/FXm/4icG/qzpFf0gmfzwGblKcfPKeB+cI1e5qwBoRe
         4axjpgwLXEgolALegX2Fo8NqGrObr1YDdNOr9yBA=
Date:   Sun, 01 Oct 2023 12:56:48 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tim.c.chen@intel.com, jack@suse.cz, hannes@cmpxchg.org,
        djwong@kernel.org, dchinner@redhat.com, chuck.lever@oracle.com,
        cem@kernel.org, brauner@kernel.org, axelrasmussen@google.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-move-memcg-charge-out-of-shmem_add_to_page_cache.patch added to mm-unstable branch
Message-Id: <20231001195648.9A6ACC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: move memcg charge out of shmem_add_to_page_cache()
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-move-memcg-charge-out-of-shmem_add_to_page_cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-move-memcg-charge-out-of-shmem_add_to_page_cache.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: shmem: move memcg charge out of shmem_add_to_page_cache()
Date: Fri, 29 Sep 2023 20:31:27 -0700 (PDT)

Extract shmem's memcg charging out of shmem_add_to_page_cache(): it's
misleading done there, because many calls are dealing with a swapcache
page, whose memcg is nowadays always remembered while swapped out, then
the charge re-levied when it's brought back into swapcache.

Temporarily move it back up to the shmem_get_folio_gfp() level, where the
memcg was charged before v5.8; but the next commit goes on to move it back
down to a new home.

In making this change, it becomes clear that shmem_swapin_folio() does not
need to know the vma, just the fault mm (if any): call it fault_mm rather
than charge_mm - let mem_cgroup_charge() decide whom to charge.

Link: https://lkml.kernel.org/r/4b2143c5-bf32-64f0-841-81a81158dac@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Carlos Maiolino <cem@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Tim Chen <tim.c.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   68 +++++++++++++++++++++------------------------------
 1 file changed, 29 insertions(+), 39 deletions(-)

--- a/mm/shmem.c~shmem-move-memcg-charge-out-of-shmem_add_to_page_cache
+++ a/mm/shmem.c
@@ -146,9 +146,8 @@ static unsigned long shmem_default_max_i
 #endif
 
 static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
-			     struct folio **foliop, enum sgp_type sgp,
-			     gfp_t gfp, struct vm_area_struct *vma,
-			     vm_fault_t *fault_type);
+			struct folio **foliop, enum sgp_type sgp, gfp_t gfp,
+			struct mm_struct *fault_mm, vm_fault_t *fault_type);
 
 static inline struct shmem_sb_info *SHMEM_SB(struct super_block *sb)
 {
@@ -760,12 +759,10 @@ static unsigned long shmem_unused_huge_s
  */
 static int shmem_add_to_page_cache(struct folio *folio,
 				   struct address_space *mapping,
-				   pgoff_t index, void *expected, gfp_t gfp,
-				   struct mm_struct *charge_mm)
+				   pgoff_t index, void *expected, gfp_t gfp)
 {
 	XA_STATE_ORDER(xas, &mapping->i_pages, index, folio_order(folio));
 	long nr = folio_nr_pages(folio);
-	int error;
 
 	VM_BUG_ON_FOLIO(index != round_down(index, nr), folio);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -776,16 +773,7 @@ static int shmem_add_to_page_cache(struc
 	folio->mapping = mapping;
 	folio->index = index;
 
-	if (!folio_test_swapcache(folio)) {
-		error = mem_cgroup_charge(folio, charge_mm, gfp);
-		if (error) {
-			if (folio_test_pmd_mappable(folio)) {
-				count_vm_event(THP_FILE_FALLBACK);
-				count_vm_event(THP_FILE_FALLBACK_CHARGE);
-			}
-			goto error;
-		}
-	}
+	gfp &= GFP_RECLAIM_MASK;
 	folio_throttle_swaprate(folio, gfp);
 
 	do {
@@ -813,15 +801,12 @@ unlock:
 	} while (xas_nomem(&xas, gfp));
 
 	if (xas_error(&xas)) {
-		error = xas_error(&xas);
-		goto error;
+		folio->mapping = NULL;
+		folio_ref_sub(folio, nr);
+		return xas_error(&xas);
 	}
 
 	return 0;
-error:
-	folio->mapping = NULL;
-	folio_ref_sub(folio, nr);
-	return error;
 }
 
 /*
@@ -1341,10 +1326,8 @@ static int shmem_unuse_swap_entries(stru
 
 		if (!xa_is_value(folio))
 			continue;
-		error = shmem_swapin_folio(inode, indices[i],
-					  &folio, SGP_CACHE,
-					  mapping_gfp_mask(mapping),
-					  NULL, NULL);
+		error = shmem_swapin_folio(inode, indices[i], &folio, SGP_CACHE,
+					mapping_gfp_mask(mapping), NULL, NULL);
 		if (error == 0) {
 			folio_unlock(folio);
 			folio_put(folio);
@@ -1827,12 +1810,11 @@ static void shmem_set_folio_swapin_error
  */
 static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			     struct folio **foliop, enum sgp_type sgp,
-			     gfp_t gfp, struct vm_area_struct *vma,
+			     gfp_t gfp, struct mm_struct *fault_mm,
 			     vm_fault_t *fault_type)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
-	struct mm_struct *charge_mm = vma ? vma->vm_mm : NULL;
 	struct swap_info_struct *si;
 	struct folio *folio = NULL;
 	swp_entry_t swap;
@@ -1860,7 +1842,7 @@ static int shmem_swapin_folio(struct ino
 		if (fault_type) {
 			*fault_type |= VM_FAULT_MAJOR;
 			count_vm_event(PGMAJFAULT);
-			count_memcg_event_mm(charge_mm, PGMAJFAULT);
+			count_memcg_event_mm(fault_mm, PGMAJFAULT);
 		}
 		/* Here we actually start the io */
 		folio = shmem_swapin(swap, gfp, info, index);
@@ -1897,8 +1879,7 @@ static int shmem_swapin_folio(struct ino
 	}
 
 	error = shmem_add_to_page_cache(folio, mapping, index,
-					swp_to_radix_entry(swap), gfp,
-					charge_mm);
+					swp_to_radix_entry(swap), gfp);
 	if (error)
 		goto failed;
 
@@ -1946,7 +1927,7 @@ static int shmem_get_folio_gfp(struct in
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo;
-	struct mm_struct *charge_mm;
+	struct mm_struct *fault_mm;
 	struct folio *folio;
 	pgoff_t hindex;
 	gfp_t huge_gfp;
@@ -1963,7 +1944,7 @@ repeat:
 	}
 
 	sbinfo = SHMEM_SB(inode->i_sb);
-	charge_mm = vma ? vma->vm_mm : NULL;
+	fault_mm = vma ? vma->vm_mm : NULL;
 
 	folio = filemap_get_entry(mapping, index);
 	if (folio && vma && userfaultfd_minor(vma)) {
@@ -1975,7 +1956,7 @@ repeat:
 
 	if (xa_is_value(folio)) {
 		error = shmem_swapin_folio(inode, index, &folio,
-					  sgp, gfp, vma, fault_type);
+					   sgp, gfp, fault_mm, fault_type);
 		if (error == -EEXIST)
 			goto repeat;
 
@@ -2061,9 +2042,16 @@ alloc_nohuge:
 	if (sgp == SGP_WRITE)
 		__folio_set_referenced(folio);
 
-	error = shmem_add_to_page_cache(folio, mapping, hindex,
-					NULL, gfp & GFP_RECLAIM_MASK,
-					charge_mm);
+	error = mem_cgroup_charge(folio, fault_mm, gfp);
+	if (error) {
+		if (folio_test_pmd_mappable(folio)) {
+			count_vm_event(THP_FILE_FALLBACK);
+			count_vm_event(THP_FILE_FALLBACK_CHARGE);
+		}
+		goto unacct;
+	}
+
+	error = shmem_add_to_page_cache(folio, mapping, hindex, NULL, gfp);
 	if (error)
 		goto unacct;
 
@@ -2661,8 +2649,10 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pm
 	if (unlikely(pgoff >= max_off))
 		goto out_release;
 
-	ret = shmem_add_to_page_cache(folio, mapping, pgoff, NULL,
-				      gfp & GFP_RECLAIM_MASK, dst_vma->vm_mm);
+	ret = mem_cgroup_charge(folio, dst_vma->vm_mm, gfp);
+	if (ret)
+		goto out_release;
+	ret = shmem_add_to_page_cache(folio, mapping, pgoff, NULL, gfp);
 	if (ret)
 		goto out_release;
 
_

Patches currently in -mm which might be from hughd@google.com are

shmem-shrink-shmem_inode_info-dir_offsets-in-a-union.patch
shmem-remove-vma-arg-from-shmem_get_folio_gfp.patch
shmem-factor-shmem_falloc_wait-out-of-shmem_fault.patch
shmem-trivial-tidyups-removing-extra-blank-lines-etc.patch
shmem-shmem_acct_blocks-and-shmem_inode_acct_blocks.patch
shmem-move-memcg-charge-out-of-shmem_add_to_page_cache.patch
shmem-_add_to_page_cache-before-shmem_inode_acct_blocks.patch
shmempercpu_counter-add-_limited_addfbc-limit-amount.patch


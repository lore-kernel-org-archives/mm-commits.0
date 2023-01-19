Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A581CC38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbjASBVg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:21:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjASBT5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:19:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65056CCD0
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8599361B08
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1426C433D2;
        Thu, 19 Jan 2023 01:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090995;
        bh=9Qkg48Cs+j41e5z502BoRQi97fVuUrOfpa/h4Ka8bWI=;
        h=Date:To:From:Subject:From;
        b=0gOZ9aOnk1yd4L3xcbswXliltB+CgMSDnbprAPs9nVfGy1nWAcfuoy7yaUFw23BH7
         Sy3vH7zq7B9ZOl85Z//V/5UaO/dhFhMb/z+0fBGBSav5MQrLiKbhT1shqi0uxEVQIh
         o+WfZCSG1sIVOrxf2exEFRdSl6p6N1f1VN1tlrwE=
Date:   Wed, 18 Jan 2023 17:16:34 -0800
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        Michael@MichaelLarabel.com, hannes@cmpxchg.org,
        andrea.righi@canonical.com, yuzhao@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-vma_has_recency.patch removed from -mm tree
Message-Id: <20230119011634.E1426C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add vma_has_recency()
has been removed from the -mm tree.  Its filename was
     mm-add-vma_has_recency.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm: add vma_has_recency()
Date: Fri, 30 Dec 2022 14:52:51 -0700

Add vma_has_recency() to indicate whether a VMA may exhibit temporal
locality that the LRU algorithm relies on.

This function returns false for VMAs marked by VM_SEQ_READ or
VM_RAND_READ.  While the former flag indicates linear access, i.e., a
special case of spatial locality, both flags indicate a lack of temporal
locality, i.e., the reuse of an area within a relatively small duration.

"Recency" is chosen over "locality" to avoid confusion between temporal
and spatial localities.

Before this patch, the active/inactive LRU only ignored the accessed bit
from VMAs marked by VM_SEQ_READ.  After this patch, the active/inactive
LRU and MGLRU share the same logic: they both ignore the accessed bit if
vma_has_recency() returns false.

For the active/inactive LRU, the following fio test showed a [6, 8]%
increase in IOPS when randomly accessing mapped files under memory
pressure.

  kb=$(awk '/MemTotal/ { print $2 }' /proc/meminfo)
  kb=$((kb - 8*1024*1024))

  modprobe brd rd_nr=1 rd_size=$kb
  dd if=/dev/zero of=/dev/ram0 bs=1M

  mkfs.ext4 /dev/ram0
  mount /dev/ram0 /mnt/
  swapoff -a

  fio --name=test --directory=/mnt/ --ioengine=mmap --numjobs=8 \
      --size=8G --rw=randrw --time_based --runtime=10m \
      --group_reporting

The discussion that led to this patch is here [1].  Additional test
results are available in that thread.

[1] https://lore.kernel.org/r/Y31s%2FK8T85jh05wH@google.com/

Link: https://lkml.kernel.org/r/20221230215252.2628425-1-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Righi <andrea.righi@canonical.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michael Larabel <Michael@MichaelLarabel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    8 ++++++
 mm/memory.c               |    7 ++----
 mm/rmap.c                 |   42 +++++++++++++++---------------------
 mm/vmscan.c               |    5 +++-
 4 files changed, 33 insertions(+), 29 deletions(-)

--- a/include/linux/mm_inline.h~mm-add-vma_has_recency
+++ a/include/linux/mm_inline.h
@@ -594,4 +594,12 @@ pte_install_uffd_wp_if_needed(struct vm_
 #endif
 }
 
+static inline bool vma_has_recency(struct vm_area_struct *vma)
+{
+	if (vma->vm_flags & (VM_SEQ_READ | VM_RAND_READ))
+		return false;
+
+	return true;
+}
+
 #endif
--- a/mm/memory.c~mm-add-vma_has_recency
+++ a/mm/memory.c
@@ -1402,8 +1402,7 @@ again:
 						force_flush = 1;
 					}
 				}
-				if (pte_young(ptent) &&
-				    likely(!(vma->vm_flags & VM_SEQ_READ)))
+				if (pte_young(ptent) && likely(vma_has_recency(vma)))
 					mark_page_accessed(page);
 			}
 			rss[mm_counter(page)]--;
@@ -5115,8 +5114,8 @@ static inline void mm_account_fault(stru
 #ifdef CONFIG_LRU_GEN
 static void lru_gen_enter_fault(struct vm_area_struct *vma)
 {
-	/* the LRU algorithm doesn't apply to sequential or random reads */
-	current->in_lru_fault = !(vma->vm_flags & (VM_SEQ_READ | VM_RAND_READ));
+	/* the LRU algorithm only applies to accesses with recency */
+	current->in_lru_fault = vma_has_recency(vma);
 }
 
 static void lru_gen_exit_fault(void)
--- a/mm/rmap.c~mm-add-vma_has_recency
+++ a/mm/rmap.c
@@ -823,25 +823,14 @@ static bool folio_referenced_one(struct
 		}
 
 		if (pvmw.pte) {
-			if (lru_gen_enabled() && pte_young(*pvmw.pte) &&
-			    !(vma->vm_flags & (VM_SEQ_READ | VM_RAND_READ))) {
+			if (lru_gen_enabled() && pte_young(*pvmw.pte)) {
 				lru_gen_look_around(&pvmw);
 				referenced++;
 			}
 
 			if (ptep_clear_flush_young_notify(vma, address,
-						pvmw.pte)) {
-				/*
-				 * Don't treat a reference through
-				 * a sequentially read mapping as such.
-				 * If the folio has been used in another mapping,
-				 * we will catch it; if this other mapping is
-				 * already gone, the unmap path will have set
-				 * the referenced flag or activated the folio.
-				 */
-				if (likely(!(vma->vm_flags & VM_SEQ_READ)))
-					referenced++;
-			}
+						pvmw.pte))
+				referenced++;
 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 			if (pmdp_clear_flush_young_notify(vma, address,
 						pvmw.pmd))
@@ -875,7 +864,20 @@ static bool invalid_folio_referenced_vma
 	struct folio_referenced_arg *pra = arg;
 	struct mem_cgroup *memcg = pra->memcg;
 
-	if (!mm_match_cgroup(vma->vm_mm, memcg))
+	/*
+	 * Ignore references from this mapping if it has no recency. If the
+	 * folio has been used in another mapping, we will catch it; if this
+	 * other mapping is already gone, the unmap path will have set the
+	 * referenced flag or activated the folio in zap_pte_range().
+	 */
+	if (!vma_has_recency(vma))
+		return true;
+
+	/*
+	 * If we are reclaiming on behalf of a cgroup, skip counting on behalf
+	 * of references from different cgroups.
+	 */
+	if (memcg && !mm_match_cgroup(vma->vm_mm, memcg))
 		return true;
 
 	return false;
@@ -906,6 +908,7 @@ int folio_referenced(struct folio *folio
 		.arg = (void *)&pra,
 		.anon_lock = folio_lock_anon_vma_read,
 		.try_lock = true,
+		.invalid_vma = invalid_folio_referenced_vma,
 	};
 
 	*vm_flags = 0;
@@ -921,15 +924,6 @@ int folio_referenced(struct folio *folio
 			return 1;
 	}
 
-	/*
-	 * If we are reclaiming on behalf of a cgroup, skip
-	 * counting on behalf of references from different
-	 * cgroups
-	 */
-	if (memcg) {
-		rwc.invalid_vma = invalid_folio_referenced_vma;
-	}
-
 	rmap_walk(folio, &rwc);
 	*vm_flags = pra.vm_flags;
 
--- a/mm/vmscan.c~mm-add-vma_has_recency
+++ a/mm/vmscan.c
@@ -3794,7 +3794,10 @@ static int should_skip_vma(unsigned long
 	if (is_vm_hugetlb_page(vma))
 		return true;
 
-	if (vma->vm_flags & (VM_LOCKED | VM_SPECIAL | VM_SEQ_READ | VM_RAND_READ))
+	if (!vma_has_recency(vma))
+		return true;
+
+	if (vma->vm_flags & (VM_LOCKED | VM_SPECIAL))
 		return true;
 
 	if (vma == get_gate_vma(vma->vm_mm))
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-multi-gen-lru-fix-crash-during-cgroup-migration.patch


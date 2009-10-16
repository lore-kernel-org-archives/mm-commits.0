From: akpm@linux-foundation.org
Subject: + mm-dont-call-pte_unmap-against-an-improper-pte.patch added to -mm tree
Date: Fri, 16 Oct 2009 15:32:31 -0700
Message-ID: <200910162232.n9GMWVhV026677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751560AbZJPWcj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Oct 2009 18:32:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm: don't call pte_unmap() against an improper pte
has been added to the -mm tree.  Its filename is
     mm-dont-call-pte_unmap-against-an-improper-pte.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: don't call pte_unmap() against an improper pte
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

There are some places where we do like:

	pte = pte_map();
	do {
		(do break in some conditions)
	} while (pte++, ...);
	pte_unmap(pte - 1);

But if the loop breaks at the first loop, pte_unmap() unmaps invalid pte.

This patch is a fix for this problem.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewd-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/memory.c~mm-dont-call-pte_unmap-against-an-improper-pte mm/memory.c
--- a/mm/memory.c~mm-dont-call-pte_unmap-against-an-improper-pte
+++ a/mm/memory.c
@@ -641,6 +641,7 @@ static int copy_pte_range(struct mm_stru
 		pmd_t *dst_pmd, pmd_t *src_pmd, struct vm_area_struct *vma,
 		unsigned long addr, unsigned long end)
 {
+	pte_t *orig_src_pte, *orig_dst_pte;
 	pte_t *src_pte, *dst_pte;
 	spinlock_t *src_ptl, *dst_ptl;
 	int progress = 0;
@@ -654,6 +655,8 @@ again:
 	src_pte = pte_offset_map_nested(src_pmd, addr);
 	src_ptl = pte_lockptr(src_mm, src_pmd);
 	spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
+	orig_src_pte = src_pte;
+	orig_dst_pte = dst_pte;
 	arch_enter_lazy_mmu_mode();
 
 	do {
@@ -677,9 +680,9 @@ again:
 
 	arch_leave_lazy_mmu_mode();
 	spin_unlock(src_ptl);
-	pte_unmap_nested(src_pte - 1);
+	pte_unmap_nested(orig_src_pte);
 	add_mm_rss(dst_mm, rss[0], rss[1]);
-	pte_unmap_unlock(dst_pte - 1, dst_ptl);
+	pte_unmap_unlock(orig_dst_pte, dst_ptl);
 	cond_resched();
 	if (addr != end)
 		goto again;
@@ -1820,10 +1823,10 @@ static int apply_to_pte_range(struct mm_
 	token = pmd_pgtable(*pmd);
 
 	do {
-		err = fn(pte, token, addr, data);
+		err = fn(pte++, token, addr, data);
 		if (err)
 			break;
-	} while (pte++, addr += PAGE_SIZE, addr != end);
+	} while (addr += PAGE_SIZE, addr != end);
 
 	arch_leave_lazy_mmu_mode();
 
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

mm-dont-call-pte_unmap-against-an-improper-pte.patch
memcg-coalesce-uncharge-during-unmap-truncate.patch
memcg-coalesce-charging-via-percpu-storage.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
memcg-coalesce-charging-via-percpu-storage-fix-2.patch


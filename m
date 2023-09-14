Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E619EEEAA5D
	for <mm-commits@archiver.kernel.org>; Thu, 14 Sep 2023 18:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjINSOo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Sep 2023 14:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbjINSOn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2023 14:14:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8151FD5
        for <mm-commits@vger.kernel.org>; Thu, 14 Sep 2023 11:14:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250B1C433C7;
        Thu, 14 Sep 2023 18:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694715279;
        bh=kjQxeFhWEnlrDK69+bKyAkbPKsLLSI6zaXHhOkRAVdU=;
        h=Date:To:From:Subject:From;
        b=OxcxGIFPmw1wiUKpzYMUxSRrKRziRoUmB3My+wIcyNjgbscVLbNN6P6EQX0xPZiop
         qjMHJtzlVKTbGterxX2n9VE+VEiCJaylZA+s80TnoPAA1FRI2LfaqN8TmKiGlqGCqK
         9SR4WDafKNz+Zh0wkunXn8I5VK6sgZZ9Zi0HVXiA=
Date:   Thu, 14 Sep 2023 11:14:38 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, oliver.sang@intel.com, feng.tang@intel.com,
        fengwei.yin@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-add-filemap_map_order0_folio-to-handle-order0-folio.patch added to mm-hotfixes-unstable branch
Message-Id: <20230914181439.250B1C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: filemap: add filemap_map_order0_folio() to handle order0 folio
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     filemap-add-filemap_map_order0_folio-to-handle-order0-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-add-filemap_map_order0_folio-to-handle-order0-folio.patch

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
From: Yin Fengwei <fengwei.yin@intel.com>
Subject: filemap: add filemap_map_order0_folio() to handle order0 folio
Date: Thu, 14 Sep 2023 21:47:41 +0800

Kernel test robot reported regressions for several benchmarks [1].
The regression are related with commit:
de74976eb65151a2f568e477fc2e0032df5b22b4 ("filemap: add filemap_map_folio_range()")

It turned out that function filemap_map_folio_range() brings these
regressions when handle folio with order0.

Add filemap_map_order0_folio() to handle order0 folio. The benefit
come from two perspectives:
  - the code size is smaller (around 126 bytes)
  - no loop

Testing showed the regressions reported by 0day [1] all are fixed:
commit 9f1f5b60e76d44fa: parent commit of de74976eb65151a2
commit fbdf9263a3d7fdbd: latest mm-unstable commit
commit 7fbfe2003f84686d: this fixing patch

9f1f5b60e76d44fa fbdf9263a3d7fdbd            7fbfe2003f84686d
---------------- --------------------------- ---------------------------
   3843810           -21.4%    3020268            +4.6%    4018708      stress-ng.bad-altstack.ops
     64061           -21.4%      50336            +4.6%      66977      stress-ng.bad-altstack.ops_per_sec

   1709026           -14.4%    1462102            +2.4%    1750757      stress-ng.fork.ops
     28483           -14.4%      24368            +2.4%      29179      stress-ng.fork.ops_per_sec

   3685088           -53.6%    1710976            +0.5%    3702454      stress-ng.zombie.ops
     56732           -65.3%      19667            +0.7%      57107      stress-ng.zombie.ops_per_sec

     61874           -12.1%      54416            +0.4%      62136      vm-scalability.median
  13527663           -11.7%   11942117            -0.1%   13513946      vm-scalability.throughput
 4.066e+09           -11.7%   3.59e+09            -0.1%  4.061e+09      vm-scalability.workload

[1]:
https://lore.kernel.org/oe-lkp/72e017b9-deb6-44fa-91d6-716ee2c39cbc@intel.com/T/#m7d2bba30f75a9cee8eab07e5809abd9b3b206c84

Link: https://lkml.kernel.org/r/20230914134741.1937654-1-fengwei.yin@intel.com
Fixes: de74976eb65151a2f568e477fc2e0032df5b22b4 ("filemap: add filemap_map_folio_range()")
Signed-off-by: Yin Fengwei <fengwei.yin@intel.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202309111556.b2aa3d7a-oliver.sang@intel.com
Cc: Feng Tang <feng.tang@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   69 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 48 insertions(+), 21 deletions(-)

--- a/mm/filemap.c~filemap-add-filemap_map_order0_folio-to-handle-order0-folio
+++ a/mm/filemap.c
@@ -3475,13 +3475,11 @@ skip:
  */
 static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 			struct folio *folio, unsigned long start,
-			unsigned long addr, unsigned int nr_pages)
+			unsigned long addr, unsigned int nr_pages,
+			unsigned int *mmap_miss)
 {
 	vm_fault_t ret = 0;
-	struct vm_area_struct *vma = vmf->vma;
-	struct file *file = vma->vm_file;
 	struct page *page = folio_page(folio, start);
-	unsigned int mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
 	unsigned int count = 0;
 	pte_t *old_ptep = vmf->pte;
 
@@ -3489,8 +3487,7 @@ static vm_fault_t filemap_map_folio_rang
 		if (PageHWPoison(page + count))
 			goto skip;
 
-		if (mmap_miss > 0)
-			mmap_miss--;
+		(*mmap_miss)++;
 
 		/*
 		 * NOTE: If there're PTE markers, we'll leave them to be
@@ -3525,7 +3522,35 @@ skip:
 	}
 
 	vmf->pte = old_ptep;
-	WRITE_ONCE(file->f_ra.mmap_miss, mmap_miss);
+
+	return ret;
+}
+
+static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
+		struct folio *folio, unsigned long addr,
+		unsigned int *mmap_miss)
+{
+	vm_fault_t ret = 0;
+	struct page *page = &folio->page;
+
+	if (PageHWPoison(page))
+		return ret;
+
+	(*mmap_miss)++;
+
+	/*
+	 * NOTE: If there're PTE markers, we'll leave them to be
+	 * handled in the specific fault path, and it'll prohibit
+	 * the fault-around logic.
+	 */
+	if (!pte_none(ptep_get(vmf->pte)))
+		return ret;
+
+	if (vmf->address == addr)
+		ret = VM_FAULT_NOPAGE;
+
+	set_pte_range(vmf, folio, page, 1, addr);
+	folio_ref_inc(folio);
 
 	return ret;
 }
@@ -3541,7 +3566,7 @@ vm_fault_t filemap_map_pages(struct vm_f
 	XA_STATE(xas, &mapping->i_pages, start_pgoff);
 	struct folio *folio;
 	vm_fault_t ret = 0;
-	int nr_pages = 0;
+	unsigned int nr_pages = 0, mmap_miss = 0, mmap_miss_saved;
 
 	rcu_read_lock();
 	folio = next_uptodate_folio(&xas, mapping, end_pgoff);
@@ -3569,25 +3594,27 @@ vm_fault_t filemap_map_pages(struct vm_f
 		end = folio->index + folio_nr_pages(folio) - 1;
 		nr_pages = min(end, end_pgoff) - xas.xa_index + 1;
 
-		/*
-		 * NOTE: If there're PTE markers, we'll leave them to be
-		 * handled in the specific fault path, and it'll prohibit the
-		 * fault-around logic.
-		 */
-		if (!pte_none(ptep_get(vmf->pte)))
-			goto unlock;
-
-		ret |= filemap_map_folio_range(vmf, folio,
-				xas.xa_index - folio->index, addr, nr_pages);
+		if (!folio_test_large(folio))
+			ret |= filemap_map_order0_folio(vmf,
+					folio, addr, &mmap_miss);
+		else
+			ret |= filemap_map_folio_range(vmf, folio,
+					xas.xa_index - folio->index, addr,
+					nr_pages, &mmap_miss);
 
-unlock:
 		folio_unlock(folio);
 		folio_put(folio);
-		folio = next_uptodate_folio(&xas, mapping, end_pgoff);
-	} while (folio);
+	} while ((folio = next_uptodate_folio(&xas, mapping, end_pgoff)) != NULL);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 out:
 	rcu_read_unlock();
+
+	mmap_miss_saved = READ_ONCE(file->f_ra.mmap_miss);
+	if (mmap_miss >= mmap_miss_saved)
+		WRITE_ONCE(file->f_ra.mmap_miss, 0);
+	else
+		WRITE_ONCE(file->f_ra.mmap_miss, mmap_miss_saved - mmap_miss);
+
 	return ret;
 }
 EXPORT_SYMBOL(filemap_map_pages);
_

Patches currently in -mm which might be from fengwei.yin@intel.com are

filemap-add-filemap_map_order0_folio-to-handle-order0-folio.patch

